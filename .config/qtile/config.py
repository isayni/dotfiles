"""   ___  _   _ _
     / _ \| |_(_) | ___
    | | | | __| | |/ _ \
    | |_| | |_| | |  __/
     \__\_\\__|_|_|\___|

    Configuartion file for Qtile window manager.
"""
import subprocess, os
from typing import List

from libqtile import qtile, bar, layout, widget, hook, extension
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

bar_size     = 22
colorscheme  = "gruvbox"
netinterface = "enp34s0"
mod          = "mod4"
terminal     = "alacritty" # guess_terminal()
browser      = "librewolf"
filemanager  = "pcmanfm"
margin       = 4

def init_colors():
    if colorscheme == "tokyonight":
        return {
            "background": '#1a1b26', #0
            "foreground": '#ccd0f0', #1
            "black":      '#24283b', #2
            "red":        '#ff7a93', #3
            "green":      '#b9f27c', #4
            "yellow":     '#ff9e64', #5
            "blue":       '#7da6ff', #6
            "magenta":    '#bb9af7', #7
            "cyan":       '#0db9d7', #8
            "white":      '#acb0d0', #9
        }
    if colorscheme == "gruvbox":
        return {
            # "background": '#242424', #0
            "background": '#101010', #0
            "foreground": '#fbf1c7', #1
            # "black":      '#383535', #2
            "black":      '#262626', #2
            "red":        '#fb4934', #3
            "green":      '#b8bb26', #4
            "yellow":     '#fabd2f', #5
            "blue":       '#83a598', #6
            "magenta":    '#d3869b', #7
            "cyan":       '#8ec07c', #8
            "white":      '#ebdbb2', #9
        }
colors = init_colors()

keys = [
    # Switch between windows
    Key([mod], "h",     lazy.layout.left()),
    Key([mod], "l",     lazy.layout.right()),
    Key([mod], "j",     lazy.layout.down()),
    Key([mod], "k",     lazy.layout.up()),
    Key([mod], "Tab",   lazy.next_screen()),

    # Move windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "k", lazy.layout.grow_up()),

    # Toggle between split and unsplit sides of stack.
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),

    # Controls
    Key([mod], "w",            lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "Escape",       lazy.window.toggle_fullscreen()),
    Key([mod], "b",            lazy.hide_show_bar("top")),

    # Audio
    Key([], "XF86AudioLowerVolume", lazy.spawn('volumecontrol down')),
    Key([], "XF86AudioRaiseVolume", lazy.spawn('volumecontrol up')),
    Key([], "XF86AudioMute",        lazy.spawn('volumecontrol mute')),

    # Spotify
    Key([], "XF86AudioPlay",        lazy.spawn(
        'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify '\
        '/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause'
    )),
    Key([], "XF86AudioPrev",        lazy.spawn(
        'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify '\
        '/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous'
    )),
    Key([], "XF86AudioNext",        lazy.spawn(
        'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify '\
        '/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next'
    )),

    # Spawn
    Key([mod], "Return",     lazy.spawn(terminal)),
    Key([mod], "f",          lazy.spawn(browser)),
    Key([mod], "e",          lazy.spawn(filemanager)),
    Key([mod], "r",          lazy.spawn("rofi -show drun")),
    Key([mod, "shift"], "r", lazy.spawn("rofi -show drun -run-command 'gksudo {cmd}'")),
    Key([mod], "F1",         lazy.spawn("dmenu_confedit")),
    Key([mod], "F2",         lazy.spawn("color-picker.sh")),
    Key([mod], "F3",         lazy.spawn("dmenu_movie")),
    Key([mod], "F4",         lazy.spawn("dmenu_vm")),
    Key([], "Scroll_Lock",   lazy.spawn("clip2qr")),
    Key([], "Print",         lazy.spawn("screenshot")),
    Key([mod], "z",          lazy.spawn("pavucontrol")),
    Key([], 'F1',            lazy.spawn("rofi -show window")),

    # Scratchpads
    Key([mod], "x", lazy.group['scratchpad'].dropdown_toggle('term')),
    Key([mod], "y", lazy.group['chatgpt'].dropdown_toggle('term')),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod1 + shift + letter of group = move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False)),
    ])

groups.extend([
    ScratchPad('scratchpad', [
        DropDown('term', 'alacritty -o window.opacity=1',
            opacity=1,
            width=0.95,
            x=0.025,
            y=0.006
        ),
    ]),
    ScratchPad('chatgpt', [
        DropDown('term', 'alacritty -o window.opacity=1 -e chatgpt',
            opacity=1,
            width=0.95,
            x=0.025,
            y=0.006
        ),
    ])
])

