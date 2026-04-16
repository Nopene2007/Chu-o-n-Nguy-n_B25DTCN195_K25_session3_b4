use ss3;
-- 1. Cấu trúc bảng đơn hàng hiện tại
CREATE TABLE ORDERS (
    OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    OrderDate DATETIME,
    TotalAmount DECIMAL(18, 2),
    Status VARCHAR(20), -- 'Completed', 'Canceled', 'Pending'
    -- Giải pháp Soft Delete thường yêu cầu thêm cột này:
    IsDeleted BIT DEFAULT 0
);

-- 2. Dữ liệu thực tế: Hỗn hợp đơn hàng thành công và đơn hàng bị hủy
INSERT INTO ORDERS (CustomerName, OrderDate, TotalAmount, Status) VALUES
(N'Nguyễn Văn A', '2023-01-10', 500000, 'Completed'),
(N'Khách hàng vãng lai', '2023-02-15', 1200000, 'Canceled'), -- "Rác" cần xử lý
(N'Trần Thị B', '2023-05-20', 300000, 'Canceled'),           -- "Rác" cần xử lý
(N'Lê Văn C', '2024-01-05', 850000, 'Completed');

-- 3. Vấn đề truy vấn chậm:
-- Mỗi khi tìm đơn hàng "Sống", hệ thống vẫn phải quét qua đống đơn "Hủy"
SELECT * FROM ORDERS WHERE Status = 'Completed';

-- Cách 2:
create table otherOrders(
	OrderID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    OrderDate DATETIME,
    TotalAmount DECIMAL(18, 2),
    Status VARCHAR(20),
    IsDeleted BIT DEFAULT 0
);
insert into otherOrders
select * from orders
where status='Canceled';

delete from orders
where status='canceled';


