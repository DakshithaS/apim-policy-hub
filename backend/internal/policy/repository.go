package policy

import (
	"context"
)

// Repository defines the interface for policy data access
type Repository interface {
	ListPolicies(ctx context.Context, filters PolicyFilters) ([]*PolicyVersion, error)
	CountPolicies(ctx context.Context, filters PolicyFilters) (int, error)

	// Metadata operations
	GetDistinctCategories(ctx context.Context) ([]string, error)
	GetDistinctProviders(ctx context.Context) ([]string, error)
	GetDistinctPlatforms(ctx context.Context) ([]string, error)

	GetPolicyVersion(ctx context.Context, name string, version string) (*PolicyVersion, error)
	ListPolicyVersions(ctx context.Context, name string, page, pageSize int) ([]*PolicyVersion, error)
	CountPolicyVersions(ctx context.Context, name string) (int, error)
	GetLatestPolicyVersion(ctx context.Context, name string) (*PolicyVersion, error)
	CreatePolicyVersion(ctx context.Context, version *PolicyVersion) (*PolicyVersion, error)

	// Strategy-based policy retrieval
	GetPolicyVersionByExact(ctx context.Context, name, version string) (*PolicyVersion, error)
	GetPolicyVersionByLatestPatch(ctx context.Context, name string, majorVersion, minorVersion int32) (*PolicyVersion, error)
	GetPolicyVersionByLatestMinor(ctx context.Context, name string, majorVersion int32) (*PolicyVersion, error)
	GetPolicyVersionByLatestMajor(ctx context.Context, name string) (*PolicyVersion, error)

	// Bulk strategy-based policy retrieval
	BulkGetPolicyVersionsByExact(ctx context.Context, requests []ExactVersionRequest) ([]*PolicyVersion, error)
	BulkGetPolicyVersionsByLatestPatch(ctx context.Context, requests []PatchVersionRequest) ([]*PolicyVersion, error)
	BulkGetPolicyVersionsByLatestMinor(ctx context.Context, requests []MinorVersionRequest) ([]*PolicyVersion, error)
	BulkGetPolicyVersionsByLatestMajor(ctx context.Context, policyNames []string) ([]*PolicyVersion, error)

	// Documentation operations
	GetPolicyDoc(ctx context.Context, versionID int32, page string) (*PolicyDoc, error)
	ListPolicyDocs(ctx context.Context, versionID int32) ([]*PolicyDoc, error)
	UpsertPolicyDoc(ctx context.Context, doc *PolicyDoc) (*PolicyDoc, error)
}
