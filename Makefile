.PHONY: clean check build.local build.linux build.osx build.docker build.push

BINARY        		 ?= tiny-docker-http-test
VERSION       		 ?= $(shell git describe --tags --always --dirty)
IMAGE         		 ?= hjacobs/$(BINARY)
TAG           		 ?= $(VERSION)
GITHEAD       		 = $(shell git rev-parse --short HEAD)
GITURL        		 = $(shell git config --get remote.origin.url)
GITSTATUS     		 = $(shell git status --porcelain || echo "no changes")
SOURCES       		 = $(shell find . -name '*.go')
DOCKERFILE    		 ?= Dockerfile
GOPKGS        		 = $(shell go list ./... | grep -v /vendor/)
BUILD_FLAGS   		 ?= -v
LDFLAGS       		 ?= -X main.version=$(VERSION) -w -s

default: build.local

clean:
	rm -rf build

test:
	go test -v -race $(GOPKGS)

fmt:
	go fmt $(GOPKGS)

check:
	golint $(GOPKGS)
	go vet -v $(GOPKGS)

build.local: build/$(BINARY)
build.linux: build/linux/$(BINARY)
build.osx: build/osx/$(BINARY)

build/$(BINARY): $(SOURCES)
	CGO_ENABLED=0 go build -o build/$(BINARY) $(BUILD_FLAGS) -ldflags "$(LDFLAGS)" .

build/linux/$(BINARY): $(SOURCES)
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build $(BUILD_FLAGS) -o build/linux/$(BINARY) -ldflags "$(LDFLAGS)" .

build/osx/$(BINARY): $(SOURCES)
	GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build $(BUILD_FLAGS) -o build/osx/$(BINARY) -ldflags "$(LDFLAGS)" .

build.docker: scm-source.json build.linux #zalando compliant image
	docker build --rm -t "$(IMAGE):$(TAG)" -f $(DOCKERFILE) .

build.push: build.docker
	docker push "$(IMAGE):$(TAG)"

scm-source.json: .git
	@echo '{"url": "git:$(GITURL)", "revision": "$(GITHEAD)", "author": "$(USER)", "status": "$(GITSTATUS)"}' > scm-source.json
