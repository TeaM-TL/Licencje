# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: wmaint.tcl 14 2013-01-26 12:58:02Z tlu $
############################
if [winfo exists .maint] then { 
    destroy .maint
}

toplevel .maint
wm title .maint [mc "Window to manage dates of maintenase/warranty"]
ttk::frame .maint.f
pack .maint.f -fill both

ttk::labelframe .maint.f.f2 -text [mc "Hardlocks/Felics"]
grid .maint.f.f2 -row 2 -column 1 -sticky nswe -padx 2m -pady 1m

tablelist::tablelist .maint.f.f2.t \
    -columns {0 "Id" 0 "IdKey" 0 "KeyNo" 0 "DateSold" 0 "DateMaintenanse" 0 "Comments"} \
    -width 50 -height 8 \
    -stretch all -setfocus 0 \
    -labelcommand tablelist::sortByColumn \
    -xscrollcommand ".maint.f.f2.x set" \
    -yscrollcommand ".maint.f.f2.y set"
# scrollbars
scrollbar .maint.f.f2.x -orient horizontal \
    -command ".maint.f.f2.t xview"
scrollbar .maint.f.f2.y -orient vertical \
    -command ".maint.f.f2.t yview"

pack .maint.f.f2.x -side bottom -fill x
pack .maint.f.f2.y -side right -fill y
pack .maint.f.f2.t -fill both -expand 1

########
#Buttons
ttk::frame .maint.f.f3
grid .maint.f.f3 -row 3 -column 1 -sticky nswe -padx 2m -pady 1m

# ttk::entry .maint.f.f3.e1
# mentry::dateMentry .maint.f.f3.e3 Ymd .
# mentry::dateMentry .maint.f.f3.e4 Ymd .
# ttk::entry .maint.f.f3.e7 -width 1

ttk::button .maint.f.f3.b1 -text [mc "Save"]
ttk::button .maint.f.f3.b2 -text [mc "Close"] -command {destroy .maint}

grid .maint.f.f3.b1 .maint.f.f3.b2

# EOF