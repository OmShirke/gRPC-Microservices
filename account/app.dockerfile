# Build Stage
FROM golang:1.20-alpine3.20.3 AS build

# Install build dependencies
RUN apk --no-cache add gcc g++ make ca-certificates

# Set the working directory inside the container
WORKDIR /go/src/github.com/OmShirke/gRPC-Microservices

# Copy necessary files for dependency resolution and building
COPY go.mod go.sum ./
RUN go mod download

# Copy the vendor and service-specific files
COPY vendor vendor
COPY account account

# Build the Go application
RUN GO111MODULE=on go build -mod vendor -o /go/bin/account-service ./account/cmd/account

# Runtime Stage
FROM alpine:3.20.3

# Set the working directory
WORKDIR /usr/bin

# Copy the built binary from the build stage
COPY --from=build /go/bin/account-service .

# Expose the service port
EXPOSE 8080

# Define the startup command
CMD ["account-service"]
