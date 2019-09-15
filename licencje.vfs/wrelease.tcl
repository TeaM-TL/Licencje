# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wrelease.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .release] then { 
    destroy .release
}

toplevel .release

ttk::frame .release.f
pack .release.f -fill both

ttk::label .release.f.l1 -text [mc "Name"]
ttk::label .release.f.l2 -text [mc "Date_start"]
ttk::label .release.f.l3 -text [mc "Date_end"]

ttk::entry .release.f.e1 -width 25
mentry::dateMentry .release.f.e2 Ymd .
mentry::dateMentry .release.f.e3 Ymd .

ttk::button .release.f.b1
ttk::button .release.f.b2 -text [mc "Close"] -command {destroy .release}

grid .release.f.l1 .release.f.e1 -padx 1m -pady 1m  -sticky w
grid .release.f.l2 .release.f.e2 -padx 1m -pady 1m -sticky w
grid .release.f.l3 .release.f.e3 -padx 1m -pady 1m -sticky w
grid .release.f.b1 .release.f.b2 -padx 1m -pady 3m

# EOF