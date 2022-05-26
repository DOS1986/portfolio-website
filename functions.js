var CommandHistory = new Array();
var CommandHistoryIndex = 0;
var isContactMode = false;

var isName = false;
var isEmail = false;
var isMessage = false;
var isSent = false;

var name = '';
var email = '';
var message = '';

var contactPrompt = '';


var previousOnload = window.onload;

idleTime = 0;

//window.onload
window.onload = function() {
    if (previousOnload) {
        previousOnload();
    }
    document.getElementById('commandPrompt').innerHTML = 'C:\\>';
	//Increment the idle time counter every minute.
	var idleInterval = setInterval("timerIncrement()",10000);
	
	document.onmousemove = function(e){idleTime = 0;};
    document.onkeypress = function(e){idleTime = 0;};
	setFocusToEntryBox();
}

//timerIncrement Function
function timerIncrement() {
    idleTime = idleTime + 1;
	if (idleTime > 4) { // 20 minutes
        	CallbackRestartProgram();
    }
}

//handleKeyPress(keyCode, obj) Function
function handleKeyPress(keyCode, obj) {
    switch (keyCode) {
        case 13:
            handleReturn(obj);
            break;
        case 38:
            if (CommandHistoryIndex > 0) {
                CommandHistoryIndex--;
                document.getElementById('commandContainer').innerHTML = CommandHistory[CommandHistoryIndex];
                document.getElementById('entryBox').value = CommandHistory[CommandHistoryIndex];
            }
            break;
        case 40:
            if (CommandHistoryIndex < CommandHistory.length) {
                if (CommandHistoryIndex < CommandHistory.length - 1) {
                    CommandHistoryIndex++;
                }
                document.getElementById('commandContainer').innerHTML = CommandHistory[CommandHistoryIndex];
                document.getElementById('entryBox').value = CommandHistory[CommandHistoryIndex];
            }
            break;
        default:
            document.getElementById('commandContainer').innerHTML = obj.value.replace(/ /g, ' ');
    }
}

//handleReturn(obj) Function
function handleReturn(obj) {
    CommandHistory[CommandHistory.length] = obj.value;
    CommandHistoryIndex = CommandHistory.length;
   
   
   if(!isContactMode){
	switch(obj.value.toLowerCase()) {
		case 'help':
			var sOutput = '';
			sOutput += 'CLS         Clears the screen. <br /> \
			            DIR         Displays a list of files and subdirectories in a directory. <br /> \
			            HELP        Provides Help information on what commands there are. <br /> \
						RESTART        Resets the program back to the beginning';
			Callback(sOutput);
			break;
		case 'dir':
			var sOutput = '';
			sOutput += '<a onclick="CallbackPortfolioProgram()" href="javascript:void(0);">Portfolio.exe</a><br /> \
						<a onclick="CallbackResumeProgram()" href="javascript:void(0);">Resume.exe</a><br /> \
						<a onclick="CallbackAboutProgram()" href="javascript:void(0);">About.exe</a><br /> \
						<!--<a onclick="handleReturn(contact)" href="javascript:void(0);">-->Contact.exe<!--</a>--> \
						';
			Callback(sOutput);
			break;
		case 'restart':
			CallbackRestartProgram()
			break;
		case 'cls':
			CallbackClearScreen()
			break;
		case 'portfolio': case 'portfolio.exe':
			CallbackPortfolioProgram()
			break;	
		case 'resume': case 'resume.exe':
			CallbackResumeProgram()	
			break;			
		case 'about': case 'about.exe':
			CallbackAboutProgram()	
			break;			
		case 'contact': case 'contact.exe':
			var sOutput = '';
			sOutput = 'To contact me please fill out your information in the requested blocks.';
			isContactMode=true;
			contactPrompt = 'Name';
			Callback(sOutput);
			break;						
		default:
			var sOutput = '';
			sOutput += '\'' + obj.value + '\' is not recognized as an internal or external command, operable program or batch file.<br /> \
			type help for a list of commands to use.';
			Callback(sOutput);
			break;
	}
   } else {
		if(!isName) {
			isName=true;
			name = ''+ obj.value.toLowerCase() +'';
			var sOutput = '';
			sOutput = ''+ obj.value.toLowerCase() + '';
			contactPrompt = 'Email';
			Callback(sOutput);
		} else {
			if(!isEmail) {
				isEmail=true;
				email = ''+ obj.value.toLowerCase() +'';
				var sOutput = '';
				sOutput = ''+ obj.value.toLowerCase() + '';
				contactPrompt = 'Message';
				Callback(sOutput);
			} else {
				if(!isMessage) {
					isMessage=true;
					message = ''+ obj.value.toLowerCase() +'';
					var sOutput = '';
					sOutput = 'Your message has been sent to me.';
					Callback(sOutput);
					} 
					sendMessage(name, email, message);
					isContact=false;
					setPromptToNormal();
				}
			}
		}
	}

