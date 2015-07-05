// matrix of circle values, range 0.0<=val<=1.0
float vals[][] = new float[8][8];

// is the circle growing or decaying?
boolean growing[][] = new boolean[8][8];

static final float R0 = 0.8F; // starting size before growing
static final float GROWTH = 1.05F; // growth rate
static final float DECAY = 0.95F; // decay rate
static final float THRESHOLD = 0.0001F; // size before we consider it to be zero
final color inner_circle = color(150, 0, 0);
final color outer_circle = color(200, 0, 0);

PGraphics pg;
void setup()
{
  size(1000, 1000);
  frameRate(60);
  pg=createGraphics(width, height);

  //init to zero
  for(int x=0;x<vals.length;x++)
  {
    for(int y=0;y<vals[x].length;y++)
    {
      vals[x][y]=0F;
      growing[x][y]=false;
    }
  }  
}

void draw()
{
  // double buffering
  pg.beginDraw();
  pg.background(0);
  final float xStep = width/9F;
  final float yStep = height/9F;
  pg.stroke(150);
  for(int x=0;x<8;x++)
  {
    // eight vertical lines top to bottom
    pg.line((int)(xStep*(x+1)), 0,(int)(xStep*(x+1)), height); 
  }

  for(int y=0;y<8;y++)
  {
    // eight horizontal lines
    pg.line(0, (int)(yStep*(y+1)), width,(int)(yStep*(y+1))); 
  }
  pg.noStroke();
  pg.ellipseMode(CENTER);
  final int x0=(int)random(9)%8;
  final int y0=(int)random(9)%8;
  if(!growing[x0][y0])
  {
    // if not already growing
    vals[x0][y0]=R0;
    growing[x0][y0]=true;
  }

  for(int x=0;x<vals.length;x++)
  {
    for(int y=0;y<vals[x].length;y++)
    {
      if(vals[x][y]>0)
      {
        if(vals[x][y]>=1F)
        {
          growing[x][y] = false;
          vals[x][y]=1F;
        }
        pg.fill(outer_circle);
        pg.ellipse((int)(xStep*(x+1)), (int)(yStep*(y+1)), (int)(xStep*vals[x][y]), (int)(yStep*vals[x][y]));
        pg.fill(inner_circle);
        vals[x][y]*=(growing[x][y]?GROWTH:DECAY);
        pg.ellipse((int)(xStep*(x+1)), (int)(yStep*(y+1)), (int)(xStep*vals[x][y]), (int)(yStep*vals[x][y]));
        if(vals[x][y]<THRESHOLD)
        {
          vals[x][y]=0F;
        }
      }
    }
  }  
  pg.endDraw();
  image(pg, 0, 0);
}
