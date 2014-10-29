import 'dart:html';
import 'dart:async';
import 'dart:math' as math;
import 'package:viltage/viltage.dart';
import 'complex.dart';

CanvasElement testCanvas = querySelector('#test1');
Entity fractalRect;
int maxIter = 32;
Complex power = new Complex(2.0, 0.0);
double bailout = 4.0;
Complex offset = new Complex(-3.0, -2.0);
Complex size = new Complex(0.25, 0.25);

Entity initFractalEntity(VilTAGE v, int w, int h) {
  Entity e = new Entity(0, 0, 1, v);
  
  List<String> charRect = new List<String>();
  StringBuffer horizStringBuffer = new StringBuffer();
  
  for (int i = 0; i < w; i++) {
    horizStringBuffer.write(" ");
  }
  
  String horizString = horizStringBuffer.toString();
  
  for (int j = 0; j < h; j++) {
    charRect.add(horizString);
  }
  
  e.states[0].createCharNodeRect(0, 0, charRect);
  return e;
}

void main() {
  VilTAGEConfig vtc = new VilTAGEConfig(querySelector('#console'), 640, 480);
  vtc.width = 64;
  vtc.height = 48;
  VilTAGE viltage = new VilTAGE(vtc);
  fractalRect = initFractalEntity(viltage, vtc.width, vtc.height);
  for (int y = 0; y < vtc.height; y++) {
    for (int x = 0; x < vtc.width; x++) {
      double c = mandelbrot(new Complex(x / vtc.width / size.x + offset.x, y / vtc.height / size.y + offset.y));
      String newChar = " ";
      if (c == 0.0) {
        newChar = " ";
      } else if (c > 0.0 && c < 0.2) {
        newChar = ".";
      } else if (c >= 0.2 && c < 0.4) {
        newChar = ":";
      } else if (c >= 0.4 && c < 0.6) {
        newChar = "+";
      } else if (c >= 0.6 && c < 0.8) {
        newChar = "=";
      } else if (c >= 0.8 && c < 1.0) {
        newChar = "0";
      } else if (c == 1.0) {
        newChar = "@";
      }
      fractalRect.states[0].charNodes[y * vtc.width + x].char = newChar;
    }
  }
  generateFractal(mandelbrot, true);
}

double mandelbrot (Complex xy) {
  Complex z = new Complex(xy.x, xy.y);
  double i = 0.0;
  
  while (i < maxIter && z.abs() <= bailout) {
    z = z.pow(power).add(xy);
    i++;
  }
  
  if (i < maxIter) {
    i -= math.log(math.log(z.abs())) / math.log(power.abs());
    return i / maxIter;
  } else {
    return 1.0;
  }
}

Function lastFormula;
Timer timer;
Duration dur = new Duration(milliseconds: 4);

void generateFractal (Function formula, bool resetSize) {
  if (timer != null) timer.cancel();
  lastFormula = formula;
  
  /*
  if (resetSize) {
      offset = new Complex(formula.offset.x, formula.offset.y);
      size = new Complex(formula.size.x, formula.size.y);
  }
  */
  
  int w = testCanvas.width;
  int h = testCanvas.height;
  CanvasRenderingContext2D g = testCanvas.getContext("2d");
  ImageData img = g.getImageData(0, 0, w, h);
  List<int> pix = img.data;
  int y = 0;
  
  List<int> getColor(double i) {
    double k = 1.0 / 3.0;
    double k2 = 2.0 / 3.0;
    double cr = 0.0;
    double cg = 0.0;
    double cb = 0.0;
    
    if (i >= k2) {
      cr = i - k2;
      cg = (k - 1) - cr;
    }
    else if (i >= k) {
      cg = i - k;
      cb = (k - 1) - cg;
    }
    else {
      cb = i;
    }
    
    int r, g, b;
    if (i.isNaN) {
      r = 0;
      g = 0;
      b = 0;
    } else {
      r = (cr * 3 * 255).toInt();
      g = (cg * 3 * 255).toInt();
      b = (cb * 3 * 255).toInt();
    }
    return [r, g, b];
  }
  
  void drawPixel(int x, int y, double i) {
    List<int> c = getColor(i);
    int off = 4 * (y * w + x);
    pix[off] = c[0];
    pix[off + 1] = c[1];
    pix[off + 2] = c[2];
    pix[off + 3] = 255;
  }
  
  void drawLine() {
    for (int x = 0; x < w; x++) {
      double c = formula(new Complex(x / w / size.x + offset.x, y / h / size.y + offset.y));
      drawPixel(x, y, c);
    }
    
    g.putImageData(img, 0, 0);
    
    if (++y < h) {
      timer = new Timer(dur, drawLine);
    } else {
      //document.getElementById("im").src = cv.toDataURL();
    }
  }
  
  if (y < h) {
    timer = new Timer(dur, drawLine);
  }
}
