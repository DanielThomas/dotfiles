# Consume unrecognized CSI sequences rather than letting zsh's line editor
# self-insert trailing bytes. Ghostty encodes Ctrl+punctuation as CSI u
# sequences (e.g. Ctrl+, → ESC[44;5u) which zsh has no bindings for.
#
# This binds the CSI introducer ESC[ as a catch-all. ZSH's prefix-based
# key matching means longer bindings (arrow keys, home/end, etc.) still
# match first — this only fires for sequences nothing else has claimed.
# The widget reads until the ECMA-48 final byte (0x40-0x7E) to consume
# the full sequence.
#
# https://www.reddit.com/r/zsh/comments/yzhx3l/zle_binkey_skip_csi_sequences/
function skip-csi-sequence() {
  local key
  while read -sk key && (( $((#key)) < 0x40 || $((#key)) > 0x7E )); do
    # consume parameter and intermediate bytes
  done
}

zle -N skip-csi-sequence
bindkey '\e[' skip-csi-sequence
