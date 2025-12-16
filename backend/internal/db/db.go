/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
 *
 * This software is the property of WSO2 LLC. and its suppliers, if any.
 * Dissemination of any information or reproduction of any material contained
 * herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
 * You may not alter or remove any copyright or other notice from copies of this content.
 */

package db

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5/pgxpool"
	"go.uber.org/zap"

	"github.com/wso2/policyhub/internal/config"
	"github.com/wso2/policyhub/internal/logging"
)

// DB wraps the database connection
type DB struct {
	*pgxpool.Pool
}

// NewDB creates a new database connection
func NewDB(cfg *config.DatabaseConfig, logger *logging.Logger) (*DB, error) {
	logger.Info("Connecting to database",
		zap.String("driver", "pgx"),
		zap.String("host", cfg.Host),
	)

	config, err := pgxpool.ParseConfig(cfg.DSN())
	if err != nil {
		return nil, fmt.Errorf("failed to parse config: %w", err)
	}

	// Set connection pool settings
	config.MaxConns = int32(cfg.MaxConns)
	config.MinConns = int32(cfg.MinConns)

	pool, err := pgxpool.NewWithConfig(context.Background(), config)
	if err != nil {
		return nil, fmt.Errorf("failed to create pool: %w", err)
	}

	// Ping database to verify connection
	if err := pool.Ping(context.Background()); err != nil {
		return nil, fmt.Errorf("failed to ping database: %w", err)
	}

	logger.Info("Database connection established")

	return &DB{
		Pool: pool,
	}, nil
}

// Close closes the database connection
func (db *DB) Close() error {
	db.Pool.Close()
	return nil
}
