class Cell {
  boolean alive = false; 
  boolean border = false;
  int alive_neighbors;
  public static final float radius = 5;

  float life;

  void randomAlive() {
    float a = random(0, 100);
    if (a<=25) alive = true;
  }

  void render(float xpos, float ypos) {
    life+=2.4f;

    if (border) alive = false;
    if (alive)fill(sin(life)*128, sin(life/4.8)*64, cos(life*.04)%64);//fill(lerpColor(c1, c2, sin(life/60)));
    else if (border) fill(80, 80, 80);
    else fill(180, 180, 180, 40);
    /*
    ellipseMode(RADIUS);
     ellipseMode(CENTER);
     ellipse(xpos, ypos, radius, radius);
     */
    rectMode(RADIUS);
    rectMode(CENTER);
    rect(xpos, ypos, radius, radius);
  }

  void SetAlive(boolean next_life) {
    alive = next_life;
  }

  void ToggleAlive() {
    if (alive) alive = false;
    else alive = true;
  }
}


Cell[][] cells;
Cell[][] cells_buffer;

int rows, columns, tick, spawnertick;

float change = 0;

void setup() {
  noStroke();
  size(1280, 720); 
  rows = int(height/Cell.radius);
  columns = int(width/Cell.radius);
  cells = new Cell[columns][rows];
  cells_buffer = new Cell[columns][rows];

  frameRate(10);
  makeCells();
}

void SetBorders() {
  for (int i = 0; i<columns-1; i++) {
    for (int j = 0; j<4; j++) {
      cells[i][j].border = true; //was i,0
      if (j==0) {
        cells[i][rows-1].border = true; //was rows-1
      }else 
        cells[i][rows-j].border = true; //was rows-1
    }
  }
  for (int i = 0; i<rows-1; i++) {
    for (int j = 0; j<4; j++) {
      cells[j][i].border = true;
      if (j==0) {
        cells[columns-1][i].border=true;
      }else 
        cells[columns-j][i].border=true;
      //cells[columns-1][i].border=true;
    }
  }
  cells[columns-1][rows-1].border=true;
}
void CheckNeighbors() { 

  //change+=.01f;

  for (int i = 1; i<columns-1; i++) {
    for (int j = 1; j<rows-1; j++) {
      cells[i][j].alive_neighbors = 0;

      if (cells[i-1][j+1].alive && cells[i-1][j+1].border!=true) cells[i][j].alive_neighbors++;
      if (cells[i-1][j].alive && cells[i-1][j].border!=true) cells[i][j].alive_neighbors++;
      if (cells[i-1][j-1].alive && cells[i-1][j-1].border!=true) cells[i][j].alive_neighbors++;
      if (cells[i][j-1].alive && cells[i][j-1].border!=true) cells[i][j].alive_neighbors++;
      if (cells[i][j+1].alive && cells[i][j+1].border!=true) cells[i][j].alive_neighbors++;
      if (cells[i+1][j+1].alive && cells[i+1][j+1].border!=true) cells[i][j].alive_neighbors++;
      if (cells[i+1][j-1].alive && cells[i+1][j-1].border!=true) cells[i][j].alive_neighbors++;
      if (cells[i+1][j].alive && cells[i+1][j].border!=true) cells[i][j].alive_neighbors++;

      //println("cell ["+i+"]["+j+"]"+" has " + cells[i][j].alive_neighbors+ " alive neighbors");
      cells_buffer[i][j] = cells[i][j];
      //  println(cells_buffer[i][j].alive + "  " + cells[i][j].alive);
    }
  }

  for (int i = 1; i<columns-1; i++) {
    for (int j = 1; j<rows-1; j++) {    
      if (cells[i][j].alive == true && (cells[i][j].alive_neighbors == 3))cells_buffer[i][j].SetAlive(true);
      else if (cells[i][j].alive == true && (cells[i][j].alive_neighbors == 2))cells_buffer[i][j].SetAlive(true); 
      else if (cells[i][j].alive == false && cells[i][j].alive_neighbors == 3)cells_buffer[i][j].SetAlive(true);
      else cells_buffer[i][j].SetAlive(false);
    }
  }


  for (int i = 1; i<columns-1; i++) {
    for (int j = 1; j<rows-1; j++) {
      cells[i][j] = cells_buffer[i][j];
    }
  }
}

void makeSpaceShip(int i, int j) {
  cells[i][j].SetAlive(true);
  cells[i+1][j].SetAlive(true);
  cells[i+2][j].SetAlive(true);
  cells[i+2][j+1].SetAlive(true);
  cells[i+1][j+2].SetAlive(true);
}

void populate(int i, int j) {
  cells[i][j].SetAlive(true);
  int count = 0;
  while (count<100) {
    cells[i+int(random(40))][j+int(random(40))].SetAlive(true);
    count++;
  }
}


void spawnLife() {
  spawnertick=0;
  for (int i = 0; i<columns; i++) {
    for (int j = 0; j<rows; j++) {
      if (cells[i][j].alive==false) {
        float rnd = random(0, 100);
        if (rnd<10) {
          cells[i][j].alive = true;
        }
      }
    }
  }
}

void makeCells() {
  for (int i = 0; i<columns; i++) {
    for (int j = 0; j<rows; j++) {
      cells[i][j] = new Cell();
      cells[i][j].randomAlive();
    }
  }
  SetBorders();
}


void draw() {

  if (spawnertick>50) spawnLife();
  spawnertick++;
  tick++;
  //saveFrame("img_4k_"+tick+".png");
  if (mousePressed == true) {
    if (mouseButton == RIGHT) {
      println(mouseX+"  "+mouseY +"        "+ mouseX / Cell.radius+ "  "+mouseY / Cell.radius);
      makeSpaceShip(int(mouseX / Cell.radius), int((mouseY/Cell.radius)));
    }
    if (mouseButton == LEFT) {
      populate(int(mouseX / Cell.radius), int((mouseY/Cell.radius)));
    }
  }
  CheckNeighbors();

  for (int i = 0; i<columns; i++) {
    for (int j = 0; j<rows; j++) {
      cells[i][j].render(i*Cell.radius+Cell.radius*.5f, j*Cell.radius+Cell.radius*.5f);
    }
  }
}
