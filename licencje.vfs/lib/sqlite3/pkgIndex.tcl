# pkgIndex.tcl - Copyright (C) 2004 Pat Thoyts <patthoyts@users.sf.net>
#
# The package will simply not be provided on incompatible versions.

namespace eval ::platform {
    proc platform {} {
        global tcl_platform
        set plat [lindex $tcl_platform(os) 0]
        set mach $tcl_platform(machine)
        switch -glob -- $mach {
            sun4* { set mach sparc }
            intel -
            i*86* { set mach x86 }
            "Power Macintosh" { set mach ppc }
        }
        switch -- $plat {
          AIX   { set mach ppc }
          HP-UX { set mach hppa }
        }
        if {[string equal $plat "Darwin"] \
                && [llength [info command ::tk]] != 0} {
            append mach -[::tk windowingsystem]
        }
        return "$plat-$mach"
    }
}

set qwerty [::platform::platform] 

package ifneeded sqlite3 3.8.0.1 \
    [list load [file join $dir [::platform::platform] tclsqlite3[info sharedlibextension]] Sqlite3]


# EOF