//Callback(sHTML) Function
function Callback(sHTML) {
	sHTML = sHTML.replace(/</g, '<');
	var obj = document.getElementById('entryBox');
	var sOutput = '';
	if (!isContactMode) {
		sOutput += '<div style="padding-bottom:15px;">C:\\>' + obj.value + '<br />';
		setPromptToNormal();
	} else {
		sOutput += '<div style="padding-bottom:15px;">' + document.getElementById('commandPrompt').innerHTML + ' ' + obj.value + '<br />';
		document.getElementById('commandPrompt').innerHTML = contactPrompt + ': ';
	}
	sOutput += sHTML;
	sOutput += '</div>';
	document.getElementById('outputContainer').innerHTML += sOutput;
	obj.value = '';
	document.getElementById('commandContainer').innerHTML = '';
	window.scrollBy(0, 10000);
}

//CallbackClearScreen
function CallbackClearScreen() {
	document.getElementById('entryBox').value = '';
	document.getElementById('outputContainer').innerHTML = '<br>';
	document.getElementById('commandContainer').innerHTML = '';
	window.scrollBy(0, -10000);
}

//CallbackRestartProgram Function
function CallbackRestartProgram() {
	document.getElementById('entryBox').value = '';
	document.getElementById('outputContainer').innerHTML = 'David O. Southwood | Portfolio Website [Version 1.0.0]<br /> \
	Copyright (c) 2012 David O. Southwood. All rights reserved.<br /><br /> \
	Please type Help for a list of commands to use<br /><br /> \
	C:\\>dir <br /> \
	<a onclick="CallbackPortfolioProgram()" href="javascript:void(0);">Portfolio.exe</a><br /> \
	<a onclick="CallbackResumeProgram()" href="javascript:void(0);">Resume.exe</a><br /> \
	<a onclick="CallbackAboutProgram()" href="javascript:void(0);">About.exe</a><br /> \
	<!--<a onclick="handleReturn(contact)" href="javascript:void(0);">-->Contact.exe<!--</a>--><br /><br />';
	document.getElementById('commandContainer').innerHTML = '';
	window.scrollBy(0, -10000);
}

//CallbackPortfolioProgram Function
function CallbackPortfolioProgram() {
	document.getElementById('entryBox').value = '';
	document.getElementById('outputContainer').innerHTML = '<div id="portfolio"><div id="nav"><ul> \
				<li><a onclick="getCoraopolisProject()" href="javascript:void(0);">Coraopolis Library</a></li> \
				<li><a onclick="getYWCAWheelingProject()" href="javascript:void(0);">YWCA Wheeling</a></li> \
				<li><a onclick="getPhotoTouchupProject()" href="javascript:void(0);">Photo Manipilation</a></li> \
				<li><a onclick="getAdverGamesProject()" href="javascript:void(0);">Special Project Game</a></li> \
				</ul></div> \
				<div id="content"><h1><span id="title"></span></h1><br \> \
				<div id="link"></div><br /> \
				<h1>Project Description</h1><br /> \
				<div id="desc"></div><br \><br \>\
				</div></div>';
	document.getElementById('commandContainer').innerHTML = '';
	window.scrollBy(0, -10000);
}

