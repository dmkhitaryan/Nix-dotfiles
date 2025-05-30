{config, pkgs, ...}:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "dmenu_run" ''
      dmenu_execs="$(${pkgs.dmenu}/bin/dmenu_path)"
      app=$(echo "$dmenu_execs" | ${pkgs.dmenu}/bin/dmenu "$@" -i -p "Dmenu: ") || exit
      
      declare -A GPU_APPS=(
        ["floorp"]=1
        ["steam"]=1
        ["vesktop"]=1
      )

      if [[ -n ''${GPU_APPS[$app]} ]]; then
        exec nvidia-offload "$app"
      else
        exec "$app"
      fi
    
    '')
  ];
}