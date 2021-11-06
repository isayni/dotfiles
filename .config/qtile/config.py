# QTile window manager config file
import subprocess, os, time
from typing import List

from libqtile import qtile, bar, layout, widget, hook, extension
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
bar_size=22
terminal = guess_terminal()

# tokyonight
colors = ['#1a1b26', #0
          '#ccd0f0',
          '#24283b', #8
          '#ff7a93', #1
          '#b9f27c', #2
          '#ff9e64', #3
          '#7da6ff', #4
          '#bb9af7', #5
          '#0db9d7', #6
          '#acb0d0'] #7

# gruvbox
colors = ['#242424', #0
          '#fbf1c7', #1
          '#383535', #2
          # '#cc241d',
          # '#98971a',
          # '#d79921',
          # '#458588',
          # '#b16286',
          # '#689d6a',
          # '#a89984']
          '#fb4934', #3
          '#b8bb26', #4
          '#fabd2f', #5
          '#83a598', #6
          '#d3869b', #7
          '#8ec07c', #8
          '#ebdbb2'] #9

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

    # Audio
    Key([], "XF86AudioLowerVolume", lazy.spawn('volumecontrol down')),
    Key([], "XF86AudioRaiseVolume", lazy.spawn('volumecontrol up')),
    Key([], "XF86AudioMute",        lazy.spawn('volumecontrol mute')),

    # Spawn
    Key([mod], "Return",     lazy.spawn(terminal)),
    Key([mod], "f",          lazy.spawn("firefox")),
    Key([mod], "e",          lazy.spawn("pcmanfm-qt")),
    Key([mod], "r",          lazy.spawn("dmenu_run")),
    Key([mod, "shift"], "r", lazy.spawn("dmenu_sudo")),
    Key([mod], "F1",         lazy.spawn("dmenu_confedit")),
    Key([mod], "F2",         lazy.spawn("color-picker.sh")),
    Key([mod], "F3",         lazy.spawn("dmenu_unicode")),
    Key([], "Scroll_Lock",   lazy.spawn("clip2qr")),
    Key([], "Print",         lazy.spawn("screenshot")),
    Key([], 'F1',            lazy.run_extension(extension.WindowList(dmenu_font = 'JetBrains Mono'))),

    # Scratchpads
    Key([mod], "x", lazy.group['scratchpad'].dropdown_toggle('term')),
    Key([mod], "z", lazy.group['scratchpad'].dropdown_toggle('pavu')),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False),
            desc="Move focused window to group {}".format(i.name)),
    ])

groups.extend([
    ScratchPad('scratchpad', [
        DropDown('term', 'alacritty -o background_opacity=1',
                 opacity=1,
                 width=0.95,
                 x=0.025,
                 y=0.006
        ),
        DropDown('pavu', 'pavucontrol',
                 opacity=1,
                 width=0.4,
                 height=0.4,
                 x=0.3,
                 y=0.006
        )
    ])
])

################################################
"""LAYOUTS"""
layout_theme = {
    "margin": 4,
    "border_width": 2,
    "border_focus": '#d79921',
    "border_normal": colors[0],
}
floating_theme = {
    "margin": 0,
    "border_width": 2,
    "border_focus": colors[8],
    "border_normal": colors[7]
}
layouts = [
    layout.Columns(
        **layout_theme
    ),
    # layout.Floating(
        # **layout_theme
    # ),
    # layout.TreeTab(
        # active_bg=colors[7],
        # bg_color='#121212',
        # border_width=2,
        # inactive_bg=colors[8],
        # inactive_fg='#000000',
        # padding_y=5,
        # panel_width=160,
        # previous_on_rm=True,
        # font='Inconsolata Bold',
        # fontsize=18,
        # padding_x=10,
        # section_left=20,
        # section_fontsize=16,
        # section_top=10
    # ),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.Max(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.VerticalTile(),
    layout.Zoomy(),
]

widget_defaults = dict(
    font='Fira Code SemiBold',
    fontsize=15,
    padding=4,
    foreground=colors[9],
    background=colors[0]
)
extension_defaults = widget_defaults.copy()

widgets = [
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
        active = colors[1],
        inactive = colors[2],
        this_current_screen_border = colors[3],
        other_screen_border = colors[6],
    ),
    widget.WindowName(
        background = colors[2]
    ),
    widget.Memory(
        foreground = colors[3],
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.CPU(
        foreground = colors[4],
        format = '{freq_current}GHz {load_percent}%'
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.Net(
        interface = "enp34s0",
        format = '⬇{down} ⬆{up}',
        foreground = colors[6]
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.Systray(
        background = colors[2],
    ),
    widget.Sep(
        margin=10,
        linewidth = 2,
        padding = 4
    ),
    widget.Clock(
        format='%d %B - %a %H:%M:%S',
        foreground = colors[5]
    ),
    widget.Sep(
        linewidth = 2,
        padding = 4
    ),
    widget.Image(
        filename = '~/YTOW/img/icons/power_button.png',
        margin = 4,
        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("dmenu_power")}
    ),
    widget.Sep(
        linewidth = 0,
        padding = 4
    ),
            ]

screens = [
    Screen(
        top=bar.Bar(
            widgets,
            size=bar_size,
            margin=[4, 6, 2, 6]
        ),
    ),
    Screen(
        top=bar.Bar([
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
                active = colors[1],
                inactive = colors[2],
                this_current_screen_border = colors[3],
                other_screen_border = colors[6],
            ),
            widget.WindowName(
                background = colors[2]
            ),
            widget.Clock(
                format='%H:%M:%S',
                foreground = colors[5]
            ),
        ],
            size=bar_size,
            margin=[4, 6, 2, 6]
        ),
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
    Match(wm_class='timeshift-gtk'),
    Match(wm_class='pavucontrol'),
    Match(wm_class='GParted'),
    Match(wm_class='battle.net.exe'),
    Match(wm_class='pcmanfm-qt'),
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
main = None  # WARNING: this is deprecated and will be removed soon

follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"

wmname = "LG3D"

# Prevent floating windows to go behind the stacked ones
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
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])