//CallbackResumeProgram Function
function CallbackResumeProgram() {
	document.getElementById('entryBox').value = '';
	document.getElementById('outputContainer').innerHTML = ' \
			 	<div id="resume"><h1><span>Resume</span></h1> \
				<div id="resume_about"></div> \
				<div id="resume_skills"></div> \
				<div id="resume_education"></div> \
				<div id="resume_employment"></div><br /> \
				click <a href="../../js/files//Resume.pdf" target="_blank">here</a> to download a pdf version of my resume. <br /> \
				click <a href="../../js/files//Resume.docx" target="_blank">here</a> to download a microsoft word version of my resume. \
				</div>';
				getGeneralInfo();
				getSkills();
				getEducation();
				getEmployment();
	document.getElementById('commandContainer').innerHTML = '';
	window.scrollBy(0, -10000);
}

//CallbackAboutProgram Function
function CallbackAboutProgram() {
	document.getElementById('entryBox').value = '';
	document.getElementById('outputContainer').innerHTML = '<div id="about_me"><h1><span>About Me</span></h1> \
					<p>Hi, My name is David Southwood and I\'m a programmer.</p> \
					<p>I am a freelance web developer living in Pittsburgh, Pennsylvania.</p> \
					<p>When I find the time, I enjoy tinkering with code in the XNA game studio and \
					   playing video games.</p> \
					<p>I\'ve just completed my Associates degree at the art institute and \
					   looking forward to what the future holds for me.</p><br /> \
					   <p>As I\'m sure you have noticed my portfolio site is very retro in terms of design. \
					   This is a play on my initials DOS (David O. Southwood) so I thought it would be interesting to design my portfolio in the old DOS command Prompt format.</p> \
					   <p>I hope you enjoy it feel free to hit me up on \
					   <a href="https://twitter.com/Techie1986" target="_blank">Twitter</a>, \
					   <a href="http://www.linkedin.com/in/davidsouthwood" target="_blank">Linkedin</a>, \
					   <a href="https://live.xbox.com/en-US/Profile?gamertag=Techie%20san" target="_blank">XBOX live</a>, \
					   <a href="http://www.facebook.com/dos1986" target="_blank">Facebook</a>, \
					   or <a href="https://plus.google.com/102888947114327771118/posts" target="_blank">Google+</a>. </p> \
				</div>';
				getGeneralInfo();
				getSkills();
				getEducation();
				getEmployment();
	document.getElementById('commandContainer').innerHTML = '';
	window.scrollBy(0, -10000);
}

//sendMessage(str1, str2, str3) Function
function  sendMessage(str1, str2, str3){
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
	
	xmlhttp.onreadystatechange=function(){
  		if (xmlhttp.readyState==4 && xmlhttp.status==200)
    	{
    	}
}
xmlhttp.open("GET","sendMessage.php?q="+str1+"&r="+str2+"&s="+str3,true);
xmlhttp.send();
}

//setPromptToNormal Function
function setPromptToNormal() {
	document.getElementById('commandPrompt').innerHTML = 'C:\\>';
}

//setFocusToEntryBox Function
function setFocusToEntryBox() {
    var o = document.getElementById('entryBox');
    o.focus();
}

//getCoraopolisProject Function
function getCoraopolisProject() {
	
	document.getElementById('content').style.visibility = 'visible'; 
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
  
	xmlhttp.open("GET","xml/coraopolis.xml",false);
	xmlhttp.send();
	xmlDoc=xmlhttp.responseXML;

	document.getElementById("title").innerHTML= xmlDoc.getElementsByTagName("title")[0].childNodes[0].nodeValue;
	document.getElementById("link").innerHTML = xmlDoc.getElementsByTagName("link")[0].childNodes[0].nodeValue;
	document.getElementById("desc").innerHTML= xmlDoc.getElementsByTagName("desc")[0].childNodes[0].nodeValue;
}

