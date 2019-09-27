CREATE TABLE condition (
    months NUMERIC, 
    id INTEGER PRIMARY KEY, 
    id_status NUMERIC,
    FOREIGN KEY(id_status) REFERENCES status (id));
    
CREATE TABLE customers (
    id INTEGER PRIMARY KEY, 
    customer_id NUMERIC, 
    city TEXT, 
    name TEXT,
    phone TEXT, 
    person TEXT, 
    email TEXT, 
    comment TEXT, 
    address TEXT, 
    zip TEXT);
    
CREATE TABLE keys (
    id INTEGER PRIMARY KEY, 
    number TEXT, 
    previous NUMERIC, 
    current NUMERIC, 
    doc_no TEXT, 
    date_in TEXT, 
    date_out TEXT, 
    type TEXT, 
    vtoc BLOB);
    
CREATE TABLE licenses (
    id INTEGER PRIMARY KEY,
    quantity NUMERIC, 
    valid TEXT, 
    id_key NUMERIC, 
    id_product NUMERIC, 
    license_no TEXT,
	FOREIGN KEY(id_product) REFERENCES products (id),
	FOREIGN KEY(id_key) REFERENCES keys (id));
    
CREATE TABLE products (
    id INTEGER PRIMARY KEY, 
    productid TEXT, 
    id_release_first NUMERIC, 
    id_release_last NUMERIC, 
    main_add NUMERIC, 
    name TEXT,
    FOREIGN KEY(id_release_first) REFERENCES releases (id),
	FOREIGN KEY(id_release_last) REFERENCES releases (id));
    
CREATE TABLE releases (
    id INTEGER PRIMARY KEY, 
    date_end TEXT, 
    date_start TEXT, 
    name TEXT);
    
CREATE TABLE soldkeys (
    id INTEGER PRIMARY KEY, 
    comment TEXT, 
    agreement_no TEXT, 
    active_maint NUMERIC, 
    date_maint TEXT, 
    date_sold TEXT, 
    id_customer NUMERIC, 
    id_key NUMERIC,
	FOREIGN KEY(id_customer) REFERENCES customers (id),
	FOREIGN KEY(id_key) REFERENCES keys (id));
    
CREATE TABLE status (
    id INTEGER PRIMARY KEY, 
    name TEXT);
    
CREATE UNIQUE INDEX customers_name ON customers(name ASC);
CREATE INDEX licenses_id_key ON licenses(id_key ASC);
CREATE INDEX licenses_id_product ON licenses(id_product ASC);
CREATE INDEX licenses_valid ON licenses(valid ASC);
CREATE INDEX soldkeys_id_customer ON soldkeys(id_customer ASC);
CREATE INDEX soldkeys_id_key ON soldkeys(id_key ASC);

