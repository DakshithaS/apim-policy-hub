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
	"database/sql/driver"
	"encoding/json"
	"time"
)

// Checksum represents a checksum with algorithm and value
type Checksum struct {
	Algorithm string `json:"algorithm"`
	Value     string `json:"value"`
}

// Scan implements the sql.Scanner interface for database retrieval
func (c *Checksum) Scan(value interface{}) error {
	if value == nil {
		return nil
	}
	bytes, ok := value.([]byte)
	if !ok {
		return json.Unmarshal([]byte(value.(string)), c)
	}
	return json.Unmarshal(bytes, c)
}

type PolicyVersion struct {
	ID         int32
	PolicyName string
	Version    string
	IsLatest   bool

	// Policy fields (metadata and version-specific data)
	DisplayName        string
	Provider           string
	Description        *string
	Categories         StringArray
	Tags               StringArray
	LogoPath           *string
	BannerPath         *string
	SupportedPlatforms StringArray

	// Version-specific fields
	ReleaseDate    *time.Time
	DefinitionYAML string
	IconPath       *string
	SourceType     *string
	DownloadURL    *string
	Checksum       *Checksum
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

// PolicyDoc represents a documentation page
type PolicyDoc struct {
	ID              int32
	PolicyVersionID int32
	Page            string
	ContentMd       string
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

// StringArray is a custom type for JSONB string arrays
type StringArray []string

// Scan implements the sql.Scanner interface
func (s *StringArray) Scan(value interface{}) error {
	if value == nil {
		*s = []string{}
		return nil
	}

	bytes, ok := value.([]byte)
	if !ok {
		*s = []string{}
		return nil
	}

	return json.Unmarshal(bytes, s)
}

// Value implements the driver.Valuer interface
func (s StringArray) Value() (driver.Value, error) {
	if len(s) == 0 {
		return json.Marshal([]string{})
	}
	return json.Marshal(s)
}

// PolicyFilters holds filter criteria for listing policies
type PolicyFilters struct {
	Search     string
	Categories []string
	Providers  []string
	Platforms  []string
	Page       int
	PageSize   int
}

// PaginationInfo holds pagination metadata
type PaginationInfo struct {
	Page       int
	PageSize   int
	TotalItems int
	TotalPages int
}

// CalculateTotalPages calculates total pages from total items and page size
func CalculateTotalPages(totalItems, pageSize int) int {
	if pageSize == 0 {
		return 0
	}
	pages := totalItems / pageSize
	if totalItems%pageSize > 0 {
		pages++
	}
	return pages
}

// PolicyResolveRequest represents a policy resolution request
type PolicyResolveRequest struct {
	Name              string
	Version           string
	VersionResolution string
}

// PolicyResolveItem represents a policy item in resolve response
type PolicyResolveItem struct {
	Name        string
	Version     string
	DownloadURL string
	Checksum    *Checksum
}

// ResolvePolicyVersion represents a resolved policy version from database
type ResolvePolicyVersion struct {
	PolicyName  string    `json:"policy_name"`
	Version     string    `json:"version"`
	DownloadUrl string    `json:"download_url"`
	Checksum    *Checksum `json:"checksum"`
}

// Bulk request types for optimization
type ExactVersionRequest struct {
	Name    string
	Version string
}

type PatchVersionRequest struct {
	Name         string
	MajorVersion int32
	MinorVersion int32
}

type MinorVersionRequest struct {
	Name         string
	MajorVersion int32
}

// PolicyMetadata represents the metadata.json structure
type PolicyMetadata struct {
	DisplayName        string   `json:"displayName"`
	Provider           string   `json:"provider"`
	Description        string   `json:"description"`
	Categories         []string `json:"categories"`
	Tags               []string `json:"tags"`
	SupportedPlatforms []string `json:"supportedPlatforms"`
	LogoURL            string   `json:"logoUrl"`
	BannerURL          string   `json:"bannerUrl"`
}