//getYWCAWheelingProject
function getYWCAWheelingProject() {
	
	document.getElementById('content').style.visibility = 'visible'; 
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
  
	xmlhttp.open("GET","xml/ywca.xml",false);
	xmlhttp.send();
	xmlDoc=xmlhttp.responseXML;

	document.getElementById("title").innerHTML= xmlDoc.getElementsByTagName("title")[0].childNodes[0].nodeValue;
	document.getElementById("link").innerHTML = xmlDoc.getElementsByTagName("link")[0].childNodes[0].nodeValue;
	document.getElementById("desc").innerHTML= xmlDoc.getElementsByTagName("desc")[0].childNodes[0].nodeValue;
}

//getPhotoTouchupProject Function
function getPhotoTouchupProject() {
	
	document.getElementById('content').style.visibility = 'visible'; 
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
  
	xmlhttp.open("GET","xml/phototouchup.xml",false);
	xmlhttp.send();
	xmlDoc=xmlhttp.responseXML;

	document.getElementById("title").innerHTML= xmlDoc.getElementsByTagName("title")[0].childNodes[0].nodeValue;
	document.getElementById("link").innerHTML = xmlDoc.getElementsByTagName("link")[0].childNodes[0].nodeValue;
	document.getElementById("desc").innerHTML= xmlDoc.getElementsByTagName("desc")[0].childNodes[0].nodeValue;
}

//getAdverGamesProject Function
function getAdverGamesProject() {
	
	document.getElementById('content').style.visibility = 'visible'; 
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
  
	xmlhttp.open("GET","xml/advergames.xml",false);
	xmlhttp.send();
	xmlDoc=xmlhttp.responseXML;

	document.getElementById("title").innerHTML= xmlDoc.getElementsByTagName("title")[0].childNodes[0].nodeValue;
	document.getElementById("link").innerHTML = xmlDoc.getElementsByTagName("link")[0].childNodes[0].nodeValue;
	document.getElementById("desc").innerHTML= xmlDoc.getElementsByTagName("desc")[0].childNodes[0].nodeValue;
}

//getGeneralInfo
function getGeneralInfo() {
		document.getElementById("resume_about").innerHTML = '\
				<h1><span>About Me<\span><\h1><br \> \
				<div id="name"></div><br \> \
				<div id="profession"></div><br /> \
				<div id="phone"></div><br /> \
				<div id="email"></div><br \><br \> \
				<div id="googleplus"></div><br \> \
				<div id="facebook"></div><br \> \
				<div id="linkedin"></div> \
				</div>';
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
  
	xmlhttp.open("GET","xml/generalinfo.xml",false);
	xmlhttp.send();
	xmlDoc=xmlhttp.responseXML;
			
	document.getElementById("name").innerHTML = xmlDoc.getElementsByTagName("name")[0].childNodes[0].nodeValue;
	document.getElementById("profession").innerHTML= xmlDoc.getElementsByTagName("title")[0].childNodes[0].nodeValue;
	document.getElementById("phone").innerHTML= xmlDoc.getElementsByTagName("phone")[0].childNodes[0].nodeValue;
	document.getElementById("email").innerHTML = xmlDoc.getElementsByTagName("email")[0].childNodes[0].nodeValue;
	document.getElementById("googleplus").innerHTML= xmlDoc.getElementsByTagName("googleplus")[0].childNodes[0].nodeValue;
	document.getElementById("facebook").innerHTML= xmlDoc.getElementsByTagName("facebook")[0].childNodes[0].nodeValue;
	document.getElementById("linkedin").innerHTML = xmlDoc.getElementsByTagName("linkedin")[0].childNodes[0].nodeValue;
}

