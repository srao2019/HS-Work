import javax.swing.JFrame;


public class Frame extends JFrame{
	public Frame(){
		setSize(900,900);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		setTitle("Unblock Me");
		
	}
	public static void main(String[] args){
		Frame f=new Frame();
		Panel p=new Panel();
		f.setContentPane(p);
		f.setVisible(true);
		
	}
}
