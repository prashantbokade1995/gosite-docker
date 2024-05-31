# Use the official Golang image as a build stage
FROM golang:1.19 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go application source code to the container
COPY . .

# Build the Go application
RUN go mod init myapp && go mod tidy && go build -o myapp

# Use a minimal base image to run the Go application
FROM ubuntu:22.04

# Update the package list and install dependencies
RUN apt update && apt install -y ca-certificates && apt install -y golang

# Set the working directory inside the container
WORKDIR /app

# Copy the built Go application from the builder stage
COPY --from=builder /app/myapp .

# Expose the port the application runs on
EXPOSE 8080

# Command to run the application
CMD ["./myapp"]
