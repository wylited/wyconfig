# wyconfig

My personal linux config files for customizations and personal choices.

Files & folders descriptions.
```
~/.config/          (Linux makes use of regular slashes, unlike windows...)
> Alacritty/        (https://github.com/alacritty/alacritty, a modern, hardware accelerated terminal. \delta Ayu color scheme + transparency)
> bspwm/            (https://github.com/baskerville/bspwm, tiling x11 wm, binary space paritioning using a binary tree to represent windows)
> doom/             (https://github.com/doomemacs/doomeamcs, An GNU emacs [https://github.com/emacs-mirror/emacs] framework)
> hypr/             (https://github.com/hyprwm, Hypr and Hyprland configurations, amazing animated and slick window managers for linux)
> polybar/          (https://github.com/polybar/polybar, A fast and simple to use tool to create status bars)
> SXHKD/            (https://github.com/baskerville/sxhkd, Simple X11 Hot Key Daemon)
< vscode/           (https://github.com/microsoft/vscode, TODO!)
```

I use [rsync](https://linux.die.net/man/1/rsync) to sync this configuration folder directly to `~/.config`
```
$ rsync -a ~/wyconfig ~/.config
``` 
