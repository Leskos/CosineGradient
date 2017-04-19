import controlP5.*;
import java.util.*;

float r_Bias  = 0.5;
float r_Amp   = 0.4;
float r_Freq  = 1;
float r_Phase = 1;

float g_Bias  = 0.5;
float g_Amp   = 0.4;
float g_Freq  = 1;
float g_Phase = 0.3;

float b_Bias  = 0.5;
float b_Amp   = 0.4;
float b_Freq  = 1;
float b_Phase = 0.7;

int curvePreset = -1;
int speedPreset = -1;

ControlP5 cp5;
CosineGradient cosineGradient;
PrintWriter outputColours;

void setup()
{
  size( 840, 1000 );
  cp5 = new ControlP5( this );
  frameRate(5000);

  cosineGradient = new CosineGradient();
  cosineGradient.initialise( 20, 150, 100 );
}


void draw()
{
  background( 100 );
  cosineGradient.update();
  
  fill(255);
  textSize( 20 );
  text( (int)frameRate + " FPS", 10, 25 );
}


class CosineGradient
{
  final int numOutputs = 12;

  color[] colours;

  int x, y, w, h;

  float rSpeed =  0;
  float gSpeed =  0;
  float bSpeed =  0;

  int lastFrame = 0;

  PVector getValue( float t )
  {
    float r = cos( (r_Freq * t + r_Phase) * PI * 2 );
    float g = cos( (g_Freq * t + g_Phase) * PI * 2 );
    float b = cos( (b_Freq * t + b_Phase) * PI * 2 );

    r = constrain( r_Bias+r_Amp*r, 0, 1);
    g = constrain( g_Bias+g_Amp*g, 0, 1);
    b = constrain( b_Bias+b_Amp*b, 0, 1);

    return new PVector( r, g, b );
  }


  void update()
  {
    float timeDelta = (float)(millis()-lastFrame)/1000;
    lastFrame = millis();
    if ( rSpeed<0 && r_Phase<abs(rSpeed)  ) {
      cp5.getController("r_Phase").setValue( (r_Phase+(rSpeed*timeDelta)+1)%1 );
    } else {
      cp5.getController("r_Phase").setValue( (r_Phase+(rSpeed*timeDelta))%1 );
    }

    if ( gSpeed<0 && g_Phase<abs(gSpeed)  ) {
      cp5.getController("g_Phase").setValue( (g_Phase+(gSpeed*timeDelta)+1)%1 );
    } else {
      cp5.getController("g_Phase").setValue( (g_Phase+(gSpeed*timeDelta))%1 );
    }

    if ( bSpeed<0 && b_Phase<abs(bSpeed)  ) {
      cp5.getController("b_Phase").setValue( (b_Phase+(bSpeed*timeDelta)+1)%1 );
    } else {
      cp5.getController("b_Phase").setValue( (b_Phase+(bSpeed*timeDelta))%1 );
    }


    float xSpacing = 5;
    float xWidth   = (w-xSpacing)/numOutputs;

    for ( int i=0; i<numOutputs; i++ )
    {
      PVector colour = getValue( i*(1/(float)numOutputs) );
      fill( colour.x*255, colour.y*255, colour.z*255 );
      rect( (xSpacing)+x+(i*xWidth), y-110, xWidth-xSpacing, 90 );
      colours[i] = color( colour.x*255, colour.y*255, colour.z*255 );
    }
  }


