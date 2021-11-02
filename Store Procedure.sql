﻿USE [QLBH];
--sp xem danh sách hóa đơn
IF OBJECTPROPERTY(OBJECT_ID('dbo.SP_XEM_DS_HOADON'), N'IsProcedure') = 1 
    DROP PROCEDURE [dbo].[SP_XEM_DS_HOADON]
GO
CREATE PROCEDURE SP_XEM_DS_HOADON 
AS
BEGIN
	SELECT * FROM HoaDon
END
GO
--TEST
--EXEC SP_XEM_DS_HOADON
GO
--sp thêm mới hóa đơn
IF OBJECTPROPERTY(OBJECT_ID('dbo.SP_THEM_HOADON'), N'IsProcedure') = 1 
    DROP PROCEDURE [dbo].[SP_THEM_HOADON]
GO

CREATE PROCEDURE SP_THEM_HOADON
	@MaHD	VARCHAR(20),
	@MaKH	VARCHAR(20),  
	@NgayLap	DATETIME,
	@TongTien INT
AS
BEGIN	
	SET NOCOUNT ON;
	IF EXISTS (SELECT * FROM KhachHang WHERE MaKH = @MaKH)
	BEGIN
		INSERT INTO HoaDon
		VALUES (@MaHD,@MaKH,@NgayLap,@TongTien);
	END
	ELSE
		BEGIN
			RAISERROR(N'Khách hàng không tồn tại',16,1);
		END
	
END
GO
--TEST
--EXEC SP_THEM_HOADON 'HD000200','KH000000','01/05/2020','150000'
GO
--Thống kê doanh thu theo tháng
IF OBJECTPROPERTY(OBJECT_ID('dbo.SP_THONGKE_DOANHTHU'), N'IsProcedure') = 1 
    DROP PROCEDURE [dbo].[SP_THONGKE_DOANHTHU]
GO
CREATE PROCEDURE SP_THONGKE_DOANHTHU
	@Thang	INT,
	@Nam INT
AS
BEGIN	
	SET NOCOUNT ON;
	IF EXISTS (SELECT * FROM HoaDon WHERE (MONTH(NgayLap) = @Thang) and (YEAR(NgayLap)=@Nam))
	BEGIN
		SELECT SUM(TongTien)as DOANHTHU FROM HoaDon WHERE (MONTH(NgayLap) = @Thang) and (YEAR(NgayLap)=@Nam)
	END
	ELSE
		BEGIN
			RAISERROR(N'Tháng không có doanh thu',16,1);
		END
	
END
GO
--TEST
EXEC SP_THONGKE_DOANHTHU '12','2020'
GO

