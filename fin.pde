import processing.sound.*;

Rain[] rain = new Rain[0];
String[]colors = {"#75b9be", "#696d7d", "#d72638", "#f49d37", "#140f2d"};
color backgroundCol;
int splashCount = 0;

void setup() {
  size(800, 600);
  background(#FAF9ED);
  backgroundCol = color(#FAF9ED);
}

void draw() {
  //backgroundCol = color(#FAF9ED);
  //backgroundCol = color(red(backgroundCol), green(backgroundCol), blue(backgroundCol), 10);
  //background(backgroundCol);
noStroke();
fill(#FAF9ED,10);
rect(0,0,width,height);
  if (frameCount % 2 == 0) {
    rain = (Rain[])append(rain, new Rain(random(width), random(-100, height), random(5, 30)));
  }

  for (int i = rain.length-1; i >= 0; i--) {
    rain[i].move();
    rain[i].show();
  }
}

class Pointer {
  float dist;
  float rad;
  float speed;
  float acc;
  PVector pos;
  float finalSize;
  PVector downSpeed;
  PVector downAcc;

  Pointer(float rad, float acc, float finalSize) {
    dist = 1;
    this.rad = rad;
    speed = 0;
    this.acc = acc;
    pos = new PVector(0, 0);
    this.finalSize = finalSize;
    downSpeed = new PVector(0, 0.01);
    downAcc = new PVector(0, 0.05 + acc / 500);
  }

  void move() {
    if (dist <= finalSize) {
      speed += acc;
      dist += speed;
      pos = new PVector(cos(rad) * dist, sin(rad) * dist);
    } 
    else {
      downSpeed.add(downAcc);
      pos.add(downSpeed);  
    }
  }
}


class Rain {
  Pointer[] splat;
  color rainColor1;
  color rainColor2;
  color rainColor3;
  float x;
  float y;
  int death;
  float extent;
  float noiseStart;

  Rain(float x, float y, float extent) {
    splat = new Pointer[int(random(20, 30))];
    rainColor1 = int(random(200,255));
      rainColor2 = int(random(200,255));
      rainColor3 = int(random(255));
    //color(random(255));
    this.x = x;
    this.y = y;
    death = 500;
    this.extent = extent;
    noiseStart = random(1000);
    for (int i = 0; i < splat.length; i++) {
      float acc = noise(noiseStart + i * 0.1);
      splat[i] = new Pointer(i * TWO_PI / splat.length, acc, extent);
    }  
  }

  void move() {
    for (Pointer n: splat) {
      n.move();
    }
    death--;
    if (death < 1) {
      rain = (Rain[])subset(rain, 1);
    }
  } 

  void show() {
    noStroke();
   // rainColor.setAlpha(80);
    fill(rainColor1,rainColor2,rainColor3);
    push();
    translate(x, y);
    beginShape();
    for (Pointer n: splat) {
      curveVertex(n.pos.x, n.pos.y);
    }
    endShape(CLOSE);
    pop();
  }
}

void mousePressed() {
  if (!Float.isNaN(frameRate)) {
    surface.setResizable(true);
    surface.setAlwaysOnTop(true);
    surface.setLocation(0, 0);
    surface.setSize(displayWidth, displayHeight);
    splashCount++;
  } 
  else {
    surface.setAlwaysOnTop(false);
    surface.setResizable(false);
    surface.setLocation(100, 100);
    surface.setSize(800 + 2 * splashCount, 600 + 2 * splashCount);
  }
}
