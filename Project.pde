import java.util.*;

BarChart chart;
MainVis mainVis1;
MainVis mainVis2;
MainVis mainVis3;
MainVis mainVis4;
MainVis mainVis5;
Dropdown dropdown;
Button button;

final int spacing = 16;
PFont fontBold;
PFont fontRegular;
static float e = 0.00000000000001f;
Table table;
String selectedDate;
String lastDate = "";
HashMap < String, Data > intervalData;
String selectedCategory = "";
String selectedInterval = "";

void setup() {
  size(1400, 1400);
  fontBold = createFont("Arial Bold", 18);
  fontRegular = createFont("Arial", 18);
  table = loadTable("CPSC583.csv", "header");
  intervalData = new HashMap < String, Data > ();
  Set < String > dates = new HashSet < String > ();

  for (TableRow row: table.rows()) {
    PersonData rowData = new PersonData();
    String interval = row.getString("Interval");
    String date = row.getString("Date ");
    if (!dates.contains(date)) {
      dates.add(date);
    }
    rowData.name = row.getString("Name");
    rowData.sleep = row.getFloat("Sleep");
    rowData.energyLevel = row.getInt("Energy Level");
    rowData.foodIntake = row.getFloat("Food Intake");
    rowData.exerciseTime = row.getFloat("Excerise Time");
    rowData.entertainmentTime = row.getFloat("Screen time (Entertainment)");
    rowData.academicTime = row.getFloat("Screen time (Academic)");
    rowData.caloriesBurnt = row.getInt("Calories Burnt");
    rowData.stressLevel = row.getInt("Stress Level");
    rowData.leisureTime = row.getFloat("Leisure Time");
    rowData.numOfSocialInteractions = row.getInt("# of Social Interactions in Person");
    rowData.numOfSleepInteruptions = row.getInt("# of Sleep Interruptions");
    rowData.numOfChores = row.getInt("Number of Chores");

    if (intervalData.containsKey(interval)) {
      Data d = intervalData.get(interval);
      if (d.dates.containsKey(date)) {
        ArrayList < PersonData > p = d.dates.get(date);
        p.add(rowData);
      } else {
        ArrayList < PersonData > p = new ArrayList < PersonData > ();
        p.add(rowData);
        d.dates.put(date, p);
      }
    } else {
      Data d = new Data();
      ArrayList < PersonData > p = new ArrayList < PersonData > ();
      p.add(rowData);
      d.dates.put(date, p);
      intervalData.put(interval, d);
    }
  }
  dropdown = new Dropdown(850, 50, dates);
  button = new Button(850, 50);
}

void draw() {
  background(0);
  //chart.draw();
  
  if(!lastDate.equals(selectedDate)) {
    lastDate = selectedDate;
    ArrayList < PersonData > p = intervalData.get("Overnight").dates.get(selectedDate);
    mainVis1 = new MainVis(50, 50, 300, p, new MainVisOptions(color(150), color(0), "Overnight", selectedDate));
    ArrayList < PersonData > p1 = intervalData.get("Morning").dates.get(selectedDate);
    mainVis2 = new MainVis(450, 50, 300, p1, new MainVisOptions(color(150), color(0), "Morning", selectedDate));
    ArrayList < PersonData > p2 = intervalData.get("Afternoon").dates.get(selectedDate);
    mainVis3 = new MainVis(50, 400, 300, p2, new MainVisOptions(color(150), color(0), "Afternoon", selectedDate));
    ArrayList < PersonData > p3 = intervalData.get("Evening").dates.get(selectedDate);
    mainVis4 = new MainVis(450, 400, 300, p3, new MainVisOptions(color(150), color(0), "Evening", selectedDate));
    ArrayList < PersonData > p4 = intervalData.get("Late Night").dates.get(selectedDate);
    mainVis5 = new MainVis(50, 750, 300, p4, new MainVisOptions(color(150), color(0), "Late Night", selectedDate));
  }
  
  if(selectedCategory.equals("") && selectedInterval.equals("")) {
    mainVis1.draw();
    mainVis2.draw();
    mainVis3.draw();
    mainVis4.draw();
    mainVis5.draw();
    dropdown.draw();
  } else {
    ArrayList < Point > points = new ArrayList < Point > ();
    for (TableRow row: table.rows()) {
      String interval = row.getString("Interval");
      String date = row.getString("Date ");
      if (selectedInterval.equals(interval) && selectedDate.equals(date)) {
        points.add(new Point(row.getString("Name"), row.getFloat(selectedCategory)));
      }
    }
    ChartData d = new ChartData(points);
    chart = new BarChart(50, 50, 800, d, new BarChartOptions("Name", selectedCategory, color(0), color(150), selectedDate + " - " + selectedInterval, "Category: " + selectedCategory));
    chart.draw();
    button.draw();
  }
}
 //<>//
