class race_robot.main_nav extends MovieClip{
	private var the_type:String = ""
	private var the_obst:Number = 0;
	
	   // constructor!!
	   public function main_nav(){
		   
		   }
		   

		   
	
	public function user_interface(){
      var current_int = this._parent.the_track.lane.user._name;
	   the_obst = this._parent.the_track.lane.user.current_obst;
	  trace(the_obst+" object interaction with?");
        this._parent.arms_btn_mc.onRelease = function(){this.use_part("l_arm_obj", this._parent.the_track.lane.user.arms_type, current_int, "lane")};   
        this._parent.legs_btn_mc.onRelease = function(){this.use_part("legs_obj", this._parent.the_track.lane.user.legs_type, current_int, "lane")};
        this._parent.head_btn_mc.onRelease = function(){this.use_part("head_obj", this._parent.the_track.lane.user.head_type, current_int, "lane" )};
		this._parent.help_btn_mc.onRelease = function(){this._parent.the_track.lane[current_int].teleport(the_obst)};
		}
		

	

	   public function use_part(part:String, type:String, user:String, lane:String){
		   the_obst = this._parent.the_track[lane][user].current_obst;
		   if(user == "user"){
	   trace(this._parent.the_track.lane[user][part]+"using part");
	   trace(the_obst+"getting current object>>")
	   trace(user+"the user");
	   trace(type+"the user");
       this._parent.the_track.lane[user][part].gotoAndPlay(25); //playing animation.
	   trace(this._parent.the_track.lane[user][part]+"fighting part");
	   this._parent.the_track.lane[user][part].attack(part, type,the_obst, user);
		   }else{
			   trace("using part ," + this._parent.the_track[lane][user][part]);
			   trace(lane+" "+user+" "+part);
	   this._parent.the_track[lane][user][part].attack(part, type, the_obst, user);
			}
	   }
			
		
       public function disable_btns(){
		  this._parent.head_btn_mc.enabled = false;
		  this._parent.head_btn_mc.gotoAndStop(1);
		  this._parent.arms_btn_mc.enabled = false;
		  this._parent.arms_btn_mc.gotoAndStop(1);
		  this._parent.legs_btn_mc.enabled = false;
		  this._parent.legs_btn_mc.gotoAndStop(1);
		  this._parent.help_btn_mc.enabled = false;
		  this._parent.help_btn_mc.gotoAndStop(1);
		  trace(this._parent.help_btn_mc._currentframe+"the current frame of help");
		  //this._parent.go_btn_mc.enabled = false;
		  }
	
	}