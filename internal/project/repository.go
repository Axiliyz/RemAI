package project

import (
	"context"
)

type ProjectRepository interface {
	Create(ctx context.Context, project Project) (int64, error)
}
