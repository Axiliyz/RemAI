package project

import "github.com/jackc/pgx/v5/pgxpool"

type PostgresProjectRepository struct {
	pool *pgxpool.Pool
}

func NewPostgresProjectRepository(pool *pgxpool.Pool) *PostgresProjectRepository {
	return &PostgresProjectRepository{
		pool: pool,
	}
}
