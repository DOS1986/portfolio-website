import robot.*;
class robot.Robot extends MovieClip {
	// main variable declarations
	public var _weight:Number = 0;
	public var _username:String;
	public var _total:Number = 0;
	public var _speedcap:Number = 0;
	public var _speed:Number = 0;
	public var _constant:Boolean = false;
	public var _distance:Number = 0;
	public static var ai_relate:Boolean = true;
	public var obst_relate:Boolean = true;
	public var type = new Array("plastic", "copper", "iron", "alum", "tin");
	// Secondary Vars 
	public var start_movement:Boolean = true;
	private var IsReady:Boolean;
	private var call_once:Boolean = false;
	public var legs_type:String = "";
	public var arms_type:String = "";
	public var head_type:String = "";
	public var body_type:String = "";
	public var _xVelocity:Number = 0;
	public var _yVelocity:Number = 0;
	public var youwin:Boolean;
	public var legs_obj;
	public var l_arm_obj;
	public var r_arm_obj;
	public var head_obj;
	public var body_obj;
	private var ticker = 0;
	public var start_move:Boolean = true;
	public var obst_1:Boolean = false;
	public var obst_2:Boolean = false;
	public var obst_3:Boolean = false;
	private var boost:Boolean = true;
	private var ai:Boolean = false;
	private var ai_parts:Array = new Array();
	private var ai_lane:String = "";
	public var used_part:Boolean = false;
	public var no_move:Boolean = false;
	public var current_obst:Number = 0;
	

