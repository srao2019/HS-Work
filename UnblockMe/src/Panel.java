import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.text.AttributedString;
import java.util.ArrayList;

import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JRadioButtonMenuItem;


@SuppressWarnings("serial")
public class Panel extends JPanel implements MouseListener,ActionListener{

	private ArrayList<Block> puzzle1 = new ArrayList<Block>(); //holds all the blocks 
	private Block [][] slots = new Block [6][6]; //represents a space in the grid. holds a block or null
	private int moves=0; //number of moves
	private int x; //x coordinate of click
	private int y; //y coordinate of click
	private int distanceMoved; //distance block is trying to move
	private int moveX; //horizontal distance block is trying to move
	private int moveY; //vertical distance block is trying to move
	private String moveDirection; //direction block is trying to move
	private JButton reset; //resets puzzle so blocks are in original locations
	
	
	public Panel(){
		setPuzzle1(); //sets locations of blocks in puzzle
		addMouseListener(this); 
		reset=new JButton("Reset"); 
		this.setLayout(null);
		reset.setLayout(null);
		reset.setBounds(690,125,100,30); //sets location of button
		add(reset);
		reset.addActionListener(this);
		reset.setActionCommand("reset");
	}
	
	public void actionPerformed(ActionEvent e){
		String action=e.getActionCommand();
		if(action.equals("reset")){ //when reset is hit, the blocks are moved to original locations
			puzzle1.clear();
			setPuzzle1();
			moves++; //resetting the board counts as a move
			repaint();
		}
	}
	
	public void setPuzzle1(){
		puzzle1.add(new Block(3,0,0,true,false,"big_block.png")); 
		puzzle1.add(new Block(2,0,200,true,true,"red_block.png"));
		puzzle1.add(new Block(2,0,300,false,false,"small_block_vert.png"));
		puzzle1.add(new Block(3,0,500,true,false,"big_block.png"));
		puzzle1.add(new Block(3,200,100,false,false,"big_block_vert.png"));
		puzzle1.add(new Block(3,500,0,false,false,"big_block_vert.png"));
		puzzle1.add(new Block(2,400,300,true,false,"small_block.png"));
		puzzle1.add(new Block(2,400,400,false,false,"small_block_vert.png"));
		//sets blocks in their designated slots when the puzzle begins
		slots[0][0]= puzzle1.get(0);
		slots[0][1]= puzzle1.get(0);
		slots[0][2]= puzzle1.get(0);
		slots[0][3]= null;
		slots[0][4]= null;
		slots[0][5]= puzzle1.get(5);
		slots[1][0]= null;
		slots[1][1]= null;
		slots[1][2]= puzzle1.get(4);
		slots[1][3]= null;
		slots[1][4]= null;
		slots[1][5]= puzzle1.get(5);
		slots[2][0]= puzzle1.get(1);
		slots[2][1]= puzzle1.get(1);
		slots[2][2]= puzzle1.get(4);
		slots[2][3]= null;
		slots[2][4]= null;
		slots[2][5]= puzzle1.get(5);
		slots[3][0]= puzzle1.get(2);
		slots[3][1]= null;
		slots[3][2]= puzzle1.get(4);
		slots[3][3]= null;
		slots[3][4]= puzzle1.get(6);
		slots[3][5]= puzzle1.get(6);
		slots[4][0]= puzzle1.get(2);
		slots[4][1]= null;
		slots[4][2]= null;
		slots[4][3]= null;
		slots[4][4]= puzzle1.get(7);
		slots[4][5]= null;
		slots[5][0]= puzzle1.get(3);
		slots[5][1]= puzzle1.get(3);
		slots[5][2]= puzzle1.get(3);
		slots[5][3]= null;
		slots[5][4]= puzzle1.get(7);
		slots[5][5]= null;
		
		
	}
	
