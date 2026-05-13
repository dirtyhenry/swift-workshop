default: build

# Build the Swift package
build:
    swift build

# Run the test suite (pass extra args, e.g. `just test --filter MyTest`)
test *ARGS:
    swift test {{ARGS}}

# Run the package executable (if one is defined)
run:
    swift run

# Remove build artifacts from .build/
clean:
    swift package clean

# Resolve package dependencies from Package.resolved
resolve:
    swift package resolve

# Update package dependencies to their latest allowed versions
update:
    swift package update

# Open the package in Xcode
open:
    open Package.swift

# Format all Swift sources in place
format:
    swift format --in-place --recursive Sources Tests Package.swift

# Install Node dependencies (changesets CLI) via Yarn
install:
    yarn install

# Add a new changeset describing the next release's changes
changeset:
    yarn changeset

# Consume pending changesets: bump version and update CHANGELOG.md
changeset-version:
    yarn changeset version

# Show pending changesets and the next version they would produce
changeset-status:
    yarn changeset status

# Create a git tag for the current version
changeset-tag:
    yarn changeset tag
