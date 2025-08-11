// === PLAYER VARIABLES ===
float playerX, playerY;       // Player's position
float playerW = 60, playerH = 20;  // Player's size (width & height)
float playerSpeed = 6;        // How fast the player moves
int playerDir = 0;            // Direction of movement: -1 (left), 1 (right), 0 (stop)

// === BLOCK (ENEMY) VARIABLES ===
final int MAX_BLOCKS = 100;   // Maximum number of blocks allowed at once
float[] blockX = new float[MAX_BLOCKS];    // X positions of blocks
float[] blockY = new float[MAX_BLOCKS];    // Y positions of blocks
float[] blockW = new float[MAX_BLOCKS];    // Widths of blocks
float[] blockH = new float[MAX_BLOCKS];    // Heights of blocks
float[] blockSpeed = new float[MAX_BLOCKS]; // Falling speed of each block
int blockCount = 0;           // Number of blocks currently on screen

// === GAME STATE VARIABLES ===
int score = 0;                // Player's score
boolean gameOver = false;     // True when player loses

// === SETUP: runs once at the beginning ===
void setup() {
  size(600, 600);             // Window size
  playerX = width / 2 - playerW / 2;  // Start player in the middle
  playerY = height - 40;      // Place player near bottom
  frameRate(60);              // Set frame rate to 60 FPS
}

// === DRAW: runs every frame ===
void draw() {
  background(30);             // Clear screen with dark background

  if (!gameOver) {
    // === PLAYER MOVEMENT ===
    playerX += playerDir * playerSpeed;  // Update position based on direction
    playerX = constrain(playerX, 0, width - playerW);  // Keep player on screen

    // === DRAW PLAYER ===
    fill(0, 200, 255);        // Bright blue color
    rect(playerX, playerY, playerW, playerH);  // Draw player rectangle

    // === BLOCK SPAWNING ===
    if (frameCount % 30 == 0 && blockCount < MAX_BLOCKS) {
      // Every 30 frames (0.5s at 60fps), add a new block
      blockX[blockCount] = random(0, width - 60);      // Random horizontal position
      blockY[blockCount] = -20;                        // Start above screen
      blockW[blockCount] = random(30, 80);             // Random width
      blockH[blockCount] = 20;                         // Constant height
      blockSpeed[blockCount] = random(3, 7);           // Random falling speed
      blockCount++;                                    // Increase block count
    }

    // === UPDATE & DRAW BLOCKS ===
    for (int i = 0; i < blockCount; i++) {
      blockY[i] += blockSpeed[i];                      // Move block down

      fill(255, 100, 100);                             // Red color
      rect(blockX[i], blockY[i], blockW[i], blockH[i]);  // Draw block

      // === COLLISION DETECTION ===
      boolean hit = blockX[i] < playerX + playerW &&
                    blockX[i] + blockW[i] > playerX &&
                    blockY[i] < playerY + playerH &&
                    blockY[i] + blockH[i] > playerY;

      if (hit) {
        gameOver = true;    // End game on collision
      }

      // === REMOVE OFF-SCREEN BLOCKS ===
      if (blockY[i] > height) {
        // Replace this block with the last one in the array
        blockCount--;
        blockX[i] = blockX[blockCount];
        blockY[i] = blockY[blockCount];
        blockW[i] = blockW[blockCount];
        blockH[i] = blockH[blockCount];
        blockSpeed[i] = blockSpeed[blockCount];
        i--;  // Check new block that was moved into this slot
        score++;  // Increase score for avoiding the block
      }
    }

    // === DISPLAY SCORE ===
    fill(255);                // White text
    textSize(20);
    text("Score: " + score, 10, 25);

  } else {
    // === GAME OVER SCREEN ===
    fill(255, 0, 0);          // Red text
    textSize(40);
    textAlign(CENTER);
    text("GAME OVER", width / 2, height / 2);

    textSize(20);
    text("Final Score: " + score, width / 2, height / 2 + 40);
    text("Press 'R' to Restart", width / 2, height / 2 + 70);
  }
}

// === HANDLE KEY PRESSES ===
void keyPressed() {
  if (key == CODED) {
    // Arrow key handling
    if (keyCode == LEFT) {
      playerDir = -1;  // Move left
    } else if (keyCode == RIGHT) {
      playerDir = 1;   // Move right
    }
  }

  // Restart game
  if (key == 'r' || key == 'R') {
    restart();
  }
}

// === HANDLE KEY RELEASE ===
void keyReleased() {
  if (key == CODED) {
    // Stop movement when arrow key released
    if (keyCode == LEFT || keyCode == RIGHT) {
      playerDir = 0;
    }
  }
}

// === RESET GAME TO INITIAL STATE ===
void restart() {
  playerX = width / 2 - playerW / 2;  // Reset player position
  score = 0;                          // Reset score
  blockCount = 0;                     // Remove all blocks
  gameOver = false;                   // Resume game
}
