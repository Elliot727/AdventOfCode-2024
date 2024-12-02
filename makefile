# Makefile for Go projects with cmd/main.go structure

# Application name
APP_NAME := myapp

# Go parameters
GOCMD := go
GOBUILD := $(GOCMD) build
GOCLEAN := $(GOCMD) clean
GOTEST := $(GOCMD) test
GOGET := $(GOCMD) get

# Directories
CMD_DIR := cmd
BUILD_DIR := build
MAIN_PKG := $(CMD_DIR)/main.go

# Build version and git commit details
VERSION := $(shell git describe --tags --always --dirty)
COMMIT := $(shell git rev-parse --short HEAD)
BUILD_TIME := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

# Linker flags to inject version information
LDFLAGS := -ldflags "-X main.Version=$(VERSION) -X main.Commit=$(COMMIT) -X main.BuildTime=$(BUILD_TIME)"

# Default goal
.PHONY: all
all: clean test build

# Build the application
.PHONY: build
build:
	@echo "Building $(APP_NAME)..."
	@mkdir -p $(BUILD_DIR)
	@$(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME) $(MAIN_PKG)
	@echo "Build complete. Binary is in $(BUILD_DIR)/$(APP_NAME)"

# Run the application
.PHONY: run
run:
	@$(GOCMD) run $(MAIN_PKG)

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning up..."
	@$(GOCLEAN)
	@rm -rf $(BUILD_DIR)

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	@$(GOTEST) ./...

# Install dependencies
.PHONY: deps
deps:
	@echo "Downloading dependencies..."
	@$(GOGET) -v ./...

# Cross-compilation for different platforms
.PHONY: build-cross
build-cross:
	@echo "Cross-compiling..."
	@mkdir -p $(BUILD_DIR)
	
	# Linux
	@GOOS=linux GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-linux-amd64 $(MAIN_PKG)
	
	# macOS
	@GOOS=darwin GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-darwin-amd64 $(MAIN_PKG)
	
	# Windows
	@GOOS=windows GOARCH=amd64 $(GOBUILD) $(LDFLAGS) -o $(BUILD_DIR)/$(APP_NAME)-windows-amd64.exe $(MAIN_PKG)

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all       : Clean, test, and build the application"
	@echo "  build     : Compile the application"
	@echo "  run       : Run the application directly"
	@echo "  clean     : Remove build artifacts"
	@echo "  test      : Run all tests"
	@echo "  deps      : Download dependencies"
	@echo "  build-cross : Build for Linux, macOS, and Windows"
	@echo "  help      : Show this help message"