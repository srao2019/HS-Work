
public class Block {

	private float mass; //mass of block
	private int x; //x coordinate
	private int y; //y coordinate
	
	public Block(float m, int x1, int y1){
		mass=m;
		x=x1;
		y=y1;
		
	}

	public float getMass() {
		return mass;
	}

	public void setMass(float mass) {
		this.mass = mass;
	}

	public int getX() {
		return x;
	}

	public void setX(int x) {
		this.x = x;
	}

	public int getY() {
		return y;
	}

	public void setY(int y) {
		this.y = y;
	}
}