layout_theme = {
    "margin": margin,
    "border_width": 2,
    "margin_on_single": margin,
    "border_focus": colors["red"],
    "border_normal": colors["background"],
    "border_focus_stack": colors["cyan"],
    "border_normal_stack": colors["background"]
}
floating_theme = {
    "margin": 0,
    "border_width": 2,
    "border_focus": colors["cyan"],
    "border_normal": colors["magenta"]
}
layouts = [
    layout.Columns(**layout_theme),
    layout.Zoomy(**layout_theme),
]
second_screen_layouts = [
    layout.Columns(num_columns=1, insert_position=1, **layout_theme)
]

widget_defaults = dict(
    font='Fira Code SemiBold',
    fontsize=15,
    padding=4,
    foreground=colors["white"],
    background=colors["background"]
)
extension_defaults = widget_defaults.copy()

main_widgets = [
    widget.CurrentLayoutIcon(
        scale = 0.8,
        padding = 6,
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.GroupBox(
        font = 'Inconsolata extra expanded black',
        disable_drag = True,
        borderwidth = 2,
        highlight_method = 'line',
        highlight_color = '#111111',
        active = colors["foreground"],
        inactive = colors["black"],
        this_current_screen_border = colors["red"],
        this_screen_border = colors["white"],
        other_screen_border = colors["blue"],
        other_current_screen_border = colors["black"],
    ),
    widget.WindowName(
        background = colors["black"]
    ),
    widget.Memory(
        foreground = colors["red"],
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.CPU(
        foreground = colors["green"],
        format = '{freq_current}GHz {load_percent}%'
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.Net(
        interface = netinterface,
        format = '⬇{down} ⬆{up}',
        foreground = colors["blue"]
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.Systray(
        background = colors["black"],
    ),
    widget.Sep(
        margin=10,
        linewidth = 2,
        padding = 4
    ),
    widget.Clock(
        format='%d %B - %a %H:%M:%S',
        foreground = colors["yellow"]
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.Image(
        filename = '~/.config/qtile/power_button.png',
        margin = 4,
        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("dmenu_power")}
    ),
    widget.Sep(
        linewidth = 0,
        padding = 4
    ),
]
second_screen_widgets = [
    widget.CurrentLayoutIcon(
        scale = 0.8,
        padding = 6,
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.GroupBox(
        font = 'Inconsolata extra expanded black',
        disable_drag = True,
        borderwidth = 2,
        highlight_method = 'line',
        highlight_color = '#111111',
        active = colors["foreground"],
        inactive = colors["black"],
        this_current_screen_border = colors["red"],
        this_screen_border = colors["white"],
        other_screen_border = colors["blue"],
        other_current_screen_border = colors["black"],
    ),
    widget.WindowName(
        background = colors["black"]
    ),
    widget.Clock(
        format='%H:%M:%S',
        foreground = colors["yellow"]
    ),
]
screens = [
    Screen(
        top=bar.Bar(
            main_widgets,
            size=bar_size,
            margin=[margin, margin, 0, margin]
        ),
        wallpaper="/usr/share/wallpapers/dt/0142.jpg",
        wallpaper_mode="fill"
    ),
    Screen(
        top=bar.Bar(
            second_screen_widgets,
            size=bar_size,
            margin=[margin, margin, 0, margin]
        ),
        wallpaper="/usr/share/wallpapers/dt/0142.jpg",
        wallpaper_mode="fill"
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.toggle_floating())
]

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='unetbootin.elf'),
    # Match(wm_class=''),
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
], **floating_theme)

dgroups_key_binder = None
dgroups_app_rules = []  # type: List

follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"

wmname = "Qtile"

# Prevent floating windows from going behind the tiled ones
@hook.subscribe.focus_change
def float_to_front():
    if qtile.current_window.floating:
        qtile.current_window.cmd_bring_to_front()
    else:
        for window in qtile.current_group.windows:
            if window.floating:
                window.cmd_bring_to_front()

@hook.subscribe.startup_once
def autostart():
    subprocess.Popen(
        [os.path.expanduser('~/.config/qtile/autostart.sh')]
    )

@hook.subscribe.startup
def start():
    if len(qtile.screens) > 1:
        qtile.groups[8]._configure(second_screen_layouts, floating_layout, qtile)

        qtile.groups_map['1'].cmd_toscreen(0)
        qtile.groups_map['9'].cmd_toscreen(1)
