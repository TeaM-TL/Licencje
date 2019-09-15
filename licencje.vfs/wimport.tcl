# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wimport.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .import] then { 
    destroy .import
}
if [winfo exists .mpimport] then { 
    destroy .mpimport
}

toplevel .import
wm title .import [mc "Import licenses from file"]

#############################  pane
ttk::panedwindow .import.pane -orient vertical

############################# f1
ttk::frame .import.f1

ttk::label .import.f1.l -text [mc "Number/HostId"]
ttk::entry .import.f1.e
grid .import.f1.l .import.f1.e -padx 2m

############################# f2
ttk::labelframe .import.pane.f2 -text [mc "List of products"]

tablelist::tablelist .import.pane.f2.t \
    -columns {0 "License No" 0 "Product" 0 "Valid" 0 "Quantity" 0 "ProductId"} \
    -width 80 -height 10 -font {Courier 9} \
    -stretch all -setfocus 0 -selectmode extended\
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand ".import.pane.f2.x set" \
    -yscrollcommand ".import.pane.f2.y set"
.import.pane.f2.t columnconfigure 0 -title [mc "License No"]
.import.pane.f2.t columnconfigure 1 -title [mc "Product"]
.import.pane.f2.t columnconfigure 2 -title [mc "Valid until"]
.import.pane.f2.t columnconfigure 3 -title [mc "Quantity"]
.import.pane.f2.t columnconfigure 4 -hide 1
# scrollbars
scrollbar .import.pane.f2.x -orient horizontal \
    -command ".import.pane.f2.t xview"
scrollbar .import.pane.f2.y -orient vertical \
    -command ".import.pane.f2.t yview"

pack .import.pane.f2.x -side bottom -fill x
pack .import.pane.f2.y -side right -fill y
pack .import.pane.f2.t -fill both -expand 1

############################# f3
ttk::labelframe .import.pane.f3 -text [mc "License sheet"]

ctext .import.pane.f3.text -relief sunken \
    -xscrollcommand ".import.pane.f3.x set" \
    -yscrollcommand ".import.pane.f3.y set" \
    -bd 2 -setgrid 1 -undo 1 -wrap none \
    -font {Courier 9}  -height 10 -width 80
ttk::scrollbar .import.pane.f3.x -command ".import.pane.f3.text xview" \
    -orient horizontal
ttk::scrollbar .import.pane.f3.y -command ".import.pane.f3.text yview"
pack .import.pane.f3.x -side bottom -fill x
pack .import.pane.f3.y -side right -fill y
pack .import.pane.f3.text -expand yes -fill both

# autohide scroll
#::autoscroll::autoscroll .import.pane.f3.x
#::autoscroll::autoscroll .import.pane.f3.y
# syntax highlight
ctext::addHighlightClassForRegexp .import.pane.f3.text comments blue {#[^\n\r]*}

############################# f4
ttk::frame .import.f4

ttk::button .import.f4.b1 -text [mc "Open"]
ttk::button .import.f4.b2 -text [mc "Save"]
ttk::button .import.f4.b3 -text [mc "Close"] -command {destroy .import}

pack .import.f4.b1 .import.f4.b2 .import.f4.b3 -side left -padx 2m -expand 0

############################# frames
pack .import.f1 -padx 2m -pady 1m 
pack .import.pane -padx 2m -pady 1m -expand 1 -fill both
pack .import.f4 -padx 2m -pady 1m

############################# paned windows
.import.pane add .import.pane.f2
.import.pane add .import.pane.f3

############################# menu
menu .mpimport
.mpimport add command -label [mc "Remove"] -command {
    foreach i [.import.pane.f2.t curselection] {
	.import.pane.f2.t delete $i
    }
}
.mpimport add separator
.mpimport add command -label [mc "Close"]

####
# bind
bind [.import.pane.f2.t bodytag] <Button-3> {
    foreach {tablelist::W tablelist::x tablelist::y} \
 	[tablelist::convEventFields %W %x %y] {}
    set rowimport [.import.pane.f2.t containing $tablelist::y]
    tk_popup .mpimport %X %Y
}

# EOF