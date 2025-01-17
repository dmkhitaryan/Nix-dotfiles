.PHONY: update-home
update-home:
	home-manager switch --flake /home/necoarc/dotfiles#necoarc

.PHONY: update-os
update-os:
	sudo nixos-rebuild switch --flake /home/necoarc/dotfiles#necoarc

.PHONY: clean
clean:
	sudo nix-collect-garbage -d
