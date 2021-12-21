![VIMPS Logo](VIMPS_Banner.png)

<p align="center">
    Current Version: 2.0.0 (December 2021)
</p>

## What is VIMBIUS?
VIMBIUS (VIM Basic Input Utilities) is a lightweight collection of VIM Utilities designed to help with the highlighting and creation of DAI-Specific Files. This used to be included as part of Vimbius but was removed to reduce complexity and plugin size.

## Prerequisites:
* Plugin syntax highlighting and additional features requires the presence of the[vim-plugin-syntax](https://github.com/cburj/vim-plugin-syntax/) plugin.

## Features:
* Matflo Code snippets - a number of common code snippets can be found in the main menu (bind ```mm```). There are also a few quick snippets such as creating an ```if( !XXX_ValidRecNo )``` statement based off the current variable under your cursor using keybind ```cvr``` (Check Valid RecNo).
* Display current function name with ```f``` or jump to the top of the current function with ```ff```
* Single-line commenting for Plugin, SDF, DF Alias and WIKI files using ```com``` to toggle comment on/off.
* Hash include shortcut to convert the filename under your cursor to a ```#include "xxx_lib.h"``` statement using ```hi```.
* Save/Quit menu for people who can't remember how to do this in VIM ;) this can be found in the Main Menu by pressing ```mm```
* Convert a Template file using its file name. For example you can rename a template to manual_loc_lib.c, edit the file and run the converter. Every instance of ```XXX/Xxx/xxx``` will be converted to ```MANUAL_LOC/ManualLoc/manual_loc```. This can be accessed in the main menu (```mm```) and selecting ```Convert Template```.
* Show output of ```hg status .``` in a new split to the right. Also includes Syntax highlighting to replicate the output seen in the terminal (as best as possible). You can then choose to "invert" the status of a file by hovering over the file and pressing ```<C-x>``` (```ctrl+x```). For example, an uncommited file is ADDED and a modified file is REVERTED etc. You can also open a file from this menu by pressing ```enter```, the file will then be opened in a new tab on the left. Tabs can be switched between by using ```gt```.

## Main Keybind:
* ```mm``` Draws the VIMBIUS Main Menu Popup Box, where you can acess most tools (including code snippets)

## Installation with a Plugin Manager
* Add the following to your .vimrc file where you would normally install plugins: ``` Plug 'cburj/vimbius'```
* Save and Quit the file.
* Open a new VIM buffer and call ```:PlugInstall```
* Wait for the plugin to clone and install.

## Updating VIMBIUS with a Plugin Manager
* Open a new VIM buffer and call ```:PlugUpdate```

## Contributing
If you feel comfortable developing new features in Vimscript, then feel free to create a pull request and I will gladly merge in your code!

## Planned Development
* Config/Settings - allow users to set global options in their ```.vimrc``` that influence the behaviour of VIMBIUS. E.g. Disabling specific keybinds.
* Show list of all keybinds in a Main menu option, to make things a bit easier to learn.
