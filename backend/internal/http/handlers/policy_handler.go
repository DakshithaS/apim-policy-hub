/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

package handlers

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"

	"github.com/wso2/policyhub/internal/errs"
	"github.com/wso2/policyhub/internal/http/dto"
	"github.com/wso2/policyhub/internal/http/middleware"
	"github.com/wso2/policyhub/internal/logging"
	"github.com/wso2/policyhub/internal/policy"
)

// PolicyHandler handles policy-related HTTP requests
type PolicyHandler struct {
	service *policy.Service
	logger  *logging.Logger
}

// NewPolicyHandler creates a new policy handler
func NewPolicyHandler(service *policy.Service, logger *logging.Logger) *PolicyHandler {
	return &PolicyHandler{
		service: service,
		logger:  logger,
	}
}

// ListPolicies handles GET /policies
func (h *PolicyHandler) ListPolicies(c *gin.Context) {
	filters := policy.PolicyFilters{
		Search:     c.Query("search"),
		Categories: parseCommaSeparatedValues(c, "category", "categories"),
		Providers:  parseCommaSeparatedValues(c, "provider", "providers"),
		Platforms:  parseCommaSeparatedValues(c, "platform", "platforms"),
		Page:       getIntQuery(c, "page", 1),
		PageSize:   getIntQuery(c, "pageSize", 20),
	}

	policies, pagination, err := h.service.ListPolicies(c.Request.Context(), filters)
	if err != nil {
		_ = c.Error(err)
		return
	}

	// Convert to DTOs
	items := make([]dto.PolicyDTO, 0, len(policies))
	for _, p := range policies {
		items = append(items, toPolicyDTO(p))
	}

	paginationDTO := dto.PaginationDTO{
		Page:       pagination.Page,
		PageSize:   pagination.PageSize,
		TotalItems: pagination.TotalItems,
		TotalPages: pagination.TotalPages,
	}

	middleware.SendSuccessWithPagination(c, items, paginationDTO)
}

// GetPolicySummary handles GET /policies/{name}
func (h *PolicyHandler) GetPolicySummary(c *gin.Context) {
	name := c.Param("name")

	policyVersion, err := h.service.GetPolicyWithLatestVersion(c.Request.Context(), name)
	if err != nil {
		_ = c.Error(err)
		return
	}

	policyData := toPolicyDTO(policyVersion)
	middleware.SendSuccess(c, policyData)
}

// ListPolicyVersions handles GET /policies/{name}/versions
func (h *PolicyHandler) ListPolicyVersions(c *gin.Context) {
	name := c.Param("name")
	page := getIntQuery(c, "page", 1)
	pageSize := getIntQuery(c, "pageSize", 20)

	versions, pagination, err := h.service.ListPolicyVersions(c.Request.Context(), name, page, pageSize)
	if err != nil {
		_ = c.Error(err)
		return
	}

	// Convert to DTOs
	items := make([]dto.PolicyDTO, 0, len(versions))
	for _, v := range versions {
		items = append(items, toPolicyDTO(v))
	}

	paginationDTO := dto.PaginationDTO{
		Page:       pagination.Page,
		PageSize:   pagination.PageSize,
		TotalItems: pagination.TotalItems,
		TotalPages: pagination.TotalPages,
	}

	middleware.SendSuccessWithPagination(c, items, paginationDTO)
}

// GetLatestVersion handles GET /policies/{name}/versions/latest
func (h *PolicyHandler) GetLatestVersion(c *gin.Context) {
	name := c.Param("name")

	// Get latest version
	policyVersion, err := h.service.GetLatestPolicyVersion(c.Request.Context(), name)
	if err != nil {
		_ = c.Error(err)
		return
	}

	policyData := toPolicyDTO(policyVersion)
	middleware.SendSuccess(c, policyData)
}

// GetPolicyVersionDetail handles GET /policies/{name}/versions/{version}
func (h *PolicyHandler) GetPolicyVersionDetail(c *gin.Context) {
	name := c.Param("name")
	version := c.Param("version")

	// Get version detail
	policyVersion, err := h.service.GetPolicyVersion(c.Request.Context(), name, version)
	if err != nil {
		_ = c.Error(err)
		return
	}

	policyData := toPolicyDTO(policyVersion)
	middleware.SendSuccess(c, policyData)
}

