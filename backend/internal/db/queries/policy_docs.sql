/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

-- name: GetPolicyDoc :one
SELECT * FROM policy_docs
WHERE policy_version_id = $1 AND page = $2;

-- name: ListPolicyDocs :many
SELECT * FROM policy_docs
WHERE policy_version_id = $1
ORDER BY page;

-- name: UpsertPolicyDoc :one
INSERT INTO policy_docs (
    policy_version_id,
    page,
    content_md,
    created_at,
    updated_at
) VALUES (
    $1, $2, $3, NOW(), NOW()
)
ON CONFLICT (policy_version_id, page)
DO UPDATE SET
    content_md = EXCLUDED.content_md,
    updated_at = NOW()
RETURNING *;