  void initialise( int _x, int _y, int _w )
  {
    x = _x;
    y = _y;
    w = max(_w, 500);

    lastFrame = millis();

    colours = new color[ numOutputs ];
    for ( int i=0; i<numOutputs; i++ )
    {
      colours[i] = color( 0, 0, 0 );
    }

    Group gradientGroup = cp5.addGroup( "group_Gradient" )
      .setLabel( "Cosine_Gradient" )
      .setPosition( x, y )
      .setWidth( w );

    CosineGradientCanvas canvas = (CosineGradientCanvas)gradientGroup.addCanvas( new CosineGradientCanvas() );

    int xPos     = 10;
    int yPos     = canvas.gradientEndY+25;
    int sliderH  = 20;
    int sliderW  = w-60;
    int ySpacing = sliderH+5;

    cp5.addSlider( "r_Bias" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 1 )
      .setValue( r_Bias );    

    yPos += ySpacing;

    cp5.addSlider( "r_Amp" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 1 )
      .setValue( r_Amp );

    yPos += ySpacing;

    cp5.addSlider( "r_Freq" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 3 )
      .setValue( r_Freq );

    yPos += ySpacing;

    cp5.addSlider( "r_Phase" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 1 )
      .setValue( r_Phase );

    yPos += ySpacing *1.3;

    cp5.addSlider( "g_Bias" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 1 )
      .setValue( g_Bias );

    yPos += ySpacing;

    cp5.addSlider( "g_Amp" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 1 )
      .setValue( g_Amp );

    yPos += ySpacing;

    cp5.addSlider( "g_Freq" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 3 )
      .setValue( g_Freq );

    yPos += ySpacing;

    cp5.addSlider( "g_Phase" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 1 )
      .setValue( g_Phase );

    yPos += ySpacing *1.3;

    cp5.addSlider( "b_Bias" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 1 )
      .setValue( b_Bias );

    yPos += ySpacing;

    cp5.addSlider( "b_Amp" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 1 )
      .setValue( b_Amp );

    yPos += ySpacing;

    cp5.addSlider( "b_Freq" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 3 )
      .setValue( b_Freq );

    yPos += ySpacing;

    cp5.addSlider( "b_Phase" )
      .setPosition( xPos, yPos )
      .setSize( sliderW, sliderH )
      .setGroup( gradientGroup )
      .setRange( 0, 1 )
      .setValue( b_Phase );

    yPos += ySpacing*1.5;

    int buttonW = sliderW/5;

    cp5.addButton( "Randomise_all" )
      .setPosition( (w/2)-(buttonW*1.5)-10, yPos )
      .setSize( buttonW, sliderH )
      .setGroup( gradientGroup );

    cp5.addButton( "Randomise_curves" )
      .setPosition( (w/2)-(buttonW*0.5), yPos )
      .setSize( buttonW, sliderH )
      .setGroup( gradientGroup );

    cp5.addButton( "Randomise_speed" )
      .setPosition( (w/2)+(buttonW*0.5)+10, yPos )
      .setSize( buttonW, sliderH )
      .setGroup( gradientGroup );

    yPos += ySpacing*1.5;

    cp5.addButton( "Reset_r_speed" )
      .setPosition( xPos, yPos )
      .setSize( sliderW/5, sliderH )
      .setGroup( gradientGroup );

    cp5.addSlider( "r_Speed" )
      .setPosition( xPos+(sliderW/5)+10, yPos )
      .setSize( sliderW-(sliderW/5)-10, sliderH )
      .setGroup( gradientGroup )
      .setRange( -1, 1 )
      .setValue(0);

    yPos += ySpacing;

    cp5.addButton( "Reset_g_speed" )
      .setPosition( xPos, yPos )
      .setSize( sliderW/5, sliderH )
      .setGroup( gradientGroup );

    cp5.addSlider( "g_Speed" )
      .setPosition( xPos+(sliderW/5)+10, yPos )
      .setSize( sliderW-(sliderW/5)-10, sliderH )
      .setGroup( gradientGroup )
      .setRange( -1, 1 )
      .setValue(0);

    yPos += ySpacing;

    cp5.addButton( "Reset_b_speed" )
      .setPosition( xPos, yPos )
      .setSize( sliderW/5, sliderH )
      .setGroup( gradientGroup );

    cp5.addSlider( "b_Speed" )
      .setPosition( xPos+(sliderW/5)+10, yPos )
      .setSize( sliderW-(sliderW/5)-10, sliderH )
      .setGroup( gradientGroup )
      .setRange( -1, 1 )
      .setValue(0);

    
    yPos += ySpacing * 1.5;
     
    int curvePresetX = (w/2)-(sliderW/4)-120;
    int speedPresetX = (w/2)+10;
    
    cp5.addTextfield( "Curves Preset Name" )
      .setPosition( curvePresetX, yPos )
      .setSize( sliderW/4, sliderH )
      .setLabel( "" )
      .setGroup( gradientGroup )
      .setAutoClear( false );
      
    cp5.addBang("saveCurvesPreset")
     .setPosition(curvePresetX+(sliderW/4)+5,yPos)
     .setGroup( gradientGroup )
     .setSize( 105,sliderH)
     .setLabel( "Save Curves Preset" )
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     
    cp5.addTextfield( "Speed Preset Name" )
      .setPosition( speedPresetX, yPos )
      .setSize( sliderW/4, sliderH )
      .setLabel( "" )
      .setGroup( gradientGroup )
      .setAutoClear( false );
      
    cp5.addBang("saveSpeedPreset")
     .setPosition(speedPresetX+(sliderW/4)+5,yPos)
     .setGroup( gradientGroup )
     .setSize( 105,sliderH)
     .setLabel( "Save Speed Preset" )
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
    
    yPos += ySpacing ;
            
    cp5.addScrollableList("curvePresetList")
     .setPosition( curvePresetX , yPos)
     .setGroup( gradientGroup )
     .setSize(sliderW/4, 100)
     .setLabel( "Curve Presets" )
     .setBarHeight(20)
     .setItemHeight(20)
     .setType(ScrollableList.DROPDOWN)
     .close();
    
    cp5.addBang("loadCurvePreset")
     .setPosition(curvePresetX+(sliderW/4)+5,yPos)
     .setGroup( gradientGroup )
     .setSize( 105,sliderH)
     .setLabel( "Load Curves Preset" )
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
     
    cp5.addScrollableList("speedPresetList")
     .setPosition( speedPresetX , yPos)
     .setGroup( gradientGroup )
     .setSize(sliderW/4, 100)
     .setLabel( "Speed Presets" )
     .setBarHeight(20)
     .setItemHeight(20)
     .setType(ScrollableList.DROPDOWN)
     .close();
    
    cp5.addBang("loadSpeedPreset")
     .setPosition(speedPresetX+(sliderW/4)+5,yPos)
     .setGroup( gradientGroup )
     .setSize( 105,sliderH)
     .setLabel( "Load Speed Preset" )
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
     ;
     
    updatePresets();
    
    h        = yPos+sliderH+10;
    canvas.w = w;
    canvas.h = h;


    cp5.getProperties().addSet("curves");
    cp5.getProperties().addSet("speed");

    cp5.getProperties().move(cp5.getController( "r_Bias"  ), "default", "curves");
    cp5.getProperties().move(cp5.getController( "r_Amp"   ), "default", "curves");
    cp5.getProperties().move(cp5.getController( "r_Freq"  ), "default", "curves");
    cp5.getProperties().move(cp5.getController( "r_Phase" ), "default", "curves");

    cp5.getProperties().move(cp5.getController( "g_Bias"  ), "default", "curves");
    cp5.getProperties().move(cp5.getController( "g_Amp"   ), "default", "curves");
    cp5.getProperties().move(cp5.getController( "g_Freq"  ), "default", "curves");
    cp5.getProperties().move(cp5.getController( "g_Phase" ), "default", "curves");

    cp5.getProperties().move(cp5.getController( "b_Bias"  ), "default", "curves");
    cp5.getProperties().move(cp5.getController( "b_Amp"   ), "default", "curves");
    cp5.getProperties().move(cp5.getController( "b_Freq"  ), "default", "curves");
    cp5.getProperties().move(cp5.getController( "b_Phase" ), "default", "curves");

    cp5.getProperties().move(cp5.getController( "r_Speed"  ), "default", "speed");
    cp5.getProperties().move(cp5.getController( "g_Speed"  ), "default", "speed");
    cp5.getProperties().move(cp5.getController( "b_Speed"  ), "default", "speed");
  }
}


