import javax.swing.JFrame;
public class PhysicsSimMain {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		JFrame f=new JFrame("Physics Sim"); //makes a frame
		f.setSize(800,800); //sets size of frame
		f.setVisible(true);
		f.setContentPane(new Sim()); //makes content based upon sim
		f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		

	}

}
