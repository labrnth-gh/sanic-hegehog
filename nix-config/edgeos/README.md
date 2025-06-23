## Edge-OS Configuration (NixOS)

While this configuration can be applied to any computer running NixOS, 
it is meant to be "flashed" to a bare NixOS system that: has internet acecss and
is reachable over the network.


To provision:
1. `cd` to this folder
2. Use `nixos-anywhere` fetch the `hardware-configuration.nix` from the edge device
   and install NixOS with to the disk. Note that `EDGE_DEVICE_IP` is the IP address
   of your edge device.
   ```bash
   nix run github:nix-community/nixos-anywhere -- \
     --flake .#nixos-edge \
     --generate-hardware-config nixos-generate-config ./hardware-configuration.nix \
     --target-host user@EDGE_DEVICE_IP
   ```

When the installation is done, the device should automatically reboot and be 
accessable at the same IP address.

> [!NOTE]
> You should now have a `hardware-configuration.nix` in this folder
> corresponding to the hardware configuraiton on the edge device.

To update:
At this point, the edge device is provisioned with NixOS and our software 
configuration. However, the *configurations themselves* do not exist on the
edge device. In order to update the edge device, run the following command from
this folder. (Note, this presumes that you have the `hardware-configuration.nix`)
file generated during the installation step described in the previous section.
```bash
nix run nixpkgs#nixos-rebuild -- \
  --target-host user@EDGE_DEVICE_IP \
  --use-remote-sudo \
  switch \
  --flake .#nixos-edge
```



> [!NOTE]
Take note of the following (copied from [the note in nixos-anywhere quickstart](https://github.com/nix-community/nixos-anywhere/blob/ff87db6a952191648ffaea97ec5559784c7223c6/docs/quickstart.md?plain=1#L271)
> 
> If you have previously accessed this server using SSH, you may see the following
> message the next time you try to log in to the target.
> 
> ```
> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
> @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
> @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
> IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
> Someone could be eavesdropping on you right now (man-in-the-middle attack)!
> It is also possible that a host key has just been changed.
> The fingerprint for the ED25519 key sent by the remote host is
> XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
> Please contact your system administrator.
> Add correct host key in ~/.ssh/known_hosts to get rid of this message.
> Offending ECDSA key in ~/.ssh/known_hosts:6
>   remove with:
>   ssh-keygen -f ~/.ssh/known_hosts" -R "<ip address>"
> Host key for <ip_address> has changed and you have requested strict checking.
> Host key verification failed.
> ```
> 
> This is because the `known_hosts` file in the `.ssh` directory now contains a
> mismatch, since the server has been overwritten. To solve this, use a text
> editor to remove the old entry from the `known_hosts` file (or use the command
> `ssh-keygen -R <ip_address>`). The next connection attempt will then treat this
> as a new server.
> 
> The error message line `Offending ECDSA key in ~/.ssh/known_hosts:6` gives the
> line number that needs to be removed from the `known_hosts` file (line 6 in this
> example).
