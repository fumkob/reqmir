.DEFAULT_GOAL := help

.PHONY: help doctor build build-app test test-ios tools-resolve lint format format-check

IOS_DEVICE ?= iPhone 18 Pro
IOS_OS ?= latest
# The scheme Xcode generates for the whole package; the per-library schemes have no tests.
IOS_SCHEME ?= reqmir-Package

# SwiftLint ships as an artifact bundle rather than an executable target, so `swift run swiftlint`
# does not work; the resolved binary is called directly.
SWIFTLINT := Tools/.build/artifacts/swiftlint/SwiftLintBinary/SwiftLintBinary.artifactbundle/macos/swiftlint
# Inside artifacts/ so that deleting the downloaded binary also invalidates the stamp.
TOOLS_STAMP := Tools/.build/artifacts/.tools-resolved
# `find -exec {} +` rather than `find | xargs`: with no matching files, xargs would start
# swift-format with no arguments and it would hang reading stdin.
SWIFT_FILES := find Sources Tests App Package.swift Tools/Package.swift -name '*.swift' \
	-not -path '*/.build/*'

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

tools-resolve: $(TOOLS_STAMP) ## Resolve the Tools package and fetch the pinned SwiftLint

$(TOOLS_STAMP): Tools/Package.swift Tools/Package.resolved
	swift package --package-path Tools resolve
	@touch $@

lint: $(TOOLS_STAMP) ## Run SwiftLint (warnings fail the run)
	$(SWIFTLINT) lint --strict

format: ## Rewrite Swift files with swift-format
	$(SWIFT_FILES) -exec xcrun swift-format format -i --parallel {} +

format-check: ## Check formatting with swift-format without rewriting files
	$(SWIFT_FILES) -exec xcrun swift-format lint --strict --parallel {} +
