package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"
)

type HealthRespone struct {
	Status string `json:"status"`
}

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("GET /health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		response := HealthRespone{
			Status: "ok",
		}

		if err := json.NewEncoder(w).Encode(response); err != nil {
			log.Printf("failed to encode response: %v", err)
		}
	})

	server := http.Server{
		Addr:              ":8080",
		Handler:           mux,
		ReadHeaderTimeout: 5 * time.Second,
		ReadTimeout:       15 * time.Second,
		WriteTimeout:      30 * time.Second,
		MaxHeaderBytes:    1 << 20,
	}
	log.Println("RemAI started on :8080")
	if err := server.ListenAndServe(); err != nil {
		log.Fatal(err)
	}
}