void mouseClicked() { //<>//
  dropdown.mouseClicked();
  mainVis1.mouseClicked();
  mainVis2.mouseClicked();
  mainVis3.mouseClicked();
  mainVis4.mouseClicked();
  mainVis5.mouseClicked();
  button.mouseClicked();
  
}

public class Button {
  public int _width;
  public int _height;
  public int x;
  public int y;

  public Button(int x, int y) {
    this._width = spacing * 8;
    this.x = x;
    this.y = y;
    this._height = spacing * 3;
  }

  public void draw() {
    Boolean hover = false;
    if (mouseX >= this.x && mouseX <= this.x + this._width && mouseY >= this.y && mouseY <= this.y + this._height) {
      hover = true;
    }
    fill(hover ? color(0,0,255):255);
    noStroke();
    rect(this.x, this.y, this._width, this._height);
    fill(hover ? 255 : 0);
    textAlign(LEFT, CENTER);
    textFont(fontBold);
    text("Back", this.x + spacing, (this.y * 2 + this._height) / 2);
  }

  public void mouseClicked() {
    if (mouseX >= this.x && mouseX <= this.x + this._width && mouseY >= this.y && mouseY <= this.y + this._height) {
      selectedCategory = "";
      selectedInterval = "";
    }
  }
}

public class Dropdown {
  public String[] values;
  public int _width;
  public int _height;
  public int x;
  public int y;
  public boolean expanded;

  public Dropdown(int x, int y, Set < String > values) {
    this.values = sort(values.toArray(new String[values.size()]));
    this._width = spacing * 12;
    this.x = x;
    this.y = y;
    selectedDate = this.values[0];
    this.expanded = false;
    this._height = spacing * 3;
  }

  public void draw() {
    fill(255);
    noStroke();
    rect(this.x, this.y, this._width, this._height);
    fill(0);
    textAlign(LEFT, CENTER);
    textFont(fontBold);
    text(this.expanded ? "Dates" : "Date: " + selectedDate, this.x + spacing, (this.y * 2 + this._height) / 2);
    if(this.expanded) {
      for(int i = 0; i < this.values.length; i++) {
        Boolean hover = false;
        float _x = this.x;
        float _y = this.y + this._height * i + this._height;
        if (mouseX >= _x && mouseX <= _x + this._width) {
          if (mouseY >= _y && mouseY <= _y + this._height) {
            hover = true;
          }
        }
        fill(this.values[i] == selectedDate || hover ? color(0,0,255) : 255);
        noStroke();
        rect(_x, _y, this._width, this._height);
        fill(this.values[i] == selectedDate || hover ? 255 : 0);
        textAlign(LEFT, CENTER);
        textFont(fontBold);
        text(this.values[i], _x + spacing, (_y * 2 + this._height) / 2);
      }
    }
  }

