package handlers

import (
	"github.com/gin-gonic/gin"

	"github.com/wso2/policyhub/internal/errs"
	"github.com/wso2/policyhub/internal/http/dto"
	"github.com/wso2/policyhub/internal/http/middleware"
	"github.com/wso2/policyhub/internal/logging"
	"github.com/wso2/policyhub/internal/policy"
	"github.com/wso2/policyhub/internal/sync"
	"github.com/wso2/policyhub/internal/validation"
)

// SyncHandler handles sync operations
type SyncHandler struct {
	syncService *sync.Service
	logger      *logging.Logger
}

// NewSyncHandler creates a new sync handler
func NewSyncHandler(syncService *sync.Service, logger *logging.Logger) *SyncHandler {
	return &SyncHandler{
		syncService: syncService,
		logger:      logger,
	}
}

// CreatePolicyVersion handles POST /policies/{name}/versions/{version}
func (h *SyncHandler) CreatePolicyVersion(c *gin.Context) {
	policyName := c.Param("name")
	version := c.Param("version")

	var req dto.SyncRequestDTO
	if err := c.ShouldBindJSON(&req); err != nil {
		_ = c.Error(err)
		return
	}

	// Validate that URL params match request body
	if req.PolicyName != "" && req.PolicyName != policyName {
		_ = c.Error(errs.NewValidationError("policy name in URL does not match request body", map[string]any{
			"url_name":  policyName,
			"body_name": req.PolicyName,
		}))
		return
	}

	if req.Version != "" && req.Version != version {
		_ = c.Error(errs.NewValidationError("version in URL does not match request body", map[string]any{
			"url_version":  version,
			"body_version": req.Version,
		}))
		return
	}

	// Use URL params as authoritative source
	req.PolicyName = policyName
	req.Version = version

	// Validate version format (must be d.d.d)
	if err := validation.ValidateVersion(req.Version); err != nil {
		_ = c.Error(err)
		return
	}

	// Validate policy name
	if err := validation.ValidatePolicyName(req.PolicyName); err != nil {
		_ = c.Error(err)
		return
	}

	// Validate documentation types
	if req.Documentation != nil {
		validDocTypes := policy.ValidDocTypes()
		filteredDocs := make(map[string]string)
		for docType, content := range req.Documentation {
			if validDocTypes[docType] {
				filteredDocs[docType] = content
			}
		}
		req.Documentation = filteredDocs
	}

	// Convert DTO to sync request
	syncReq := &sync.SyncRequest{
		PolicyName:    req.PolicyName,
		Version:       req.Version,
		SourceType:    req.SourceType,
		SourceURL:     req.SourceURL,
		DefinitionURL: req.DefinitionURL,
		Metadata: &policy.PolicyMetadata{
			DisplayName:        req.Metadata.DisplayName,
			Provider:           req.Metadata.Provider,
			Description:        req.Metadata.Description,
			Categories:         req.Metadata.Categories,
			Tags:               req.Metadata.Tags,
			SupportedPlatforms: req.Metadata.SupportedPlatforms,
			LogoURL:            req.Metadata.LogoURL,
			BannerURL:          req.Metadata.BannerURL,
		},
		Documentation: req.Documentation,
		AssetsBaseURL: req.AssetsBaseURL,
	}

	// Execute sync
	result, err := h.syncService.SyncPolicy(c.Request.Context(), syncReq)
	if err != nil {
		_ = c.Error(err)
		return
	}

	response := dto.SyncResponseDTO{
		PolicyName: result.PolicyName,
		Version:    result.Version,
		Status:     result.Status,
	}

	middleware.SendSuccess(c, response)
}
