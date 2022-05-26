
class robot.bodyPart extends MovieClip{
	public var weight:Number = 0;
	public var woot:String;
	public var enabled:Boolean = false;
	public var ap:Number = 0;
	public var called_weight:Boolean = false;
	public function bodyPart(_w:Number){
		weight = _w;
     
	}

	public function _weight(w:Number):Void{
		weight = w;
		}

    public function wooter(say:String){
		woot = say;
		
		}
		
	public function _type(t:Array){
		type.push(t);
		}	
		
		// pulling in the part, the type, and the object being effected.
    public var obstacle:Array = new Array("con_hurdle", "concrete_slab", "water_pool");
	public var type = new Array("plastic", "copper", "iron", "alum", "tin");
	public var part = new Array("head", "arm", "legs", "body");
	
	public function attack(part, the_type, obj, user){
		trace(obj+" the freeeking object num!>>>>>>>>>>>>>");
	           	// If obstacles have been appened, then reset them.
		if(obstacle[0].length > 10){obstacle[0] = "con_hurdle"
		                            obstacle[1] = "concrete_slab"
									obstacle[2] = "water_pool"}
		trace(user +" is the name");

		   
		if(user !== "user"){/// if not user then append number to end of obst name
		 obstacle[0] = obstacle[0] + user.slice(4,7);
		 obstacle[1] = obstacle[1] + user.slice(4,7);
		 obstacle[2] = obstacle[2] + user.slice(4,7);}
		trace(obstacle+"is now changed");
		trace(part +" is the part");
		var the_obstacle = obstacle[obj];
		trace(the_obstacle +" the obstacle");
		trace(the_type + "the type")
	 if(the_obstacle !== "water_pool"){
		 trace(this._parent._parent[the_obstacle]);

		if(part == "l_arm_obj"){// Arms part////////////////////
		trace("arms")
		trace("type 1");
		    if(type[0] == the_type){// plastic
			 ap = 1;
			 trace(ap +" the ap")
			 trace("plastic arms");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			
		    if(type[1] == the_type){// copper
		     ap = 2;
			 trace("copper arms");
			 
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)
			 };
			
			 if(type[2] == the_type){// iron
		     ap = 2;
			 trace("iron arms");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			 
			 if(type[3] == the_type){// alum
		     ap = 1;
			 trace("Aluminum arms");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			 
			 if(type[4] == the_type){// tin 
			ap = 1;
			 trace("tin legs");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			 
			 
			
			}
		if(part == "head_obj"){// Head part////////////////////
			trace("head");
		    if(type[0] == the_type){// plastic
			 ap = 1;
			 trace(ap +" the ap")
			 trace("plastic Head");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			
		    if(type[1] == the_type){// copper
			 trace("copper Head");
			 this._parent._parent[user].fly(user);}
			
			 if(type[2] == the_type){// iron
		     ap = 2;
			 trace("iron Head");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			 
			 if(type[3] == the_type){// alum
		     ap = 1;
			 trace("Aluminum Head");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			
			if(type[4] == the_type){// tin 
			ap = 1;
			 trace("tin legs");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			
			}
		if(part == "legs_obj"){// legs part////////////////////
			 trace("legs");
			 
		   if(type[0] == the_type){// plastic
			 ap = 1;
			 trace(ap +" the ap")
			 trace("plastic legs");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			
		    if(type[1] == the_type){// copper
		     ap = 2;
			 trace("copper legs");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			
			 if(type[2] == the_type){// iron
		     ap = 2;
			 trace("iron legs");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			 
			 if(type[3] == the_type){// alum
		     ap = 1;
			 trace("Aluminum legs");
			 trace(the_obstacle +", this is the obstacle ,"+obstacle[1] );
			 if(the_obstacle == obstacle[0] || the_obstacle == obstacle[2]){
                   this._parent._parent[user].jump(user);
			      trace("aluminium legs jumping");
			 }else{
		     trace("aluminium legs doing dmg");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
				 }
		   
		   if(type[4] == the_type){// tin 
			ap = 1;
			 trace("tin legs");
			 this._parent._parent[the_obstacle].take_dmg(ap, user, part)};
			 
		  }
			 
			}else{//// Water Pool///////////////
			trace("the water pool");
			 var weight:Number  = this._parent._parent[user].weight;
			 this._parent._parent[the_obstacle].sink_float(weight, user, part);
			 
			}};
				
		

		
			
		public function stored_weight(the_type:String, the_part:String):Number{

		if(the_part == "head_obj"){	// Head part////////////////////
            if(type[0] == the_type){return 1}// plastic
		    if(type[1] == the_type){return 2}// copper
			 if(type[2] == the_type){return 3}// iron
			 if(type[3] == the_type){return 1}// alum
			 if(type[4] == the_type){return 2}// tin
		}
		
		  if(the_part == "l_arm_obj"){// arms part////////////////////
			trace("arms");
            if(type[0] == the_type){return 1}// plastic
		    if(type[1] == the_type){return 2}// copper
			 if(type[2] == the_type){return 3}// iron
			 if(type[3] == the_type){return 1}// alum
			 if(type[4] == the_type){return 2}// tin
			}
		if(the_part == "body_obj"){// body part////////////////////
			 trace("body");
            if(type[0] == the_type){return 1}// plastic
		    if(type[1] == the_type){return 2}// copper
			 if(type[2] == the_type){return 3}// iron
			 if(type[3] == the_type){return 1}// alum
			 if(type[4] == the_type){return 2}// tin
		}
		if(the_part == "legs_obj"){// legs part////////////////////
			 trace("legs");
            if(type[0] == the_type){return 1}// plastic
		    if(type[1] == the_type){return 2}// copper
			 if(type[2] == the_type){return 2}// iron
			 if(type[3] == the_type){return 1}// alum
			 if(type[4] == the_type){return 1}// tin
			
			}
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
      };
		
		
		
		
		
	
	
}