  public void mouseClicked() {
    if (mouseX >= this.x && mouseX <= this.x + this._width && mouseY >= this.y && mouseY <= this.y + this._height) {
      this.expanded = !this.expanded;
    } else {
      this.expanded = false;
    }
    for(int i = 0; i < this.values.length; i++) {
        float _x = this.x;
        float _y = this.y + this._height * i + this._height;
        if (mouseX >= _x && mouseX <= _x + this._width) {
          if (mouseY >= _y && mouseY <= _y + this._height) {
            selectedDate = this.values[i];
          }
        }
      }
  }
}

public class MainVis {
  public ArrayList < PersonData > data;
  public int _width;
  public int x;
  public int y;
  public MainVisOptions options;
  public String[] categories;
  public HashMap < String, PVector > points;
  public HashMap < String, Float > maxPerCategory;

  public MainVis(int x, int y, int _width, ArrayList < PersonData > data, MainVisOptions options) {
    this.data = data;
    this._width = _width;
    this.x = x;
    this.y = y;
    this.options = options;
    this.categories = new String[] {
      "Sleep",
      "Energy Level",
      "Food Intake",
      "Excerise Time",
      "Screen time (Entertainment)",
      "Screen time (Academic)",
      "Calories Burnt",
      "Stress Level",
      "# of Social Interactions in Person",
      "Leisure Time",
      "# of Sleep Interruptions",
      "Number of Chores"
    };
    this.points = new HashMap < String, PVector > ();
    this.maxPerCategory = new HashMap < String, Float > ();
  }

  public color[] colors = new color[] {
    color(0, 120, 255, 60), color(189, 0, 255, 60), color(255, 154, 0, 60), color(1, 255, 31, 60), color(255, 255, 255, 60), color(255, 0, 255, 60)
  };

  public void draw() {
    fill(this.options.backgroundColor);
    noStroke();
    square(this.x, this.y, this._width);

    this.drawInfoText();
    this.drawCategories();
    this.drawPoints();
  }

