#### pipenv
export PIPENV_VENV_IN_PROJECT=true

#### XDG Base Directory
# macOS では未設定時に ~/Library/Application Support へフォールバックするツールがあるため明示する
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