void keyPressed()
{
  if ( key == 'p' )
  {
    if( outputColours == null ){
      outputColours = createWriter( "colours " +year()+"-" +month()+ "-" +day()+ " " +hour()+ "h" +minute()+ "m" +second()+  "s.txt" );
    }
    for ( int i=0; i<cosineGradient.numOutputs; i++ )
    {
      outputColours.print( (String)hex(cosineGradient.colours[i]).substring( 2 ) + " " );
    }
    outputColours.println("");
    outputColours.flush();
  }
}


class CosineGradientCanvas extends Canvas
{
  int w;
  int h;

  int graphY = 10;
  int graphH = 120;

  int gradientStartY = graphY+graphH+10;
  int gradientEndY   = gradientStartY+30;


  public void setup( PGraphics pg ) 
  {
    println("Setting up CosineGradientCanvas");
  }

  public void draw( PGraphics pg ) 
  {
    int uiBorder = 10;
    int uiWidth  = w-(uiBorder*2);

    // Draw dropdown background
    pg.fill( 0 );
    pg.rect( 0, 0, w, h );

    // Draw graph background
    pg.fill( 100 );
    pg.rect( uiBorder, graphY, uiWidth, graphH );

    for ( int i=0; i<uiWidth; i++ )
    {
      PVector colour = cosineGradient.getValue( i/(float)uiWidth );

      // Draw gradient
      pg.stroke( colour.x*255, colour.y*255, colour.z*255);
      pg.line( uiBorder+i, gradientStartY, uiBorder+i, gradientEndY);

      // Draw graphs
      pg.stroke(255, 0, 0);
      pg.point( uiBorder+i, graphY+graphH-(colour.x*graphH) );
      pg.stroke(0, 255, 0);
      pg.point( uiBorder+i, graphY+graphH-(colour.y*graphH) );
      pg.stroke(0, 0, 255);
      pg.point( uiBorder+i, graphY+graphH-(colour.z*graphH) );
    }
  }
}

