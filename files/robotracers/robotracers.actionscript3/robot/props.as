class robot.props {
	// variable declarations
	public var _weight:Number;
	private var _name:String;
	private var _constant:Boolean;
	// constructor
	function props(the_name:String, the_weight:Number, move_constant:Boolean) {
		this._weight = the_weight;
		this._name = the_name;
		this._constant = move_constant;
	}
	public function set weight(_w:Number):Void {
		this._weight = _w;
	}
	public function set name(n:String):Void {
		this._name = n;
	}
	public function set constant(_c:Boolean):Void {
		this._constant = _c;
	}
	public function get weight():Number {
		return _weight;
	}
	public function get name():String {
		return _name;
	}
	public function get constant():Boolean {
		return _constant;
	}
}
