package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Printf("Handling %s request for %s from %s..\n", r.Method, r.URL, r.RemoteAddr)
    fmt.Fprintf(w, "Hello World!")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Listening on port 8080..")
    http.ListenAndServe(":8080", nil)
}