  public void drawPoints() {
    PVector mid = new PVector((this.x * 2 + this._width) / 2 + spacing * 3, (this.y * 2 + this._width + spacing * 2) / 2);
    int count = 0;
    for (PersonData p: this.data) {
      stroke(this.colors[count]);
      fill(this.colors[count++]);
      strokeWeight(2);
      beginShape();
      PVector _s;
      _s = this.getCoords(p.sleep / this.maxPerCategory.get("Sleep"), this.points.get("Sleep"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.energyLevel / this.maxPerCategory.get("Energy Level"), this.points.get("Energy Level"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.foodIntake / this.maxPerCategory.get("Food Intake"), this.points.get("Food Intake"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.exerciseTime / this.maxPerCategory.get("Excerise Time"), this.points.get("Excerise Time"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.entertainmentTime / this.maxPerCategory.get("Screen time (Entertainment)"), this.points.get("Screen time (Entertainment)"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.academicTime / this.maxPerCategory.get("Screen time (Academic)"), this.points.get("Screen time (Academic)"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.caloriesBurnt / this.maxPerCategory.get("Calories Burnt"), this.points.get("Calories Burnt"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.stressLevel / this.maxPerCategory.get("Stress Level"), this.points.get("Stress Level"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.leisureTime / this.maxPerCategory.get("Leisure Time"), this.points.get("Leisure Time"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.numOfSocialInteractions / this.maxPerCategory.get("# of Social Interactions in Person"), this.points.get("# of Social Interactions in Person"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.numOfSleepInteruptions / this.maxPerCategory.get("# of Sleep Interruptions"), this.points.get("# of Sleep Interruptions"), mid);
      vertex(_s.x, _s.y);
      _s = this.getCoords(p.numOfChores / this.maxPerCategory.get("Number of Chores"), this.points.get("Number of Chores"), mid);
      vertex(_s.x, _s.y);
      endShape(CLOSE);
    }
  }

  public void mouseClicked() {
    for(String k : this.points.keySet()) {
     PVector p = this.points.get(k);
     if (mouseX >= p.x && mouseX <= p.x + 10) {
          if (mouseY >= p.y && mouseY <= p.y + 10) {
            selectedCategory = k;
            selectedInterval = this.options.title;
         }
       }
     }
  }
  
  private PVector getCoords(float ratio, PVector p1, PVector mid) {
    if (p1.x - mid.x < 0) {
      float m = (mid.y - p1.y) / (mid.x - p1.x);
      float alpha = atan(m);
      float xVector = dist(mid.x, mid.y, p1.x, p1.y) * ratio * cos(alpha);
      float _x = mid.x - xVector;
      return new PVector(_x, this.f(_x, m, p1));
    } else {
      float m = (p1.y - mid.y) / (p1.x - mid.x);
      float alpha = atan(m);
      float xVector = dist(p1.x, p1.y, mid.x, mid.y) * ratio * cos(alpha);
      float _x = mid.x + xVector;
      return new PVector(_x, this.f(_x, m, p1));
    }
  }

  private float f(float x, float m, PVector p) {
    return m * (x - p.x) + p.y;
  }

  private void drawInfoText() {
    noStroke();
    textAlign(LEFT);
    textFont(fontBold);
    fill(this.options.axisColor);
    textSize(spacing * 1.2);
    text(this.options.title, this.x + spacing * 1.5, this.y + spacing * 2);
    textFont(fontRegular);
    textSize(spacing * 0.8);
    text(this.options.description, this.x + spacing * 1.5, this.y + spacing * 3);
  }

  public void drawCategories() {
    for (PersonData p: this.data) {
      this.maxPerCategory.put("Sleep", this.maxPerCategory.containsKey("Sleep") ? max(p.sleep, this.maxPerCategory.get("Sleep")) : p.sleep);
      this.maxPerCategory.put("Energy Level", this.maxPerCategory.containsKey("Energy Level") ? max(p.energyLevel, this.maxPerCategory.get("Energy Level")) : p.energyLevel);
      this.maxPerCategory.put("Food Intake", this.maxPerCategory.containsKey("Food Intake") ? max(p.foodIntake, this.maxPerCategory.get("Food Intake")) : p.foodIntake);
      this.maxPerCategory.put("Excerise Time", this.maxPerCategory.containsKey("Excerise Time") ? max(p.exerciseTime, this.maxPerCategory.get("Excerise Time")) : p.exerciseTime);
      this.maxPerCategory.put("Screen time (Entertainment)", this.maxPerCategory.containsKey("Screen time (Entertainment)") ? max(p.entertainmentTime, this.maxPerCategory.get("Screen time (Entertainment)")) : p.entertainmentTime);
      this.maxPerCategory.put("Screen time (Academic)", this.maxPerCategory.containsKey("Screen time (Academic)") ? max(p.academicTime, this.maxPerCategory.get("Screen time (Academic)")) : p.academicTime);
      this.maxPerCategory.put("Calories Burnt", this.maxPerCategory.containsKey("Calories Burnt") ? max(p.caloriesBurnt, this.maxPerCategory.get("Calories Burnt")) : p.caloriesBurnt);
      this.maxPerCategory.put("Stress Level", this.maxPerCategory.containsKey("Stress Level") ? max(p.stressLevel, this.maxPerCategory.get("Stress Level")) : p.stressLevel);
      this.maxPerCategory.put("# of Social Interactions in Person", this.maxPerCategory.containsKey("# of Social Interactions in Person") ? max(p.numOfSocialInteractions, this.maxPerCategory.get("# of Social Interactions in Person")) : p.numOfSocialInteractions);
      this.maxPerCategory.put("Leisure Time", this.maxPerCategory.containsKey("Leisure Time") ? max(p.leisureTime, this.maxPerCategory.get("Leisure Time")) : p.leisureTime);
      this.maxPerCategory.put("# of Sleep Interruptions", this.maxPerCategory.containsKey("# of Sleep Interruptions") ? max(p.numOfSleepInteruptions, this.maxPerCategory.get("# of Sleep Interruptions")) : p.numOfSleepInteruptions);
      this.maxPerCategory.put("Number of Chores", this.maxPerCategory.containsKey("Number of Chores") ? max(p.numOfChores, this.maxPerCategory.get("Number of Chores")) : p.numOfChores);
    }
    fill(this.options.backgroundColor);
    stroke(this.options.axisColor);
    strokeWeight(2);
    float _x = (this.x * 2 + this._width) / 2 + spacing * 3;
    float _y = (this.y * 2 + this._width + spacing * 2) / 2;
    int count = 0;
    float radius = (this._width - spacing * 6) / 2;
    float angle = TWO_PI / this.categories.length + 0.0005;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = _x + cos(a) * radius;
      float sy = _y + sin(a) * radius;
      vertex(sx, sy);
      this.points.put(this.categories[count++], new PVector(sx, sy));
    }
    endShape(CLOSE);

    for (String cat: this.categories) {
      PVector p = this.points.get(cat);
      Boolean hover = false;
       if (mouseX >= p.x && mouseX <= p.x + 10) {
           if (mouseY >= p.y && mouseY <= p.y + 10) {
             hover = true;
          }
        }
      
      strokeWeight(10);
      if (hover) {
        stroke(0,0,255);
      } else {
        stroke(this.options.axisColor);
      }
      point(p.x, p.y);
      textSize(spacing * .6);
      fill(this.options.axisColor);
      textAlign(p.x - 200 > this.x ? LEFT : RIGHT, p.y - 200 > this.y ? TOP : BOTTOM);
      text(cat + "\n" + this.maxPerCategory.get(cat), p.x, p.y + ((p.y - 200) > this.y ? spacing / 2 : -spacing / 2));
    }
  }
}

public class MainVisOptions {
  public color axisColor;
  public color backgroundColor;
  public String title;
  public String description;

  public MainVisOptions(color axisColor, color backgroundColor, String title, String description) {
    this.axisColor = axisColor;
    this.backgroundColor = backgroundColor;
    this.title = title;
    this.description = description;
  }

}

public class Data {
  public HashMap < String, ArrayList < PersonData >> dates;

  public Data() {
    dates = new HashMap < String, ArrayList < PersonData >> ();
  }
}

public class PersonData {
  public String name;
  public float sleep;
  public int energyLevel;
  public float foodIntake;
  public float exerciseTime;
  public float entertainmentTime;
  public float academicTime;
  public int caloriesBurnt;
  public int stressLevel;
  public float leisureTime;
  public int numOfSocialInteractions;
  public int numOfSleepInteruptions;
  public int numOfChores;

  public PersonData() {}
}

public class BarChart {
  public int _width;
  public int x;
  public int y;
  public ChartData data;
  public BarChartOptions options;
  public Axis < String > xAxis;
  public Axis < Float > yAxis;

  public BarChart(int x, int y, int _width, ChartData data, BarChartOptions options) {
    this.data = data;
    this._width = _width;
    this.x = x;
    this.y = y;
    this.options = options;
    float maxVal = 0;
    Set<String> groups = new HashSet<String>();
    Set<Float> values = new HashSet<Float>();
    for(Point p : this.data.points) {
      if(!groups.contains(p.group)) {
        groups.add(p.group);
      }
      maxVal = max(maxVal, p.value);
    }
    
    for(float i = 0; i <= maxVal; i += 1.0) {
      values.add(i);
    }
    
    if(maxVal < 1.0) {
      values.add(1.0);
    }
    
    
    this.xAxis = new Axis < String > (options.xAxisLabel, groups.toArray(new String[groups.size()]), options.axisColor, x + floor(this._width * 0.2), y + floor(this._width * 0.8), floor(this._width * 0.8) - spacing * 2, floor(this._width * 0.2), true, this.options.backgroundColor);
    this.yAxis = new Axis < Float > (options.yAxisLabel, values.toArray(new Float[values.size()]), options.axisColor, x, y + floor(this._width * 0.2), floor(this._width * 0.2), floor(this._width * 0.6), false, this.options.backgroundColor);
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
    text(this.options.title, this.x + spacing * 1.5, this.y + spacing * 2);
    textFont(fontRegular);
    textSize(spacing * 0.8);
    text(this.options.description, this.x + spacing * 1.5, this.y + spacing * 3);
  }

  private void plot() {
    HashMap < String, Integer > xCoords = this.xAxis.getCoords();
    HashMap < String, Integer > yCoords = this.yAxis.getCoords();
    int yAxisSpacing = this.yAxis._height / (this.yAxis.values.length - 1);
    int barWidth = max(((this.xAxis._width - spacing * 3) / (this.xAxis.values.length - 1)) / 3, 20);
    for (int i = 0; i < this.data.points.size(); i++) {
      Point _point = this.data.points.get(i);
      int _x = xCoords.get(_point.group);
      int _yy = yCoords.get(this.yAxis.values[this.yAxis.indexOfValue(float(floor(_point.value)))].toString());
      float _y = _yy - yAxisSpacing * (_point.value - floor(_point.value));
      rect(_x - (barWidth - spacing) / 2, _y, barWidth - spacing, this.xAxis.y - _y);
      textAlign(CENTER, CENTER);
      text(_point.value, _x - (barWidth - spacing) / 2, _y - spacing );
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
    this.title = title;
    this.description = description;
  }
}

public class Axis < T > {
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
    this.values =values;
    Arrays.sort(this.values);
    this._color = _color;
    this._width = _width;
    this._height = _height;
    this.x = x;
    this.y = y;
    this.isHorizontal = isHorizontal;
    this.backgroundColor = backgroundColor;
  }

  public HashMap < String,
  Integer > getCoords() {
    HashMap < String, Integer > coords = new HashMap < String, Integer > ();
    for (int i = 0; i < this.values.length; i++) {
      if (isHorizontal) {
        int _x = this.x + (i * (this._width - spacing * 3) / (this.values.length - 1)) + spacing;
        coords.put(this.values[i].toString(), floor(_x));
      } else {
        int _y = this.y + (i * (this._height) / (this.values.length - 1));
        coords.put(this.values[this.values.length - 1 - i].toString(), floor(_y));
      }
    }
    return coords;
  }

  public int indexOfValue(T value) {
    for (int i = 0; i < this.values.length; i++) {
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
    if (isHorizontal) {
      textAlign(CENTER);
      text(this.label, (this.x * 2 + this._width) / 2, this.y + this._height - spacing * 2);
      line(this.x, this.y, this.x + this._width, this.y);
      for (int i = 0; i < this.values.length; i++) {
        int _x = this.x + (i * (this._width - spacing * 3) / (this.values.length > 0 ? this.values.length - 1 : 1)) + spacing;
        line(_x, this.y + 5, _x, this.y);
        textAlign(CENTER, TOP);
        text(this.values[i].toString(), _x, this.y + spacing / 2);
      }
    } else {
      pushMatrix();
      translate(this.x + spacing * 2, (this.y * 2 + this._height) / 2);
      rotate(radians(-90));
      textAlign(CENTER);
      text(this.label, 0, 0);
      popMatrix();
      line(this.x + this._width, this.y, this.x + this._width, this.y + this._height);
      for (int i = 0; i < this.values.length; i++) {
        int _y = this.y + (i * (this._height) / (this.values.length > 0 ? this.values.length - 1 : 1));
        line(this.x + this._width - 5, _y, this.x + this._width, _y);
        textAlign(RIGHT, CENTER);
        text(this.values[this.values.length - 1 - i].toString(), this.x + this._width - spacing / 2, _y);
      }
    }
  }
}

public class ChartData {
  public ArrayList < Point > points;

  public ChartData(ArrayList < Point > p) {
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
