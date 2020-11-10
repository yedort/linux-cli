# Restart sound processes
pulseaudio -k
sudo alsa force-reload

# Empty trash
sudo rm -rf ~/.local/share/Trash/files/*

# will be updated...
