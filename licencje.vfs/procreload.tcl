# -*-Tcl-*-
## 2007-2010 Tomasz Luczak tlu@temertech.com
# $Id: procreload.tcl 14 2013-01-26 12:58:02Z tlu $
########################################
# Reload lists
########
proc reloadStatProductList {} {
    global db f3
    
    $f3.f2.t delete 0 end
    set QUERY "SELECT id,name,main_add FROM products"
#    puts $QUERY
    db eval $QUERY valuesProduct {
	set QUERY "SELECT SUM(licenses.quantity) AS quant, SUM (soldkeys.active_maint) AS count
FROM licenses,keys,soldkeys 
WHERE licenses.id_key=keys.id AND licenses.id_product='$valuesProduct(id)' AND keys.current='1' AND keys.id=soldkeys.id_key"
#	puts $QUERY
	db eval $QUERY values {
	    set quantityProduct $values(quant)
	    if {($quantityProduct ne 0)&&($quantityProduct ne "\{\}")} then {
		lappend productsList [list $valuesProduct(id) $valuesProduct(name) $quantityProduct $valuesProduct(main_add) $values(count)]
	    }
	}
    }
    if [info exists productsList] then {
	foreach i [lsort -index 1 $productsList] {
	    $f3.f2.t insert end $i
	}
    }
}
########
proc reloadStatCustomerList {} {
    global db f3 rowf3f2

    $f3.f4.t delete 0 end
    set rowData [$f3.f2.t get $rowf3f2]
    set QUERY "SELECT customers.id, customers.name, SUM(soldkeys.active_maint) AS maint, SUM(licenses.quantity) AS lic 
    FROM soldkeys,customers,licenses,keys
    WHERE licenses.id_key=soldkeys.id_key 
	AND soldkeys.id_customer=customers.id 
	AND licenses.id_product='[lindex $rowData 0]'  
	AND keys.current='1'
	AND licenses.quantity>'0'
        AND keys.id=licenses.id_key
    GROUP BY customers.name"
#    puts $QUERY
    db eval $QUERY values {
    if {$values(maint) ne 0} then {
        set maint 1
        } else {
        set maint 0
    }
	$f3.f4.t insert end [list $values(id) $values(name) $values(lic) $maint]
    }
}
########
# list of products for customer
proc reloadKeyProductsList idKey {
    global db f1 

    $f1.f4.t delete 0 end
    if {$idKey ne ""} then {
	set QUERY "SELECT id,id_product,license_no,valid,quantity 
FROM licenses WHERE id_key='$idKey'"
#	puts $QUERY
	db eval $QUERY valuesLicense {
	    set licenseId    $valuesLicense(id)
	    set licenseNo    $valuesLicense(license_no)
	    set licenseValid $valuesLicense(valid)
	    set licenseQuantity $valuesLicense(quantity)
	    # Product
	    set QUERY "SELECT name FROM products WHERE id='$valuesLicense(id_product)'"
#	    puts $QUERY
	    db eval $QUERY valuesProduct {
		lappend listLicenses [list $licenseId $valuesProduct(name) $licenseNo $licenseValid $licenseQuantity]
	    }
	}
	if [info exists listLicenses] then {
	    foreach i [lsort -index 1 -dictionary $listLicenses] {
		$f1.f4.t insert end $i
	    }
	}
    }
}
########
# Keys
proc reloadKeysList {} {
    global db f1 licenseExpired licenseTerminal
    
    $f1.f2.t delete 0 end
    set keyKind [$f1.f3.f32.cb1 get]
    set conditions "WHERE keys.number LIKE\"%[$f1.f3.f34.e get]%\" "
    switch $keyKind {
	All     { set condition "" }
	Dongles { set condition " (type IN ('USB','LPT'))" }
	Flying  { set condition " (type IN ('FLY'))" }
	default { set condition " (type IN ('$keyKind'))" }
    }
    set keyCurrent [$f1.f3.f32.cb2 get]
    switch $keyCurrent {
	All      { set conditionTwo "(current LIKE \"%\")" }
	Current  { set conditionTwo "(current='1')"}
	Replaced { set conditionTwo "(current='0')"} 
    }
    if {($condition eq "")&&($conditionTwo ne "")} then {
	set conditions "$conditions AND $conditionTwo"
    } elseif {($condition ne "")&&($conditionTwo eq "")} then {
	set conditions "$conditions AND $condition"
    } else {
	set conditions "$conditions AND $condition AND $conditionTwo"
    }
    if {$licenseTerminal eq 1} then {
	set QUERY "SELECT DISTINCT keys.id, keys.number, keys.type, keys.date_in, keys.date_out, keys.doc_no, keys.previous, keys.current, soldkeys.active_maint, soldkeys.date_maint, soldkeys.id_key
FROM licenses, keys LEFT OUTER JOIN soldkeys
ON keys.id = soldkeys.id_key
$conditions AND keys.id=licenses.id_key AND licenses.valid<>'' 
ORDER BY keys.number"
#	puts $QUERY
	db eval $QUERY values {
	    $f1.f2.t insert end [list $values(id) $values(number) $values(type) $values(date_in) $values(date_out) $values(doc_no) $values(previous) $values(current) $values(active_maint) $values(date_maint)]
	}
    } else {
	set QUERY "SELECT keys.id, keys.number, keys.type, keys.date_in, keys.date_out, keys.doc_no, keys.previous, keys.current, soldkeys.active_maint, soldkeys.date_maint
FROM keys LEFT OUTER JOIN soldkeys
ON keys.id = soldkeys.id_key 
$conditions
ORDER BY keys.number"
#	puts $QUERY
	db eval $QUERY values {
	    $f1.f2.t insert end [list $values(id) $values(number) $values(type) $values(date_in) $values(date_out) $values(doc_no) $values(previous) $values(current) $values(active_maint) $values(date_maint)]
	}
    }
    # jest dwa razy db eval $QUERY, bo raz list wymaga zapisu 'tabela.pole', 
    # a raz tylko'pole' nie wiadomo dlaczego :-(
    return 1
}
########
# Release
proc reloadReleaseList {} {
    global db f5
    
    $f5.f3.t delete 0 end
    set QUERY "SELECT id,name,date_start, date_end FROM releases ORDER BY name"
#    puts $QUERY
    db eval $QUERY values {
	$f5.f3.t insert end [list $values(id) $values(name) $values(date_start) $values(date_end)]
    }
}
########
# Product
proc reloadProductList {} {
    global db f5
    
    $f5.f2.t delete 0 end
    set QUERY "SELECT * FROM products ORDER BY name"
#    puts $QUERY
    db eval $QUERY values {
	$f5.f2.t insert end [list $values(id) $values(name) $values(main_add) [getRelease $values(id_release_first)] [getRelease $values(id_release_last)] $values(productid)]
    }
}
########
# Customer
proc reloadCustomerList {} {
    global db f2 licenseExpired licenseTerminal
    
    $f2.f2.t delete 0 end
    if {$licenseTerminal ne 0} then {
	# lista id klientów z licencjami czasowymi
	# 
	set QUERY "SELECT  DISTINCT * \nFROM customers \nWHERE id IN \n (SELECT DISTINCT id_customer \n FROM soldkeys \n WHERE id_key IN \n  (SELECT DISTINCT licenses.id_key \n  FROM licenses WHERE valid<>\"\")) \nAND name LIKE\"%[$f2.f3.f34.e get]%\" \nORDER BY name"
    } else {
	set QUERY "SELECT * FROM customers  WHERE name LIKE\"%[$f2.f3.f34.e get]%\" ORDER BY name"
    }
#    puts $QUERY
    db eval $QUERY values {
	$f2.f2.t insert end [list $values(id) $values(name) $values(city) $values(customer_id) $values(zip) $values(address) $values(comment)]
    }
    return 1
}
########
# License
proc reloadKeyLicenseList {} {
    global db f1 row
}
########
# list of hardlock for customer
proc reloadCustomerHardlocksList idCustomer {
    global db f2 allStatuses
    
    set hardlockIdList ""
    $f2.f4.f41.t delete 0 end
    if {$idCustomer ne ""} then {
	set QUERY "SELECT id,id_key FROM soldkeys WHERE (id_customer='$idCustomer')"
#	puts $QUERY
	db eval $QUERY values {
	    set idSold $values(id)
	    set QUERY "\nSELECT number,type,doc_no,active_maint,date_maint \nFROM keys,soldkeys \nWHERE (keys.id = soldkeys.id_key) AND (keys.id='$values(id_key)')"
	    set keyCurrent [$f2.f3.f31.cb2 get]
	    switch $keyCurrent {
		All      { set conditionTwo "" }
		Current  { set conditionTwo "(current='1')"}
		Replaced { set conditionTwo "(current='0')"} 
	    }
	    if {$conditionTwo ne ""} then {
		set QUERY "$QUERY AND $conditionTwo"
	    } 
	    #else { set QUERY "$QUERY ORDER BY number" }
	    set QUERY "$QUERY \nORDER BY number"

#	    puts $QUERY
	    db eval $QUERY keysvalues {
		lappend row [list $values(id_key) $idSold $keysvalues(number) $keysvalues(type) $keysvalues(doc_no) $keysvalues(active_maint) $keysvalues(date_maint)] 
		lappend hardlockIdList $values(id_key)
	    }
	}
	if [info exists row] then {
	    foreach i [lsort -index 2 $row] {
		$f2.f4.f41.t insert end $i
	    }
	}
    }
#    puts "hardlockIdList: $hardlockIdList"
    return $hardlockIdList
}
########
# list of products for customer
proc reloadCustomerProductsList hardlocksIdList {
    global db f2
    $f2.f4.f42.t delete 0 end
    if {[llength $hardlocksIdList] ne 0} then {
	set hardlocksIdList [join $hardlocksIdList ,]
#	puts "$hardlocksIdList"
        set QUERY "SELECT licenses.id,licenses.id_product,licenses.license_no,licenses.valid,licenses.quantity,keys.number \nFROM licenses,keys \nWHERE licenses.id_key=keys.id AND keys.id IN ($hardlocksIdList)"
#        puts $QUERY
	db eval $QUERY valuesLicense {
	    set licenseId $valuesLicense(id)
	    set hardlockNumber $valuesLicense(number)
	    set licenseNo $valuesLicense(license_no)
	    set licenseValid $valuesLicense(valid)
	    set licenseQuantity $valuesLicense(quantity)
	    # Product
	    set QUERY "SELECT name FROM products WHERE id='$valuesLicense(id_product)'"
#	    puts $QUERY
	    db eval $QUERY valuesProduct {
		lappend productslist [list $licenseId $hardlockNumber $valuesProduct(name) $licenseNo $licenseValid $licenseQuantity]
	    }
	}
#	puts $productslist
 	if [info exists productslist] {
	    foreach i [lsort -index 2 -dictionary $productslist] {
 		$f2.f4.f42.t insert end $i
	    }
 	}
    }
}
########
# list of licenses for customer
proc reloadCustomerLicensesList {} {
    global db f2
}
# EOF