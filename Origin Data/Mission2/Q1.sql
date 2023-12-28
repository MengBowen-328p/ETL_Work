-- 1、每日订单总额/总笔数分析
use itcast_shop_2021443754;
create table if not exists app_order_total (
    id int primary key auto_increment,
    dt date,
    total_money double,
    total_cnt int
);

insert into app_order_total
select null,
       substring(createTime, 1, 10) as dt,
       round(sum(realTotalMoney), 2) as total_money,
       sum(orderId) as total_cnt
from ods_itheima_orders
where substring(createTime, 1, 10)='2019-09-05'
group by substring(createTime, 1, 10);