	public void paintComponent(Graphics g){
		super.paintComponent(g); //clears the board
		g.setColor(new Color(204,102,0)); //color for background of board
		g.drawRect(0,0,600,600);
		g.fillRect(0,0,600,600);
		g.setColor(Color.BLACK);
		g.drawLine(600,200,700,200); //draws goal lines
		g.drawLine(600,300,700,300);
		for(Block b:puzzle1){
			g.drawImage(b.getImage(),b.getXco(),b.getYco(),null); //draws blocks
		}
		
		g.setFont(new Font("Arial",Font.BOLD,35)); 
		g.drawString("Unblock Me", 650, 40); //title
		g.drawLine(650,40,840,40);//underline
		g.setFont(new Font("Arial",Font.BOLD,25));  
		g.drawString("Moves: "+moves,690, 100); //moves
	}

	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub
	
	}
	
	public boolean isInt(String s){
		    try { 
		        Integer.parseInt(s);  //checks if a string is an int
		    } catch(NumberFormatException e) { 
		        return false; 
		    }
		    // only got here if we didn't return false
		    return true;
	}
	// this method is to check if the slot where we will move it to is in bounds and empty.
	public boolean checkSlots(int xSlot, int ySlot, Block b,int m){
			if (b.getDirection() == 2){//moving down
				for (int i = 0; i <m; i++){
					if ( ySlot+b.getSize()+i> 5 || ySlot+i+b.getSize() <= 0 || (slots[ySlot+b.getSize()+i][xSlot] != null && slots[ySlot+b.getSize()+i][xSlot] != b)){
						// if it is out of bounds, not null and not itself then dont move
						return false;
					}
				}
			} else if(b.getDirection() == 1){ //moving up
				for (int i = 0; i <m; i++){
					if ( ySlot-i > 5 || ySlot-i <= 0 || (slots[ySlot-i-1][xSlot] != null)){
						//dont have to check that its not itself because when moving up it will never hit itself
						return false;
					}
				}
			} else if (b.getDirection() == 3){ //moving right
				for (int i = 0; i < m; i++){
					if (xSlot+b.getSize()+i > 5 || xSlot+b.getSize()+i <= 0 || (slots[ySlot][xSlot+b.getSize()+i] != null && slots[ySlot][xSlot+b.getSize()+i] != b)){
						// if it is out of bounds, not null and not itself then dont move
						return false;
					}
				}
			} else if(b.getDirection() == 4){
				for (int i = 0; i < m; i++){ //moving left
					if (xSlot-i > 5 || xSlot-i <= 0 || (slots[ySlot][xSlot-i-1] != null))
						//dont have to check that its not itself because when moving left it will never hit itself
						return false;
					}
				}
			
			return true;
		}
	//this method is to change the values of slots to contain the new blocks that were just moved
	public void changeSlots(int xSlot, int ySlot, Block b, int m){
		if (b.getDirection() == 2){ //moving down
			for (int i = 0; i < m; i++){
				slots[ySlot+b.getSize()+i][xSlot] = b; //the ones below need to be set to the block
				slots[ySlot+i][xSlot] = null; //as the block moves down, the upper part becomes null
			}
		} else if(b.getDirection() == 1){ //moving up
			for (int i = 0; i < m; i++){
				slots[ySlot-i-1][xSlot] = b; //the ones above need to be set to the block
				slots[ySlot+b.getSize()-i-1][xSlot] = null; //as the block moves up, the lower part becomes null
			}
		} else if (b.getDirection() == 3){ //moving right
			for (int i = 0; i < m; i++){
				slots[ySlot][xSlot+b.getSize()+i] = b; //the ones right need to be set to the block
				slots[ySlot][xSlot+i] = null; //as the block moves right, the left part becomes null
			}
		} else if(b.getDirection() == 4){ //moving left
			for (int i = 0; i < m; i++){
				slots[ySlot][xSlot-i-1] = b; //the ones left need to be set to the block
				slots[ySlot][xSlot+b.getSize()-i-1] = null; //as the block moves left, the right part becomes null
				
			}
		}
	}

	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub
		x = e.getX(); //x coordinate of click
		y = e.getY(); //y coordinate of click
		if (slots[y/100][x/100] == null){ // if nothing is there
			JOptionPane.showMessageDialog(this, "Nothing there", "Error", JOptionPane.WARNING_MESSAGE);
			return;
		}
		moveDirection = JOptionPane.showInputDialog(this,"What direction would you like to move?" + "\n" + "Please type in all lowercase!",null);
		if(slots[y/100][x/100].isHor()&& (moveDirection.equals("up") || moveDirection.equals("down"))){
			//if trying to move a horizontal block up or down
			JOptionPane.showMessageDialog(this, "Try Again!", "Error", JOptionPane.WARNING_MESSAGE); 
			return;
		}
		if(!slots[y/100][x/100].isHor()&& (moveDirection.equals("right") || moveDirection.equals("left"))){
			//if trying to move a vertical block right or left
			JOptionPane.showMessageDialog(this, "Try Again!", "Error", JOptionPane.WARNING_MESSAGE);
			return;
		}
		if (moveDirection.equals("up")){
			String s = JOptionPane.showInputDialog(this,"How many spaces would you like to move?",null);
			if (!isInt(s)){
				//if its not an int
				JOptionPane.showMessageDialog(this, "Try Again!", "Error", JOptionPane.WARNING_MESSAGE);
				return;
			}
			slots[y/100][x/100].moveDirection(1); //indicates up
			distanceMoved = Integer.parseInt(s); //how much to move
			moveX = 0; //how much to move horizontally
			moveY = Integer.parseInt(s); //how much to move vertically
			moveY *= (-100); //to indicate coordinates to move
		} else if (moveDirection.equals("right")){
			String s = JOptionPane.showInputDialog(this,"How many spaces would you like to move?",null);
			if (!isInt(s)){
				//if its not an int
				JOptionPane.showMessageDialog(this, "Try Again!", "Error", JOptionPane.WARNING_MESSAGE);
				return;
			}
			slots[y/100][x/100].moveDirection(3); //indicates right
			distanceMoved = Integer.parseInt(s); // how much to move
			moveX = Integer.parseInt(s) * 100; //how much to move horizontally based on coordinates
			moveY = 0;
		} else if(moveDirection.equals("down")){ 
			String s = JOptionPane.showInputDialog(this,"How many spaces would you like to move?",null);
			if (!isInt(s)){
				JOptionPane.showMessageDialog(this, "Try Again!", "Error", JOptionPane.WARNING_MESSAGE);
				return;
			}
			slots[y/100][x/100].moveDirection(2); //indicates down
			distanceMoved = Integer.parseInt(s);
			moveX = 0;
			moveY = Integer.parseInt(s) * 100; //how much to move vertically based on coordinates
		}else if(moveDirection.equals("left")){
			String s = JOptionPane.showInputDialog(this,"How many spaces would you like to move?",null);
			if (!isInt(s)){
				JOptionPane.showMessageDialog(this, "Try Again!", "Error", JOptionPane.WARNING_MESSAGE);
				return;
			}
			slots[y/100][x/100].moveDirection(4); //indicates left
			distanceMoved = Integer.parseInt(s);
			moveX = Integer.parseInt(s); //how much to move horizontally
			moveY = 0;
			moveX *= (-100); //puts into coordinates
		}else {
			JOptionPane.showMessageDialog(this, "Try Again!", "Error", JOptionPane.WARNING_MESSAGE);
			//if something else random was typed
			return;
		}
		Block temp=slots[y/100][x/100]; //this is the block that is clicked on
		int xo=temp.getXco(); //original coordinates of block
		int yo=temp.getYco(); //original coordinates of block
		if (checkSlots(xo/100, yo/100, temp,distanceMoved)){ 
			temp.setCoordinates(temp.getXco() + moveX, temp.getYco() + moveY); //changes coordinates to move block
			changeSlots(xo/100, yo/100,temp,distanceMoved); //changes slots
			moves++; //increments moves
			if (temp.isRed() && temp.getXco()>=400){ //checks if red is through goal
				JOptionPane.showMessageDialog(this, "Yay! You Win!", "Winner", JOptionPane.WARNING_MESSAGE);
				return;
			}
		} else {
			JOptionPane.showMessageDialog(this, "Try Again!", "Error", JOptionPane.WARNING_MESSAGE);
			//if check slots didn't work
			return;
		}
		
		
		this.repaint(); //redraws board
	}

	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}

}
