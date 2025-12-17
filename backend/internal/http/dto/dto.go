/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

package dto

import "time"

// BaseResponse is the standard API response envelope
type BaseResponse struct {
	Success bool        `json:"success"`
	Data    interface{} `json:"data"`
	Error   *ErrorDTO   `json:"error"`
	Meta    MetaDTO     `json:"meta"`
}

// PaginatedResponse is the API response envelope for paginated results
type PaginatedResponse struct {
	Success bool             `json:"success"`
	Data    interface{}      `json:"data"`
	Error   *ErrorDTO        `json:"error"`
	Meta    PaginatedMetaDTO `json:"meta"`
}

// ErrorDTO represents an error in the response
type ErrorDTO struct {
	Code    string         `json:"code"`
	Message string         `json:"message"`
	Details map[string]any `json:"details,omitempty"`
}

// MetaDTO contains response metadata
type MetaDTO struct {
	TraceID   string    `json:"trace_id"`
	Timestamp time.Time `json:"timestamp"`
	RequestID string    `json:"request_id"`
}

// PaginatedMetaDTO contains response metadata with pagination
type PaginatedMetaDTO struct {
	TraceID    string        `json:"trace_id"`
	Timestamp  time.Time     `json:"timestamp"`
	RequestID  string        `json:"request_id"`
	Pagination PaginationDTO `json:"pagination"`
}

// PaginationDTO contains pagination information
type PaginationDTO struct {
	Page       int `json:"page"`
	PageSize   int `json:"pageSize"`
	TotalItems int `json:"totalItems"`
	TotalPages int `json:"totalPages"`
}

// DocsAllResponseDTO contains all documentation pages as an array
type DocsAllResponseDTO []DocsSingleResponseDTO

// DocsSingleResponseDTO represents a single documentation page
type DocsSingleResponseDTO struct {
	Page    string `json:"page"`
	Format  string `json:"format"`
	Content string `json:"content"`
}

// PolicyMetadataDTO represents policy metadata
type PolicyMetadataDTO struct {
	DisplayName        string   `json:"displayName" binding:"required"`
	Provider           string   `json:"provider" binding:"required"`
	Description        string   `json:"description"`
	Categories         []string `json:"categories"`
	Tags               []string `json:"tags"`
	SupportedPlatforms []string `json:"supportedPlatforms"`
	LogoURL            string   `json:"logoUrl"`
	BannerURL          string   `json:"bannerUrl"`
}

// SyncRequestDTO represents the sync request payload
type SyncRequestDTO struct {
	PolicyName    string            `json:"policyName" binding:"required"`
	Version       string            `json:"version" binding:"required"`
	SourceType    string            `json:"sourceType" binding:"required"`
	DownloadURL   string            `json:"downloadUrl" binding:"required"`
	DefinitionURL string            `json:"definitionUrl" binding:"required"`
	Metadata      PolicyMetadataDTO `json:"metadata" binding:"required"`
	Documentation map[string]string `json:"documentation"`
	AssetsBaseURL string            `json:"assetsBaseUrl"`
	Checksum      *ChecksumDTO      `json:"checksum"`
}

// SyncResponseDTO represents the sync response payload
type SyncResponseDTO struct {
	PolicyName string `json:"policyName"`
	Version    string `json:"version"`
	Status     string `json:"status"`
}

// HealthResponseDTO represents health check response
type HealthResponseDTO struct {
	Status    string    `json:"status"`
	Timestamp time.Time `json:"timestamp"`
}

// ResolvePolicyRequestDTO represents a resolve policy retrieval request
type ResolvePolicyRequestDTO []ResolvePolicyItemDTO

// ResolvePolicyItemDTO represents a single policy request in the batch
type ResolvePolicyItemDTO struct {
	Name              string `json:"name" binding:"required"`
	Version           string `json:"version" binding:"required"`
	VersionResolution string `json:"versionResolution,omitempty"`
}

// ChecksumDTO represents a checksum with algorithm and value
type ChecksumDTO struct {
	Algorithm string `json:"algorithm"`
	Value     string `json:"value"`
}

// ResolvePolicyVersion represents a resolved policy version
type ResolvePolicyVersion struct {
	PolicyName  string      `json:"policy_name"`
	Version     string      `json:"version"`
	DownloadUrl string      `json:"download_url"`
	Checksum    ChecksumDTO `json:"checksum"`
}

// PolicyDTO represents the standardized policy object
// Used across all GET endpoints for consistent response structure
type PolicyDTO struct {
	Name               string       `json:"name"`
	Version            string       `json:"version"`
	DisplayName        string       `json:"displayName"`
	Description        string       `json:"description,omitempty"`
	Provider           string       `json:"provider"`
	Categories         []string     `json:"categories"`
	Tags               []string     `json:"tags"`
	SupportedPlatforms []string     `json:"supportedPlatforms"`
	LogoURL            string       `json:"logoUrl,omitempty"`
	BannerURL          string       `json:"bannerUrl,omitempty"`
	IconURL            string       `json:"iconUrl,omitempty"`
	ReleaseDate        *string      `json:"releaseDate,omitempty"`
	IsLatest           bool         `json:"isLatest"`
	SourceType         string       `json:"sourceType,omitempty"`
	DownloadURL        string       `json:"downloadUrl,omitempty"`
	Checksum           *ChecksumDTO `json:"checksum,omitempty"`
}
