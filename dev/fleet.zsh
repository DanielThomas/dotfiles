if [ ! -z "$CODER_WORKSPACE_NAME" ]; then
	dest_dir="$HOME/.local/lib"
	mkdir -p "$dest_dir"
	launcher="$dest_dir/fleet"
	if [ ! -f "$launcher" ]; then
		echo "Bootstrapping Fleet launcher..."
		arch=$(arch)
		if [[ "x86_64" == "$arch" ]]; then
			arch="x64"
		fi
		curl -LSs "https://download.jetbrains.com/product?code=FLL&release.type=preview&release.type=eap&platform=linux_$arch" --output "$launcher" && chmod +x "$launcher"
	fi
	fleet_cache=/home/coder/.cache/JetBrains/Fleet
	fleet_workspace="$fleet_cache/workspace-params"
	if [ ! -f "$fleet_cache/dock.address" ]; then
		(nohup $launcher launch workspace -- --auth=accept-everyone 2>&1 &) | grep -m 1 'Join this workspace using URL' | cut -d '?' -f 2 > "$fleet_workspace"
	fi
fi
