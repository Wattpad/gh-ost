.PHONY: clean ghost build push

PREFIX=wattpad/gh-ost-rds
REPO_INFO=$(shell git config --get remote.origin.url)
BINARY=gh-ost

ifndef VERSION
  VERSION := git-$(shell git rev-parse --short HEAD)
endif

ifndef TAG
  TAG := $(VERSION)
endif

clean:
	rm -f $(BINARY)

ghost: clean
	GOOS=linux go build -a -ldflags \
		"-w -X main.AppVersion=${VERSION}" \
		-o $(BINARY) \
		go/cmd/gh-ost/main.go

build: ghost
	docker build -t $(PREFIX):$(TAG) .
	docker tag $(PREFIX):$(TAG) $(PREFIX):latest

push: build
	docker push $(PREFIX):$(TAG)
	docker push $(PREFIX):latest
