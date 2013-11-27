//Define a listener that responds to location updates
class MyLocationListener implements LocationListener {

  void onLocationChanged(Location location) {
    // Called when a new location is found by the network location provider.
    latit  = (float)location.getLatitude();
    longi = (float)location.getLongitude();
  }

  void onProviderDisabled (String provider) {
  }

  void onProviderEnabled (String provider) {
  }

  void onStatusChanged (String provider, int status, Bundle extras) {
  }
}

//This array should contain the GPS coordinates of every intersection within your play area. First latitude then longitude
double[][] landmarks = {
{40.70722, -74.00746}, // Maiden Lane and Liberty Street and Gold Street and Maiden Lane
{40.709476, -74.00168}, // Pearl Street and Dover Street and Frankfort Street and Pearl Street
{40.71011, -74.001175}, // Pearl Street and Pearl Street and Robert F Wagner Sr Place and Avenue of the Finest and Robert F. Wagner Sr. Place
{40.706226, -74.00317}, // South Street and Fulton Street
{40.70678, -74.00361}, // Fulton Street and Front Street
{40.70966, -74.00483}, // Gold Street and Beekman Street
{40.707672, -74.003105}, // Water Street and Beekman Street and Water Street
{40.70838, -73.99939}, // Robert F. Wagner Sr. Place and South Street
{40.707832, -74.004326}, // Fulton Street and Pearl Street
{40.70381, -74.00832}, // Old Slip and Front Street
{40.708614, -74.00937}, // Liberty Street and Nassau Street
{40.70772, -74.00827}, // Liberty Street and William Street
{40.70408, -74.00899}, // Water Street and Hanover Square and Old Slip
{40.710167, -74.00425}, // Gold Street and Spruce Street
{40.70698, -74.006454}, // Pearl Street and Fletcher Street
{40.706375, -74.00569}, // Fletcher Street and Water Street
{40.704777, -74.00975}, // Pearl Street and William Street and Hanover Square
{40.704544, -74.00946}, // Pearl Street and Hanover Square and Hanover Square
{40.707207, -74.00595}, // Platt Street and Pearl Street
{40.70786, -74.006836}, // Platt Street and Gold Street
{40.708347, -74.00764}, // Platt Street and William Street
{40.706013, -74.00881}, // Wall Street and Hanover Street
{40.707695, -74.0102}, // Nassau Street and Nassau Street and Pine Street
{40.70695, -74.008995}, // William Street and Pine Street
{40.70605, -74.007454}, // Pearl Street and Pine Street
{40.705307, -74.00621}, // Pine Street and Front Street
{40.704803, -74.00542}, // South Street and Pine Street
{40.705624, -74.00677}, // Water Street and Pine Street and Pine Street
{40.709404, -74.00513}, // Gold Street and Gold Street
{40.705795, -74.009865}, // Exchange Place and William Street and Exchange Place
{40.70815, -74.002144}, // Peck Slip and Water Street
{40.707718, -74.00175}, // Peck Slip and Front Street
{40.707275, -74.00134}, // South Street and Peck Slip
{40.708252, -74.00194}, // Peck Slip and Water Street and Peck Slip
{40.70781, -74.00157}, // Peck Slip and Front Street
{40.707363, -74.00118}, // South Street and Peck Slip
{40.708847, -74.0025}, // Peck Slip and Pearl Street
{40.707905, -74.00602}, // Cliff Street and John Street
{40.70812, -74.00983}, // Cedar Street and Nassau Street
{40.706375, -74.00713}, // Pearl Street and Cedar Street
{40.70734, -74.008644}, // William Street and Cedar Street
{40.705147, -74.00999}, // William Street and South William Street and Beaver Street
{40.70879, -74.00086}, // Water Street and Dover Street
{40.708347, -74.00049}, // Front Street and Dover Street
{40.707905, -74.00012}, // South Street and Dover Street and Dover Street and South Street
{40.70892, -74.005264}, // Fulton Street and Edens Alley
{40.709873, -74.00706}, // Fulton Street and Dutch Street
{40.70953, -74.008415}, // Nassau Street and John Street
{40.7087, -74.007286}, // William Street and John Street
{40.708225, -74.00653}, // Gold Street and Gold Street and John Street
{40.707386, -74.005486}, // Pearl Street and John Street and John Street
{40.706406, -74.004555}, // Front Street and John Street and John Street and Front Street
{40.709114, -74.00785}, // Dutch Street and John Street
{40.70579, -74.00387}, // South Street and South Street and John Street and East River Esplanade
{40.70909, -74.00551}, // Fulton Street and Fulton Street and Gold Street and Gold Street
{40.709557, -74.00643}, // Fulton Street and William Street
{40.70545, -74.008}, // Pearl Street and Beaver Street
{40.70523, -74.004745}, // South Street and Maiden Lane
{40.706707, -74.00233}, // South Street and Beekman Street
{40.705547, -74.00795}, // Wall Street and Pearl Street
{40.70375, -74.00705}, // Gouverneur Lane and South Street
{40.704224, -74.00631}, // Wall Street and South Street and South Street and Wall Street and Wall Street
{40.70859, -73.99905}, // Robert F Wagner Senior Place and Robert F Wagner Sr Place and South Street
{40.706722, -74.00678}, // Maiden Lane and Pearl Street
{40.70638, -74.0095}, // Wall Street and Wall Street and William Street
{40.707977, -74.008}, // William Street and Maiden Lane
{40.710396, -74.0056}, // Beekman Street and William Street and Beekman Street and William Street
{40.707214, -74.00275}, // Front Street and Beekman Street and Front Street
{40.704285, -74.00767}, // Gouverneur Lane and Front Street
{40.704803, -74.00695}, // Wall Street and Front Street
{40.70579, -74.00552}, // Maiden Lane and Front Street
{40.70518, -74.00739}, // Wall Street and Water Street
{40.709045, -74.008896}, // Maiden Lane and Nassau Street
{40.704674, -74.008125}, // Gouverneur Lane and Water Street
{40.706142, -74.00602}, // Maiden Lane and Water Street and Maiden Lane
{40.708668, -74.00601}, // Edens Alley and Gold Street
{40.709385, -74.00038}, // Robert F. Wagner Sr. Place and Robert F. Wagner Sr. Place
{40.70319, -74.00798}, // South Street and South Street and South Street and Old Slip
{40.704212, -74.00879}, // Old Slip and Water Street
{40.703316, -74.00777}, // South Street and South Street and Old Slip and Old Slip
{40.70745, -74.00407}, // Fulton Street and Fulton Street and Water Street and Pearl Street
{40.706852, -74.005005}, // John Street and Water Street
{40.710415, -74.009476}, // Dey Street and Broadway
{40.71022, -74.007744}, // Fulton Street and Nassau Street
{40.710327, -74.009544}, // Broadway and John Street
{40.709805, -74.00999}, // Cortlandt Street and Maiden Lane and Broadway
{40.70332, -74.0102}, // Water Street and Coenties Slip
{40.70497, -74.00892}, // Pearl Street and Hanover Street
{40.70486, -74.00888}, // Pearl Street and Hanover Street
{40.70552, -74.00791}, // Wall Street and Pearl Street
{40.70516, -74.00736}, // Wall Street and Water Street
{40.708076, -74.00345}, // Beekman Street and Pearl Street and Beekman Street and Pearl Street
{40.708775, -73.99929}, // South Street and Robert F Wagner Sr Place and Robert F Wagner Sr Place
{40.705315, -74.00902}, // Hanover Street and Beaver Street
{40.705544, -74.009056}, // Hanover Street and Exchange Place
{40.708405, -74.004776}, // Cliff Street and Fulton Street
{40.707214, -74.00397}, // Fulton Street and Fulton Street and Water Street
{40.706932, -74.00374}, // Fulton Street and Front Street
{40.705986, -74.00522}, // Front Street and Fletcher Street and Fletcher Street and Front Street
{40.703106, -74.00758}, // East River Esplanade and Old Slip
{40.70404, -74.006096}, // Wall Street and East River Esplanade
{40.707653, -74.00001}, // Dover Street and East River Esplanade
{40.705414, -74.00448}, // South Street and Fletcher Street
{40.709152, -74.010544}, // Liberty Street and Broadway
{40.710938, -74.00505}, // William Street and Spruce Street
{40.708305, -74.011246}, // Broadway and Pine Street
{40.708797, -74.01085}, // Cedar Street and Broadway
{40.710888, -74.00906}, // Fulton Street and Broadway
{40.70371, -74.010605}, // Pearl Street and Coenties Slip
{40.710964, -74.003654}, // Gold Street and Frankfort Street
{40.71079, -74.003365}, // Frankfort Street and Gold Street
{40.71123, -74.00648}, // Beekman Street and Nassau Street
{40.708435, -73.99859}, // Robert F Wagner Senior Place and East River Esplanade
{40.708710, -74.004044} //Beekman Street and Cliff Street
};

