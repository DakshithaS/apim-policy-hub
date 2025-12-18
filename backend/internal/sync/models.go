/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

package sync

import "github.com/wso2/policyhub/internal/policy"

// SyncRequest represents a policy sync request
type SyncRequest struct {
	PolicyName    string
	Version       string
	SourceType    string
	DownloadURL   string
	DefinitionURL string
	Metadata      *policy.PolicyMetadata
	Documentation map[string]string
	AssetsBaseURL string
	Checksum      *policy.Checksum
}

// SyncResult represents the result of a sync operation
type SyncResult struct {
	PolicyName string
	Version    string
	Status     string
}
