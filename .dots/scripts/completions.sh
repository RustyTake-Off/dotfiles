#!/usr/bin/env bash
# Completions for various cli tools

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.2

# Completions for bash
if [ -f /usr/share/bash-completion/bash_completion ]; then
  source "/usr/share/bash-completion/bash_completion"
elif [ -f /etc/bash_completion ]; then
  source "/etc/bash_completion"
fi

# Completions for brew
if [ -f "$(command -v /home/linuxbrew/.linuxbrew/bin/brew)" ]; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# Completions for nvm
if [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]; then
  source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi

# Completions for pip/pip3
if [ -x "$(command -v pip)" ]; then
  _pip_completion() {
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" COMP_CWORD=$COMP_CWORD PIP_AUTO_COMPLETE=1 $1 2>/dev/null ) )
  }
  complete -o default -F _pip_completion pip
  complete -o default -F _pip_completion pip3
fi

# Completions for azcli
if [ -x "$(command -v az)" ]; then
  source "$HOME/lib/azure-cli/az.completion"
fi

# Completions for npm
if [ -x "$(command -v npm)" ]; then
  if type complete &>/dev/null; then
    _npm_completion () {
      local words cword
      if type _get_comp_words_by_ref &>/dev/null; then
        _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
      else
        cword="$COMP_CWORD"
        words=("${COMP_WORDS[@]}")
      fi

      local si="$IFS"
      if ! IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                            COMP_LINE="$COMP_LINE" \
                            COMP_POINT="$COMP_POINT" \
                            npm completion -- "${words[@]}" \
                            2>/dev/null)); then
        local ret=$?
        IFS="$si"
        return $ret
      fi
      IFS="$si"
      if type __ltrim_colon_completions &>/dev/null; then
        __ltrim_colon_completions "${words[cword]}"
      fi
    }
    complete -o default -F _npm_completion npm
  elif type compdef &>/dev/null; then
    _npm_completion() {
      local si=$IFS
      compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                  COMP_LINE=$BUFFER \
                  COMP_POINT=0 \
                  npm completion -- "${words[@]}" \
                  2>/dev/null)
      IFS=$si
    }
    compdef _npm_completion npm
  elif type compctl &>/dev/null; then
    _npm_completion () {
      local cword line point words si
      read -Ac words
      read -cn cword
      let cword-=1
      read -l line
      read -ln point
      si="$IFS"
      if ! IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                        COMP_LINE="$line" \
                        COMP_POINT="$point" \
                        npm completion -- "${words[@]}" \
                        2>/dev/null)); then

        local ret=$?
        IFS="$si"
        return $ret
      fi
      IFS="$si"
    }
    compctl -K _npm_completion npm
  fi
fi

# Completions for node
if [ -x "$(command -v node)" ]; then
  _node_complete() {
    local cur_word options
    cur_word="${COMP_WORDS[COMP_CWORD]}"
    if [[ "${cur_word}" == -* ]] ; then
      COMPREPLY=( $(compgen -W '--experimental-sea-config --tls-min-v1.1 --addons --node-memory-debug --experimental-specifier-resolution --prof-process --trace-warnings --force-async-hooks-checks --diagnostic-dir --insecure-http-parser --watch-preserve-output --heapsnapshot-near-heap-limit --disable-warning --heapsnapshot-signal --experimental-wasi-unstable-preview1 --interactive --experimental-vm-modules --inspect-port --cpu-prof-interval --heap-prof-interval --experimental-fetch --http-parser --experimental-loader --enable-source-maps --input-type --jitless --experimental-require-module --check --experimental-network-imports --inspect --experimental-global-webcrypto --experimental-policy --track-heap-objects --cpu-prof --experimental-detect-module --policy-integrity --trace-atomics-wait --allow-addons --watch --experimental-default-type --trace-deprecation --eval --experimental-test-coverage --disallow-code-generation-from-strings --title --throw-deprecation --heap-prof-dir --warnings --expose-internals --pending-deprecation --tls-min-v1.2 --preserve-symlinks-main --allow-fs-write --global-search-paths --experimental-global-customevent --prof --import --test --trace-sigint --experimental-json-modules --openssl-shared-config --conditions --help --security-revert --watch-path --tls-cipher-list --test-timeout --disable-proto --env-file --zero-fill-buffers --require --experimental-worker --test-shard --use-bundled-ca --experimental-top-level-await --openssl-legacy-provider --v8-pool-size --force-fips --experimental-shadow-realm --completion-bash --preserve-symlinks --test-reporter-destination --trace-event-file-pattern --secure-heap-min --abort-on-uncaught-exception --trace-event-categories --v8-options --network-family-autoselection-attempt-timeout --report-dir --build-snapshot-config --disable-wasm-trap-handler --unhandled-rejections --snapshot-blob --report-exclude-network --experimental-websocket --tls-min-v1.3 --enable-fips --report-on-fatalerror --huge-max-old-generation-size --node-snapshot --icu-data-dir --experimental-abortcontroller --report-filename --experimental-permission --interpreted-frames-native-stack --experimental-wasm-modules --use-openssl-ca --test-name-pattern --use-largepages --test-reporter --secure-heap --napi-modules --tls-keylog --extra-info-on-fatal-exception --stack-trace-limit --openssl-config --trace-uncaught --experimental-repl-await --debug-brk --trace-tls --tls-max-v1.2 --test-concurrency --force-node-api-uncaught-exceptions-policy --perf-basic-prof-only-functions --experimental-print-required-tla --report-compact --debug-arraybuffer-allocations --trace-sync-io --force-context-aware --max-semi-space-size --perf-prof-unwinding-info --allow-child-process --max-http-header-size --redirect-warnings --enable-etw-stack-walking --perf-basic-prof --max-old-space-size --allow-worker --print --report-signal --dns-result-order --test-only --network-family-autoselection --cpu-prof-name --report-uncaught-exception --inspect-wait --perf-prof --trace-exit --harmony-shadow-realm --heap-prof-name --version --frozen-intrinsics --inspect-brk --inspect-publish-uid --test-udp-no-try-send --tls-max-v1.3 --heap-prof --report-on-signal --cpu-prof-dir --allow-wasi --tls-min-v1.0 --inspect-brk-node --test-force-exit --deprecation --trace-promises --experimental-import-meta-resolve --experimental-modules --experimental-report --allow-fs-read --build-snapshot --debug --verify-base-objects --debug-port --inspect= -i --debug= --debug-brk= -e --inspect-brk= --inspect-wait= -C -pe --enable-network-family-autoselection --prof-process --loader --inspect-brk-node= -c -r --print <arg> --trace-events-enabled -v --security-reverts --es-module-specifier-resolution -h -p --report-directory' -- "${cur_word}") )
      return 0
    else
      COMPREPLY=( $(compgen -f "${cur_word}") )
      return 0
    fi
  }
  complete -o filenames -o nospace -o bashdefault -F _node_complete node node_g
fi
