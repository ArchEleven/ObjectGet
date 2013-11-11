//Important sketch permissions: ACCESS_FINE_LOCATION, ACCESS_COURSE_LOCATION, SEND_SMS, VIBRATE, BLUETOOTH, INTERNET
//General import
import android.content.Context;
//GPS imports
import android.location.Location;
import android.location.LocationManager;
import android.location.LocationListener;
import android.location.GpsStatus.Listener;
import android.os.Bundle;
//Vibration imports
import android.app.Notification;
import android.app.NotificationManager;
//SMS imports
import android.telephony.gsm.SmsManager;

//Adjust these variables too match your local needs
String endLocation = "the South Street Seaport"; //where people should gather at the end of the game. UPDATE

// This array should contain the GPS coordinators of play area's corners.
float[][] playArea = new float[4][4];

float[][] largeArea = {
  {-74.007894, 40.707410},
  {-74.004880, 40.709892},
  {-74.001920, 40.706758},
  {-74.004758, 40.705056}
};

float[][] smallArea = largeArea;

//something to add too the tweets so you don't post the same tweet twice.
//It's is only relevant if you're playing more than one game in a day. If not, just leave it as 0.
//If you're play multiple games over the course of a multiple days, update this number at the start of each day
int unique = 0;

int gameLength = 1800; //how long does the game last in seconds. 30 minutes = 1800, 1 hour = 3600
int updateFreq = 180; //how often does the game post to twitter in seconds. five minutes = 300, 3 minutes = 180, 10 minutes = 60
int captureDelay = 30; //the period where you can't capture the Object after it's been captured, in seconds.

//These variables do not need to be altered to match local conditions
//Team colors
color blueTeam = color(20, 144, 255);
color redTeam = color(200, 0, 0);
color yellowTeam = color(255, 255, 51);
color greenTeam= color(10, 500, 10);
color noTeam = color(150, 150, 150);
color teamColors[] = {blueTeam, redTeam, yellowTeam, greenTeam, noTeam};

//Buttons
Button buttons[] = new Button[4];
Button startBig;
Button startSmall;

//Game values
int caseOwner = 4; //this the team that has currently has the Object. 0 = blue, 1 = red, 2 = yellow, 3 = green, 4 = no one
int winningTeam = 4;
int scores[] = {0, 0, 0, 0, 0};

//Game state/timing variables
long gameStart; //when did the game start?
long lastUpdate; //the last time we sent out a location update
long lastCheck; //the last time we updated the score
long lastCaptured; //the time when the Object was last captured
boolean playing = false; //are we playing the game?
Boolean recentlyCaptured = false; //has anyone taken the Object recently?

//SMS variables
SmsManager sm = SmsManager.getDefault();
String number = "40404"; //The number I'm sending too

//GPS variables
LocationManager locationManager;
MyLocationListener locationListener;
float latit, longi; //the set place where the longitude and latitude will be put
float[] results = new float[3];
Location location;

//Vibration variables
NotificationManager gNotificationManager;
Notification gNotification;
long[] gVibrate = {0,100}; //vibrates for 10 milliseconds. Isn't very long, because it should shut off pretty quickly

//Text variables
String[] fontList;
PFont f;
int texts = 0;
String updates = "NEW GAME BUTTONS\nDO NOT TOUCH.";

void setup() {
  orientation(LANDSCAPE);

  //creates the team buttons
  buttons[0] = new Button(20, 20, height/2 - 40, width/2 - 40, blueTeam, "1", false);
  buttons[0].off();
  buttons[1] = new Button(width/2 + 20, 20, height/2 - 40, width/2 - 40, redTeam, "2", true);
  buttons[1].off();
  buttons[2] = new Button(20, height/2 + 20, height/2 - 40, width/2 - 40, yellowTeam, "3", false);
  buttons[2].off();
  buttons[3] = new Button(width/2 + 20, height/2 + 20, height/2 - 40, width/2 - 40, greenTeam, "4", true);
  buttons[3].off();
  //creates the starting buttons
  startBig = new Button(50, 50, 50, 50, 255, 140, 0, "B", true);
  startSmall = new Button(50, 150, 50, 50, 255, 130, 171, "S", true); 
  //the front for text
  fontList = PFont.list();
  f = createFont(fontList[4], 40, true);
  textFont(f);
  //GPS pieces
  location = new Location("");
  for(int i = 0; i < 3; i++)
  {
    results[i] = 0;
  }
}

