<?php
$con1 = mysqli_connect("127.0.0.1","sspanel","sspanel","sspanel");
if($con1){
	echo 1;
}else{
	echo 0;
}
$con2 = mysqli_connect("52.221.193.211","v2b","497290234","v2b");
if($con2){
	echo 1;
}else{
	echo 0;
}
$con1_sql="SELECT email,uuid,money,t,u,d,passwd,transfer_enable,ga_token,class,reg_time,class_expire FROM user WHERE money>0||class>0";
$con2_sql="insert into v2_user(id,email,uuid,balance,t,u,d,password,transfer_enable,token,group_id,created_at,expired_at,updated_at) VALUES ($x,'$email','$uuid','$money','$t','$u','$d','$passwd',$transfer_enable,'$ga_token',$class,$reg_time,$class_expire,$z)";
$con1_query=mysqli_query($con1,$con1_sql);
if($con1_query){
	echo "aaa";
}
$x=6;
$z=123124125;
while($v=$con1_arr=mysqli_fetch_array($con1_query)){
	$email=$v['email'];
	$uuid=$v['uuid'];
	$money=$v['money'];
	$t=$v['t'];
	$u=$v['u'];
	$d=$v['d'];
	$passwd=$['passwd'];
	$transfer_enable=$v['transfer_enable'];
	$ga_token=$v['ga_token'];
	$class=$v['class'];
	$reg_time=strtotime("$v['reg_time']");
	$class_expire=strtotime("$v['class_expire']");
	mysqli_query($con2,$con2_sql);
	$x++;
	
}
mysqli_close($con1);
mysqli_close($con2);
?>

