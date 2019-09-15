# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wkey.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .key] then { 
    destroy .key
}
toplevel .key

ttk::frame .key.f
pack .key.f -fill both
ttk::label .key.f.l0 -text [mc "Customer"]
ttk::label .key.f.l1 -text [mc "Number/HostId"]
ttk::label .key.f.l2 -text [mc "Kind"]
ttk::label .key.f.l3 -text [mc "Date in"]
ttk::label .key.f.l4 -text [mc "Date out"]
ttk::label .key.f.l5 -text [mc "Doc No"]
ttk::label .key.f.l6 -text [mc "Previous"]
ttk::label .key.f.l7 -text [mc "Current"]
ttk::label .key.f.l8 -text [mc "Date sold"]
ttk::label .key.f.l9 -text [mc "Maintenance"]
ttk::label .key.f.l10 -text [mc "Maintenance Date"]

ttk::label .key.f.l01
ttk::entry .key.f.e1
ttk::combobox .key.f.cb2 -values [list "USB" "HASP" "NetHASP" "LPT" "FLY"] -width 8
mentry::dateMentry .key.f.e3 Ymd .
mentry::dateMentry .key.f.e4 Ymd .
ttk::entry .key.f.e5
ttk::combobox .key.f.cb6 
ttk::checkbutton .key.f.e7 -text [mc "Yes/No"] \
    -variable wkeyActive
mentry::dateMentry .key.f.e8 Ymd .
ttk::checkbutton .key.f.e9 -text [mc "Yes/No"] \
    -variable wkeyMaint -onvalue 1 -offvalue 0
mentry::dateMentry .key.f.e10 Ymd .

ttk::button .key.f.b1
ttk::button .key.f.b2 -text [mc "Close"] -command {destroy .key} 

grid .key.f.l0  .key.f.l01 -padx 1m -pady 1m -sticky w
grid .key.f.l1  .key.f.e1  -padx 1m -pady 1m -sticky w
grid .key.f.l2  .key.f.cb2 -padx 1m -pady 1m -sticky w
grid .key.f.l3  .key.f.e3  -padx 1m -pady 1m -sticky w
grid .key.f.l4  .key.f.e4  -padx 1m -pady 1m -sticky w
grid .key.f.l5  .key.f.e5  -padx 1m -pady 1m -sticky w
grid .key.f.l6  .key.f.cb6 -padx 1m -pady 1m -sticky w
grid .key.f.l7  .key.f.e7  -padx 1m -pady 1m -sticky w
grid .key.f.l8  .key.f.e8  -padx 1m -pady 1m -sticky w
grid .key.f.l9  .key.f.e9  -padx 1m -pady 1m -sticky w
grid .key.f.l10 .key.f.e10 -padx 1m -pady 1m -sticky w
grid .key.f.b1  .key.f.b2  -padx 1m -pady 3m

# EOF