void onResume() {
  super.onResume();
  // Acquire a reference to the system Location Manager
  locationManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
  // Build Listener
  locationListener = new MyLocationListener();
  locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListener);
  
  gNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
  
  // Creates a new notifaction object.
  gNotification = new Notification();
  // Defines the vibrate variable in the notifaction as the pattern we defined above
  gNotification.vibrate = gVibrate;
}

void onPause(){
  super.onPause();
  locationManager.removeUpdates(locationListener);
}

void draw() {
  //What the phone does when the game is running
  if (playing) {
    background(teamColors[caseOwner]);
    
    for(int i = 0; i < buttons.length; i++){
      buttons[i].display();
    }
    
    //checks if you're in the play area
    if (millis() - lastCheck >= 100){
     if(!inPlayArea(latit, longi)){
       //if not, vibrate the phone
        gNotificationManager.notify(1, gNotification);
       }
       else{
         //if so, give the owner points
        scores[caseOwner]++;
       }
      lastCheck = millis();
    }

    //sends the current location to twitter
    if (millis() - lastUpdate >= (updateFreq * 1000)){      
      if (caseOwner < 4) {
        sendText("The " + teamName(caseOwner) + " Team has the Object. It is near " + closestLandmark(latit, longi) + ". " + formatTime((int)(gameLength*1000 + gameStart) - millis() + 10) + " remain.");
      }
      else {
        sendText("No one has the Object. It is near " + closestLandmark(latit, longi) + ". " + formatTime((int)((gameLength*1000 + gameStart - millis())) + 10) + " remain.");
      }
      lastUpdate = millis();
    }
    
    if(millis() - lastCaptured >= (captureDelay * 1000) && recentlyCaptured == true)
    {
      recentlyCaptured = false;
    }

    //ends the game once enough time has passed
    if(millis() - gameStart >= (gameLength * 1000)){
      playing = false;
      for(int i = 0; i < buttons.length; i++){
        buttons[i].off();
      }
      startBig.on();
      startSmall.on();
      decideWinner();
      updates = "NEW GAME BUTTONS\nDO NOT TOUCH.";
    }
  }
  //this is what the app does when the game is not running
  else {
    background(teamColors[winningTeam]);
    startBig.display();
    startSmall.display();
  }
  fill(0);
  text(updates, 110, 65, 750, 450);
}

//Announces the winner, team scores from highest to lowest
//This method is based on the assumpition that ties are so unlikely that they're not worth checking for
//If there is a tie, it will fail to report correctly.
void decideWinner()
{
  winningTeam = 0;
  int scoreOrder[] = {4, 4, 4, 4}; //you can't give an array a variable size, so if you want more or less teams than four, you'll have to change this variable.
  int lessThan;
  for(int i = 0; i < scoreOrder.length; i++)
  {
    lessThan = 0;
    for(int j = 0; j < scores.length-1; j++)
    {
      if(scores[i] < scores[j])
      {
        lessThan++;
      }
    }
    scoreOrder[lessThan] = i;
  }
  winningTeam = scoreOrder[0];
  
  String winnerText = teamName(winningTeam) + " team wins! Scores: ";
  for(int i = 0; i < scoreOrder.length; i++)
  {
    winnerText += teamName(scoreOrder[i]) + " Team: " + formatTime(scores[scoreOrder[i]]*100);
    if(i < scoreOrder.length - 1)
    {
      winnerText += ", ";
    }
  }
  winnerText += ".";
  sendText(winnerText);
  delay(1000);
  sendText("Thank you for playing. Please return to " + endLocation + ". Text \"STOP\" to stop receiving updates.");
}

//Returns the name of the team when given a number value
String teamName(int whichTeam)
{
  switch(whichTeam){
    case 0: return "Blue";
    case 1: return "Red";
    case 2: return "Yellow";
    case 3: return "Green";
    default: return "No";
  }
}

