import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;


public class Block {

	private int size;
	private int xco;
	private int yco;
	private boolean isHor;
	private boolean isRed;
	private String image;
	private int direction;
	
	public Block(int s, int x, int y, boolean h, boolean r,String img){
		size = s;
		xco = x;
		yco = y;
		isHor = h;
		isRed =r;
		image=img;
	}
	
	public void moveDirection(int d){
		direction = d;
	}
	
	public int getDirection(){
		return direction;
	}

	public int getSize() {
		return size;
	}

	public void setXco(int xco) {
		this.xco = xco;
	}

	public int getXco() {
		return xco;
	}

	public void setYco(int yco) {
		this.yco = yco;
	}

	public int getYco() {
		return yco;
	}


	public boolean isHor() {
		return isHor;
	}

	public boolean isRed() {
		return isRed;
	}
	
	public void setCoordinates(int x,int y){
		this.xco=x;
		this.yco=y;
	}
	
	public BufferedImage getImage(){
		BufferedImage img = null;
		try {
		    img = ImageIO.read(new File(image));
		} catch (IOException e) {
		   e.printStackTrace();
		}
		return img;
	}
	
}
