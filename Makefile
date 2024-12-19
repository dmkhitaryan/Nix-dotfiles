.PHONY: update
update:
	home-manager switch --flake .#necoarc

.PHONY: update
clean:
	sudo nix-collect-garbage -d