/*
 *  ControlP5 callback methods
 */
 
public void r_Speed( float value ) {
  cosineGradient.rSpeed = value * -0.1;
}

public void g_Speed( float value ) {
  cosineGradient.gSpeed = value * -0.1;
}

public void b_Speed( float value ) {
  cosineGradient.bSpeed = value * -0.1;
}


public void Reset_r_speed( float value ) {
  cp5.getController("r_Speed").setValue(0);
}

public void Reset_g_speed( float value ) {
  cp5.getController("g_Speed").setValue(0);
}

public void Reset_b_speed( float value ) {
  cp5.getController("b_Speed").setValue(0);
}


public void Randomise_all( float val ) {
  randomiseSpeedVals();
  randomiseCurveVals();
}

public void Randomise_speed( float val ) {
  randomiseSpeedVals();
}

public void Randomise_curves( float val ) {
  randomiseCurveVals();
}

public void randomiseSpeedVals()
{
  cp5.getController("r_Speed").setValue(  random( -1, 1 ) );
  cp5.getController("g_Speed").setValue(  random( -1, 1 ) );
  cp5.getController("b_Speed").setValue(  random( -1, 1 ) );
}


public void randomiseCurveVals()
{
  float biasMin  = 0.3;
  float biasMax  = 0.7;
  
  float ampMin   = 0.1;
  float ampMax   = 0.5;
  
  float freqMin  = 0.5;
  float freqMax  = 2;
  
  cp5.getController( "r_Bias"  ).setValue( random( biasMin, biasMax ) );
  cp5.getController( "r_Amp"   ).setValue( random( ampMin,  ampMax  ) );
  cp5.getController( "r_Freq"  ).setValue( random( freqMin, freqMax ) );
  cp5.getController( "r_Phase" ).setValue( random( 0,       1       ) );
  
  cp5.getController( "g_Bias"  ).setValue( random( biasMin, biasMax ) );
  cp5.getController( "g_Amp"   ).setValue( random( ampMin,  ampMax  ) );
  cp5.getController( "g_Freq"  ).setValue( random( freqMin, freqMax ) );
  cp5.getController( "g_Phase" ).setValue( random( 0,       1       ) );
  
  cp5.getController( "b_Bias"  ).setValue( random( biasMin, biasMax ) );
  cp5.getController( "b_Amp"   ).setValue( random( ampMin,  ampMax  ) );
  cp5.getController( "b_Freq"  ).setValue( random( freqMin, freqMax ) );
  cp5.getController( "b_Phase" ).setValue( random( 0,       1       ) );
}

