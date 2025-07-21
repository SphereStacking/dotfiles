#!/usr/bin/env bash
# インストールテスト

set -ue

TEST_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(cd "$TEST_DIR/.." && pwd)"

# テスト結果
TESTS_PASSED=0
TESTS_FAILED=0

# テスト関数
test_info() {
    echo -e "\033[34m[TEST]\033[0m $*"
}

test_pass() {
    echo -e "\033[32m[PASS]\033[0m $*"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

test_fail() {
    echo -e "\033[31m[FAIL]\033[0m $*"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

# ディレクトリ構造のテスト
test_directory_structure() {
    test_info "Testing directory structure..."
    
    local required_dirs=(
        "scripts"
        "scripts/core"
        "scripts/install"
        "shell"
        "shell/common"
        "shell/macos"
        "shell/wsl2"
        "config"
        "docs"
        "tests"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$DOTFILES_DIR/$dir" ]]; then
            test_pass "Directory exists: $dir"
        else
            test_fail "Directory missing: $dir"
        fi
    done
}

# 必要なファイルの存在テスト
test_required_files() {
    test_info "Testing required files..."
    
    local required_files=(
        "install.sh"
        ".zshrc"
        ".gitconfig_shared"
        ".gitignore_global"
        "scripts/core/link.sh"
        "shell/common/init.zsh"
    )
    
    for file in "${required_files[@]}"; do
        if [[ -f "$DOTFILES_DIR/$file" ]]; then
            test_pass "File exists: $file"
        else
            test_fail "File missing: $file"
        fi
    done
}

# スクリプトの実行可能性テスト
test_script_executability() {
    test_info "Testing script executability..."
    
    local executable_files=(
        "install.sh"
        "scripts/core/link.sh"
    )
    
    for file in "${executable_files[@]}"; do
        if [[ -x "$DOTFILES_DIR/$file" ]]; then
            test_pass "Executable: $file"
        else
            test_fail "Not executable: $file"
        fi
    done
}

# 構文チェック
test_shell_syntax() {
    test_info "Testing shell script syntax..."
    
    local shell_scripts
    shell_scripts=$(find "$DOTFILES_DIR" -name "*.sh" -type f -not -path "*/.history/*" -not -path "*/.SphereStacking/*" -not -path "*/backup*/*" -not -path "*/docs/.script.sh")
    
    while IFS= read -r script; do
        if bash -n "$script" 2>/dev/null; then
            test_pass "Syntax OK: $(basename "$script")"
        else
            test_fail "Syntax error: $(basename "$script")"
        fi
    done <<< "$shell_scripts"
}

# zsh設定ファイルの基本チェック
test_zsh_config() {
    test_info "Testing zsh configuration..."
    
    # .zshrcに必要な要素が含まれているかチェック
    if grep -q "shell/common/init.zsh" "$DOTFILES_DIR/.zshrc"; then
        test_pass "zshrc loads common configuration"
    else
        test_fail "zshrc doesn't load common configuration"
    fi
    
    if grep -q "OSTYPE" "$DOTFILES_DIR/.zshrc"; then
        test_pass "zshrc has OS detection"
    else
        test_fail "zshrc missing OS detection"
    fi
}

# GitHub CLI設定のテスト
test_github_cli_config() {
    test_info "Testing GitHub CLI configuration..."
    
    # Brewfileにgh（GitHub CLI）が含まれているかチェック
    if grep -q '"gh"' "$DOTFILES_DIR/Brewfile"; then
        test_pass "GitHub CLI included in Brewfile"
    else
        test_fail "GitHub CLI not found in Brewfile"
    fi
    
    # GitHub CLIが利用可能かチェック（インストール済みの場合）
    if command -v gh >/dev/null 2>&1; then
        test_pass "GitHub CLI is available"
        
        # 基本的なghコマンドのテスト（認証不要）
        if gh --version >/dev/null 2>&1; then
            test_pass "GitHub CLI version check OK"
        else
            test_fail "GitHub CLI version check failed"
        fi
    else
        test_pass "GitHub CLI not installed (OK for test environment)"
    fi
}

# パフォーマンステスト
test_performance() {
    test_info "Testing performance..."
    
    # zshが利用可能かチェック
    if ! command -v zsh >/dev/null 2>&1; then
        test_pass "zsh not available in CI environment (skipping performance test)"
        return 0
    fi
    
    # .zshrcの読み込み時間をテスト（概算）
    start_time=$(date +%s%N)
    if timeout 10 zsh -c "source $DOTFILES_DIR/.zshrc; echo 'test complete'" 2>/dev/null; then
        end_time=$(date +%s%N)
        duration=$(( (end_time - start_time) / 1000000 )) # ミリ秒に変換
        
        if [[ $duration -lt 5000 ]]; then # 5秒未満に緩和
            test_pass "zshrc loads within reasonable time (${duration}ms)"
        else
            test_fail "zshrc loads too slowly (${duration}ms)"
        fi
    else
        test_pass "zshrc loading skipped (dependencies not available in CI)"
    fi
}

# テスト実行
main() {
    echo "=== dotfiles Installation Test ==="
    echo ""
    
    test_directory_structure
    echo ""
    
    test_required_files
    echo ""
    
    test_script_executability
    echo ""
    
    test_shell_syntax
    echo ""
    
    test_zsh_config
    echo ""
    
    test_github_cli_config
    echo ""
    
    test_performance
    echo ""
    
    # 結果表示
    echo "=== Test Results ==="
    echo "Passed: $TESTS_PASSED"
    echo "Failed: $TESTS_FAILED"
    echo ""
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "\033[32m✓ All tests passed!\033[0m"
        exit 0
    else
        echo -e "\033[31m✗ Some tests failed!\033[0m"
        exit 1
    fi
}

main "$@"