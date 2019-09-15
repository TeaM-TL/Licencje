# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wlicense.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .license] then { 
    destroy .license
}

toplevel .license

ttk::frame .license.f
pack .license.f -fill both

ttk::label .license.f.l1 -text [mc "Number/HostId"]
ttk::label .license.f.l2 -text [mc "Product"]
ttk::label .license.f.l3 -text [mc "License No"]
ttk::label .license.f.l4 -text [mc "Valid until"]
ttk::label .license.f.l5 -text [mc "Quantity"]

ttk::entry .license.f.e1
ttk::combobox .license.f.cb2 -values [getProductList] -state readonly -width 25
ttk::entry .license.f.e3 -font {Courier 9}
mentry::dateMentry .license.f.e4 Ymd .
ttk::entry .license.f.e5 -width 3 -validate key \
    -validatecommand {expr [string is int %P]}
#    -validatecommand {expr {[string is int %P] && ![string match "0*" %P]}}

ttk::button .license.f.b1
ttk::button .license.f.b2 -text [mc "Close"] -command {destroy .license}

grid .license.f.l1 .license.f.e1 -padx 1m -pady 1m -sticky w
grid .license.f.l2 .license.f.cb2 -padx 1m -pady 1m -sticky w
grid .license.f.l3 .license.f.e3 -padx 1m -pady 1m -sticky w
grid .license.f.l4 .license.f.e4 -padx 1m -pady 1m -sticky w
grid .license.f.l5 .license.f.e5 -padx 1m -pady 1m -sticky w
grid .license.f.b1 .license.f.b2 -padx 1m -pady 3m

# EOF