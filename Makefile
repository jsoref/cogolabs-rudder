# Variable Config
PWD := $(shell pwd)
GOPATH := $(shell go env GOPATH)

all: build
.PHONY: test

# Building
build:
	@echo "Building Rudder to $(PWD)/rudder..."
	@GO111MODULE=on go build -o $(PWD)/rudder ./cmd/rudder
	
# Linting and testing
$(GOPATH)/bin/golangci-lint:
	@curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(go env GOPATH)/bin v1.17.1
lint: $(GOPATH)/bin/golangci-lint
	@echo "Running golangci-lint"
	@golangci-lint run ./internal/... ./cmd/...
test:
	@GO111MODULE=on go test -race -covermode=atomic -coverprofile=c.out ./internal/...

# Remove generated files
clean:
	@echo "Cleaning up all generated files"
	@rm -rf $(PWD)/rudder
	@rm -rf $(PWD)/c.out
	@rm -rf $(PWD)/kube
	@rm -rf $(PWD)/dist

