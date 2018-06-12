/*
From 2008 to 2012 and the last column is the total value
Anything beyond 50k is gold
Below 50k but bigger than 10k is silver
Anything else below 10k is bronze
*/

PFont font;
PImage goldCoin;
PImage silverCoin;  //Set up the variables for the images
PImage bronzeCoin;
PImage mappleLeaf;
final int imageWidth = 100; //size of the images
final int imageHeight = 100;
int indexForGraph = -1; //index for graph is at negative one to prevent the graphs from being presented at the start of the program

final int numCols = 6;  //Six coins
final int numRows =1; //Only one row of them



final String fileName = "scitech-spending.csv"; //Domestic spending on research and development

fundingData[] funding = new fundingData[7]; //Array of values that will be present scross the window

class fundingData
{
  int imageX;                         //Set up my class
  int imageY;
  int[] fundingThroughTheYears = new int[5];      //Set this rray to five because we only want to focus on the five colums with the yearly value. Not the ones with the name or total column
  int totalFunding;
  String domesticNames;
  fundingData(int total, String names)
  {                                            //Set up constructor
    totalFunding = total;
    domesticNames = names;
  }
}


void setup()
{
  size(1200, 450);
  background(255);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  fill(0);
  textSize(15);
  indexForGraph = - 1;
  font = loadFont("AdobeThai-Regular-48.vlw"); 
  goldCoin = loadImage("Gold Coin.jpg");                    //Load the images
  silverCoin = loadImage("Silver Coin.jpg");
  bronzeCoin = loadImage("Bronze Coin.jpg");
  mappleLeaf = loadImage("Maple_Leaf.svg.png");

  readData();       //Call my read data function
}


void draw()
{
  background(255);
  text("Domestic spending on research and development", width/2,height/10);
  text("Gold: Above 50k", width/2 - 170,height/6 - 7);
  text("Silver: below 50k", width/2,height/6 - 7);
  text("Bronze: below 10k", width/2 + 170,height/6 - 7);                         //Text for the info of the program
  text("Mapple Leaf is the total in the country", width/2 ,height/5);
  drawCoins(funding); //Call the draw text function
  if (indexForGraph >= 0)
  {
    drawBarGraph(indexForGraph); //When the index for the graph is zero it will call the drawBarGraph function
  }
}

void mouseClicked()
{
  if (indexForGraph >= 0)   //When the index for the graph is zero 
  {
    indexForGraph = -1; //It will go back to negative 1, when you click on it. Taking away the graph
  } 
  else
  {
    indexForGraph = indexForCountry(mouseX, mouseY);  //Else it will go for where the mouse will click on the next index
  }
}


void readData()
{
  String[] fileNames = loadStrings(fileName);           //load names from the file
  for (int j = 0; j < fileNames.length; j++)
  {
    if (j < 5 || j > 11)                        //Disrigard all the other lines in the exel file and fucuse on the 7 rows
    {
      continue;
    } 
    String[] spliting = fileNames[j].split(",");  //Split it
    int domesticNum = j - 5;
    funding[domesticNum] = new fundingData(Integer.parseInt(spliting[6]), spliting[0]);   //Set my object instance to the first and last column (Names and Total column)
    funding[domesticNum].fundingThroughTheYears = new int[5];  //Have this array instance with the five years of funding
    funding[domesticNum].fundingThroughTheYears[0] = Integer.parseInt(spliting[1]);
    funding[domesticNum].fundingThroughTheYears[1] = Integer.parseInt(spliting[2]);   //Appending them all the the array
    funding[domesticNum].fundingThroughTheYears[2] = Integer.parseInt(spliting[3]);
    funding[domesticNum].fundingThroughTheYears[3] = Integer.parseInt(spliting[4]);
    funding[domesticNum].fundingThroughTheYears[4] = Integer.parseInt(spliting[5]);
  }
}



