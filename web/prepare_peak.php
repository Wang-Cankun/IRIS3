<?php
	header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
	header("Cache-Control: post-check=0, pre-check=0", false);
	header("Pragma: no-cache");
	#http://bmbl.sdstate.edu/iris3/prepare_tomtom.php?jobid=2018122581354&ct=6&bic=3&m=3&db=HOCOMOCO
	require_once("config/common.php");
	require_once("config/smarty.php");
	require_once("lib/spyc.php");
//require_once("lib/hmmer.php");
$jobid = $_GET['jobid'];
$ct=$_GET['ct'];
$bic=$_GET['bic'];
$module=$_GET['module'];
$motif=$_GET['m'];
$db=$_GET['db'];
//$encodedString = json_encode($annotation1);
$done_file="a";
if(strlen($module) > 0){
	$motif_filename = "/home/www/html/iris3/data/$jobid/logo/$module"."bic$bic"."m$motif".".fsa.meme";
	$check_dir = "/home/www/html/iris3/data/$jobid/tomtom/module$module"."bic$bic"."m$motif"."/JASPAR/tomtom.html";
	if (!file_exists($check_dir)){
	header("Refresh: 1;url='prepare_tomtom.php?jobid=$jobid&ct=$ct&bic=$bic&m=$motif&db=$db'");
}   else if (file_exists("/home/www/html/iris3/data/$jobid/tomtom/module$module"."bic$bic"."m$motif/$db")){
	$status = "0";
	header("Location: data/$jobid/tomtom/module$module"."bic$bic"."m$motif/$db/tomtom.html");
}	else {

	header("Refresh: 30;url='prepare_tomtom.php?jobid=$jobid&ct=$ct&bic=$bic&m=$motif&db=$db'");
}
} else {
	$motif_filename = "/home/www/html/iris3/data/$jobid/logo/ct$ct"."bic$bic"."m$motif".".fsa.meme";
	$check_dir = "/home/www/html/iris3/data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif"."/JASPAR/tomtom.html";
	if (!file_exists($check_dir)){
	header("Refresh: 1;url='prepare_tomtom.php?jobid=$jobid&ct=$ct&bic=$bic&m=$motif&db=$db'");
}   else if (file_exists("/home/www/html/iris3/data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif/$db")){
	$status = "0";
	header("Location: data/$jobid/tomtom/ct$ct"."bic$bic"."m$motif/$db/tomtom.html");
}	else {

	header("Refresh: 30;url='prepare_tomtom.php?jobid=$jobid&ct=$ct&bic=$bic&m=$motif&db=$db'");
}
}

$smarty->assign('filename',$filename);
$smarty->assign('jobid',$jobid);
$smarty->display('prepare_tomtom.tpl');

?>