//getSkills Function
function getSkills() {
		document.getElementById("resume_skills").innerHTML = '\
				<h1><span>My Skills<\span><\h1> \
				<br \><div id="lbl_software">Software</div><div id="lbl_coding">Coding</div><br \> \
				<div id="software1"></div>  <div id="coding1"></div><br /> \
				<div id="software2"></div>  <div id="coding2"></div><br /> \
				<div id="software3"></div>  <div id="coding3"></div><br \> \
				<div id="software4"></div>  <div id="coding4"></div><br \> \
				<div id="software5"></div>  <div id="coding5"></div><br \> \
				<div id="software6"></div>  <div id="coding6"></div> \
				</div>';
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
  
	xmlhttp.open("GET","xml/skills.xml",false);
	xmlhttp.send();
	xmlDoc=xmlhttp.responseXML;
			
	document.getElementById("software1").innerHTML= xmlDoc.getElementsByTagName("software1")[0].childNodes[0].nodeValue;
	document.getElementById("software2").innerHTML = xmlDoc.getElementsByTagName("software2")[0].childNodes[0].nodeValue;
	document.getElementById("software3").innerHTML= xmlDoc.getElementsByTagName("software3")[0].childNodes[0].nodeValue;
	document.getElementById("software4").innerHTML= xmlDoc.getElementsByTagName("software4")[0].childNodes[0].nodeValue;
	document.getElementById("software5").innerHTML = xmlDoc.getElementsByTagName("software5")[0].childNodes[0].nodeValue;
	document.getElementById("software6").innerHTML= xmlDoc.getElementsByTagName("software6")[0].childNodes[0].nodeValue;
	document.getElementById("coding1").innerHTML= xmlDoc.getElementsByTagName("coding1")[0].childNodes[0].nodeValue;
	document.getElementById("coding2").innerHTML = xmlDoc.getElementsByTagName("coding2")[0].childNodes[0].nodeValue;
	document.getElementById("coding3").innerHTML= xmlDoc.getElementsByTagName("coding3")[0].childNodes[0].nodeValue;
	document.getElementById("coding4").innerHTML = xmlDoc.getElementsByTagName("coding4")[0].childNodes[0].nodeValue;
	document.getElementById("coding5").innerHTML= xmlDoc.getElementsByTagName("coding5")[0].childNodes[0].nodeValue;
	document.getElementById("coding6").innerHTML= xmlDoc.getElementsByTagName("coding6")[0].childNodes[0].nodeValue;
}

//getEducation Function
function getEducation() {
		document.getElementById("resume_education").innerHTML = '\
				<h1><span>Education<\span><\h1><br \> \
				<div id="college_name"></div> \
				<div id="college_location"></div>\
				<div id="college_graduation"></div><br /> \
				<div id="college_degree"></div> \
				<div id="college_field"></div><br \><br \> \
				<div id="college_name2"></div> \
				<div id="college_location2"></div> \
				<div id="college_graduation2"></div><br /> \
				<div id="college_degree2"></div> \
				<div id="college_field2"></div> \
				</div>';
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
  
	xmlhttp.open("GET","xml/education.xml",false);
	xmlhttp.send();
	xmlDoc=xmlhttp.responseXML;
			
	document.getElementById("college_name").innerHTML = xmlDoc.getElementsByTagName("college_name")[0].childNodes[0].nodeValue;
	document.getElementById("college_location").innerHTML= xmlDoc.getElementsByTagName("college_location")[0].childNodes[0].nodeValue;
	document.getElementById("college_graduation").innerHTML= xmlDoc.getElementsByTagName("college_graduation")[0].childNodes[0].nodeValue;
	document.getElementById("college_degree").innerHTML = xmlDoc.getElementsByTagName("college_degree")[0].childNodes[0].nodeValue;
	document.getElementById("college_field").innerHTML= xmlDoc.getElementsByTagName("college_field")[0].childNodes[0].nodeValue;
	document.getElementById("college_name2").innerHTML= xmlDoc.getElementsByTagName("college_name2")[0].childNodes[0].nodeValue;
	document.getElementById("college_location2").innerHTML = xmlDoc.getElementsByTagName("college_location2")[0].childNodes[0].nodeValue;
	document.getElementById("college_graduation2").innerHTML= xmlDoc.getElementsByTagName("college_graduation2")[0].childNodes[0].nodeValue;
	document.getElementById("college_degree2").innerHTML = xmlDoc.getElementsByTagName("college_degree2")[0].childNodes[0].nodeValue;
	document.getElementById("college_field2").innerHTML= xmlDoc.getElementsByTagName("college_field2")[0].childNodes[0].nodeValue;
}