	// constructor
	public function Robot(the_name:String, the_weight:Number, speedcap:Number, move_constant:Boolean, head:String, body:String, legs:String, arms:String) {
		super();
		this._username = the_name;
		this._weight = the_weight;
		this.head_type = head;
		this.legs_type = legs;
		this.arms_type = arms;
		this.body_type = body;
	}
	public function set weight(w:Number):Void {
		this._weight = w;
	}
	public function set username(n:String):Void {
		this._username = n;
	}
	public function get weight():Number {
		return this._weight;
	}
	public function get username():String {
		return _username;
	}
	public function set constant(_c:Boolean):Void {
		_constant = _c;
	}
	public function get constant():Boolean {
		return _constant;
	}
	public function build():Void {
		trace("building");
		var temp = new Object();
		var parts = new Array("body", "head", "r_arm", "l_arm", "legs");
		var i;
		for (i in parts) {
			var part = parts[i];
			temp._x = this[part+"_obj"]._x;
			temp._y = this[part+"_obj"]._y;
			var type;
			if (part == "l_arm" || part == "r_arm") {
				type = "arms";
			} else {
				type = part;
			}
			// Attaching Parts
			this.attachMovie(this[type+"_type"]+"_"+part, part+"_obj", this[part+"_obj"].getDepth(), temp);
			this[part+"_obj"]._xscale = 65;
			this[part+"_obj"]._yscale = 65;
			var the_weight = this[part+"_obj"].stored_weight(part, type);
			total_weight(the_weight);
		}
		//this.attachMovie(head_type+"_head", "head", head_obj.getDepth());
	}
	public function randomizer(type:Array) {
		function random_type(type) {
			var max = type.length;
			var num = Math.round(Math.random()*(max-1));
			return type[num];
		}
		body_type = random_type(type);
		head_type = random_type(type);
		arms_type = random_type(type);
		legs_type = random_type(type);
		
		trace("randomizing");
		build();
	}
	/// Adding to total, then to weight when it has be called the 4th time.
	/// everytime a part is loaded it calls this function.
	public var times:Number = 0;
	public var weight_set:Boolean = false;
	public function total_weight(num:Number) {
		++times;
		if (times<=4) {
			trace(times+" times");
			_total += num;
		} else {
			_total += num;
			_weight = _total;
			speedcap();
		}
	}
	//////////////////////// MOVEMENT///////////////////////////
	private var ai_speed;
	public function start_ai(the_speed:Number) {
		if (start_move == true) {
			start_move = false;
			trace("ai_speed being set");
			ai_speed = setInterval(Proxy.create(this, move_user), the_speed);
		}
	}
	////
	// Setting the speed cap for every user based on the weight.
	public function get speedcap():Void {
		// Speed 
		if (_weight>=4) {
			_speedcap = 4;
		}
		if (_weight>=7) {
			_speedcap = 3;
		}
		if (_weight>=10) {
			_speedcap = 2;
		}
		//trace(_speedcap+" the speedcap, setting");  
	}
	/// Moving the user//////////////////////////
	public function move_user() {
		// Speed Up  
		if(no_move == false){
		trace("the freeking speed cap "+_speedcap);
		if (_speedcap == 4 && _xVelocity<4) {
			trace("light");
			_xVelocity += .700;
			_yVelocity += .440;
		}
		if (_speedcap == 3 && _xVelocity<4) {
			trace("medium");
			_xVelocity += .550;
			_yVelocity += .400;
		}
		if (_speedcap == 2 && _xVelocity<4) {
			trace("heavy");
			_xVelocity += .400;
			_yVelocity += .245;
		}
		if (_xVelocity>=1 && call_once == false) {
			call_once = true;
			slow_user();
		}
		}
	}
	// Starts to slow user consitantly, using set interval
	public var slow_user_constant;
	public function slow_user() {
		slow_user_constant = setInterval(Proxy.create(this, slow_down), 100);
	}
	// Slows down user
	public function slow_down() {
		//trace(this._xVelocity);
		if (_xVelocity>.1 || _yVelocity>.1) {
			_xVelocity -= .0500;
			_yVelocity -= .0300;
			trace("slowing");
		} else if (_xVelocity<=.1 || _yVelocity<=.1) {
			clearInterval(slow_user_constant);
			_xVelocity = 0;
			_yVelocity = 0;
			trace("stopping");
			call_once = false;
			this.legs_obj.gotoAndStop(1);
			this.l_arm_obj.gotoAndStop(1);
			this.r_arm_obj.gotoAndStop(1);
			start_movement = true;
		}
	}
	public function set_distance() {
	}
	//////////////////// AI FUNCTIONS //////////////////////////////
	// makes ai, move backwards with the track.
	// essentially subtracts the current x postion with the users and the ai.
	// the ai will keep functioning as normal if this doesn't run.
	public function stick_ai():Void {
		if (ai_relate == true) {
			this._x -= _parent._parent.lane.user._xVelocity;
			this._y -= _parent._parent.lane.user._yVelocity;
		}
	}
	////////////////////////////
	//AI Distance
	// Checks distance and current obstacles overcome so it can stop the user.	 
	public function ai_distance(num:Number) {
		// pulls in ai number if needed.
		_distance += this._xVelocity // distance = velocity accumulated
		trace(_distance+" from finish line");
		trace(start_movement);
		trace(_xVelocity+" the velocity");
		if (this._xVelocity>0 && start_movement == true) {
			start_movement = false;
			trace(_xVelocity+" the velocity");
			this.legs_obj.gotoAndPlay(2);
			this.l_arm_obj.gotoAndPlay(2);
			this.r_arm_obj.gotoAndPlay(2);
		}
		// Obstacle 1 
		if ((_distance>=350) && (obst_1 == false)) {
			_xVelocity = 0;
			_yVelocity = 0;
			ai_interact_1(num);
			trace(" ai interaction 1");
		} else if ((_distance>=720) && (obst_2 == false)) {
			trace("ai interaction 2");
			_xVelocity = 0;
			_yVelocity = 0;
			ai_interact_2(num);
		} else if ((_distance>=1090) && (obst_3 == false)) {
			trace(" ai interaction 3");
			_xVelocity = 0;
			_yVelocity = 0;
			ai_interact_3(num);
		} else if ((_distance>=1300) && (boost == true)) {
			trace("ai boosting");
			boost = false;
			go_go_gadget_boost();
		} else if (_distance>=2000) {
			_xVelocity = 0;
			_yVelocity = 0;
			_parent._parent._parent.gotoAndStop(8);
		}
	}
	///////////////////////User functions/////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
	public function user_distance() {
		_distance = Math.abs(_parent._parent.track_2._x);
		trace(_distance);
		trace(start_movement);
		trace(_xVelocity+" the velocity");
		if (this._xVelocity>0 && start_movement == true) {
			start_movement = false;
			this.legs_obj.gotoAndPlay(2);
			this.l_arm_obj.gotoAndPlay(2);
			this.r_arm_obj.gotoAndPlay(2);
		}
		// Obstacle 1 
		if ((_distance>=350) && (obst_1 == false)) {
			obst_relate = false;
			_xVelocity = 0;
			_yVelocity = 0;
			interact_1();
			trace("interaction 1");
		} else if ((_distance>=720) && (obst_2 == false)) {
			trace("interaction 2");
			obst_relate = false;
			_xVelocity = 0;
			_yVelocity = 0;
			interact_2();
		} else if ((_distance>=1090) && (obst_3 == false)) {
			trace("interaction 3");
			obst_relate = false;
			_xVelocity = 0;
			_yVelocity = 0;
			interact_3();
		} else if ((_distance>=1300) && (boost == true)) {
			trace("boosting");
			boost = false;
			go_go_gadget_boost();
		} else if (_distance>=1800) {
			obst_relate = false;
			_xVelocity = 0;
			_yVelocity = 0;
			_parent._parent._parent.gotoAndStop(8);
		}
	}
	////////////////////////////////////////////////////////////////////////////////////////////////
	///////// Interacting with objects////////////////////////////////////////////////
	// why is this not pulling in paramerters?
	// How cant you get through the object?
	public function test_object(i):Array {
		if (i == 1) {
			// construction hurdle
			var cant = new Array("na");
			return cant;
		}
		if (i == 2) {
			// Concrete barrier
			var cant = new Array("na");
			return cant;
		}
		if (i == 3) {
			// water pool
			var cant = new Array("na");
			return cant;
		}
	}
	/////////////////////////////////// FIND PARTS TO DISABLE////////////////////////////
	public var disable_btn:Array = new Array();
	public function enable_parts(types:Array) {
		// if a part type checks true, that part will be disabled
		// for head
		var called = 0;
		called++;
		trace("called"+called);
		var i;
		for (i in types) {
			var atype:String = types[i];
			if (body_type == atype) {
				// if type tests true, add btn number to disable
				disable_btn.push(1);
				trace("disable head");
			}
		}
		// for legs and arms
		for (i in types) {
			if (arms_type == atype) {
				// if type tests true, add btn number to disable
				disable_btn.push(2);
				trace("disable arm");
			}
			if (legs_type == atype) {
				// if type tests true, add btn number to disable
				disable_btn.push(3);
				trace("disable legs");
			}
		}
		enable_buttons();
	}
	//////////////////// enable buttons//////////////////////
	public function enable_buttons() {
		
		var counter = 0;
		var i;
		trace("the array "+disable_btn);
		//trace("the user name" + this._name);
		if (this._name=="user") {// making sure ai is not running function
			_root.help_btn_mc.enabled = true;
			_root.help_btn_mc.gotoAndPlay(2);
			_root.go_btn.enabled = false;
			trace("help btn being enabled");
			
			if (contains(1, disable_btn) == -1) {
				_root.head_btn_mc.enabled = true;
				_root.head_btn_mc.gotoAndPlay(2);
			} else {
				counter++;
			}
			if (contains(2, disable_btn) == -1) {
				_root.arms_btn_mc.enabled = true;
				_root.arms_btn_mc.gotoAndPlay(2);
			} else {
				counter++;
			}
			if (contains(3, disable_btn) == -1) {
				_root.legs_btn_mc.enabled = true;
				_root.legs_btn_mc.gotoAndPlay(2);
			} else {
				counter++;
			}
		} else {
			for(i=1;i<4;i++){  // popping out previous places parts
			ai_parts.pop();
			}
			// AI 
			// add parts enabled to array.
			ai_parts.push("helper");
			trace("disabling  ai btn's .........");
			if (contains(1, disable_btn) == -1) {
				ai_parts.push("head");
			} else {
				counter++;
			}
			if (contains(2, disable_btn) == -1) {
				ai_parts.push("arms");
			} else {
				counter++;
			}
			if (contains(3, disable_btn) == -1) {
				ai_parts.push("legs");
			} else {
				counter++;
			}
			trace(this.ai_lane);
			var the_types:Array = new Array(head_type, arms_type, legs_type);
	        pick_part(ai_parts, the_types, this._name, ai_lane);
			
		}
	}
	private var callonce = 0;
	private var cant_use;
	public var interact:Number = 0;
	private var inter_num:Number = 0;
	public function interact_1():Void {
		if (callonce == 0) {
			this.current_obst = 0;
			trace("the current_obst"+ current_obst);
			cant_use = test_object(1);
			enable_parts(cant_use);
			callonce++;
		}
	}
	public function interact_2():Void {
		if (callonce == 1) {
			this.current_obst = 1;
			trace("the current_obst"+ current_obst);
			cant_use = test_object(2);
			enable_parts(cant_use);
			callonce++;
		}
	}
	public function interact_3():Void {
		if (callonce == 2) {
			this.current_obst = 2;
			cant_use = test_object(3);
			enable_parts(cant_use);
			callonce++;
		}
	}
	///////////////// AI INTERACT////////////////////////////
	public function ai_interact_1(inter_num:Number):Void {
		if (callonce == 0) {
			no_move = true;
			this.current_obst = 0;
			cant_use = test_object(1);
			enable_parts(cant_use);
			callonce++;
		}
	}
	public function ai_interact_2(inter_num:Number):Void {
		if (callonce == 1) {
			no_move = true;
			trace("inter num"+ inter_num);
			this.current_obst = 1;
			cant_use = test_object(2);
			enable_parts(cant_use);
			callonce++;
		}
	}
	public function ai_interact_3(inter_num:Number):Void {
		if (callonce == 2) {
			no_move = true;
			this.current_obst = 2;
			cant_use = test_object(3);
			enable_parts(cant_use);
			callonce++;
		}
	}
	
