//Takes an xml file from OSM
import java.util.Map;

XML map;

Point[] p;
int[] pCount;

//put the name of your xml file in here. Or just name it map
String mapName = "map";

ArrayList roads;

void setup(){
  map = loadXML(mapName + ".xml");
  //extracts all the nodes
  XML[] nodes = map.getChildren("node");
  //extracts all the ways
  XML[] ways = map.getChildren("way");
  //Goes through all the ways , figures out which ones are named roads, and puts them in an array list
  roads = new ArrayList();
  int correctTags;
  for(int i = 0; i < ways.length; i++){
    correctTags = 0;
    XML[] tags = ways[i].getChildren("tag");
    for(int j = 0; j < tags.length; j++){
      if(tags[j].getString("k").equals("highway")){
        correctTags++;
      }
      else if(tags[j].getString("k").equals("name")){
        correctTags++;
      }
    }
    if(correctTags >= 2){
      roads.add(ways[i]);
    }
  }
  //wayNames(roads);
  
  //Figures out which nodes appear more than once in a waypoint
  //This probably isn't the cleanest way to do this
  
  //Creates a point for every waypoint
  p = new Point[nodes.length]; //an array of all the points
  pCount = new int[nodes.length]; //how many times each point appears in a route
  for(int i = 0; i < nodes.length; i++){
    String id = nodes[i].getString("id");
    float lat = nodes[i].getFloat("lat");
    float lon = nodes[i].getFloat("lon");
    p[i] = new Point(lat, lon, id);
    pCount[i] = 0;
  }
  
  //Goes through every route and checks if a given point is in that route
  //And counts how many times each route appears
  for(int i = 0; i < roads.size(); i++){
    XML way = (XML)roads.get(i);
    String wayName = getName(way);
    XML[] nd = way.getChildren("nd");
    for(int j = 0; j < nd.length; j++){
      String id = nd[j].getString("ref");
      for(int k = 0; k < p.length; k++){
        if(p[k].getId().equals(id)){
          //increments the count, so we know how many times it appears
          pCount[k] += 1;
          //adds the name of this waypoint too the point
          p[k].addName(wayName);
          k = p.length;
        } 
      }
    }
  }
  
  //Prints out the intersections
  println("Name,lat,long");
  String landmarks = "double[][] landmarks = {\n";
  String landmarkNames = "String[] landmarkNames = {\n";
  for(int i = 0; i < p.length; i++){
    if(pCount[i] > 1){
      landmarks += "{" + p[i].lat + ", " + p[i].lon + "}, // " + p[i].getName() + "\n";
      landmarkNames += "\"" + p[i].getName() + "\",\n";
      //use this to get the intersections in a format suitable for transfering too a spreadsheet
      //println(p[i].getName()+","+p[i].lat+","+p[i].lon);
    }
  }
  landmarks += "};";
  landmarkNames += "};";
  //use this to print out the coordinates in a format you can paste directly into the Object Get code
  println(landmarks);
  println();
  println(landmarkNames);
}

//takes a way and gets a name out of it, if a name there be
String getName(XML way){
  XML[] tags = way.getChildren("tag");
  for(int j = 0; j < tags.length; j++){
    if(tags[j].getString("k").equals("name")){
      return tags[j].getString("v");
    }
  }
  return "no name";
}

//takes an array of ways and prints out all their names
//A good way too see what ways you're dealing with
void wayNames(ArrayList roads){
  for(int i = 0; i < roads.size(); i++){
    XML way = (XML)roads.get(i);
    String name = getName(way);
    if(!name.equals("no name")){
      println("Way " + i + ": " + name);
    }
    else{
     println("Way " + i + ": " + name + " ID: " + way.getString("id"));
    }
  }
}

void draw(){
  //nothing is being drawn in this.
}
