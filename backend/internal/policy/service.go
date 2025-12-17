/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

package policy

import (
	"context"
	"encoding/json"
	"strconv"
	"strings"
	"sync"

	"go.uber.org/zap"

	"github.com/wso2/policyhub/internal/errs"
	"github.com/wso2/policyhub/internal/logging"
)

// Service implements business logic for policies
type Service struct {
	repo   Repository
	logger *logging.Logger
}

// NewService creates a new policy service
func NewService(repo Repository, logger *logging.Logger) *Service {
	return &Service{
		repo:   repo,
		logger: logger,
	}
}

// ListPolicies retrieves a paginated list of policies with smart fallback to older versions
func (s *Service) ListPolicies(ctx context.Context, filters PolicyFilters) ([]*PolicyVersion, *PaginationInfo, error) {
	// Validate and set defaults
	if filters.Page < 1 {
		filters.Page = 1
	}
	if filters.PageSize < MinPageSize || filters.PageSize > MaxPageSize {
		filters.PageSize = DefaultPageSize
	}

	// Database handles smart version selection AND pagination efficiently
	policies, err := s.repo.ListPolicies(ctx, filters)
	if err != nil {
		return nil, nil, errs.SanitizeDatabaseError("listing policies")
	}

	// Count unique policies for pagination
	total, err := s.repo.CountPolicies(ctx, filters)
	if err != nil {
		return nil, nil, errs.SanitizeDatabaseError("counting policies")
	}

	pagination := &PaginationInfo{
		Page:       filters.Page,
		PageSize:   filters.PageSize,
		TotalItems: total,
		TotalPages: CalculateTotalPages(total, filters.PageSize),
	}

	return policies, pagination, nil
}

// GetPolicyWithLatestVersion retrieves the latest policy version (contains all policy data)
func (s *Service) GetPolicyWithLatestVersion(ctx context.Context, name string) (*PolicyVersion, error) {
	latestVersion, err := s.repo.GetLatestPolicyVersion(ctx, name)
	if err != nil {
		return nil, errs.PolicyVersionNotFound(name, "latest")
	}

	return latestVersion, nil
}

// ListPolicyVersions retrieves versions for a policy
func (s *Service) ListPolicyVersions(ctx context.Context, name string, page, pageSize int) ([]*PolicyVersion, *PaginationInfo, error) {
	if page < 1 {
		page = 1
	}
	if pageSize < MinPageSize || pageSize > MaxPageSize {
		pageSize = DefaultPageSize
	}

	versions, err := s.repo.ListPolicyVersions(ctx, name, page, pageSize)
	if err != nil {
		return nil, nil, errs.NewDatabaseError("Failed to list versions", map[string]any{"error": err.Error()})
	}

	total, err := s.repo.CountPolicyVersions(ctx, name)
	if err != nil {
		return nil, nil, errs.NewDatabaseError("Failed to count versions", map[string]any{"error": err.Error()})
	}

	pagination := &PaginationInfo{
		Page:       page,
		PageSize:   pageSize,
		TotalItems: total,
		TotalPages: CalculateTotalPages(total, pageSize),
	}

	return versions, pagination, nil
}

// GetPolicyVersion retrieves a specific policy version
func (s *Service) GetPolicyVersion(ctx context.Context, name, version string) (*PolicyVersion, error) {
	policyVersion, err := s.repo.GetPolicyVersion(ctx, name, version)
	if err != nil {
		return nil, errs.PolicyVersionNotFound(name, version)
	}

	return policyVersion, nil
}

// GetLatestPolicyVersion retrieves the latest version of a policy
func (s *Service) GetLatestPolicyVersion(ctx context.Context, name string) (*PolicyVersion, error) {
	latestVersion, err := s.repo.GetLatestPolicyVersion(ctx, name)
	if err != nil {
		return nil, errs.PolicyVersionNotFound(name, "latest")
	}

	return latestVersion, nil
}

// GetPolicyDefinition retrieves the raw policy definition JSON
func (s *Service) GetPolicyDefinition(ctx context.Context, name, version string) (json.RawMessage, error) {
	policyVersion, err := s.GetPolicyVersion(ctx, name, version)
	if err != nil {
		return nil, err
	}

	return []byte(policyVersion.DefinitionYAML), nil
}

