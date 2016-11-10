package org.adl.samplerte.util;

import java.applet.Applet;
import java.awt.Color;
import java.awt.Graphics;

public class TestApplet extends Applet {

	public void init() {
		System.out.println("init...");
		
	}

	public void paint(Graphics g) {
		g.drawRect(0,0,250,100);
		g.setColor(Color.blue);
		g.drawString("Look at me, I'm a Java Applet!",10,50);
	}
	
	public void ttt() {
		System.out.println("=====");
	}
}
