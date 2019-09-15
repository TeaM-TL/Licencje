# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wkeylist.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .keylist] then { 
    destroy .keylist
}

toplevel .keylist
wm title .keylist [mc "List of dongles and flying licenses"]

#############################  pane
ttk::panedwindow .keylist.pane -orient vertical
pack .keylist.pane -padx 2m -pady 2m -expand 1 -fill both

############################ f2
ttk::labelframe .keylist.pane.f2 -text [mc "List of dongles and flying licenses"]

ctext .keylist.pane.f2.text -relief sunken \
    -xscrollcommand ".keylist.pane.f2.x set" \
    -yscrollcommand ".keylist.pane.f2.y set" \
    -bd 2 -setgrid 1 -undo 1 -wrap none \
    -font {Courier 9}  -height 15 -width 100
ttk::scrollbar .keylist.pane.f2.x -command ".keylist.pane.f2.text xview" \
    -orient horizontal
ttk::scrollbar .keylist.pane.f2.y -command ".keylist.pane.f2.text yview"
pack .keylist.pane.f2.x -side bottom -fill x
pack .keylist.pane.f2.y -side right -fill y
pack .keylist.pane.f2.text -expand yes -fill both

# syntax highlight
ctext::addHighlightClassForRegexp .keylist.pane.f2.text keyred red {^#.*}
ctext::addHighlightClassForRegexp .keylist.pane.f2.text keyblue blue {^[^#]+}
ctext::addHighlightClassForSpecialChars  .keylist.pane.f2.text keymagenta magenta {#}

############################ f3
ttk::labelframe .keylist.f3 -text [mc "Filters"]

ttk::checkbutton .keylist.f3.cb1 -text [mc "Number"]   -variable fkNumber
ttk::checkbutton .keylist.f3.cb2 -text [mc "Type"]     -variable fkType
ttk::checkbutton .keylist.f3.cb3 -text [mc "Date in"]  -variable fkDateIn
ttk::checkbutton .keylist.f3.cb4 -text [mc "Date out"] -variable fkDateOut
ttk::checkbutton .keylist.f3.cb5 -text [mc "Doc No"]   -variable fkDocNo
ttk::checkbutton .keylist.f3.cb6 -text [mc "Current"]  -variable fkCurrent
ttk::checkbutton .keylist.f3.cb7 -text [mc "Previous"] -variable fkPrevious
ttk::button .keylist.f3.br -text [mc "Refresh"]
pack .keylist.f3.cb1 .keylist.f3.cb2 .keylist.f3.cb3 \
    .keylist.f3.cb4 .keylist.f3.cb5 .keylist.f3.cb6 \
    .keylist.f3.cb7 \
    -side left -padx 2m
if ![info exists fkNumber]   then {set fkNumber "1"}
if ![info exists fkType]     then {set fkType "1"}
if ![info exists fkDateIn]   then {set fkDateIn "0"}
if ![info exists fkDateOut]  then {set fkDateOut "0"}
if ![info exists fkDocNo]    then {set fkDocNo "0"}
if ![info exists fkCurrent]  then {set fkCurrent "0"}
if ![info exists fkPrevious] then {set fkPrevious "0"}

############################ f4
ttk::frame .keylist.f4

ttk::button .keylist.f4.b1 -text [mc "Generate PDF"]
ttk::button .keylist.f4.b2 -text [mc "View PDF"]
ttk::button .keylist.f4.b3 -text [mc "Save to file"]
ttk::button .keylist.f4.b4 -text [mc "Close"] -command {destroy .keylist}

pack  .keylist.f4.b3 .keylist.f4.b4 -side left -padx 2m

############################ frames
pack .keylist.pane.f2 -padx 2m -pady 1m -expand 1 -fill both
pack .keylist.f3 -padx 2m -pady 1m 
pack .keylist.f4 -padx 2m -pady 1m

############################# paned windows
.keylist.pane add .keylist.pane.f2

# EOF