// GetPolicyDefinition handles GET /policies/{name}/versions/{version}/definition
func (h *PolicyHandler) GetPolicyDefinition(c *gin.Context) {
	name := c.Param("name")
	version := c.Param("version")

	definition, err := h.service.GetPolicyDefinition(c.Request.Context(), name, version)
	if err != nil {
		_ = c.Error(err)
		return
	}

	// Return raw YAML without envelope
	c.Data(200, "text/yaml", definition)
}

// GetAllDocs handles GET /policies/{name}/versions/{version}/docs
func (h *PolicyHandler) GetAllDocs(c *gin.Context) {
	name := c.Param("name")
	version := c.Param("version")

	docs, err := h.service.GetAllDocs(c.Request.Context(), name, version)
	if err != nil {
		_ = c.Error(err)
		return
	}

	response := toDocsAllResponseDTO(docs)
	middleware.SendSuccess(c, response)
}

// GetSingleDoc handles GET /policies/{name}/versions/{version}/docs/{page}
func (h *PolicyHandler) GetSingleDoc(c *gin.Context) {
	name := c.Param("name")
	version := c.Param("version")
	page := c.Param("page")

	content, err := h.service.GetSingleDoc(c.Request.Context(), name, version, page)
	if err != nil {
		_ = c.Error(err)
		return
	}

	response := dto.DocsSingleResponseDTO{
		Page:    page,
		Format:  "markdown",
		Content: content,
	}

	middleware.SendSuccess(c, response)
}

// GetCategories handles GET /policies/categories
func (h *PolicyHandler) GetCategories(c *gin.Context) {
	categories, err := h.service.GetDistinctCategories(c.Request.Context())
	if err != nil {
		_ = c.Error(err)
		return
	}

	middleware.SendSuccess(c, categories)
}

// GetProviders handles GET /policies/providers
func (h *PolicyHandler) GetProviders(c *gin.Context) {
	providers, err := h.service.GetDistinctProviders(c.Request.Context())
	if err != nil {
		_ = c.Error(err)
		return
	}

	middleware.SendSuccess(c, providers)
}

// GetPlatforms handles GET /policies/platforms
func (h *PolicyHandler) GetPlatforms(c *gin.Context) {
	platforms, err := h.service.GetDistinctPlatforms(c.Request.Context())
	if err != nil {
		_ = c.Error(err)
		return
	}

	middleware.SendSuccess(c, platforms)
}

// ResolvePolicies handles POST /policies/resolve
func (h *PolicyHandler) ResolvePolicies(c *gin.Context) {
	var req dto.ResolvePolicyRequestDTO
	if err := c.ShouldBindJSON(&req); err != nil {
		_ = c.Error(err)
		return
	}

	// Check batch size limit
	if len(req) > policy.MaxBatchSize {
		_ = c.Error(errs.NewValidationError(
			fmt.Sprintf("too many policies in batch (max %d)", policy.MaxBatchSize),
			map[string]any{
				"maxBatchSize": policy.MaxBatchSize,
				"provided":     len(req),
			},
		))
		return
	}

	// Validate and normalize requests
	requests := make([]*policy.PolicyResolveRequest, 0, len(req))
	for _, item := range req {
		// Normalize version (remove 'v' prefix if present)
		normalizedVersion := strings.TrimPrefix(item.Version, "v")

		// Default versionResolution to "exact" if not provided
		versionResolution := item.VersionResolution
		if versionResolution == "" {
			versionResolution = policy.VersionResolutionExact
		}

		// Validate versionResolution
		if versionResolution != policy.VersionResolutionExact && versionResolution != policy.VersionResolutionPatch && versionResolution != policy.VersionResolutionMinor {
			_ = c.Error(errs.NewValidationError("invalid versionResolution", map[string]any{
				"allowed_values": []string{policy.VersionResolutionExact, policy.VersionResolutionPatch, policy.VersionResolutionMinor},
				"provided":       versionResolution,
			}))
			return
		}

		requests = append(requests, &policy.PolicyResolveRequest{
			Name:              item.Name,
			Version:           normalizedVersion,
			VersionResolution: versionResolution,
		})
	}

	// Resolve policies
	resolved, err := h.service.ResolvePolicyVersions(c.Request.Context(), requests)
	if err != nil {
		_ = c.Error(err)
		return
	}

	// Convert to response DTO
	response := make([]dto.ResolvePolicyVersion, 0, len(resolved))
	for _, item := range resolved {
		var checksumDTO dto.ChecksumDTO
		if item.Checksum != nil {
			checksumDTO = dto.ChecksumDTO{
				Algorithm: item.Checksum.Algorithm,
				Value:     item.Checksum.Value,
			}
		}
		response = append(response, dto.ResolvePolicyVersion{
			PolicyName:  item.Name,
			Version:     item.Version,
			DownloadUrl: item.DownloadURL,
			Checksum:    checksumDTO,
		})
	}

	middleware.SendSuccess(c, response)
}

