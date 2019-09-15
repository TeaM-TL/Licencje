# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: procmaint.tcl 14 2013-01-26 12:58:02Z tlu $
#######################################
# window of maintenanse
proc maintenance {} {
    global db filewmaintenance
    source $filewmaintenance

#     tk_messageBox -type yesno -icon question \
# 	-title [mc "Maintenance"] \
# 	-message [mc "Not ready yet"] \
# 	-detail [mc "Window to manage dates of maintenase/warranty"]
}
#######################################
# list customer
# period - czas trwania opieki
# days - liczba dni na ile wcze¶niej ma listowaæ
proc  maintCustomerList {statusId} {
    global db f2
    
    $f2.f2.t delete 0 end
    $f2.f4.f41.t delete 0 end
    $f2.f4.f42.t delete 0 end
    
    # hack ;-) is posible to put other dateNow in find field for testing
    if [eval {regexp 20\[0-9]{2}\[.]\[0-9]{2}\[.]\[0-9]{2} [$f2.f3.f34.e get]}] then {
	set dateNow [clock scan [string map {. -} [$f2.f3.f34.e get]]]
    } else {
	set dateNow [clock scan now]
    }
    set period [expr 0]
    puts "dateNow [clock format $dateNow -format %Y-%m-%d]"
    set QUERY "SELECT id_key,date_sold,date_maint FROM soldkeys "
    switch $statusId {
	1 { 
	    append QUERY "WHERE date_maint=''"
	    set period [expr 180]
	}
	2 { append QUERY "WHERE active_maint='1' AND date_maint > '[clock format $dateNow -format %Y.%m.%d]'"}
	3 { append QUERY "WHERE active_maint='0' AND date_maint <> ''"}
    }
#    puts $QUERY
    db eval $QUERY values {
	switch $statusId {
	    1 {	set dateStart [clock scan [string map {. -} $values(date_sold)]]
	    }
	    2 { set dateStart [clock scan [string map {. -} $values(date_maint)]]
	    }
	}
	if {($statusId eq 1)||($statusId eq 2)} then {
	    set dateEnd [expr $dateStart + ($period * 60 * 60 *24)]
	    set diffDate [expr ($dateEnd - $dateNow) / (60 * 60 *24)]
	    puts "Sold: $values(date_sold), Maint: $values(date_maint), End: [clock format $dateEnd -format %Y-%m-%d], diff: $diffDate"

	    if {($diffDate < "[$f2.f3.f32.e3 get]")&&($diffDate > [expr -1])} then {
		set QUERY "SELECT id,name,city FROM customers WHERE name='[getCustomerName $values(id_key)]' ORDER BY name"
#		puts $QUERY
		db eval $QUERY values {
		    $f2.f2.t insert end [list $values(id) $values(name) $values(city)]
		}
	    }
	}
    }
}
#######################################
# get statuses of maintenanse
proc getListStatuses {} {
    global db 
    
    set QUERY "SELECT name FROM status ORDER by name"
#    puts $QUERY
    return [db eval $QUERY]
}

#######################################
# get id of status
proc getStatusId name {
    global db 
    set QUERY "SELECT id FROM status WHERE name='$name'"
#    puts $QUERY
    return [db eval $QUERY]
}
# EOF