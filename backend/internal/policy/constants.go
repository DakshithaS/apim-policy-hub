/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

package policy

import "time"

// DocType represents the type of documentation
type DocType string

const (
	DocTypeOverview      DocType = "overview"
	DocTypeConfiguration DocType = "configuration"
	DocTypeExamples      DocType = "examples"
	DocTypeFAQ           DocType = "faq"
)

// Pagination constants
const (
	DefaultPageSize = 20
	MaxPageSize     = 100
	MinPageSize     = 1
)

// Batch processing constants
const (
	MaxBatchSize = 100 // Maximum batch size limit
)

// Validation constants
const (
	MaxPolicyNameLength  = 100
	MaxVersionLength     = 50
	MaxDescriptionLength = 1000
)

// HTTP timeouts
const (
	HTTPTimeout = 30 * time.Second
)

// Regular expressions for validation
const (
	PolicyNameRegex = `^[a-zA-Z0-9_-]+$`
	VersionRegex    = `^\d+\.\d+\.\d+$`
)

// ValidDocTypes returns a map of valid documentation types
func ValidDocTypes() map[string]bool {
	return map[string]bool{
		string(DocTypeOverview):      true,
		string(DocTypeConfiguration): true,
		string(DocTypeExamples):      true,
		string(DocTypeFAQ):           true,
	}
}