	var the_parts;
	var count:Number = 0;
	public function pick_part(the_parts:Array, the_types, the_name:String, the_lane:String){
		    
			var max = 3;
			var num = Math.round(Math.random()*(max));
			trace("the num ="+ num+", the max is" + max);
			if(num == 0){trace(num+" was choosen");
			_root.legs_btn_mc.use_part("head_obj", the_types[0], the_name, the_lane, current_obst)}
		    if(num == 1){trace(num+" was choosen");
			_root.legs_btn_mc.use_part("l_arm_obj", the_types[1], the_name, the_lane, current_obst)}
			if(num == 2){trace(num+" was choosen");
			_root.legs_btn_mc.use_part("legs_obj", the_types[2], the_name, the_lane, current_obst)}
			if(num == 3){teleport(count)}
		count++
		};
	
	
	private var stop_boost:Number = 0;
	private var start_boost;
	public function go_go_gadget_boost() {
		trace("GO GO GADGET BOOST!");
		trace(stop_boost);
		trace(stop_boost+"stop boost go go");
		start_boost = setInterval(Proxy.create(this, booster), 100);
	}
	public function booster() {
		// test body type and determine booster speed.
		if (stop_boost<=10) {
			if (type[0] == body_type) {
				_xVelocity += .400;
				_yVelocity += .241;
			}
			// plastic 
			if (type[1] == body_type) {
				_xVelocity += .400;
				_yVelocity += .241;
			}
			// copper 
			if (type[2] == body_type) {
				_xVelocity += .400;
				_yVelocity += .241;
			}
			// iron 
			if (type[3] == body_type) {
				_xVelocity += .400;
				_yVelocity += .241;
			}
			// alum 
			if (type[4] == body_type) {
				_xVelocity += .400;
				_yVelocity += .241;
			}
			// tin 
			stop_boost++;
			trace(stop_boost+"booster function");
		} else {
			trace(stop_boost+"booster function");
			clearInterval(start_boost);
		}
	}
	public function finish():Void {
		trace("you won!!!");
	}
	// for searching arrays
	var i;
	public function contains(input, arrayData) {
		for (i=0; i<arrayData.length; i++) {
			if (arrayData[i] == input) {
				return 1;
			}
		}
		return -1;
	}
	private var num:Number;
	/// alow ai and obstacles to relate again.*/
	public function start_relate(num) {
		no_move = false;
		trace("start relate num" +num);
		if (num == 0) {
			obst_1 = true;
		}
		if (num == 1) {
			obst_2 = true;
		}
		if (num == 2) {
			obst_3 = true;
		}
		if(this._name == "user"){
		ai_relate = true;
		obst_relate = true;
		_root.go_btn.enabled = true;}
		else{}
	}
	
	
			var the_user;

