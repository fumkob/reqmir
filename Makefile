.DEFAULT_GOAL := help

.PHONY: help doctor build build-app test test-ios

IOS_DEVICE ?= iPhone 18 Pro
IOS_OS ?= latest
# The scheme Xcode generates for the whole package; the per-library schemes have no tests.
IOS_SCHEME ?= reqmir-Package

# $(shell ...) returns an empty string and carries on even when the command fails. Unless we
# stop here, builds would silently run with whichever Xcode xcode-select points at.
DEVELOPER_DIR := $(shell scripts/developer-dir.sh)
ifeq ($(strip $(DEVELOPER_DIR)),)
$(error Could not determine which Xcode to use (see the message above))
endif
export DEVELOPER_DIR

help: ## List the targets
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk -F ':.*## ' '{printf "  %-14s %s\n", $$1, $$2}'

doctor: ## Show the Xcode, Swift, iOS runtimes, and simulator devices in use
	@echo "DEVELOPER_DIR: $(DEVELOPER_DIR)"
	@echo
	@xcodebuild -version
	@echo
	@swift --version 2>&1
	@echo
	@echo "iOS runtimes:"
	@xcrun simctl list runtimes iOS
	@echo
	@echo "Available simulator devices:"
	@xcrun simctl list devices available iOS

build: build-app ## Build the Swift package and the Mac app
	swift build

# Signing is off so that the build works without a development team, both here and on CI.
build-app: ## Build the Mac app without code signing
	xcodebuild build -quiet -project App/Reqmir.xcodeproj -scheme Reqmir \
		-destination 'generic/platform=macOS' CODE_SIGNING_ALLOWED=NO

test: ## Run the package tests on macOS
	swift test

test-ios: ## Run the package tests on the iOS simulator (IOS_DEVICE, IOS_OS)
	xcodebuild test -quiet -scheme '$(IOS_SCHEME)' \
		-destination 'platform=iOS Simulator,name=$(IOS_DEVICE),OS=$(IOS_OS)'