// GetAllDocs retrieves all documentation pages for a version
func (s *Service) GetAllDocs(ctx context.Context, name, version string) (map[string]string, error) {
	policyVersion, err := s.GetPolicyVersion(ctx, name, version)
	if err != nil {
		return nil, err
	}

	docs, err := s.repo.ListPolicyDocs(ctx, policyVersion.ID)
	if err != nil {
		return nil, errs.NewDatabaseError("Failed to retrieve docs", map[string]any{"error": err.Error()})
	}

	result := make(map[string]string)
	for _, doc := range docs {
		result[doc.Page] = doc.ContentMd
	}

	return result, nil
}

// GetSingleDoc retrieves a single documentation page
func (s *Service) GetSingleDoc(ctx context.Context, name, version, page string) (string, error) {
	policyVersion, err := s.GetPolicyVersion(ctx, name, version)
	if err != nil {
		return "", err
	}

	doc, err := s.repo.GetPolicyDoc(ctx, policyVersion.ID, page)
	if err != nil {
		return "", errs.DocNotFound(name, version, page)
	}

	return doc.ContentMd, nil
}

// CreatePolicyVersion creates a new policy version
func (s *Service) CreatePolicyVersion(ctx context.Context, version *PolicyVersion) (*PolicyVersion, error) {
	s.logger.Info("Creating policy version",
		zap.String("policyName", version.PolicyName),
		zap.String("version", version.Version))

	// IsLatest will be determined atomically in the repository based on semantic versioning

	// Attempt to create the version - database unique constraint will prevent duplicates
	created, err := s.repo.CreatePolicyVersion(ctx, version)
	if err != nil {
		// Check if this is a unique constraint violation
		if errs.IsUniqueConstraintError(err) {
			s.logger.Info("Policy version creation skipped - version already exists",
				zap.String("policyName", version.PolicyName),
				zap.String("version", version.Version))
			return nil, errs.NewConflictError(errs.CodeValidationError, "Policy version already exists", map[string]any{
				"policyName": version.PolicyName,
				"version":    version.Version,
			})
		}
		s.logger.Error("Policy version creation failed - database error",
			zap.String("policyName", version.PolicyName),
			zap.String("version", version.Version),
			zap.Error(err))
		return nil, errs.SanitizeDatabaseError("creating policy version")
	}

	s.logger.Info("Policy version created successfully",
		zap.String("policyName", version.PolicyName),
		zap.String("version", version.Version),
		zap.Int32("id", created.ID))

	return created, nil
}

// UpsertPolicyDoc creates or updates a documentation page
func (s *Service) UpsertPolicyDoc(ctx context.Context, doc *PolicyDoc) (*PolicyDoc, error) {
	upserted, err := s.repo.UpsertPolicyDoc(ctx, doc)
	if err != nil {
		return nil, errs.NewDatabaseError("Failed to upsert doc", map[string]any{"error": err.Error()})
	}

	return upserted, nil
}

// GetDistinctCategories retrieves all unique categories from policies
func (s *Service) GetDistinctCategories(ctx context.Context) ([]string, error) {
	categories, err := s.repo.GetDistinctCategories(ctx)
	if err != nil {
		return nil, errs.NewDatabaseError("Failed to get distinct categories", map[string]any{"error": err.Error()})
	}

	return categories, nil
}

// GetDistinctProviders retrieves all unique providers from policies
func (s *Service) GetDistinctProviders(ctx context.Context) ([]string, error) {
	providers, err := s.repo.GetDistinctProviders(ctx)
	if err != nil {
		return nil, errs.NewDatabaseError("Failed to get distinct providers", map[string]any{"error": err.Error()})
	}

	return providers, nil
}

// GetDistinctPlatforms retrieves all unique platforms from policies
func (s *Service) GetDistinctPlatforms(ctx context.Context) ([]string, error) {
	platforms, err := s.repo.GetDistinctPlatforms(ctx)
	if err != nil {
		return nil, errs.NewDatabaseError("Failed to get distinct platforms", map[string]any{"error": err.Error()})
	}

	return platforms, nil
}

