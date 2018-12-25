<?php
set_time_limit(300);
require_once("config/common.php");
require_once("config/smarty.php");
require_once("lib/spyc.php");
//require_once("lib/hmmer.php");
$jobid=$_GET['jobid'];

$log1="";
$log2="";
$log="";
$status="";
session_start();
#$info = Spyc::YAMLLoad("$DATAPATH/$jobid/info.yaml");
$status= $info['status'];

$big=intval($info['big']);
$tempnam ="$DATAPATH/$jobid";	
$done_file = "$DATAPATH/$jobid/done";

$regulon_gene_name_file = array();
$regulon_file = array();


if (file_exists($done_file)){
foreach (glob("$DATAPATH/$jobid/*_bic.regulon_gene_name.txt") as $file) {
	
  $regulon_gene_name_file[] = $file;
}

foreach (glob("$DATAPATH/$jobid/*_bic.regulon.txt") as $file) {
	
  $regulon_id_file[] = $file;
}

$count_ct = range(1,count($regulon_gene_name_file));
$info_file = fopen("$DATAPATH/$jobid/$jobid"."_info.txt", "r");
$count_regulon_in_ct = array(); 
if ($info_file) {
    while (($line = fgets($info_file)) !== false) {
        $split_line = explode (",", $line);
		if($split_line[0] == "filter_num"){
			$filter_num = $split_line[1];
		} else if($split_line[0] == "total_num"){
			$total_num = $split_line[1];
		} else if($split_line[0] == "filter_num"){
			$filter_num = $split_line[1];
		} else if($split_line[0] == "filter_rate"){
			$filter_rate = $split_line[1];
		} else if($split_line[0] == "total_label"){
			$total_label = $split_line[1];
		} else if($split_line[0] == "total_bic"){
			$total_bic = $split_line[1];
		} else if($split_line[0] == "total_ct"){
			$total_ct = $split_line[1];
		} else if($split_line[0] == "total_regulon"){
			$total_regulon = $split_line[1];
		}
    }

    fclose($info_file);
} else {
	print_r("Info file not found");
    // error opening the file.
} 

foreach ($regulon_gene_name_file as $key=>$this_regulon_gene_name_file){
	
	$status = "1";
	$fp = fopen("$this_regulon_gene_name_file", 'r');
	 if ($fp){
	 while (($line = fgetcsv($fp, 0, "\t")) !== FALSE) if ($line) {
		 $regulon_result[$key][] = array_map('trim',$line);
		 
	 }
	 //$count_regulon_in_ct[$key] = count($regulon_result[$key])
	 
	 array_push($count_regulon_in_ct,count($regulon_result[$key]));
	 } else{
		 die("Unable to open file");
	 }
	fclose($fp);
	
	}
foreach ($regulon_id_file as $key=>$this_regulon_id_file){
	
	$status = "1";

	$fp = fopen("$this_regulon_id_file", 'r');
	if ($fp){
	while (($line = fgetcsv($fp, 0, "\t")) !== FALSE) 
		if ($line) {$regulon_id_result[$key][] = array_map('trim',$line);}
	} else{
		die("Unable to open file");
	}
	fclose($fp);
	}


}else if (!file_exists($tempnam)) {
	$status= "404";
}else {
	$status = "0";
	header("Refresh: 15;url='results.php?jobid=$jobid'");
}
 



//print_r($regulon_result);
//$encodedString = json_encode($annotation1);
 
//Save the JSON string to a text file.
//file_put_contents('json_array.txt', $encodedString);
$_SESSION[$jobid."ann"]=$annotation1;
$smarty->assign('filter_num',$filter_num);
$smarty->assign('total_num',$total_num);
$smarty->assign('filter_rate',$filter_rate);
$smarty->assign('total_label',$total_label);
$smarty->assign('total_bic',$total_bic);
$smarty->assign('total_ct',$total_ct);
$smarty->assign('total_regulon',$total_regulon);
$smarty->assign('count_ct',$count_ct);
$smarty->assign('status',$status);
$smarty->assign('jobid',$jobid);
$smarty->assign('count_regulon_in_ct',$count_regulon_in_ct);
$smarty->assign('regulon_result',$regulon_result);
$smarty->assign('regulon_id_result',$regulon_id_result);
$smarty->assign('big',$big);
$smarty->assign('annotation', $annotation1);
$smarty->assign('LINKPATH', $LINKPATH);
$smarty->display('results.tpl');

?>
