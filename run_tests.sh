#!/bin/bash
#
# EMERGE Testing Framework - CLI Test Execution Engine
# 
# Runs all EMERGE unit and integration tests using standard Lua 5.1 interpreter
# with comprehensive Mudlet API mocking.
#
# Usage:
#   ./run_tests.sh              # Run all tests
#   ./run_tests.sh --verbose    # Run with verbose output
#   ./run_tests.sh --help       # Show help
#

set -e  # Exit on any error

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
TEST_DIR="$SCRIPT_DIR/test"
LUA_CMD="lua"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'  
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Function to print colored output
print_color() {
    local color=$1
    shift
    echo -e "${color}$*${RESET}"
}

# Function to print help
show_help() {
    print_color $CYAN "EMERGE Testing Framework - CLI Test Runner"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h        Show this help message"
    echo "  --verbose, -v     Enable verbose output"
    echo "  --list, -l        List available test files"
    echo "  --lua <path>      Specify Lua interpreter path (default: lua)"
    echo ""
    echo "Examples:"
    echo "  $0                # Run all tests"
    echo "  $0 --verbose      # Run with detailed output"
    echo "  $0 --lua lua5.1   # Use specific Lua version"
    echo ""
}

# Function to check Lua installation
check_lua() {
    if ! command -v $LUA_CMD &> /dev/null; then
        print_color $RED "❌ Error: Lua interpreter '$LUA_CMD' not found"
        echo ""
        echo "Please install Lua 5.1 or specify the path with --lua option"
        echo ""
        echo "Installation examples:"
        echo "  Ubuntu/Debian: sudo apt-get install lua5.1"
        echo "  macOS:         brew install lua@5.1"
        echo "  CentOS/RHEL:   sudo yum install lua"
        echo ""
        exit 1
    fi
    
    # Check Lua version
    local lua_version=$($LUA_CMD -v 2>&1 | head -1)
    if [[ $VERBOSE == true ]]; then
        print_color $BLUE "📋 Using: $lua_version"
    fi
}

# Function to list test files
list_test_files() {
    print_color $CYAN "🔍 Available test files:"
    if [ -d "$TEST_DIR" ]; then
        find "$TEST_DIR" -name "*_test.lua" -type f | sort | while read -r file; do
            echo "  • ${file#$SCRIPT_DIR/}"
        done
    else
        print_color $YELLOW "⚠️  Test directory not found: $TEST_DIR"
    fi
}

# Parse command line arguments
VERBOSE=false
LIST_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -l|--list)
            LIST_ONLY=true
            shift
            ;;
        --lua)
            LUA_CMD="$2"
            shift 2
            ;;
        *)
            print_color $RED "❌ Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Handle list-only mode
if [[ $LIST_ONLY == true ]]; then
    list_test_files
    exit 0
fi

# Main execution
main() {
    print_color $BOLD$CYAN "🧪 EMERGE Testing Framework"
    print_color $CYAN "=========================="
    echo ""
    
    # Check prerequisites
    check_lua
    
    # Verify test directory exists
    if [ ! -d "$TEST_DIR" ]; then
        print_color $RED "❌ Error: Test directory not found: $TEST_DIR"
        exit 1
    fi
    
    # Check if BDD runner exists
    local bdd_runner="$TEST_DIR/bdd_runner.lua"
    if [ ! -f "$bdd_runner" ]; then
        print_color $RED "❌ Error: BDD test runner not found: $bdd_runner"
        exit 1
    fi
    
    # Count test files
    local test_count=$(find "$TEST_DIR" -name "*_test.lua" -type f | wc -l)
    if [ "$test_count" -eq 0 ]; then
        print_color $YELLOW "⚠️  No test files found matching pattern *_test.lua"
        echo ""
        echo "Create test files in the test/ directory following the naming convention:"
        echo "  test/emerge_core_test.lua"
        echo "  test/emerge_manager_test.lua" 
        echo "  test/my_feature_test.lua"
        exit 1
    fi
    
    if [[ $VERBOSE == true ]]; then
        print_color $BLUE "📁 Found $test_count test file(s)"
        list_test_files
        echo ""
    fi
    
    # Change to script directory for relative paths to work
    cd "$SCRIPT_DIR"
    
    # Run the BDD test runner
    print_color $BLUE "🚀 Running tests..."
    echo ""
    
    # Execute tests and capture exit code
    set +e  # Don't exit on test failures
    $LUA_CMD "$bdd_runner"
    local test_exit_code=$?
    set -e
    
    echo ""
    
    # Report final result
    if [ $test_exit_code -eq 0 ]; then
        print_color $BOLD$GREEN "✅ All tests passed! EMERGE framework is ready for development."
    else
        print_color $BOLD$RED "❌ Some tests failed. Please review the output above."
        print_color $YELLOW "💡 Tips for fixing test failures:"
        echo "  • Check that modules can be loaded without errors"
        echo "  • Verify API compatibility between modules" 
        echo "  • Ensure event-driven architecture is followed"
        echo "  • Review error messages for specific issues"
    fi
    
    echo ""
    
    # Exit with the same code as the test runner
    exit $test_exit_code
}

# Execute main function
main "$@"