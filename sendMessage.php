<?php
$name = $_GET["q"];
$email = $_GET["r"];
$message = $_GET["s"];

$errors = '';
$myemail = 'dos1986@gmail.com';//<-----Put Your email address here.
if(empty($_GET["q"])  ||
   empty($_GET["r"]) ||
   empty($_GET["s"]))
{
    $errors .= "\n Error: all fields are required";
}
$name = $_GET["q"];
$email_address = $_GET["r"];
$message = $_GET["s"];
if (!preg_match(
"/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/i",
$email_address))
{
    $errors .= "\n Error: Invalid email address";
}

if( empty($errors))
{
$to = $myemail;
$email_subject = "Contact form submission: $name";
$email_body = "You have received a new message. ".
" Here are the details:\n Name: $name \n ".
"Email: $email_address\n Message: $message";
$headers = "From: $myemail\n";
$headers .= "Reply-To: $email_address";
mail($to,$email_subject,$email_body,$headers);
}

?>