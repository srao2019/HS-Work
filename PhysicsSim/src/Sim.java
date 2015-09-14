import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;

import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;



public class Sim extends JPanel implements ActionListener, Runnable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private JButton addBlock; //button to addBlock
	private JButton clear;
	private ArrayList<Block> blocksL=new ArrayList<Block>(); //Blocks on Left side
	private ArrayList<Block> blocksR=new ArrayList<Block>(); //blocks on right side
	private float sumL; //sum of masses on left side
	private float sumR; //sum of masses on right side
	private PString stringL; //left string
	private PString stringR; //right string
	final double G=9.8; //acceleration due to gravity
	private double a; //acceleration of moving blocks
	private double tension; //tension of string
	
	public Sim(){
		addBlock=new JButton("Add Block"); //creates new button
		clear= new JButton("Clear");
		//addBlock.setBounds(700,250,50,100);
		add(addBlock); //adds it to frame
		addBlock.addActionListener(this);
		addBlock.setActionCommand("Add Block");
		add(clear);
		clear.addActionListener(this);
		clear.setActionCommand("Clear");
		
		stringL=new PString(350,185,350,350); //sets string bounds
		stringR=new PString(425,185,425,350);
		
		
	}
	public void stringReset(){
		stringL=new PString(350,185,350,350); //sets string bounds
		stringR=new PString(425,185,425,350);
	}
	public void actionPerformed(ActionEvent e){
		String action=e.getActionCommand();
		if(action.equals("Add Block")){
			String result=JOptionPane.showInputDialog(this,"Enter mass:");
			float mass=0;
			while(true){
				try{
					mass=Float.parseFloat(result); //makes result into the mass
					break;
				}catch(NumberFormatException n){
					result=JOptionPane.showInputDialog(this, "Try Again: "); //keeps repeating this till a proper number is entered
				}
			}
			String[] buttons = { "Left", "Right"};    
			int loc = JOptionPane.showOptionDialog(null, "Which side?", "Which side?",
			        JOptionPane.DEFAULT_OPTION, 0, null, buttons, buttons[0]);
			
			if(loc==1){//right
				int y=stringR.getY2();
				for(int i=0;i<blocksR.size();i++){
					y+=50; //place new block below earlier block
					}
				blocksR.add(new Block(mass,stringR.getX1()-25,y));
			}else{//left
				int y=stringL.getY2();
				for(int i=0;i<blocksL.size();i++){
					y+=50; 
				}
				blocksL.add(new Block(mass,stringL.getX1()-25,y));
			}
		
		repaint();
		
		} else if(action.equals("Clear")){
			blocksR.clear();
			blocksL.clear();
			stringReset();
			tension=0;
			repaint();
		}
	}
		

	public void paint(Graphics g){
		//removeAll();
		super.paintComponent(g); //clears frame
		add(addBlock);
		//add(addF);
		g.drawString("Basic Atwood Machine", 300,50);
		g.setColor(Color.GRAY);
		g.fillOval(350, 150, 75, 75); //pulley
		g.setColor(Color.BLACK);
		//g.drawLine(350,185,350,350);
		//g.drawLine(425,185,425,350);
		g.drawLine(stringL.getX1(),stringL.getY1(),stringL.getX2(),stringL.getY2()); //draws strings
		g.drawLine(stringR.getX1(),stringR.getY1(),stringR.getX2(),stringR.getY2());
		
		//sum up masses
		sumR=0;
		sumL=0;
		for(Block b:blocksR){
			g.drawRect(b.getX(), b.getY(), 50,50);
			g.drawString(((Float)b.getMass()).toString(),b.getX()+20, b.getY()+25);
			sumR+=b.getMass();
		}
		for(Block b:blocksL){
			g.drawRect(b.getX(), b.getY(), 50,50);
			g.drawString(((Float)b.getMass()).toString(),b.getX()+20, b.getY()+25);
			sumL+=b.getMass();
		}
		
		g.drawString("Acceleration: "+((Double)findA()).toString(),600,400);
		g.drawString("Tension: "+((Double)findT()).toString(),600,420);
		if(sumR>sumL || sumL>sumR){
			Thread t=new Thread(this); //start moving blocks
			t.start();
		}
			
		
	}
	
	public double findA(){
		a=((Math.abs(sumR-sumL))*G)/(sumR+sumL);
		return a;
		
	}
	public double findT(){
		if(sumR>sumL)
			if(sumL==0)
				tension=sumR*G;
			else
				tension=(sumL*a)+(sumL*G);
		if(sumL>sumR)
			if(sumR==0)
				tension=sumL*G;
			else
				tension=(sumR*a)+(sumR*G);
		stringL.setTension(tension);
		stringR.setTension(tension);
		return tension;
		
		
		
	}

	
	
	public void run() {
		if(sumR>sumL){
			if(stringL.height()>50){
				try{
				Thread.sleep((long)(1/findA())*100);
					for(Block b: blocksR) //changes y coordinate of block to move the block down/up
						b.setY(b.getY()+10);
					for(Block b: blocksL)
						b.setY(b.getY()-10);
					stringR.setY2(stringR.getY2()+10);
					stringL.setY2(stringL.getY2()-10);
					
					repaint();
					
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			}
					
		}else{
			if(stringR.height()>50){
				try{
					Thread.sleep((long)(1/findA())*100);
					for(Block b: blocksR)
						b.setY(b.getY()-10);
					for(Block b: blocksL)
						b.setY(b.getY()+10);
					stringR.setY2(stringR.getY2()-10);
					stringL.setY2(stringL.getY2()+10);
					
					repaint();
					
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				}
		}
	}
			
			
}