//This contains the names of every intersection. They should be in the same order as the GPS cordinants
String[] landmarkNames = {
"Maiden Lane and Gold St",
"Pearl St and Frankfort St",
"Pearl St and Robert F Wagner Sr Place",
"South St and Fulton St",
"Fulton St and Front St",
"Gold St and Beekman St",
"Water St and Beekman St",
"Robert F. Wagner Sr. Place and South St",
"Fulton St and Pearl St",
"Old Slip and Front St",
"Liberty St and Nassau St",
"Liberty St and William St",
"Water St and Old Slip",
"Gold St and Spruce St",
"Pearl St and Fletcher St",
"Fletcher St and Water St",
"Pearl St and William St",
"Pearl St and Hanover Square",
"Platt St and Pearl St",
"Platt St and Gold St",
"Platt St and William St",
"Wall St and Hanover St",
"Nassau St and Pine St",
"William St and Pine St",
"Pearl St and Pine St",
"Pine St and Front St",
"South St and Pine St",
"Water St and Pine St",
"Gold St and Ann St",
"Exchange Place and William St",
"Peck Slip and Water St",
"Peck Slip and Front St",
"South St and Peck Slip",
"Peck Slip and Water St",
"Peck Slip and Front St",
"South St and Peck Slip",
"Peck Slip and Pearl St",
"Cliff St and John St",
"Cedar St and Nassau St",
"Pearl St and Cedar St",
"William St and Cedar St",
"William St and Beaver St",
"Water St and Dover St",
"Front St and Dover St",
"South St and Dover St",
"Fulton St and Edens Alley",
"Fulton St and Dutch St",
"Nassau St and John St",
"William St and John St",
"Gold St and John St",
"Pearl St and John St",
"John St and Front St",
"Dutch St and John St",
"South St and John St",
"Fulton St and Gold St",
"Fulton St and William St",
"Pearl St and Beaver St",
"South St and Maiden Lane",
"South St and Beekman St",
"Wall St and Pearl St",
"Gouverneur Lane and South St",
"South St and Wall St",
"Robert F Wagner Sr Place and South St",
"Maiden Lane and Pearl St",
"Wall St and William St",
"William St and Maiden Lane",
"Beekman St and William St",
"Front St and Beekman St",
"Gouverneur Lane and Front St",
"Wall St and Front St",
"Maiden Lane and Front St",
"Wall St and Water St",
"Maiden Lane and Nassau St",
"Gouverneur Lane and Water St",
"Water St and Maiden Lane",
"Edens Alley and Gold St",
"Robert F. Wagner Sr. Place and Robert F. Wagner Sr. Place",
"South St and Old Slip",
"Old Slip and Water St",
"South St and Old Slip",
"Fulton St andPearl St",
"John St and Water St",
"Dey St and Broadway",
"Fulton St and Nassau St",
"Broadway and John St",
"Cortlandt St and Maiden Lane and Broadway",
"Water St and Coenties Slip",
"Pearl St and Hanover St",
"Pearl St and Hanover St",
"Wall St and Pearl St",
"Wall St and Water St",
"Beekman St and Pearl St",
"South St and Robert F Wagner Sr Place",
"Hanover St and Beaver St",
"Hanover St and Exchange Place",
"Cliff St and Fulton St",
"Fulton St and Water St",
"Fulton St and Front St",
"Fletcher St and Front St",
"East River Esplanade and Old Slip",
"Wall St and East River Esplanade",
"Dover St and East River Esplanade",
"South St and Fletcher St",
"Liberty St and Broadway",
"William St and Spruce St",
"Broadway and Pine St",
"Cedar St and Broadway",
"Fulton St and Broadway",
"Pearl St and Coenties Slip",
"Gold St and Frankfort St",
"Frankfort St and Gold St",
"Beekman St and Nassau St",
"Robert F Wagner Senior Place and East River Esplanade",
"Beekman St and Cliff St"
};