		public function fly(the_user){trace(the_user+"flying");
         
		this._parent._parent.lane.gotoAndPlay(15);
		this._parent[the_user].head_obj.gotoAndPlay(25);
		this.tween_forward(current_obst,the_user);
		
			
		
		}
		public function jump(the_user){trace(the_user+" Jumping");
		
		
		}
	
	
	
	public function float() {
		set_forward(current_obst);
		trace("you floated!");
		this._parent._parent._parent.arms_btn_mc.disable_btns();
		this.start_relate(current_obst);
	}
	public var wait;
	public function sink() {
		trace("you sank");
		this.teleport(current_obst);
	}
	public function teleport(the_num) {
		trace("the num "+the_num);
		trace("GO GO GADGET TELEPORT!!!");
		if(this._name == "user"){
		wait = setInterval(Proxy.create(this, set_forward), 5000, the_num);
		this._parent._parent._parent.arms_btn_mc.disable_btns();}
		else{trace("set forward");
			wait = setInterval(Proxy.create(this, set_forward), 5000, the_num, this._name)}
		
	}
	private var obst:Array = new Array("con_hurdle", "concrete_slab", "water_pool");
	public function set_forward(the_num:Number, user):Void {
		this._parent[user].start_relate(the_num);
		clearInterval(wait);
		if(user == "user"){
		// setting user
		trace(this._distance);
		// setting track/ ai and obstacles
		_parent._parent.track_2._x -= 70;
		_parent._parent.track_2._y -= 40;
		/// moving up obstacles for user.
		_parent._parent.lane.con_hurdle._x -= 70;
		_parent._parent.lane.con_hurdle._y -= 40;
		_parent._parent.lane.concrete_slab._x -= 70;
		_parent._parent.lane.concrete_slab._y -= 40;
		_parent._parent.lane.water_pool._x -= 70;
		_parent._parent.lane.water_pool._y -= 40;
		/// moving up ai and obstacles
		for (i=1; i<=3; i++) {
			_parent._parent["lane_"+i]["con_hurdle_"+i]._x -= 70;
			_parent._parent["lane_"+i]["con_hurdle_"+i]._y -= 40;
			_parent._parent["lane_"+i]["concrete_slab_"+i]._x -= 70;
			_parent._parent["lane_"+i]["concrete_slab_"+i]._y -= 40;
			_parent._parent["lane_"+i]["water_pool_"+i]._x -= 70;
			_parent._parent["lane_"+i]["water_pool_"+i]._y -= 40;
			_parent._parent["lane_"+i]["user_"+i]._x -= 70;
			_parent._parent["lane_"+i]["user_"+i]._y -= 40;
			// setting obstacles
		
		}
		
	}else{trace("robot place forward");
	this._x += 70;
		      this._y += 40;}
			  
}



