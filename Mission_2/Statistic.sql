-- 1、每日订单总额/总笔数分析
create table if not exists app_order_total (
    id int primary key auto_increment,
    dt date,
    total_money double,
    total_cnt int
);

insert into
    app_order_total
select
    null,
    substring(createTime, 1, 10) as dt,
    round(sum(realTotalMoney), 2) as total_money,
    sum(orderId) as total_cnt
from
    ods_itheima_orders
where
    substring(createTime, 1, 10) = '2019-09-05'
group by
    substring(createTime, 1, 10);

-- 2、下订单用户总数分析
create table if not exists app_order_user(
    id int primary key auto_increment,
    dt date,
    total_user_cnt int
);

insert into
    app_order_user
select
    null,
    substring(createTime, 1, 10),
    count(distinct userId) as total_user_cnt
from
    ods_itheima_orders
group by
    substring(createTime, 1, 10);

-- 3、每天不同支付方式订单总额/订单笔数
create table if not exists app_order_paytype(
    id int primary key auto_increment,
    dt date,
    pay_type varchar(100),
    total_money double,
    total_cnt int
);

insert into
    app_order_paytype
select
    null,
    substring(createTime, 1, 10) as dt,
    case
        payType
        when 1 then '支付宝'
        when 2 then '微信'
        when 3 then '现金'
        else '其他'
    end as pay_type,
    round(sum(realTotalMoney), 2) as total_money,
    count(orderId) as total_cnt
from
    ods_itheima_orders
group by
    substring(createTime, 1, 10),
    pay_type;

-- 4.订单数量TOP5
create table if not exists app_goods_top5(
    id int primary key auto_increment,
    dt date,
    goodsName varchar(100),
    cnt int
);

insert into
    app_goods_top5
select
    null,
    substring(a.createtime, 1, 10) as dt,
    b.goodsName,
    count(*) as cnt
from
    ods_itheima_order_goods a
    join ods_itheima_goods b on a.goodsId = b.goodsId
group by
    b.goodsName,
    substring(a.createtime, 1, 10)
order by
    cnt desc
limit
    5;

-- 5.每天不同商品分类订单个数统计
create table if not exists app_cat_cnt(
    id int primary key auto_increment,
    daystr date,
    catName varchar(100),
    cnt int
);

insert into
    app_cat_cnt
select
    null,
    substring(a.createTime, 1, 10) as daystr,
    c.catName,
    count(*) as cnt
from
    ods_itheima_order_goods a
    join ods_itheima_goods b on a.goodsId = b.goodsId
    join ods_itheima_goods_cats c on b.goodsCatId = c.catId
group by
    substring(a.createTime, 1, 10),
    c.catName;