// Copyright 2011 Google Inc. All Rights Reserved.

/**
 * An abstract class for any Demo of the Box2D library.
 */
class Demo {
  /** All of the bodies in a simulation. */
  List<Body> bodies;

  /** The default canvas width and height. */
  static final int CANVAS_WIDTH = 900;
  static final int CANVAS_HEIGHT = 600;

  /** Scale of the viewport. */
  static final num _VIEWPORT_SCALE = 10;

  /** The gravity vector's y value. */
  static final num GRAVITY = -10;

  /** The timestep and iteration numbers. */
  static final num TIME_STEP = 1/60;
  static final int VELOCITY_ITERATIONS = 10;
  static final int POSITION_ITERATIONS = 10;

  /** The drawing canvas. */
  HTMLCanvasElement canvas;

  /** The canvas rendering context. */
  CanvasRenderingContext2D ctx;

  /** The transform abstraction layer between the world and drawing canvas. */
  IViewportTransform viewport;

  /** The debug drawing tool. */
  DebugDraw debugDraw;

  /** The physics world. */
  World world;

  Demo() :
    bodies = new List<Body>() {
    // Setup the World.
    final gravity = new Vector(0, GRAVITY);
    bool doSleep = true;
    world = new World(gravity, doSleep, new DefaultWorldPool());
  }

  /** Advances the world forward by timestep seconds. */
  void step(num timestamp) {
    world.step(TIME_STEP, VELOCITY_ITERATIONS, POSITION_ITERATIONS);

    // Clear the animation panel and draw new frame.
    ctx.clearRect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
    world.drawDebugData();
    window.webkitRequestAnimationFrame((num time) {
      step(time);
    }, canvas);
  }

  /**
   * Creates the canvas and readies the demo for animation. Must be called
   * before calling runAnimation.
   */
  void initializeAnimation() {
    // Setup the canvas.
    canvas = document.createElement('canvas');
    canvas.width = CANVAS_WIDTH;
    canvas.height = CANVAS_HEIGHT;
    document.body.appendChild(canvas);
    ctx = canvas.getContext("2d");

    // Create the viewport transform with the center at extents.
    final extents = new Vector(CANVAS_WIDTH / 2, CANVAS_HEIGHT / 2);
    viewport = new CanvasViewportTransform(extents, extents);
    viewport.scale = _VIEWPORT_SCALE;

    // Create our canvas drawing tool to give to the world.
    debugDraw = new CanvasDraw(viewport, ctx);

    // Have the world draw itself for debugging purposes.
    world.debugDraw = debugDraw;
  }

  abstract void initialize();

  /** The name of the demo. */
  String get name() {
    return "No Demo Name";
  }

  /**
   * Starts running the demo as an animation using an animation scheduler.
   */
  void runAnimation() {
    window.webkitRequestAnimationFrame((num time) {
      step(time);
    }, canvas);
  }
}
