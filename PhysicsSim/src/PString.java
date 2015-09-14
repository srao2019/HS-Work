
public class PString {
	
	private double tension;
	private int x1;
	private int x2;
	private int y1;
	private int y2;
	
	
	public PString(int x, int y, int xx, int yy){
		x1=x;
		x2=xx;
		y1=y;
		y2=yy;
	}
	public double getTension() {
		return tension;
	}
	public void setTension(double tension) {
		this.tension = tension;
	}
	public int getX1() {
		return x1;
	}
	public void setX1(int x1) {
		this.x1 = x1;
	}
	public int getX2() {
		return x2;
	}
	public void setX2(int x2) {
		this.x2 = x2;
	}
	public int getY1() {
		return y1;
	}
	public void setY1(int y1) {
		this.y1 = y1;
	}
	public int getY2() {
		return y2;
	}
	public void setY2(int y2) {
		this.y2 = y2;
	}
	public int height(){
		return y2-y1;
	}
	public int width(){
		return x2-x1;
	}
	
}
