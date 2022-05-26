import robot.*;
class race_robot.the_tracks.obstacles.obst extends race_robot.tracks {
	public var x_position:Number = 0;
	public var y_position:Number = 0;
	public var hp:Number = 1;
	public var counting:Number = 0;
	public var _object:Number = 0;
	private var current_obst;
	private var current_obst_num = 0;
	public function obst(x:Number, y:Number, h:Number) {
		x_position = x;
		y_position = y;
		
	}
	public function set object(o:Number):Void {
		_object = o;
	}
	public function get object():Number {
		return _object;
	}

	// getting the name of the current obstacle being interated with.
	

	private var i:String;
	public function stick_obst():Void {
		if (_parent._parent.lane.user.obst_relate == true) {
			this._x = this._x-_parent._parent.lane.user._xVelocity+.045;
			this._y = this._y-_parent._parent.lane.user._yVelocity+.045;
		}
	}
	/// setting health based on current obstacle

	private var obstacles:Array = new Array("con_hurdle", "concrete_slab", "water_pool");
	public var obj_death:Array = new Array(4, 4, 4);
	private var damage_on:Boolean = true;
	private var damage_wait;
	private var repeat_dmg;
	private var callonce:Number = 0;
	public function take_dmg(ap:Number, user:String):Void {
	    this._object = this._parent[user].current_obst;
		trace(this._parent[user].current_obst+" the current obstacle, robot");
		trace(_object+" the current obstacle, obst")
		
		
		trace(this._name+" the name");
		if (damage_on==true) {
			if (callonce == 0) {
				if (user !== "user") {
					// if not main user, change obstacle name based on ai user num.
					obstacles[0] = obstacles[0]+user.slice(4, 7);
					obstacles[1] = obstacles[1]+user.slice(4, 7);
					obstacles[2] = obstacles[2]+user.slice(4, 7);
				}
				callonce++;
			}
			trace("current obstacle num is "+_object);
			if (user !== "user") {// if not human player, repeat function
			repeat_dmg = setInterval(Proxy.create(this, dmg), 600, ap, user, object) 
			}
			else{dmg(ap, user, object);}
		}
	}
	
 
	public function dmg(ap:Number, user:String, num:Number, part:String) {
		
		counting++
		trace(object);
		trace(" IM COUNTING TO "+ counting +" !");
				// calling just once per object, to set current object.
		hp += ap;
		trace("the hp" + hp);
		trace("the user is" + user);
		trace("taking dmg of "+ap+", down to "+hp+" hp");
		this._parent[user][part].gotoAndPlay(25);
		this.gotoAndStop(hp);
		trace("Destruction!");
		damage_on = false;
		damage_wait = setInterval(Proxy.create(this, dmg_switch), 200);
		// if health is drained let user start moving again/ disable buttons
		trace(obj_death[num]+"current death number");
		if (hp>obj_death[num]) {
			trace("inside" + this._parent[user]+ ", and the num is " + num);
			this._parent[user].start_relate(num);
			clearInterval(repeat_dmg);
			if (user == "user") {
				this._parent._parent._parent.arms_btn_mc.disable_btns();
			} else {
			}
		}
	}
	public function dmg_switch():Void {
		clearInterval(damage_wait);
		damage_on = true;
		trace("switching dmg back on");
	}
	public function sink_float(weight, user) {
		if (callonce == 0) {
			callonce++;
		}
		// calling just once per object, to set current object. 
		trace("current obst num is "+object);
		// need to update the distance based on the ammount moved, i think.
		if (weight>=4 && weight<=6) {
			this._parent[user].float(object);
		}
		//// play animation - float across 
		if (weight>=7 && weight<=9) {
			this._parent[user].float(object);
		}
		//// play animation - float across 
		if (weight>10) {
			this._parent._parent[user].sink(object);
		}
		//// play animation - helper bot is called 
	}
}
