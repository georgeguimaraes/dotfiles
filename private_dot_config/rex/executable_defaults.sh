#!/bin/sh
# Rex app settings that init.lua can't hold. Quit Rex before running.
defaults write com.superlogical.rex Workspace.terminalFontName -string "VictorMono Nerd Font Mono"
defaults write com.superlogical.rex Workspace.terminalFontPointSize -float 18
defaults write com.superlogical.rex Workspace.terminalFontSmoothing -bool true
