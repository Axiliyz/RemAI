package project

import (
	"context"
	"fmt"
	"strings"
)

type ProjectService struct {
	projectRepo ProjectRepository
}

func NewProjectService(repo ProjectRepository) *ProjectService {
	return &ProjectService{
		projectRepo: repo,
	}
}

func (s *ProjectService) Create(ctx context.Context, project Project) (int64, error) {
	if strings.TrimSpace(project.Name) == "" {
		return 0, ErrInvalidProjectName
	}
	id, err := s.projectRepo.Create(ctx, project)
	if err != nil {
		return 0, fmt.Errorf("create project: %w", err)
	}
	return id, nil
}
