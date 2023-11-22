BarChart chart;
PieChart pieChart;
final int spacing = 16;
PFont fontBold;
PFont fontRegular;
static float e = 0.00000000000001f;
Table table;
int[] angles = { 30, 10, 45, 35, 60, 38, 75, 67 };
String[] legendText = {"Label 1", "Label 2", "Label 3", "Label 4", "Label 5", "Label 6", "Label 7", "Label 8", "Label 9"};

void setup() {
  size(1400, 600);
  fontBold = createFont("Arial Bold", 18);
  fontRegular = createFont("Arial", 18);
  table = loadTable("CPSC583.csv", "header");
  ArrayList<Point> points = new ArrayList<Point>();
  points.add(new Point("a", 1.75));
  points.add(new Point("b", 0.25));
  points.add(new Point("c", 1));
  ChartData data = new ChartData(points);
  chart = new BarChart(100, 100, 400, data, new BarChartOptions( "x-axis",  "y-axis",  color(0),  color(255),  "Zeeshan is cool",  "joking lol"));

  background(0);
  chart.draw();
  
  pieChart = new PieChart(700, 80, 500, 300, angles);
  pieChart.draw("My PieChart");
  pieChart.drawLegend(legendText);
}

void draw() {}



public class MainVis {
  public Data data;

}


public class Data {
  public int sleep;
  public int energyLevel;
  public int foodIntake;
  public float exerciseTime;
  public float entertainmentTime;
  public float academicTime;
  public int caloriesBurnt;
  public int stressLevel;
}


public class PieChart {
  
  // Properties of the PieChart
  public int[] angles;     // Array to store the angles of each pie slice
  public float diameter;   // Diameter of the pie chart
  public int _width;       // Width of the white square background
  public int x;            // X-coordinate of the top-left corner of the white square
  public int y;            // Y-coordinate of the top-left corner of the white square
  
  // Constructor to initialize the PieChart
  public PieChart(int x, int y, int _width, float diameter, int[] data) {
    this.angles = data;
    this.diameter = diameter;
    this._width = _width;
    this.x = x;
    this.y = y;
  }
  
  // Method to draw the legend
  void drawLegend(String[] legendText) {
    float legendX = this.x + this._width + 20;
    float legendY = this.y + 20;
  
    for (int i = 0; i < this.angles.length && i < legendText.length; i++) {
      // Use HSB color space with varying hues for contrast
      float hue = map(i, 0, this.angles.length, 0, 360);
      float saturation = 90; // Adjusted saturation for more contrast
      float brightness = 90; // Adjusted brightness for more contrast
  
      // Use the color() function to create a color value
      int colorInt = color(hue, saturation, brightness);
      fill(colorInt);
      rect(legendX, legendY + i * 30, 20, 20);
  
      fill(255); // Set text color to white
      textAlign(LEFT, CENTER);
      
      // Use the legendText array for dynamic legend labels
      text(legendText[i], legendX + 30, legendY + i * 30 + 10);
    }
  }
  
  // Method to draw the PieChart
  void draw(String chartTitle) {
    // Draw a white square behind the pie chart
    fill(255);
    square(this.x, this.y, this._width);
  
    // Draw the title
    fill(255); // Set text color to black
    textAlign(CENTER, CENTER);
    textSize(20);
    text(chartTitle, this.x + this._width / 2, this.y - 20);
  
    float lastAngle = 0;
    for (int i = 0; i < this.angles.length; i++) {
      // Use HSB color space with varying hues for contrast
      float hue = map(i, 0, this.angles.length, 0, 360);
      float saturation = 90; // Adjusted saturation for more contrast
      float brightness = 90; // Adjusted brightness for more contrast
  
      // Use the color() function to create a color value
      int colorInt = color(hue, saturation, brightness);
      fill(colorInt);
  
      // Draw the arc
      arc(this.x/2.7 + width/2, height/2, this.diameter, this.diameter, lastAngle, lastAngle + radians(this.angles[i]));
  
      // Calculate the position for the label
      float labelAngle = lastAngle + radians(this.angles[i] / 2);
      float labelX = cos(labelAngle) * (this.diameter / 2 + 50) + this.x/2.7 + width/2;
      float labelY = sin(labelAngle) * (this.diameter / 2 + 50) + height/2;
  
      // Draw the text label
      fill(0); // Set text color to black
      textAlign(CENTER, CENTER);
      text(nf(this.angles[i], 0, 2), labelX, labelY); // Display value with 2 decimal places
  
      lastAngle += radians(this.angles[i]);
    }
  }

}



public class BarChart {
  public int _width;
  public int x;
  public int y;
  public ChartData data;
  public BarChartOptions options;
  public Axis<String> xAxis;
  public Axis<Float> yAxis;
  
  public BarChart(int x, int y, int _width, ChartData data, BarChartOptions options) {
    this.data = data;
    this._width = _width;
    this.x = x;
    this.y = y;
    this.options = options;
    this.xAxis = new Axis<String>(options.xAxisLabel, new String[]{"a", "b", "c"}, options.axisColor, x + floor(this._width * 0.2), y + floor(this._width * 0.8), floor(this._width * 0.8) - spacing * 2, floor(this._width * 0.2), true,this.options.backgroundColor);
    this.yAxis = new Axis<Float>(options.yAxisLabel, new Float[]{0.0, 1.0, 2.0}, options.axisColor, x, y + floor(this._width * 0.2), floor(this._width * 0.2), floor(this._width * 0.6), false, this.options.backgroundColor);
  }
  
