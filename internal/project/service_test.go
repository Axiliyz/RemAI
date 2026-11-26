package project

import (
	"context"
	"errors"
	"testing"
)

type FakeProjectRepository struct {
	called      bool
	returnID    int64
	returnError error
}

func (f *FakeProjectRepository) Create(ctx context.Context, project Project) (int64, error) {
	f.called = true
	return f.returnID, f.returnError
}

func TestProjectService(t *testing.T) {
	tests := []struct {
		name             string
		input            Project
		expectedID       int64
		expectedError    error
		repositoryCalled bool
	}{
		{
			name:             "empty name",
			input:            Project{Name: "   "},
			expectedID:       0,
			expectedError:    ErrInvalidProjectName,
			repositoryCalled: false,
		},
		{
			name:             "okay",
			input:            Project{Name: "play"},
			expectedID:       1,
			expectedError:    nil,
			repositoryCalled: true,
		},
		{
			name:             "error",
			input:            Project{Name: "error"},
			expectedID:       0,
			expectedError:    errors.New("database unavailable"),
			repositoryCalled: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			repo := &FakeProjectRepository{
				returnID:    tt.expectedID,
				returnError: tt.expectedError,
			}
			projectService := NewProjectService(repo)
			actual, err := projectService.Create(context.Background(), tt.input)
			if actual != tt.expectedID {
				t.Errorf("expected %v got %v", tt.expectedID, actual)
			}
			if tt.expectedError != nil {
				if !errors.Is(err, tt.expectedError) {
					t.Errorf("expected %v, got %v", tt.expectedError, err)
				}
			} else if err != nil {
				t.Errorf("expected no error, got %v", err)
			}
			if repo.called != tt.repositoryCalled {
				t.Errorf("repo called = %v, expected %v", repo.called, tt.repositoryCalled)
			}
		})

	}
}
