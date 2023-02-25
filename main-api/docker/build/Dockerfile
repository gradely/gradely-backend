# Specify the version of Alpine Linux being used
FROM golang:1.18-alpine3.14 as build

# Enable Go modules
ENV GO111MODULE=on

# Set the working directory
WORKDIR /app

# Copy only the necessary files and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application code
COPY . .

# Disable cgo for a static binary
ENV CGO_ENABLED=0

# Run tests
#RUN go test ./...

# Build the application
RUN go build -o api

# Expose the port that the application listens on
EXPOSE 8080

# Start the application when the container starts
CMD [ "./api" ]