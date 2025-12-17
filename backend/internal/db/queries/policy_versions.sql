-- All PolicyVersion queries - single table architecture

-- =============================================================================
-- BASIC POLICY VERSION OPERATIONS
-- =============================================================================

-- name: GetPolicyVersion :one
SELECT * FROM policy_version
WHERE policy_name = $1 AND version = $2;

-- name: GetLatestPolicyVersion :one
SELECT * FROM policy_version
WHERE policy_name = $1 AND is_latest = TRUE;

-- =============================================================================
-- POLICY VERSION LISTING & FILTERING
-- =============================================================================

-- name: ListPolicyVersions :many
SELECT * FROM policy_version
WHERE policy_name = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountPolicyVersions :one
SELECT COUNT(*) FROM policy_version
WHERE policy_name = $1;

-- name: FilterPoliciesByMultiple :many
WITH ranked_versions AS (
    SELECT 
        pv.*,
        ROW_NUMBER() OVER (
            PARTITION BY pv.policy_name 
            ORDER BY 
                pv.is_latest DESC,
                pv.created_at DESC
        ) as version_rank
    FROM policy_version pv
    WHERE ($1::text = '' OR LOWER(pv.display_name) LIKE LOWER('%' || $1 || '%') OR LOWER(pv.description) LIKE LOWER('%' || $1 || '%'))
        AND ($2::text[] IS NULL OR array_length($2::text[], 1) = 0 OR EXISTS (SELECT 1 FROM unnest($2::text[]) AS cat WHERE pv.categories ? cat))
        AND ($3::text[] IS NULL OR array_length($3::text[], 1) = 0 OR pv.provider = ANY($3::text[]))
        AND ($4::text[] IS NULL OR array_length($4::text[], 1) = 0 OR EXISTS (SELECT 1 FROM unnest($4::text[]) AS plat WHERE pv.supported_platforms ? plat))
)
SELECT 
    id, policy_name, version, is_latest, display_name, provider, description, 
    categories, tags, logo_path, banner_path, supported_platforms, 
    release_date, definition_yaml, icon_path, source_type, download_url, checksum,
    created_at, updated_at
FROM ranked_versions 
WHERE version_rank = 1
ORDER BY created_at DESC
LIMIT $5 OFFSET $6;

-- name: CountPoliciesByMultiple :one
SELECT COUNT(DISTINCT pv.policy_name) FROM policy_version pv
WHERE ($1::text = '' OR LOWER(pv.display_name) LIKE LOWER('%' || $1 || '%') OR LOWER(pv.description) LIKE LOWER('%' || $1 || '%'))
    AND ($2::text[] IS NULL OR array_length($2::text[], 1) = 0 OR EXISTS (SELECT 1 FROM unnest($2::text[]) AS cat WHERE pv.categories ? cat))
    AND ($3::text[] IS NULL OR array_length($3::text[], 1) = 0 OR pv.provider = ANY($3::text[]))
    AND ($4::text[] IS NULL or array_length($4::text[], 1) = 0 OR EXISTS (SELECT 1 FROM unnest($4::text[]) AS plat WHERE pv.supported_platforms ? plat))
;

-- =============================================================================
-- METADATA OPERATIONS
-- =============================================================================

-- name: GetDistinctCategories :many
SELECT DISTINCT jsonb_array_elements_text(categories) as category
FROM policy_version
WHERE categories IS NOT NULL AND jsonb_array_length(categories) > 0
ORDER BY category;

-- name: GetDistinctProviders :many
SELECT DISTINCT provider
FROM policy_version
WHERE provider IS NOT NULL AND provider != ''
ORDER BY provider;

-- name: GetDistinctPlatforms :many
SELECT DISTINCT jsonb_array_elements_text(supported_platforms) as platform
FROM policy_version
WHERE supported_platforms IS NOT NULL AND jsonb_array_length(supported_platforms) > 0
ORDER BY platform;

-- =============================================================================
-- POLICY VERSION MANAGEMENT
-- =============================================================================

-- name: UpdateLatestVersion :exec
UPDATE policy_version
SET is_latest = CASE
    WHEN policy_name = $1 AND version = $2 THEN TRUE
    ELSE FALSE
END
WHERE policy_name = $1;

-- name: InsertPolicyVersion :one
INSERT INTO policy_version (
    policy_name,
    version,
    is_latest,
    display_name,
    provider,
    description,
    categories,
    tags,
    logo_path,
    banner_path,
    supported_platforms,
    release_date,
    definition_yaml,
    icon_path,
    source_type,
    download_url,
    checksum,
    created_at,
    updated_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, NOW(), NOW()
)
RETURNING *;

-- =============================================================================
-- BULK POLICY RESOLUTION QUERIES
-- =============================================================================

-- name: ResolvePoliciesExact :many
SELECT 
    policy_name,
    version,
    download_url,
    checksum
FROM policy_version
WHERE (policy_name, version) IN (
    SELECT unnest($1::text[]), unnest($2::text[])
);

-- name: ResolvePoliciesPatch :many
WITH input_policies AS (
    SELECT 
        unnest($1::text[]) as policy_name,
        unnest($2::text[]) as base_version
),
parsed_versions AS (
    SELECT 
        policy_name,
        base_version,
        split_part(base_version, '.', 1)::INT as major,
        split_part(base_version, '.', 2)::INT as minor
    FROM input_policies
)
SELECT DISTINCT ON (pv.policy_name)
    pv.policy_name,
    pv.version,
    pv.download_url,
    pv.checksum
FROM parsed_versions ip
JOIN policy_version pv ON pv.policy_name = ip.policy_name
WHERE pv.major_version = ip.major 
  AND pv.minor_version = ip.minor
  AND pv.version ~ '^\d+\.\d+\.\d+$'
ORDER BY pv.policy_name, pv.major_version DESC, pv.minor_version DESC, pv.patch_version DESC;

-- name: ResolvePoliciesMinor :many
WITH input_policies AS (
    SELECT 
        unnest($1::text[]) as policy_name,
        unnest($2::text[]) as base_version
),
parsed_versions AS (
    SELECT 
        policy_name,
        base_version,
        split_part(base_version, '.', 1)::INT as major
    FROM input_policies
)
SELECT DISTINCT ON (pv.policy_name)
    pv.policy_name,
    pv.version,
    pv.download_url,
    pv.checksum
FROM parsed_versions ip
JOIN policy_version pv ON pv.policy_name = ip.policy_name
WHERE pv.major_version = ip.major
  AND pv.version ~ '^\d+\.\d+\.\d+$'
ORDER BY pv.policy_name, pv.major_version DESC, pv.minor_version DESC, pv.patch_version DESC;

-- name: ResolvePoliciesMajor :many
SELECT DISTINCT ON (pv.policy_name)
    pv.policy_name,
    pv.version,
    pv.download_url,
    pv.checksum
FROM policy_version pv
WHERE pv.policy_name = ANY($1::text[])
  AND pv.version ~ '^\d+\.\d+\.\d+$'
ORDER BY pv.policy_name, pv.major_version DESC, pv.minor_version DESC, pv.patch_version DESC;
