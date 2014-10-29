import 'dart:math' as math;

class Complex {
  double x;
  double y;
  
  Complex (double x, double y) {
    this.x = x;
    this.y = y;
  }
  
  Complex add (Complex c2) {
    return new Complex(this.x + c2.x, this.y + c2.y);
  }
  
  Complex sub (Complex c2) {
    return new Complex(this.x - c2.x, this.y - c2.y);
  }
  
  Complex mul (Complex c2) {
    double a = this.x;
    double b = this.y;
    double c = c2.x;
    double d = c2.y;
    
    return new Complex(a*c - b*d, b*c + a*d);
  }
  
  Complex div (Complex c2) {
    double a = this.x;
    double b = this.y;
    double c = c2.x;
    double d = c2.y;
    
    double r = (a*c + b*d) / (c*c + d*d);
    double i = (b*c - a*d) / (c*c + d*d);
    
    return new Complex(r, i);
  }
  
  double abs () {
    return math.sqrt(this.x * this.x + this.y * this.y);
  }
  
  Complex pol () {
    double z = this.abs();
    double f = math.atan2(this.y, this.x);
    
    return new Complex(z, f);
  }
  
  Complex rec () {
    double z = this.x.abs();
    double f = this.y;
    double a = z * math.cos(f);
    double b = z * math.sin(f);
    
    return new Complex(a, b);
  }
  
  Complex pow (Complex exp) {
    Complex b = this.pol();
    double r = b.x;
    double f = b.y;
    double c = exp.x;
    double d = exp.y;
    double z = math.pow(r, c) * math.exp(-d * f);
    double fi = d * math.log(r) + c * f;
    Complex rpol = new Complex(z, fi);
    return rpol.rec();
  }
}