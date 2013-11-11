//A class which contains an OSM waypoint and the routes it is a part of  
class Point{
  float lat;
  float lon;
  String id;
  String name;
  
  Point(float lat, float lon, String id){
    this.lat = lat;
    this.lon = lon;
    this.id = id;
    name = "";
  }
  
  String toString(){
    return id + ": " + lat + ", " + lon;
  }
  
  String getId(){
    return id;
  }
  
  void addName(String input){
    if(name == ""){
      name = input;
    }
    else{
      name += " and " + input;
    }
  }
  
  String getName(){
    return name;
  }
}