// Helper functions

func getIntQuery(c *gin.Context, key string, defaultValue int) int {
	valueStr := c.Query(key)
	if valueStr == "" {
		return defaultValue
	}
	value, err := strconv.Atoi(valueStr)
	if err != nil {
		return defaultValue
	}
	return value
}

// toPolicyDTO converts policy version to standardized DTO
func toPolicyDTO(v *policy.PolicyVersion) dto.PolicyDTO {
	desc := ""
	if v.Description != nil {
		desc = *v.Description
	}

	var releaseDate *string
	if v.ReleaseDate != nil {
		dateStr := v.ReleaseDate.Format("2006-01-02")
		releaseDate = &dateStr
	}

	logoURL := ""
	if v.LogoPath != nil {
		logoURL = *v.LogoPath
	}

	bannerURL := ""
	if v.BannerPath != nil {
		bannerURL = *v.BannerPath
	}

	iconURL := ""
	if v.IconPath != nil {
		iconURL = *v.IconPath
	}

	sourceType := ""
	if v.SourceType != nil {
		sourceType = *v.SourceType
	}

	DownloadURL := ""
	if v.DownloadURL != nil {
		DownloadURL = *v.DownloadURL
	}

	var checksumDTO *dto.ChecksumDTO
	if v.Checksum != nil {
		checksumDTO = &dto.ChecksumDTO{
			Algorithm: v.Checksum.Algorithm,
			Value:     v.Checksum.Value,
		}
	}

	return dto.PolicyDTO{
		Name:               v.PolicyName,
		Version:            v.Version,
		DisplayName:        v.DisplayName,
		Description:        desc,
		Provider:           v.Provider,
		Categories:         v.Categories,
		Tags:               v.Tags,
		SupportedPlatforms: v.SupportedPlatforms,
		LogoURL:            logoURL,
		BannerURL:          bannerURL,
		IconURL:            iconURL,
		ReleaseDate:        releaseDate,
		IsLatest:           v.IsLatest,
		SourceType:         sourceType,
		DownloadURL:        DownloadURL,
		Checksum:           checksumDTO,
	}
}

func toDocsAllResponseDTO(docs map[string]string) dto.DocsAllResponseDTO {
	var response dto.DocsAllResponseDTO

	// Define the order of pages
	pages := []string{"overview", "configuration", "examples", "faq"}

	for _, page := range pages {
		if content, ok := docs[page]; ok {
			response = append(response, dto.DocsSingleResponseDTO{
				Page:    page,
				Format:  "markdown",
				Content: content,
			})
		}
	}

	return response
}

// parseCommaSeparatedValues parses comma-separated values from query parameters
// Supports both singular and plural parameter names for backward compatibility
func parseCommaSeparatedValues(c *gin.Context, singularParam, pluralParam string) []string {
	// Try singular form first, then plural
	value := c.Query(singularParam)
	if value == "" {
		value = c.Query(pluralParam)
	}

	if value == "" {
		return nil
	}

	// Split by comma and trim whitespace
	values := strings.Split(value, ",")
	var result []string
	for _, v := range values {
		v = strings.TrimSpace(v)
		if v != "" {
			result = append(result, v)
		}
	}

	return result
}
