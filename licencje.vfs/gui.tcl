# -*-Tcl-*-
## 2007-2014 Tomasz Luczak tlu@temertech.com
# $Id: gui.tcl 24 2014-01-13 13:13:19Z tlu $
############################

wm title . "[mc "Licenses Protections Management System, rev. %s" $RELEASE] \[$ArchOS\]- (c) 2007-2014 Tomasz £uczak"
wm protocol . WM_DELETE_WINDOW chk_exit
wm state . zoomed
wm iconbitmap . -default $sourcedir/licencje.ico 


ttk::frame .f
pack .f -fill both -expand 1

# Notebook
ttk::notebook .f.nb
set frm1 [ttk::frame .f.nb.frm1]
.f.nb add .f.nb.frm1 -text [mc "Hardlocks and Felics"]
source "$filegui1"
set frm2 [ttk::frame .f.nb.frm2]
.f.nb add .f.nb.frm2 -text [mc "Customers"]
source "$filegui2"
set frm3 [ttk::frame .f.nb.frm3]
.f.nb add .f.nb.frm3 -text [mc "Stats"]
source "$filegui3"
set frm5 [ttk::frame .f.nb.frm5]
.f.nb add .f.nb.frm5 -text [mc "Products and Releases"]
source "$filegui5"
.f.nb select $frm2
pack .f.nb -padx 1m -pady 1m -fill both -expand 1


#enable keyboard traversal for a dialog box
ttk::notebook::enableTraversal .f.nb

####################################
## status bar
ttk::frame .fs -relief ridge -borderwidth 2

## status label
ttk::label .fs.wait -foreground red -font {helvetica 10 bold}
## progressbar
set progressnormal 0
set progresswidth 500
ttk::progressbar .fs.pb -variable progressnormal \
    -maximum 100 -orient horizontal -length $progresswidth

#pack .fs  -fill x -ipadx 2m
#pack .fs.wait -anchor w -padx 5m -side left
#pack .fs.pb -anchor ne  -side left -expand 1 -fill y

#########
# Queries
# GUI1
reloadKeysList
#reloadKeyLicenseList
# GUI2
reloadCustomerList
# GUI3
reloadStatProductList
# GUI5
reloadProductList
reloadReleaseList
#########
# Initial focus on search field
focus $f2.f3.f34.e

# Bind
## for focus on current widget
#bind . <Motion> {focus %W}

# Help
bind . <F1> {help}

# debug console
bind . <F4> {
    if {$windows eq 1} then {
	console show
    }
}

# debug window
bind . <F9> {source [file join $sourcedir debug.tcl]}

# EOF