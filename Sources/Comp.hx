package;


import kha.graphics4.Program;
import kha.graphics4.VertexStructure;

import kha.math.Vector2;
import kha.math.Vector4;


class Comp extends Paddle{

	public function new(program:Program, structure:VertexStructure){

		super(program, structure, new Vector2(0, -5));

	}

	override public function update(){

	}

}