/*
 *   Preset load/save methods
 */
 
public void curvePresetList( int n )
{
  curvePreset = n;
  println( "Curve Preset " +n+ " selected : " +cp5.get( ScrollableList.class, "curvePresetList" ).getItem(n).get( "name" ) );
}

public void speedPresetList( int n )
{
  speedPreset = n;
  println( "Speed Preset " +n+ " selected : " +cp5.get( ScrollableList.class, "speedPresetList" ).getItem(n).get( "name" ) );
}


public void loadCurvePreset(  )
{
  if( curvePreset == -1 ) {
    println( "No curve preset selected to load" );
  }
  else {
    String presetName = (String)cp5.get( ScrollableList.class, "curvePresetList" ).getItem(curvePreset).get( "name" );
    println( "Loading Curve Preset " +curvePreset+ "  : " +presetName );
    cp5.get(Textfield.class,"Curves Preset Name").clear();
    cp5.get(Textfield.class,"Curves Preset Name").setValue( presetName );
    cp5.get(Textfield.class,"Curves Preset Name").setUpdate(true);
    cp5.loadProperties( "presets/curves/" +presetName+ ".json" );
  }
}

public void saveSpeedPreset(  )
{
  println( "Saving speed preset : " + cp5.get(Textfield.class,"Speed Preset Name").getText());
  cp5.saveProperties( "presets/speed/"+(String)cp5.get(Textfield.class,"Speed Preset Name").getText() , "speed");
  updatePresets();
}

public void loadSpeedPreset(  )
{
  if( speedPreset == -1 ) {
    println( "No speed preset selected to load" );
  }
  else {
    String presetName = (String)cp5.get( ScrollableList.class, "speedPresetList" ).getItem(speedPreset).get( "name" );
    println( "Loading Speed Preset " +curvePreset+ "  : " +presetName );
    cp5.get(Textfield.class,"Speed Preset Name").clear();
    cp5.get(Textfield.class,"Speed Preset Name").setValue( presetName );
    cp5.get(Textfield.class,"Speed Preset Name").setUpdate(true);
    cp5.loadProperties( "presets/speed/" +presetName+ ".json" );
  }
}

public void saveCurvesPreset(  )
{
  println( "Saving curve preset : " + cp5.get(Textfield.class,"Curves Preset Name").getText());
  cp5.saveProperties( "presets/curves/"+(String)cp5.get(Textfield.class,"Curves Preset Name").getText() , "curves");
  updatePresets();
}


void updatePresets()
{
  println( "Updating presets" );
  
  List curvePresets = getCurvePresets();
  if( curvePresets != null ) {
    ScrollableList curvesList = (ScrollableList)cp5.getController("curvePresetList");
    curvesList.clear();
    curvesList.addItems( curvePresets );
  }
  else {
    println( "No Curves Presets found" );
  }
  
  List speedPresets = getSpeedPresets();
  if( speedPresets != null ) {
    ScrollableList speedList = (ScrollableList)cp5.getController("speedPresetList");
    speedList.clear();
    speedList.addItems( speedPresets );
  }
  else {
    println( "No Curves Presets found" );
  }
   
}

public List getCurvePresets()
{
  return Arrays.asList( filesInDirectory( sketchPath("")+"presets/curves" ) );
}

public List getSpeedPresets()
{
  return Arrays.asList( filesInDirectory( sketchPath("")+"presets/speed" ) );
}


public String[] filesInDirectory( String dir )
{
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    for( int i=0; i<names.length; i++ )
    {
      names[i] = names[i].substring( 0, names[i].length()-5 );
    }
    return names;
  } else {
    return new String[]{};
  }
}