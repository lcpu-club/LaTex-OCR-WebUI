# Makefile

export MONOREPO_REVISION := $(shell git rev-parse HEAD)
export BRANCH_NAME ?= main
export LATEX_OCR_UI_BRANCH ?= code.lcpu.dev/lcpu/latex-ocr-ui:$(BRANCH_NAME)
export LATEX_OCR_UI_LATEST ?= code.lcpu.dev/lcpu/latex-ocr-ui:main
export LATEX_OCR_UI_TAG ?= code.lcpu.dev/lcpu/latex-ocr-ui:$(BRANCH_NAME)-$(MONOREPO_REVISION)

all: build

build:
	docker build \
	  --build-arg BUILDKIT_INLINE_CACHE=1 \
	  --progress=plain \
	  --file Dockerfile \
	  --pull \
	  --cache-from $(OVERLEAF_BASE_LATEST) \
	  --cache-from $(OVERLEAF_BASE_BRANCH) \
	  --tag $(OVERLEAF_BASE_TAG) \
	  --tag $(OVERLEAF_BASE_BRANCH) \
	.
	
.PHONY: all build-base build-community