//getEmployment Function
function getEmployment() {
		document.getElementById("resume_employment").innerHTML = '\
				<h1><span>Employment<\span><\h1><br \> \
				<div id="job_name"></div> \
				<div id="job_location"></div> \
				<div id="job_worked"></div><br /> \
				<div id="job_title"></div><br \> \
				<ul> \
				<li id="task1"></li> \
				<li id="task2"></li> \
				<li id="task3"></li> \
				</ul> \
				<div id="job_name2"></div> \
				<div id="job_location2"></div> \
				<div id="job_worked2"></div><br /> \
				<div id="job_title2"></div><br \> \
				<ul> \
				<li id="task4"></li> \
				<li id="task5"></li> \
				<li id="task6"></li> \
				</ul> \
				<div id="job_name3"></div> \
				<div id="job_location3"></div> \
				<div id="job_worked3"></div><br /> \
				<div id="job_title3"></div><br \> \
				<ul> \
				<li id="task7"></li> \
				<li id="task8"></li> \
				<li id="task9"></li> \
				</ul> \
				</div>';
	
	if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
  		xmlhttp=new XMLHttpRequest();
  	} else {// code for IE6, IE5
  		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  	}
  
	xmlhttp.open("GET","xml/employment.xml",false);
	xmlhttp.send();
	xmlDoc=xmlhttp.responseXML;
			
	document.getElementById("job_name").innerHTML = xmlDoc.getElementsByTagName("job_name")[0].childNodes[0].nodeValue;
	document.getElementById("job_location").innerHTML= xmlDoc.getElementsByTagName("job_location")[0].childNodes[0].nodeValue;
	document.getElementById("job_worked").innerHTML= xmlDoc.getElementsByTagName("job_worked")[0].childNodes[0].nodeValue;
	document.getElementById("job_title").innerHTML = xmlDoc.getElementsByTagName("job_title")[0].childNodes[0].nodeValue;
	document.getElementById("task1").innerHTML= xmlDoc.getElementsByTagName("task1")[0].childNodes[0].nodeValue;
	document.getElementById("task2").innerHTML= xmlDoc.getElementsByTagName("task2")[0].childNodes[0].nodeValue;
	document.getElementById("task3").innerHTML = xmlDoc.getElementsByTagName("task3")[0].childNodes[0].nodeValue;
	document.getElementById("job_name2").innerHTML = xmlDoc.getElementsByTagName("job_name2")[0].childNodes[0].nodeValue;
	document.getElementById("job_location2").innerHTML= xmlDoc.getElementsByTagName("job_location2")[0].childNodes[0].nodeValue;
	document.getElementById("job_worked2").innerHTML= xmlDoc.getElementsByTagName("job_worked2")[0].childNodes[0].nodeValue;
	document.getElementById("job_title2").innerHTML = xmlDoc.getElementsByTagName("job_title2")[0].childNodes[0].nodeValue;
	document.getElementById("task4").innerHTML= xmlDoc.getElementsByTagName("task4")[0].childNodes[0].nodeValue;
	document.getElementById("task5").innerHTML= xmlDoc.getElementsByTagName("task5")[0].childNodes[0].nodeValue;
	document.getElementById("task6").innerHTML = xmlDoc.getElementsByTagName("task6")[0].childNodes[0].nodeValue;
	document.getElementById("job_name3").innerHTML = xmlDoc.getElementsByTagName("job_name3")[0].childNodes[0].nodeValue;
	document.getElementById("job_location3").innerHTML= xmlDoc.getElementsByTagName("job_location3")[0].childNodes[0].nodeValue;
	document.getElementById("job_worked3").innerHTML= xmlDoc.getElementsByTagName("job_worked3")[0].childNodes[0].nodeValue;
	document.getElementById("job_title3").innerHTML = xmlDoc.getElementsByTagName("job_title3")[0].childNodes[0].nodeValue;
	document.getElementById("task7").innerHTML= xmlDoc.getElementsByTagName("task7")[0].childNodes[0].nodeValue;
	document.getElementById("task8").innerHTML= xmlDoc.getElementsByTagName("task8")[0].childNodes[0].nodeValue;
	document.getElementById("task9").innerHTML = xmlDoc.getElementsByTagName("task9")[0].childNodes[0].nodeValue;
}

