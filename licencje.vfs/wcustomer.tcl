# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wcustomer.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .customer] then { 
    destroy .customer
}

toplevel .customer

ttk::frame .customer.f
pack .customer.f -fill both

ttk::label .customer.f.l1 -text [mc "Name"]
ttk::label .customer.f.l2 -text [mc "City"]
ttk::label .customer.f.l3 -text [mc "CustomerId"]
ttk::label .customer.f.l4 -text [mc "Zip code"]
ttk::label .customer.f.l5 -text [mc "Address"]
ttk::label .customer.f.l6 -text [mc "Comment"]
ttk::label .customer.f.l7 -text [mc "Person"]
ttk::label .customer.f.l8 -text [mc "Phone"]
ttk::label .customer.f.l9 -text [mc "E-mail"]

ttk::entry .customer.f.e1 -width 50
ttk::entry .customer.f.e2 -width 30
ttk::entry .customer.f.e3
ttk::entry .customer.f.e4 -width 10
ttk::entry .customer.f.e5 -width 40
ttk::entry .customer.f.e6 -width 40
ttk::entry .customer.f.e7
ttk::entry .customer.f.e8
ttk::entry .customer.f.e9

ttk::button .customer.f.b1
ttk::button .customer.f.b2 -text [mc "Close"] -command {destroy .customer}

grid .customer.f.l1 .customer.f.e1 -padx 1m -pady 1m -sticky w
grid .customer.f.l2 .customer.f.e2 -padx 1m -pady 1m -sticky w
grid .customer.f.l3 .customer.f.e3 -padx 1m -pady 1m -sticky w
grid .customer.f.l4 .customer.f.e4 -padx 1m -pady 1m -sticky w
grid .customer.f.l5 .customer.f.e5 -padx 1m -pady 1m -sticky w
grid .customer.f.l6 .customer.f.e6 -padx 1m -pady 1m -sticky w
grid .customer.f.l7 .customer.f.e7 -padx 1m -pady 1m -sticky w
grid .customer.f.l8 .customer.f.e8 -padx 1m -pady 1m -sticky w
grid .customer.f.l9 .customer.f.e9 -padx 1m -pady 1m -sticky w
grid .customer.f.b1 .customer.f.b2 -padx 1m -pady 3m
# EOF