void drawCoins(fundingData[] coins)
{ 
  int spacing = (width/8) + 25; //Set up the spacing of the images
  int y = height / 2;
  for (int i = 1; i < 7; i++)
  {
    coins[i].imageX = (spacing/2 + spacing * (i - 1)) + 150; //Initialize the x coordinate in loop to space them evenly as the for loop runs
    if (coins[i].totalFunding > 50000)
    {
      image(goldCoin, coins[i].imageX, y, imageWidth, imageHeight);
      text(coins[i].domesticNames, coins[i].imageX, y + 80);
    } else if (funding[i].totalFunding > 10000)
    {
      image(silverCoin, coins[i].imageX, y, imageWidth, imageHeight);                 //Depending on the value of the total column it will either be Gold, Silver Or Bronze
      text(coins[i].domesticNames, coins[i].imageX, y + 80);
    } else
    {
      image(bronzeCoin, coins[i].imageX, y, imageWidth, imageHeight);
      text(coins[i].domesticNames, coins[i].imageX, y + 80);
    }
  }
  coins[0].imageX = 80; 
  image(mappleLeaf, coins[0].imageX, y, imageWidth, imageHeight);          //Finaly draw the mapple leaf image
  text(coins[0].domesticNames, coins[0].imageX, y + 80);
}

void drawBarGraph(int i)
{
  final int padding = 50; //Space to show the graph properly

  final int rectWidth = (int)(width - 150 ); //Have the bars place around in the middle of the graph
  final int rectHeight = (int)(height - 150);

  final int axisX = width/2 - rectWidth/2 + padding;
  final int axisY = height/2 + rectHeight/2 - padding;   //X and Y axis and the size 
  final int axisHeight = rectHeight - 2 * padding;
  stroke(2);
  fill(127, 196, 229);
  rect(width/2, height/2, rectWidth, rectHeight); // Draw the background
  fill(0);
  textSize(15);
  text(funding[i].domesticNames, width/2, height/2 + rectHeight/2+5 - padding/2);   // Label it
  line(axisX, axisY, axisX, height-axisY);  // Draw axes
  line(axisX, axisY, width-axisX, axisY);
  int pointNum = 0;
  int numPoints = 5;
  int spacing = (rectWidth - 2*axisX)/numPoints; //Spacing between the bars
  float finalPointX = axisX;
  float finalPointY = axisY;
  while (pointNum < numPoints)
  {
    float verticalValue = funding[i].fundingThroughTheYears[pointNum];
    verticalValue = verticalValue / 40000 * axisHeight;
    fill(0);
    text("$"+funding[i].fundingThroughTheYears[pointNum], finalPointX+spacing, axisY-verticalValue-14);     // Draw the bar graph
    rect(finalPointX+spacing, axisY-verticalValue/2, 40, verticalValue);
    finalPointX = finalPointX+spacing;
    finalPointY = verticalValue;
    pointNum++;
  }
}

float XCoordinate(int row, int col)
{
  return (col+1)*horizSpacing() + col*imageWidth  + imageWidth/2;  //Coordinates of when in range 
}
float YCoordinate(int row, int col)
{
  return (col+1)*vertSpacing()+ col*imageHeight + imageHeight/2; //Coordinates of when in range 
}

float horizSpacing()
{
  return (width - 6*imageWidth)/(float)(6+1); //Range for the horizontal spacing
}
float vertSpacing()
{
  return (height - 1*imageHeight)/(float)(1+1); //Range for the vertical spacing
}

int indexForCountry(int x, int y)
{
  int i = -1; //When it is not
  int rowNum = 0;
  while (rowNum < numRows)           //Loop through the one row and the seven images
  {
    int colNum = 0;
    while (colNum < numCols)
    {
      int newIndex = rowNum*numCols + colNum;
      float X = XCoordinate(rowNum, colNum);
      float Y = height/2;
      if (x >= X - imageWidth -100 && x <= X + imageWidth - 100 && y >= Y - imageHeight && y <= Y + imageHeight) //Have the restiction from when the mouse is clicked in this range
      {
        i = newIndex;
        break;
      }
      colNum++;
    }
    rowNum++;
  }
  return i;
}