	public function tween_forward(the_num:Number, user):Void {
	
		
		this._parent[user].start_relate(the_num);
		clearInterval(wait);
		if(user == "user"){
		// setting user
		trace(this._distance);
		// setting track/ ai and obstacles
		var the_track:Object = new Object();
		the_track._x = _parent._parent.track_2._x;
		the_track._y = _parent._parent.track_2._y;
		new mx.transitions.Tween(_parent._parent.track_2, "_x", mx.transitions.easing.Strong.easeInOut, the_track._x, the_track._x-70, 3, true);
		new mx.transitions.Tween(_parent._parent.track_2, "_y", mx.transitions.easing.Strong.easeInOut, the_track._y, the_track._y-40, 3, true);
		
		/// moving up obstacles for user.
	   var hurdle:Object = new Object();
		hurdle._x = _parent._parent.lane.con_hurdle._x;
		hurdle._y = _parent._parent.lane.con_hurdle._y;
		
			   var slab:Object = new Object();
		slab._x = _parent._parent.lane.concrete_slab._x;
		slab._y = _parent._parent.lane.concrete_slab._y;
		
			   var pool:Object = new Object();
	     	pool._x = _parent._parent.lane.water_pool._x;
			pool._y = _parent._parent.lane.water_pool._y;
	   
		
		
		new mx.transitions.Tween(_parent._parent.lane.con_hurdle, "_x", mx.transitions.easing.Strong.easeInOut, hurdle._x, hurdle._x-70, 3, true);
		new mx.transitions.Tween(_parent._parent.lane.con_hurdle, "_y", mx.transitions.easing.Strong.easeInOut, hurdle._x, hurdle._x-40, 3, true);
		new mx.transitions.Tween(_parent._parent.lane.concrete_slab, "_x", mx.transitions.easing.Strong.easeInOut, slab._x, slab._x-70, 3, true);
		new mx.transitions.Tween(_parent._parent.lane.concrete_slab, "_y", mx.transitions.easing.Strong.easeInOut, slab._x, slab._x-40, 3, true);
		new mx.transitions.Tween(_parent._parent.lane.water_pool, "_x", mx.transitions.easing.Strong.easeInOut, pool._x, pool._x-70, 3, true);
		new mx.transitions.Tween(_parent._parent.lane.water_pool, "_y", mx.transitions.easing.Strong.easeInOut, pool._y, pool._y-40, 3, true);
		
		/// moving up ai and obstacles
		for (i=1; i<=3; i++) {
			
		new mx.transitions.Tween(_parent._parent["lane_"+i]["con_hurdle_"+i], "_x", mx.transitions.easing.Strong.easeInOut, 0, 70, 3, true);
		new mx.transitions.Tween(_parent._parent["lane_"+i]["con_hurdle_"+i], "_y", mx.transitions.easing.Strong.easeInOut, 0, 40, 3, true);
		new mx.transitions.Tween(_parent._parent["lane_"+i]["concrete_slab_"+i], "_x", mx.transitions.easing.Strong.easeInOut, 0, 70, 3, true);
		new mx.transitions.Tween(_parent._parent["lane_"+i]["concrete_slab_"+i], "_y", mx.transitions.easing.Strong.easeInOut, 0, 40, 3, true);
		new mx.transitions.Tween(_parent._parent["lane_"+i]["water_pool_"+i], "_x", mx.transitions.easing.Strong.easeInOut, 0, 70, 3, true);
		new mx.transitions.Tween(_parent._parent["lane_"+i]["water_pool_"+i], "_y", mx.transitions.easing.Strong.easeInOut, 0, 40, 3, true);
		new mx.transitions.Tween(_parent._parent["lane_"+i]["user_"+i], "_x", mx.transitions.easing.Strong.easeInOut, 0, 70, 3, true);
		new mx.transitions.Tween(_parent._parent["lane_"+i]["user_"+i], "_y", mx.transitions.easing.Strong.easeInOut, 0, 40, 3, true);
			// setting obstacles
		
		}
		
	}else{trace("robot place forward");
        new mx.transitions.Tween(_parent._parent["lane_"+i]["user_"+i], "_x", mx.transitions.easing.Strong.easeInOut, 0, 70, 3, true);
		new mx.transitions.Tween(_parent._parent["lane_"+i]["user_"+i], "_y", mx.transitions.easing.Strong.easeInOut, 0, 40, 3, true);
			}
			  
}



}
