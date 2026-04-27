CREATE DATABASE sql_session8;
USE sql_session8;


CREATE TABLE customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    gender TINYINT,
    birth_date DATE
);


CREATE TABLE category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
CREATE TABLE order_detail(
	order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT ,
    quantity_total INT,
    total_price INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    UNIQUE(order_id, product_id)

);


INSERT INTO customer (full_name, email, gender, birth_date)
VALUES
    ('Nguyễn Văn A', 'nguyenvana@gmail.com', 1, '1995-05-12'),
    ('Trần Thị B', 'tranthib@gmail.com', 0, '1998-10-25'),
    ('Lê Hoàng C', 'lehoangc@gmail.com', 1, '1990-02-28'),
    ('Phạm Mỹ D', 'phammyd@gmail.com', 0, '2001-08-15'),
    ('Đặng Đình E', 'dangdinhe@gmail.com', 1, '1985-11-03');


INSERT INTO category (category_name)
VALUES
    ('Điện thoại di động'),
    ('Máy tính xách tay'),
    ('Máy tính bảng'),
    ('Phụ kiện điện tử'),
    ('Thiết bị thông minh');


INSERT INTO product (product_name, price, category_id)
VALUES
    ('iPhone 15 Pro Max', 29990000.00, 1),
    ('MacBook Pro M3', 39990000.00, 1),
    ('iPad Air 5', 15490000.00, 3),
    ('Tai nghe AirPods Pro', 5500000.00, 4),
    ('Đồng hồ Apple Watch', 9500000.00, 5);


INSERT INTO orders (customer_id, order_date)
VALUES
    (1, '2026-01-10'),
    (2, '2026-02-14'),
    (1, '2026-03-05'), 
    (3, '2026-03-20'),
    (4, '2026-04-01');

	
INSERT INTO order_detail (order_id, product_id, quantity_total, total_price)
VALUES
    (1, 1, 1, 29990000),
    (1, 4, 2, 11000000), 
    (2, 2, 1, 39990000), 
    (3, 3, 1, 15490000), 
    (4, 5, 1, 9500000);  
    
    
-- Cập nhật giá bán cho một sản phẩm.
UPDATE product
SET price =	1200000
WHERE product_id = 1;
     
-- Cập nhật email cho một khách hàng.
UPDATE customer
SET email =	'abc@gmail.com'
WHERE customer_id = 1;
    
-- Xóa một bản ghi chi tiết đơn hàng không hợp lệ (hoặc một đơn hàng bị hủy).
DELETE FROM order_detail
WHERE order_detail_id = 6; 

-- Lấy danh sách khách hàng gồm họ tên, email và sử dụng câu lệnh CASE để hiển thị giới tính dưới dạng văn bản ('Nam' hoặc 'Nữ'). Sử dụng AS để đặt lại tên cột.
SELECT 
	full_name,
    email,
    CASE 
		WHEN gender = 1 THEN 'Nam'
        ELSE 'Nữ'
	END AS gender
FROM customer;
    
-- Lấy thông tin 3 khách hàng trẻ tuổi nhất: Sử dụng hàm YEAR() và NOW() để tính tuổi, kết hợp mệnh đề ORDER BY và LIMIT.
SELECT *
FROM customer
ORDER BY YEAR(birth_date) DESC 
LIMIT 3;

-- Hiển thị danh sách tất cả các đơn hàng kèm theo tên khách hàng tương ứng (Sử dụng INNER JOIN).
SELECT *
FROM customer c
INNER JOIN orders o
ON c.customer_id = o.customer_id;

-- Đếm số lượng sản phẩm theo từng danh mục. Sử dụng GROUP BY và HAVING để chỉ hiển thị các danh mục có từ 2 sản phẩm trở lên.
SELECT *
FROM product
WHERE category_id IN (
	SELECT category_id
	FROM product
	GROUP BY category_id
	HAVING COUNT(category_id) > 2
);

-- (Scalar Subquery) Lấy danh sách các sản phẩm có giá lớn hơn giá trị trung bình (AVG) của tất cả các sản phẩm trong cửa hàng.
SELECT *
FROM product 
WHERE price > (
SELECT AVG(price) 
FROM product
);

-- (Column Subquery) Lấy danh sách thông tin các khách hàng chưa từng đặt bất kỳ đơn hàng nào (Sử dụng toán tử NOT IN kết hợp truy vấn lồng).
SELECT *
FROM customer
WHERE customer_id NOT IN (
	SELECT customer_id
    FROM orders
);

-- (Subquery với hàm tổng hợp) Tìm các phòng ban/danh mục có tổng doanh thu lớn hơn 120% doanh thu trung bình của toàn bộ cửa hàng.
SELECT category_id, sum(price) AS total_price
FROM product
GROUP BY category_id
HAVING SUM(price) >(
	SELECT AVG(price)
    FROM product
)*1.2;


-- (Correlated Subquery) Lấy danh sách các sản phẩm có giá đắt nhất trong từng danh mục (Truy vấn con tham chiếu đến outer query).
SELECT *
FROM product p1
WHERE p1.price IN (
	SELECT MAX(p2.price)
    FROM product p2
    WHERE p1.category_id = p2. category_id
);

-- (Truy vấn lồng nhiều cấp) Tìm họ tên của các khách hàng VIP đã từng mua sản phẩm thuộc danh mục 'Điện tử' (Sử dụng truy vấn lồng 
-- từ 3 cấp trở lên thông qua các bảng Customer, Order, Order_Detail, Product, Category).


-- lấy ra tên nguòi dùng 
SELECT full_name
FROM customer
WHERE customer_id IN (
	-- lấy ra id người dùng
	SELECT customer_id
	FROM orders
	WHERE order_id IN (
		-- lấy ra id đơn hàng 
		SELECT order_id
		FROM order_detail
		WHERE order_detail_id IN (
			-- lấy ra id chi tiết đơn hàng có chứa sp
			SELECT order_detail_id
			FROM order_detail
			WHERE product_id IN (
				-- lấy ra id sp thuôc đây
				SELECT product_id
				FROM product
				WHERE category_id IN (
					-- lấy ra id của đtu
					SELECT category_id
					FROM category
					WHERE category_name = 'Phụ kiện điện tử'
				)
			)
		)
	)
)


