# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: proc.tcl 14 2013-01-26 12:58:02Z tlu $
########################################
proc chk_exit {} {
    global db
    set ans [tk_messageBox -type yesno -icon question \
		 -message [mc "Are you sure you want to quit?"]]
    if { $ans != "no" } {
	db close
	exit
    }
};


# get product list
proc getProductList {} {
    global db

    set QUERY "SELECT name FROM products ORDER BY name"
#    puts $QUERY
    return [db eval $QUERY]
}

# get customer name during Add hardlock
proc getGustomerName idCustomer {
    global db 

    set QUERY "SELECT name FROM customers WHERE id=$idCustomer"
#    puts $QUERY
    db eval $QUERY values {
	return $values(name)
    }
}

# show customer name after click on hardlock list
# frame 1
proc getCustomerName idKey {
    global db
    set customerName ""
    if {$idKey ne ""} then {
	set QUERY "SELECT name FROM customers WHERE id IN (SELECT id_customer FROM soldkeys WHERE id_key=$idKey)"
#	puts $QUERY
	db eval $QUERY values {
	    set customerName $values(name)
	}
    }
    return $customerName
}

# get release
proc getRelease {id} {
    global db

    if {$id ne ""} then {
	set QUERY "SELECT id,name FROM releases WHERE id=$id"
#	puts $QUERY
	db eval $QUERY values {
	    set result $values(name)
	}	
    } else {
	set result ""
    }
    return $result
}
########
proc getRelaseList {} {
    global db

    set QUERY "SELECT id,name FROM releases ORDER BY name"
#    puts $QUERY
    set releases ""
    db eval $QUERY values {
	lappend releases $values(name)
    }
    return $releases
}
########
proc getReleaseId release {
    global db

    if {$release ne ""} then {
	set QUERY "SELECT id FROM releases WHERE name='$release'"
#	puts $QUERY
	db eval $QUERY value {
	    return $value(id)
	}
    } else {
	return ""
    }
}
###########
proc getHardlocksList {status type} {
    global db
    
    set QUERY "SELECT number FROM keys WHERE date_out='$status' AND type LIKE '$type' ORDER BY number"
#    puts $QUERY
    return [db eval $QUERY]
}

###########
# display help
proc help {} {
    global filehelpdir

    help::destroy
    help::init [file nativename [file join $filehelpdir [mc "en"].html]]
}

####################################################
# read file
proc readscriptall filename {
    if { [catch {set input [open $filename r]} result] eq 0} then {
	set filecontents [read $input]
	close $input
    } else {
	set filecontents ""
	tk_messageBox -title [mc "Error"] -icon error \
	    -message [mc "Error open file: %s" $filename]
    }
	return $filecontents
}

######
# read file, second version
# not use, not ready yet
proc readscriptlist filename {
    set i 0
    set filecontents ""
    if { [catch {set input [open $filename r]} result] eq 0} then {
	while {![eof $input]} {
	    linsert $filecontents $i [gets $input]
	    incr i
	}   
	close $input
   } else {
	set filecontents ""
       tk_messageBox -title [mc "Error"] -icon error \
	    -message [mc "Error open file: %s" $filename]
    }
    return $filecontents
}

#####
# write script
proc writescript {filecontents filename mode} {
# mode: a+ - append, w+ - write, etc.
    if { [catch {set filehandle [open $filename $mode]} result] eq 0} then {
	# check ending lines!
	#fconfigure $filehandle -translation {crlf lf}
    fconfigure $filehandle -encoding cp1250
	puts -nonewline $filehandle $filecontents
	close $filehandle
    } else {
	set filecontents ""
	tk_messageBox -title [mc "Error"] -icon error \
	    -message [mc "Error open file: %s" $filename]
    }
}
#####
# GUI lock buttons
proc buttonlock mode {
    if {$mode eq 1} then {
	set state disabled
	set cursor watch
    } else {
	set state normal
	set cursor arrow
    }
    ## Buttons
    .tex.f3.b1 configure -state $state -cursor $cursor
    .tex.f3.b2 configure -state $state -cursor $cursor
    .tex.f3.b3 configure -state $state -cursor $cursor
    .tex.f3.b4 configure -state $state -cursor $cursor
}
####
# changes cursor icon depend mode
proc cursorwait mode {
    if {$mode eq 1} then {
	. configure -cursor watch
    } else {
	. configure -cursor arrow
    }
}

###########################
# start/stop progressbar
# variables:
#    start: 1 - on; 0 - off
#    mode: normal - determinate; inf - indeterminate
proc startprogress {start mode} {
    global progressnormal
    if {$start eq 1} then {
	### start progressbar
	# info about waiting
	.fs.wait configure -text [mc "Please wait..."]
	# progressbar
	if {$mode eq "normal"} then {
	    .fs.pb configure -mode determinate
	} else {
	    .fs.pb configure -mode indeterminate
	    .fs.pb start 10
	}
    } else {
	# stop progressbar
	.fs.pb configure -mode determinate
	set progressnormal 0
	.fs.pb stop
	.fs.wait configure -text ""
    }
}

#############################
# execute 00_start*.bat with fileevent for progressbar
# variables:
#   done: if set 0 then don't appear message "$done"
#   mode: normal/inf - type of progressbar
#   filerun: eg. 00_start1.bat
# missing error handling :-(
proc executeprocess {done mode filerun} {
    global progressstart
    set progressstart 1
    startprogress 1 inf
    set winerrlog ""
    set chann [open "|$filerun" r]
    fconfigure $chann -blocking 0
    startprogress 0 inf
    startprogress 1 $mode
    if {$mode eq "normal"} then {
	set procname "readeoppercent"
	#fileevent $chann readable "readeoppercent $chann"
    } else {
	set procname "readeop"
	#fileevent $chann readable "readeop $chann"
    }
    fileevent $chann readable "$procname $chann"
    ## wait for end subprocess
    vwait progressstart
    startprogress 0 inf
    # sucessfully finish
    if {$done ne 0 } then {
	tk_messageBox -title [mc "Done"] -message $done -icon info
    }
}

#######################
# read End Of Process
# and increment progressbar
# for install TL/packages
proc readeoppercent chan {
    global winerrlog filewinerrlog progressnormal progressstart
    set line [string trim [gets $chan]]
    if {[regexp "\[\ ]\[0-9]{1,3}\[%]$" $line result ] eq 1} then {
	set progressnormal [string range [string trim $result] 0 end-1]    
    }
    append winerrlog $line "\n"
    if {[eof $chan]} then {
	close $chan
	# write log into file
	writescript $winerrlog $filewinerrlog "a+"
	set progressstart 0
	return
    }
}

#######################
# read End Of Process
proc readeop chan {
    global winerrlog filewinerrlog progressstart
    set line [string trim [gets $chan]]
    append winerrlog $line "\n"
    if {[eof $chan]} then {
	close $chan
	# write log into file
	#writescript $winerrlog $filewinerrlog "a+"
	set progressstart 0
	return
    }
}
# EOF