# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wproduct.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .product] then { 
    destroy .product
}

toplevel .product

ttk::frame .product.f
pack .product.f -fill both

ttk::label .product.f.l1 -text [mc "Name"]
ttk::label .product.f.l2 -text [mc "Kind"]
ttk::label .product.f.l3 -text [mc "First release"]
ttk::label .product.f.l4 -text [mc "Last release"]
ttk::label .product.f.l5 -text [mc "ProductID"]

ttk::entry .product.f.e1 -width 25
ttk::checkbutton .product.f.cb2 -variable kindProduct -text [mc "main/additional"]
ttk::combobox .product.f.cb3 -values [getRelaseList] -width 10 -state readonly
ttk::combobox .product.f.cb4 -values [getRelaseList] -width 10 -state readonly
ttk::entry .product.f.e5 -width 10

ttk::button .product.f.b1
ttk::button .product.f.b2 -text [mc "Close"] -command {destroy .product}

grid .product.f.l1 .product.f.e1 -padx 1m -pady 1m  -sticky w
grid .product.f.l2 .product.f.cb2 -padx 1m -pady 1m -sticky w
grid .product.f.l3 .product.f.cb3 -padx 1m -pady 1m -sticky w
grid .product.f.l4 .product.f.cb4 -padx 1m -pady 1m -sticky w
grid .product.f.l5 .product.f.e5 -padx 1m -pady 1m -sticky w
grid .product.f.b1 .product.f.b2 -padx 1m -pady 3m



# EOF