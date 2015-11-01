package;


import kha.math.Vector2;


class Ball{

	var pos:Vector2;
	var mov:Vector2;

	var speed = 1.5;


	public function new(){

		mov = new Vector2(0, 0);

		var angle = kha.math.Random.getUpIn(25, 75);
		angle = (2*Math.PI*angle) / 360;

		mov = new Vector2(Math.cos(angle), Math.sin(angle));

		mov = mov.mult(speed);

	}

	public function update(){

	}

	public function display(){
		
	}

}
