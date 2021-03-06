<?php
ini_set("memory_limit","80M");
 
# prevent creation of new directories
$is_locked = false;
 
# figure out requested path and actual physical file paths
$orig_dir = dirname(__FILE__);
$orig_dir = '/data';
$path = "/".$_GET['path'];


$tokens = explode("/", $path);
$file = "/".implode('/', array_slice($tokens,3));
$orig_file = $orig_dir."/original".$file;
 
if (!file_exists($orig_file))
{
        header("Status: 404 Not Found");
        echo "<br/>PATH=$path<br/>ORIGFILE=$orig_file";
        return 0;
}

# check if new directory would need to be created
$save_path = "$orig_dir/$tokens[1]/$tokens[2]$file";
$save_dir = dirname($save_path);

if(!file_exists($save_dir) && $is_locked)
{
        header("Status: 403 Forbidden");
        echo "Directory creation is forbidden.";
        return 0;
}

# parse out the requested image dimensions and resize mode
$x_pos = strpos($tokens[2], 'x');
$target_width = substr($tokens[2], 0, $x_pos);
$target_height = substr($tokens[2], $x_pos+1, $x_pos);
$new_width = $target_width;
$new_height = $target_height;

# default mode
$mode = "2";

# specific mode settings and size settings based on URL

if ($tokens[2] == "comping"){
  $new_width = 500;
  $new_height = 500;
  $target_width = 500;
  $target_height = 500;
  $mode = "0";
}

if ($tokens[2] == "w800"){
  $new_width = 800;
  $new_height = 800;
  $target_width = 800;
  $target_height = 800;
  $mode = "0";
}

$image = new Imagick($orig_file);

list($orig_width, $orig_height, $type, $attr) = getimagesize($orig_file);
 
# preserve aspect ratio, fitting image to specified box
if ($mode == "0")
{
        $new_height = $orig_height * $new_width / $orig_width;
        if ($new_height > $target_height)
        {
                $new_width = $orig_width * $target_height / $orig_height;
                $new_height = $target_height;
        }
}
# zoom and crop to exactly fit specified box
else if ($mode == "2")
{
        // crop to get desired aspect ratio
        $desired_aspect = $target_width / $target_height;
        $orig_aspect = $orig_width / $orig_height;
 
        if ($desired_aspect > $orig_aspect)
        {
                $trim = $orig_height - ($orig_width / $desired_aspect);
                $image->cropImage($orig_width, $orig_height-$trim, 0, $trim/2);
#                error_log("HEIGHT TRIM $trim");
        }
        else
        {
                $trim = $orig_width - ($orig_height * $desired_aspect);
                $image->cropImage($orig_width-$trim, $orig_height, $trim/2, 0);
        }
}

# mode 3 (stretch to fit) is automatic fall-through as image will be blindly resized
# in following code to specified box
$image->resizeImage($new_width, $new_height, imagick::FILTER_LANCZOS, 1);

# save and return the resized image file
if(!file_exists($save_dir))
        mkdir($save_dir, 0777, true);

$image->setImageCompression(imagick::COMPRESSION_JPEG);
$image->setImageCompressionQuality(80);
$image->writeImage($save_path);
header('Content-type: image/jpg');
echo file_get_contents($save_path);
 
return true;
?>
