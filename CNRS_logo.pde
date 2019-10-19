import java.io.FilenameFilter;
import java.io.File;

float sw=1;
String[] lines, psFiles;
int closestPoint, n=0;
int[] r = {0, 100, 200, 45, 0, 45}; 
int[] g = {40, 195, 230, 125, 80, 155}; 
int[] b = {75, 220, 230, 195, 160, 180}; 
ArrayList<bzPoint> bzPoints; 
boolean controlPoints, help;
String psFile  = "cnrs.ps";
PImage logo80ans;

void setup() {
  size(800, 800); 
  logo80ans = loadImage("Logo80ANS_OR.png");
  lines  = loadStrings(psFile);
  psFiles = listFileNames(sketchPath("data"));
  bzPoints = new ArrayList<bzPoint>() ;
  for (int i = 0; i < lines.length; i++) {
    String[] p = lines[i].split(" ");
    if (p.length<4) {
      bzPoints.add( new bzPoint(float(p[0]), float(p[1]), 0));
    } else {
      bzPoints.add( new bzPoint(float(p[0]), float(p[1]), 1));
      bzPoints.add( new bzPoint(float(p[2]), float(p[3]), 1));
      bzPoints.add( new bzPoint(float(p[4]), float(p[5]), 0));
    }
  }
  controlPoints=true;
  help=true;
}

void draw() {
  translate(50, 50);
  scale(3);  
  background(r[0], g[0], b[0]);
  
  if (help) {
    fill(255);
    textSize(8);
    textAlign(LEFT, CENTER);
    text("h: toggle help\n"+
      "c: toggle control points\n"+
      "f: cnrs logo or segment\n"+
      "shift-click: add one point\n"+
      "space: reset\n"+
      "+/- adjust line width\n", 50, 100);
  }
  image (logo80ans,0,204,logo80ans.width/20,logo80ans.height/20);
  for (int i=0; i<bzPoints.size()/3; i++) {
    noFill();
    strokeWeight(max(sw,0.5));
    int col = 1+(i)%(r.length-2);
    stroke(r[col], g[col], b[col]);
    
    bezier(bzPoints.get(i*3).x, bzPoints.get(i*3).y, 
      bzPoints.get(i*3+1).x, bzPoints.get(i*3+1).y, 
      bzPoints.get(i*3+2).x, bzPoints.get(i*3+2).y, 
      bzPoints.get(i*3+3).x, bzPoints.get(i*3+3).y);
    stroke(255, 0, 0, 128);
    strokeWeight(max(min(3,sw*0.3),0.5));
    if (controlPoints) {
      line(bzPoints.get(i*3).x, bzPoints.get(i*3).y, 
        bzPoints.get(i*3+1).x, bzPoints.get(i*3+1).y);
      line(bzPoints.get(i*3+2).x, bzPoints.get(i*3+2).y, 
        bzPoints.get(i*3+3).x, bzPoints.get(i*3+3).y);
    }
  }
  if (controlPoints) {
    for (int i = 0; i< bzPoints.size(); i++) {
      bzPoints.get(i).display();
    }
  }

  
}

void mousePressed() {
  if (keyPressed && keyCode==SHIFT &&  key == CODED) {
      bzPoints.add( new bzPoint(float(mouseX-50)/3+10, float(mouseY-50)/3-10, 1));
      bzPoints.add( new bzPoint(float(mouseX-50)/3-10, float(mouseY-50)/3+10, 1));
      bzPoints.add( new bzPoint(float(mouseX-50)/3, float(mouseY-50)/3, 0));
  } else {

    float d=width/2;
    closestPoint = -1;
    for (int i = 0; i< bzPoints.size(); i++) {
      float mouseDist = dist((mouseX-50)/3, (mouseY-50)/3, bzPoints.get(i).x, bzPoints.get(i).y);
      if (mouseDist<d) {
        closestPoint = i;
        d=mouseDist;
      }
    }
  }
}
void mouseDragged() {
  bzPoints.get(closestPoint).x+=float(mouseX-pmouseX)/3;
  bzPoints.get(closestPoint).y+=float(mouseY-pmouseY)/3;
}
void mouseReleased() {
  
}

void keyPressed() {
  if (key==' ') setup();
  else if (key=='c') controlPoints=!controlPoints;
  else if (key=='h') help=!help;
  else if (key=='+') sw*=1.1;
  else if (key=='-') sw/=1.1;
  else if (key=='f') {
    n++;
    psFile = psFiles[n%psFiles.length];
    setup();
  }
}

String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list(new FilenameFilter() {
      @Override
        public boolean accept(File dir, String name) {
        return name.endsWith("ps");
      }
    }
    );
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}
