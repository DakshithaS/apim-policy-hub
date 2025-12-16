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
