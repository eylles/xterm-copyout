# XTerm CopyOut

Copy from the xterm scrollback buffer without mouse.


If you ever seen a luke smith video on his st build you got an idea of what this can achieve.


## installation


### requirements

- xterm (of course)
- fzf (the best)
- xclip (to copy into your clipboard)
- notify-send (notifications are nice feedback)
- coreutils


```sh
git clone https://github.com/eylles/xterm-copyout

cd xterm-copyout
make install
```

Add this to your xterm and uxterm config in xresources
```c
! XTerm options
! ··· some XTerm options ···
XTerm*printerCommand: sh -c 'xterm-copyout <&3' 3<&0
! print with ansi colors
XTerm*printAttributes: 2
! keybind overrides
XTerm*VT100.Translations: #override \n\
    Ctrl <Key>slash: print-everything() \n\
! ··· more XTerm options ···


! UXTerm options
! ··· some UXTerm options ···
UXTerm*printerCommand: sh -c 'xterm-copyout <&3' 3<&0
! print with ansi colors
UXTerm*printAttributes: 2
! keybind overrides
UXTerm*VT100.Translations: #override \n\
    Ctrl <Key>slash: print-everything() \n\
! ··· more UXTerm options ···
```

Reload your xresources
```sh
xrdb ~/path/to/your/xresources/file
```
