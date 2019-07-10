<?php
$a=file('/var/log/copy_uploaded_files.log');
if ($_GET['reverse']=='1') $a=array_reverse($a);
foreach($a as $l) echo $l, "<br />\n";