  void draw() {
    fill(this.options.backgroundColor);
    noStroke();
    square(this.x, this.y, this._width);
    this.xAxis.draw();
    this.yAxis.draw();
    this.plot();
    this.drawInfoText();
  }
  
  private void drawInfoText() {
    noStroke();
    textAlign(LEFT);
    textFont(fontBold);
    fill(this.options.axisColor);
    textSize(spacing * 1.2);
    text(this.options.title, this.x + spacing*1.5, this.y + spacing*2);
    textFont(fontRegular);
    textSize(spacing * 0.8);
    text(this.options.description, this.x + spacing*1.5, this.y + spacing*3);
  }
  
  private void plot() {
    HashMap<String, Integer> xCoords = this.xAxis.getCoords();
    HashMap<String, Integer> yCoords = this.yAxis.getCoords();
    int yAxisSpacing = this.yAxis._height / (this.yAxis.values.length - 1);
    int barWidth = max(((this.xAxis._width - spacing * 3) / (this.xAxis.values.length - 1)) / 3, 20);
    for(int i = 0; i < this.data.points.size(); i++) {
      Point _point = this.data.points.get(i);
      int _x = xCoords.get(_point.group);
      int _yy = yCoords.get(this.yAxis.values[this.yAxis.indexOfValue(float(floor(_point.value)))].toString());
      float _y = _yy - yAxisSpacing * (_point.value - floor(_point.value));
      rect(_x - (barWidth - spacing) / 2, _y, barWidth - spacing, this.xAxis.y - _y);
    }
  }
}

 public class BarChartOptions {
  public String xAxisLabel;
  public String yAxisLabel;
  public color axisColor;
  public color backgroundColor;
  public String title;
  public String description;

  public BarChartOptions(String xAxisLabel, String yAxisLabel, color axisColor, color backgroundColor, String title, String description) {
    this.xAxisLabel = xAxisLabel;
    this.yAxisLabel = yAxisLabel;
    this.axisColor = axisColor;
    this.backgroundColor = backgroundColor;
    this.title = title;  //<>//
    this.description = description;
  }
}
  
public class Axis<T> {
  public String label;
  public String alignment = "center";
  public T[] values;
  public color _color;
  public int _width;
  public int _height;
  public int x;
  public int y;
  public Boolean isHorizontal;
  public color backgroundColor;
  
  public Axis(String label, T[] values, color _color, int x, int y, int _width, int _height, Boolean isHorizontal, color backgroundColor) {
    this.label = label;
    this.values = values;
    this._color = _color; //<>//
    this._width = _width;
    this._height = _height;
    this.x = x;
    this.y = y;
    this.isHorizontal = isHorizontal;
    this.backgroundColor = backgroundColor;
  }
  
  public HashMap<String, Integer> getCoords() {
    HashMap<String, Integer> coords = new HashMap<String, Integer>();
    for(int i = 0; i < this.values.length; i++) {
     if(isHorizontal) {
        int _x = this.x + (i * (this._width-spacing * 3) / (this.values.length - 1)) + spacing;
        coords.put(this.values[i].toString(), floor(_x));
      } else {  
        int _y = this.y + (i * (this._height) / (this.values.length - 1));
        coords.put(this.values[this.values.length - 1 - i].toString(), floor(_y));  
      }
    }
    return coords;
  }
  
  public int indexOfValue(T value) {
    for(int i = 0; i < this.values.length; i++) {
     if (abs((float) value - (float) this.values[i]) < e) {
       return i;
     }
    }
    return -1;
  }
 
  
  public void draw() {
    fill(this.backgroundColor);
    noStroke();
    rect(this.x, this.y, this._width, this._height);
    textFont(fontBold);
    fill(_color);
    stroke(_color);
    strokeWeight(1);    
    textSize(spacing);
    if(isHorizontal) {
      textAlign(CENTER);
      text(this.label, (this.x * 2+this._width)/2, this.y + this._height - spacing*2);
      line(this.x, this.y, this.x + this._width, this.y);
      for(int i = 0; i < this.values.length; i++) {
        int _x = this.x + (i * (this._width - spacing*3) / (this.values.length - 1)) + spacing;
        line(_x, this.y + 5, _x, this.y);
        textAlign(CENTER, TOP);
        text(this.values[i].toString(), _x, this.y + spacing / 2);
      }
    } else {
      pushMatrix();
      translate(this.x + spacing*2, (this.y * 2 + this._height) / 2);
      rotate(radians(-90));
      textAlign(CENTER);
      text(this.label, 0, 0);
      popMatrix();
      line(this.x + this._width, this.y, this.x + this._width, this.y + this._height);
      for(int i = 0; i < this.values.length; i++) {
        int _y = this.y + (i * (this._height ) / (this.values.length-1));
        line(this.x + this._width - 5, _y, this.x + this._width, _y);
        textAlign(RIGHT, CENTER);
        text(this.values[this.values.length - 1 - i].toString(), this.x + this._width - spacing / 2, _y);
      }
    }
  }    
}
  
public class ChartData {
  public ArrayList<Point> points;
  
  public ChartData(ArrayList<Point> p) {
    this.points = p;
  }
}

public class Point {
  public String group;
  public float value;
  
  public Point(String g, float v) {
    this.group = g;
    this.value = v;
  }
}