//Resolves taps on the touch screen
void mousePressed()
{
  //Changes which team has the Object
  for(int i = 0; i < buttons.length; i++)
  {
    if(buttons[i].isWithin(mouseX, mouseY) && recentlyCaptured == false)
    {
      if(caseOwner > 3)
      {
        sendText("The " + teamName(i) + " Team has taken the Object from the neutral party.");
        lastCheck = millis();
      }
      
      if(caseOwner != i)
      {
        caseOwner = i;
        recentlyCaptured = true;
        lastCaptured = millis();
      }
    }
  }

  //Starts the game
  if (startBig.isWithin(mouseX, mouseY)) {
    playArea = largeArea;
    playing = true;
    gameStart = millis();
    lastUpdate = millis();
    unique++;

    for(int i = 0; i < buttons.length; i++){
        buttons[i].on();
    }
    startBig.off();
    startSmall.off();
    for(int i = 0; i < scores.length; i++){
      scores[i] = 0;
    }
    caseOwner = 4;
    sendText("Welcome. Your game has begun. The Object is at " + closestLandmark(latit, longi) + ".");
    updates = "";  
  }
  else if(startSmall.isWithin(mouseX, mouseY)){
    playArea = smallArea;
    playing = true;
    gameStart = millis();
    lastUpdate = millis();
    unique++;

    for(int i = 0; i < buttons.length; i++){
        buttons[i].on();
    }
    startBig.off();
    startSmall.off();
    for(int i = 0; i < scores.length; i++){
      scores[i] = 0;
    }
    caseOwner = 4;
    sendText("Welcome. Your game has begun. The Object is at " + closestLandmark(latit, longi) + ".");
    updates = ""; 
  }
}

//takes milliseconds and converts them to minutes and seconds
String formatTime(int time)
{
  int minutes = 0;
  int seconds = 0;
  int decimalSeconds = 0;
  while (time >= 60000)
  {
    time -= 60000;
    minutes++;
  }
  while (time >= 1000)
  {
    time -= 1000;
    seconds++;
  }
  while(time >= 100)
  {
    time -= 100;
    decimalSeconds++;
  }
  if (seconds >= 10)
  {
    return minutes + ":" + seconds + "." + decimalSeconds;
  }
  else
  {
    return minutes + ":0" + seconds + "." + decimalSeconds;
  }
}

//Sends a message to twitter
//If you want give every message a hashtag, add it here
//Be sure to check that none of your messages will be too many characters!
void sendText(String message)
{
  sm.sendTextMessage(number, null, message + " (" + unique + ") #ObjectGet", null, null);
  texts++;
}

//Returns the name of the landmark closest too the latitude and longitude given
String closestLandmark(float lat, float lng)
{
  float minDistance = 1000;
  int closest = 9999;
  for(int i = 0; i < landmarks.length; i++){
    location.distanceBetween((double)lat, (double)lng, landmarks[i][0], landmarks[i][1], results);
    if(results[0] < minDistance){
      closest = i;
      minDistance = results[0];
    }
  }
  if(closest >= landmarks.length){
    return "nowhere";
  }
  else{
    return landmarkNames[closest];
  }
}

//Returns true if the lat and long are within the play area, false if they are not
Boolean inPlayArea(float lng, float lat)
{
  int intersections = 0;
  for(int i = 0; i < playArea.length-1; i++){
    intersections+= lineCross(playArea[i][1], playArea[i][0], playArea[i+1][1], playArea[i+1][0], lng, lat);
  }
  intersections += lineCross(playArea[playArea.length-1][1], playArea[playArea.length-1][0], playArea[0][1], playArea[0][0], lng, lat);
  
  if(intersections%2 == 1)
  {
    return true;
  }
  return false;
}

//Checks to see if a ray cast from point p will cross the line define by 1 and 2
//returns 1 if it does, returns 0 if it doesn't
//Latitude is the equivalent of Y, Longitutde is the equivalent of X
//I know this isn't strictly accurate, given the curvative of the earth and all, but it's good enough for the game's purposes
int lineCross(float x1, float y1, float x2, float y2, float px, float py)
{
  if ((py > y1) && (py > y2))
  {
    //whenOut = py + " is move than " + y1 + " and " + y2;
    return 0;
  }

  if (x1 > x2)
  {
    if ((x2 > px) || (px > x1))
    {
      //whenOut = py + " is not between " + x1 + " and " + x2;
      return 0;
    }
  }
  else
  {
    if((x1 > px) || (px > x2))
    {
      //whenOut = py + " is not between " + x2 + " and " + x1;
      return 0;
    }
  }

  float dx = x1 - x2;
  float dy = y1 - y2;
  float slope = dy/dx;

  float b = y1 - (slope * x1); //that's b as in y = ax + b
  float intersection = (slope * px) + b;

  if (py <= intersection)
  {
    //whenOut = py + " intersects with this line.";
    return 1;
  }
  else
  {
    //whenOut = "below the line and within range, but does not intersect";
    return 0;
  }
}

//This is the end of the program
