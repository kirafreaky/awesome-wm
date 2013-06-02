-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widgets library
vicious = require("vicious")
require("revelation")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/kirafreaky/.config/awesome/themes/niceandclean/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
manager = "thunar"
browser = "firefox"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,		--1
    awful.layout.suit.tile,		--2
    awful.layout.suit.tile.left,	--3
  --awful.layout.suit.tile.bottom,
  --awful.layout.suit.tile.top,
    awful.layout.suit.fair,		--4
  --awful.layout.suit.fair.horizontal,
  --awful.layout.suit.spiral,
  --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,		--5
  --awful.layout.suit.max.fullscreen,
  --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
tags.settings = {
    { name = "Eins",  layout = layouts[1] },
    { name = "Zwei", layout = layouts[4] },
    { name = "Drei", layout = layouts[1] },
    { name = "Vier", layout = layouts[3] },
    { name = "Fünf", layout = layouts[1] },
}
for s = 1, screen.count() do
    tags[s] = {}
    for i, v in ipairs(tags.settings) do
        tags[s][i] = tag({ name = v.name })
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], "layout", v.layout)
    end
    tags[s][1].selected = true
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "Thunar", manager },
   { "Manual", terminal .. " -e man awesome" },
   { "Theme", "urxvt -e vim .config/awesome/themes/niceandclean/theme.lua"},
   { "Config", "urxvt -e vim .config/awesome/rc.lua" },
   { "Quit", awesome.quit }

}

internetmenu = {   
   { "Firerox", browser },
   { "Luakit", "luakit" },
   { "Opera", "opera" },
   { "Emesene", "emesene" },
   { "Torrent", "transmission-gtk" }
}
mediamenu = {
   { "Ncmpcpp", "urxvt -e ncmpcpp" },
   { "VLC", "vlc" },
   { "MPlayer", "gnome-mplayer" },
   { "Gtkrmd", "gtk-recordMyDesktop" },
   { "GtkPod", "gtkpod" },
--   { "Winff", "winff" },
   { "Kino", "kino" }
}
officemenu = {
   { "LibreOffice","libreoffice" },
   { "Writer","libreoffice --writer"},
   { "Presentation","libreoffice --impress" },
   { "Equation","libreoffice --math"},
   { "Draw","libreoffice --draw" },
   { "Spreadsheet","libreoffice --calc"},

}
gamemenu = {
   { "Space Invaders", "urxvt -e ascii_invaders" },
   { "Ascii Invaders", "urxvt -e ninvaders"},
   { "Invaders3", "urxvt -e vadorz"},
   { "Bomberman", "urxvt -e bomberclone"},
   { "Tetris", "urxvt -e bastet"}
}
manamenu = {
   { "Thunar", manager },
   { "Ranger", "urxvt -e ranger"}
}
editormenu = {
   { "Vim", "urxvt -e vim" },
   { "Gedit", "gedit" },
   { "Geany", "geany" }
}
graphimenu = {
   { "Viewnior", "viewnior" },
   { "Gimp", "gimp" },
   { "Agave", "agave" }
}
sistemenu = {
   { "Tasks", "urxvt -e htop"},
   --{ "Bleachbit", "gksudo bleachbit" },
   --{ "Firestarter", "gksudo firestarter" },
   { "Gparted", "gksudo gparted" },
   { "Pacmatic", "pacmatic"},
   --{ "Amdcccle", "gksudo amdcccle" },
   { "Lxappearance", "lxappearance" },
   { "Qtconfig", "/usr/bin/qtconfig" }
}

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, 
beautiful.awesome_icon },
                                    { "Internet", internetmenu },
				    { "Manager", manamenu },
				    { "Editor", editormenu },
				    { "Media", mediamenu },
				    { "Graphics", graphimenu },
				    { "Games", gamemenu },
				    { "Office", officemenu },
                                    { "System", sistemenu },
				    { "Terminal", terminal },
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Date
datewidget = widget({ type = "textbox", name = "datewidget" })
vicious.register(datewidget, vicious.widgets.date, "%R ", 30)

--Date icon
clockicon = widget({ type = "imagebox" })
clockicon.image = image(awful.util.getdir("config") .. "/icons/clock.png")

--Calendar
require('calendar2')
calendar2.addCalendarToWidget(datewidget, "<span color='cyan'>%s</span>")

-- Battery widget
batwidget = widget({ type = "textbox" })

-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$2% ", 10, "BAT0")
-- Battery Icon
baticon = widget({ type = "imagebox" })
baticon.image = image(awful.util.getdir("config") .. "/icons/bat_full.png")

-- Vol widget 
volwidget = widget({ type = "textbox" })
vicious.register(volwidget, vicious.widgets.volume, "$1%", 1, "Master")

-- Vol icon 
volicon = widget({ type = "imagebox", align = "right" })
volicon.image = image(awful.util.getdir("config") .. "/icons/vol.png")

--MPD

mpdwidget = widget({ type = "textbox" })
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then
            return " "
        elseif args["{state}"] == "Pause" then
		return " "
	else
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 0.5)

-- Mpd icon
mpdicon = widget({ type = "imagebox" })
mpdicon.image = image(awful.util.getdir("config") .. "/icons/note.png")

--Separator
separator = widget({ type = "imagebox" })
separator.image = image(awful.util.getdir("config") .. "/icons/separator.png")

--Spacer
separator2 = widget({ type = "imagebox" })
separator2.image = image(awful.util.getdir("config") .. "/icons/separator2.png")

-- Create a textclock widget
--mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })


-- Create a wibox for each screen and add it
mywibox = {}
mybotwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
	    separator2,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
	datewidget,
	clockicon,
	separator,
	--batwidget,
	--baticon,
	--separator,
	--volwidget,
	--volicon,
	--separator,
	--separator,
	--mpdwidget,
	--mpdicon,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
    mybotwibox[s] = awful.wibox({
       position = "bottom",
       screen = s,
       height = beautiful.bar_height
    })
    mybotwibox[s].widgets = {
        batwidget,
        baticon,
        separator,
	volwidget,
	volicon,
	separator,
        mpdwidget,
        mpdicon,
        separator,
        --wrsystray,
        layout = awful.widget.layout.horizontal.rightleft
    }


end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
    mybotwibox[mouse.screen].visible = not mybotwibox[mouse.screen].visible end),

    -- Exposé
    awful.key({			  }, "XF86LaunchA", revelation),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Music keys
    awful.key({            }, "XF86AudioPlay",     function () awful.util.spawn("mpc toggle" )  end),
    awful.key({            }, "XF86AudioNext",     function () awful.util.spawn("mpc next" )    end),
    awful.key({            }, "XF86AudioPrev",     function () awful.util.spawn("mpc prev" )    end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Firefox" },
      properties = { floating = true } },
    { rule = { class = "Thunar" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
{ rule = { class = "Gnome-mplayer" },
      properties = { floating = true } },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}