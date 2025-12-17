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

	// Bulk strategy-based policy retrieval
	BulkGetPolicyVersionsByExact(ctx context.Context, requests []ExactVersionRequest) ([]ResolvePolicyVersion, error)
	BulkGetPolicyVersionsByLatestPatch(ctx context.Context, requests []PatchVersionRequest) ([]ResolvePolicyVersion, error)
	BulkGetPolicyVersionsByLatestMinor(ctx context.Context, requests []MinorVersionRequest) ([]ResolvePolicyVersion, error)
	BulkGetPolicyVersionsByLatestMajor(ctx context.Context, policyNames []string) ([]ResolvePolicyVersion, error)

	// Documentation operations
	GetPolicyDoc(ctx context.Context, versionID int32, page string) (*PolicyDoc, error)
	ListPolicyDocs(ctx context.Context, versionID int32) ([]*PolicyDoc, error)
	UpsertPolicyDoc(ctx context.Context, doc *PolicyDoc) (*PolicyDoc, error)
}