// ResolvePolicyVersions resolves policy versions based on the provided requests
func (s *Service) ResolvePolicyVersions(ctx context.Context, requests []*PolicyResolveRequest) ([]*PolicyResolveItem, error) {
	if len(requests) == 0 {
		return []*PolicyResolveItem{}, nil
	}

	// Group requests by resolution strategy
	exactRequests := make([]ExactVersionRequest, 0)
	patchRequests := make([]PatchVersionRequest, 0)
	minorRequests := make([]MinorVersionRequest, 0)
	majorRequests := make([]string, 0)

	for _, req := range requests {
		switch req.VersionResolution {
		case VersionResolutionExact:
			exactRequests = append(exactRequests, ExactVersionRequest{
				Name:    req.Name,
				Version: req.Version,
			})
		case VersionResolutionPatch:
			// Parse version to extract major.minor
			parts := strings.Split(req.Version, ".")
			if len(parts) < 2 {
				return nil, errs.NewValidationError("invalid version format for patch resolution", map[string]any{
					"policy":   req.Name,
					"version":  req.Version,
					"expected": "major.minor.patch",
				})
			}
			major, err := strconv.Atoi(parts[0])
			if err != nil {
				return nil, errs.NewValidationError("invalid major version", map[string]any{
					"policy":  req.Name,
					"version": req.Version,
				})
			}
			minor, err := strconv.Atoi(parts[1])
			if err != nil {
				return nil, errs.NewValidationError("invalid minor version", map[string]any{
					"policy":  req.Name,
					"version": req.Version,
				})
			}
			patchRequests = append(patchRequests, PatchVersionRequest{
				Name:         req.Name,
				MajorVersion: int32(major),
				MinorVersion: int32(minor),
			})
		case VersionResolutionMinor:
			// Parse version to extract major
			parts := strings.Split(req.Version, ".")
			if len(parts) < 1 {
				return nil, errs.NewValidationError("invalid version format for minor resolution", map[string]any{
					"policy":   req.Name,
					"version":  req.Version,
					"expected": "major.minor.patch",
				})
			}
			major, err := strconv.Atoi(parts[0])
			if err != nil {
				return nil, errs.NewValidationError("invalid major version", map[string]any{
					"policy":  req.Name,
					"version": req.Version,
				})
			}
			minorRequests = append(minorRequests, MinorVersionRequest{
				Name:         req.Name,
				MajorVersion: int32(major),
			})
		case VersionResolutionMajor:
			majorRequests = append(majorRequests, req.Name)
		}
	}

	// Define result type for parallel processing
	type resolveResult struct {
		resolved []ResolvePolicyVersion
		err      error
	}

	// Execute resolution queries in parallel for better performance
	resultsChan := make(chan resolveResult, 4)

	var wg sync.WaitGroup

	// Process exact versions
	if len(exactRequests) > 0 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			resolved, err := s.repo.BulkGetPolicyVersionsByExact(ctx, exactRequests)
			resultsChan <- resolveResult{resolved: resolved, err: err}
		}()
	}

	// Process patch versions
	if len(patchRequests) > 0 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			resolved, err := s.repo.BulkGetPolicyVersionsByLatestPatch(ctx, patchRequests)
			resultsChan <- resolveResult{resolved: resolved, err: err}
		}()
	}

	// Process minor versions
	if len(minorRequests) > 0 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			resolved, err := s.repo.BulkGetPolicyVersionsByLatestMinor(ctx, minorRequests)
			resultsChan <- resolveResult{resolved: resolved, err: err}
		}()
	}

	// Process major versions
	if len(majorRequests) > 0 {
		wg.Add(1)
		go func() {
			defer wg.Done()
			resolved, err := s.repo.BulkGetPolicyVersionsByLatestMajor(ctx, majorRequests)
			resultsChan <- resolveResult{resolved: resolved, err: err}
		}()
	}

	// Close channel after all goroutines complete
	go func() {
		wg.Wait()
		close(resultsChan)
	}()

	// Collect results
	var allResolved []ResolvePolicyVersion

	// Collect all results and check for errors
	for result := range resultsChan {
		if result.err != nil {
			return nil, errs.SanitizeDatabaseError("resolving policy versions")
		}
		allResolved = append(allResolved, result.resolved...)
	}

	// Convert to response format
	response := make([]*PolicyResolveItem, 0, len(allResolved))
	for _, rpv := range allResolved {
		response = append(response, &PolicyResolveItem{
			Name:        rpv.PolicyName,
			Version:     rpv.Version,
			DownloadURL: rpv.DownloadUrl,
			Checksum:    rpv.Checksum,
		})
	}

	return response, nil
}

// ResolvePolicyVersion resolves a single policy version based on the provided request
func (s *Service) ResolvePolicyVersion(ctx context.Context, request *PolicyResolveRequest) (*PolicyResolveItem, error) {
	// Use the bulk method with a single request
	responses, err := s.ResolvePolicyVersions(ctx, []*PolicyResolveRequest{request})
	if err != nil {
		return nil, err
	}

	if len(responses) == 0 {
		return nil, errs.NewNotFoundError(errs.CodePolicyVersionNotFound, "policy version not found", map[string]any{
			"policy":     request.Name,
			"version":    request.Version,
			"resolution": request.VersionResolution,
		})
	}

	return responses[0], nil
}
