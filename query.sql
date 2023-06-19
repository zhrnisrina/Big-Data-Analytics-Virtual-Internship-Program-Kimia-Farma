use kimiafarma;

SELECT * FROM barang;
DESC barang;
ALTER TABLE barang CHANGE ï»¿kode_barang kode_barang VARCHAR(200);
ALTER TABLE barang ADD PRIMARY KEY (kode_barang);
ALTER TABLE barang MODIFY kode_lini VARCHAR(200);

SELECT * FROM barang_ds;
DESC barang_ds;
ALTER TABLE barang_ds CHANGE ï»¿kode_barang kode_barang VARCHAR(200);
ALTER TABLE barang_ds MODIFY kode_brand VARCHAR(200);

SELECT * FROM pelanggan;
DESC pelanggan;
ALTER TABLE pelanggan CHANGE ï»¿id_customer id_customer VARCHAR(200);
ALTER TABLE pelanggan MODIFY id_cabang_sales VARCHAR(200);
ALTER TABLE pelanggan MODIFY id_group VARCHAR(200);

SELECT * FROM pelanggan_ds;
DESC pelanggan_ds;
ALTER TABLE pelanggan_ds CHANGE ï»¿id_customer id_customer VARCHAR(200);
ALTER TABLE pelanggan_ds MODIFY id_cabang_sales VARCHAR(200);
ALTER TABLE pelanggan_ds MODIFY id_distributor VARCHAR(200);

SELECT * FROM penjualan;
DESC penjualan;
ALTER TABLE penjualan CHANGE ï»¿id_distributor id_distributor VARCHAR(200);
ALTER TABLE penjualan ADD PRIMARY KEY (id_invoice);
ALTER TABLE penjualan MODIFY id_cabang VARCHAR(200);
ALTER TABLE penjualan MODIFY id_customer VARCHAR(200);
ALTER TABLE penjualan MODIFY id_barang VARCHAR(200);
ALTER TABLE penjualan MODIFY brand_id VARCHAR(200);

SELECT * FROM penjualan_ds;
DESC penjualan_ds;
ALTER TABLE penjualan_ds CHANGE ï»¿id_invoice id_invoice VARCHAR(200);
ALTER TABLE penjualan_ds MODIFY id_barang VARCHAR(200);
ALTER TABLE penjualan_ds MODIFY id_customer VARCHAR(200);

ALTER TABLE penjualan_ds
ADD FOREIGN KEY(id_invoice)
REFERENCES penjualan(id_invoice)
ON DELETE SET NULL;

CREATE TABLE sales
AS 
SELECT penjualan.id_invoice, penjualan.tanggal, id_distributor, id_cabang,
penjualan.id_customer, penjualan.id_barang, 
penjualan.jumlah_barang, penjualan.unit, penjualan.harga, 
penjualan.brand_id, penjualan.lini FROM penjualan
RIGHT JOIN penjualan_ds
ON penjualan_ds.id_invoice = penjualan.id_invoice
UNION ALL
SELECT penjualan.id_invoice, penjualan.tanggal, id_distributor, id_cabang,
penjualan.id_customer, penjualan.id_barang, 
penjualan.jumlah_barang, penjualan.unit, penjualan.harga, 
penjualan.brand_id, penjualan.lini FROM penjualan
LEFT JOIN penjualan_ds
ON penjualan_ds.id_invoice = penjualan.id_invoice;

DESC sales;

CREATE TABLE customer
AS 
SELECT pelanggan.id_customer, pelanggan.`level`, 
pelanggan.nama, pelanggan.id_cabang_sales, 
pelanggan.cabang_sales, pelanggan_ds.id_distributor, 
pelanggan.`group` FROM pelanggan
RIGHT JOIN pelanggan_ds
ON pelanggan_ds.id_customer = pelanggan.id_customer
UNION ALL
SELECT pelanggan.id_customer, pelanggan.`level`, 
pelanggan.nama, pelanggan.id_cabang_sales, 
pelanggan.cabang_sales, pelanggan_ds.id_distributor, 
pelanggan.`group` FROM pelanggan
LEFT JOIN pelanggan_ds
ON pelanggan_ds.id_customer = pelanggan.id_customer;

DESC customer;

CREATE TABLE goods
AS 
SELECT barang.kode_barang, barang.nama_barang, 
barang.kemasan, barang_ds.harga, barang.kode_lini, barang.lini
FROM barang
RIGHT JOIN barang_ds
ON barang_ds.kode_barang = barang.kode_barang 
UNION ALL
SELECT barang.kode_barang, barang.nama_barang, 
barang.kemasan, barang_ds.harga, barang.kode_lini, barang.lini
FROM barang
LEFT JOIN barang_ds
ON barang_ds.kode_barang = barang.kode_barang;sales;

DESC goods;

SELECT * FROM sales;
SELECT * FROM customer;
SELECT * FROM goods;

CREATE TABLE tr
AS 
SELECT sales.id_invoice, sales.tanggal, sales.id_distributor, sales.id_cabang,
sales.id_customer, sales.id_barang, sales.jumlah_barang, sales.unit, sales.harga, 
sales.brand_id, sales.lini, customer.level, customer.nama, customer.cabang_sales, 
customer.group
FROM sales
RIGHT JOIN customer
ON customer.id_customer = sales.id_customer
UNION ALL
SELECT sales.id_invoice, sales.tanggal, sales.id_distributor, sales.id_cabang,
sales.id_customer, sales.id_barang, sales.jumlah_barang, sales.unit, sales.harga, 
sales.brand_id, sales.lini, customer.level, customer.nama, customer.cabang_sales, 
customer.group
FROM sales
LEFT JOIN customer
ON customer.id_customer = sales.id_customer;

CREATE TABLE dataset 
AS
SELECT tr.id_invoice, tr.tanggal, tr.id_distributor, tr.id_cabang,
tr.id_customer, tr.id_barang, tr.jumlah_barang, tr.unit, tr.harga, 
tr.brand_id, tr.level, tr.nama, tr.cabang_sales, 
tr.group, goods.kode_barang, goods.nama_barang, 
goods.kode_lini, goods.lini
FROM tr
RIGHT JOIN goods
ON goods.kode_barang = tr.id_barang
UNION ALL
SELECT tr.id_invoice, tr.tanggal, tr.id_distributor, tr.id_cabang,
tr.id_customer, tr.id_barang, tr.jumlah_barang, tr.unit, tr.harga, 
tr.brand_id, tr.level, tr.nama, tr.cabang_sales, 
tr.group, goods.kode_barang, goods.nama_barang, 
goods.kode_lini, goods.lini
FROM tr
LEFT JOIN goods
ON goods.kode_barang = tr.id_barang;

DESC dataset;