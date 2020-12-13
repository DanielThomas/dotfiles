## Sensible defaults for Mac OS

# Show the ~/Library folder
chflags nohidden ~/Library

# Set a really fast initial and subsequent key repeat
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10

# Disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Disable smart quotes
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Showing and hiding sheets, resizing preference windows, zooming windows
# float 0 doesn't work
defaults write -g NSWindowResizeTime -float 0.001
