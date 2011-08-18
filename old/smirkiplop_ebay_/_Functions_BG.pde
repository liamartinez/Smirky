void drawSurface() {
  for (int x = 0; x < 640; x++) {
    for (int y = 0; y < 480; y++) {

      int p = (640 * y) + x; 

      // calculate the percentage values for each level
      if (depth[p] > Threshold1)
      {
        surface.pixels[p] = level1.pixels[p];
      }

      else if (depth[p] < Threshold1 && depth[p] > Threshold2)
      {
        surface.pixels[p] = level2.pixels[p];
      }

      else if (depth[p] < Threshold2 && depth[p] > Threshold3)
      {
        surface.pixels[p] = level3.pixels[p];
      }

      else if (depth[p] < Threshold3)
      {
        surface.pixels[p] = level4.pixels[p];
      }


      // all else fails -- do this        
      else
      {
        surface.pixels[p] = level1.pixels[p];
      }
    }
  }
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------

void drawSurfaceBlended() {


  for (int x = 0; x < 640; x++) {
    for (int y = 0; y < 480; y++) {

      int p = (640 * y) + x;           

      // is this a black pixel in the image mask?

      color maskcolor = imgMask.pixels[p];
      float redness = red(maskcolor);
      if (enableMask && redness > 50)
      {
        surface.pixels[p] = color (0, 0, 0);
      }


      else if (depth[p] < Threshold1 && depth[p] > Threshold2)
      {
        // map between level 1 and level 2
        float percent_level1 = map(depth[p], Threshold2, Threshold1, 0, 1); 
        float percent_level2 = 1 - percent_level1;

        // extract color values from the first level
        float level1_red   = red(level1.pixels[p]);
        float level1_green = green(level1.pixels[p]);
        float level1_blue  = blue(level1.pixels[p]);

        // extract color values from the second level
        float level2_red   = red(level2.pixels[p]);
        float level2_green = green(level2.pixels[p]);
        float level2_blue  = blue(level2.pixels[p]);

        // construct average pixel colors based on our mapped weights value
        float newred   = ( level1_red*percent_level1   + level2_red*percent_level2 ) / 2;
        float newgreen = ( level1_green*percent_level1 + level2_green*percent_level2 ) / 2;
        float newblue  = ( level1_blue*percent_level1  + level2_blue*percent_level2 ) / 2;

        // construct a new color
        color newcolor = color( newred, newgreen, newblue );

        // assign that color to this pixel
        surface.pixels[p] = newcolor;
      }

      else if (depth[p] < Threshold2 && depth[p] > Threshold3)
      {
        // map between level 1 and level 2
        float percent_level1 = map(depth[p], Threshold3, Threshold2, 0, 1); 
        float percent_level2 = 1 - percent_level1;

        // extract color values from the first level
        float level1_red   = red(level2.pixels[p]);
        float level1_green = green(level2.pixels[p]);
        float level1_blue  = blue(level2.pixels[p]);

        // extract color values from the second level
        float level2_red   = red(level3.pixels[p]);
        float level2_green = green(level3.pixels[p]);
        float level2_blue  = blue(level3.pixels[p]);

        // construct average pixel colors based on our mapped weights value
        float newred   = ( level1_red*percent_level1   + level2_red*percent_level2 ) / 2;
        float newgreen = ( level1_green*percent_level1 + level2_green*percent_level2 ) / 2;
        float newblue  = ( level1_blue*percent_level1  + level2_blue*percent_level2 ) / 2;

        // construct a new color
        color newcolor = color( newred, newgreen, newblue );

        // assign that color to this pixel
        surface.pixels[p] = newcolor;
      }

      else if (depth[p] < Threshold3 && depth[p] > Threshold4)
      {
        // map between level 1 and level 2
        float percent_level1 = map(depth[p], Threshold4, Threshold3, 0, 1); 
        float percent_level2 = 1 - percent_level1;

        // extract color values from the first level
        float level1_red   = red(level3.pixels[p]);
        float level1_green = green(level3.pixels[p]);
        float level1_blue  = blue(level3.pixels[p]);

        // extract color values from the second level
        float level2_red   = red(level4.pixels[p]);
        float level2_green = green(level4.pixels[p]);
        float level2_blue  = blue(level4.pixels[p]);

        // construct average pixel colors based on our mapped weights value
        float newred   = ( level1_red*percent_level1   + level2_red*percent_level2 ) / 2;
        float newgreen = ( level1_green*percent_level1 + level2_green*percent_level2 ) / 2;
        float newblue  = ( level1_blue*percent_level1  + level2_blue*percent_level2 ) / 2;

        // construct a new color
        color newcolor = color( newred, newgreen, newblue );

        // assign that color to this pixel
        surface.pixels[p] = newcolor;
      }

      // all else fails -- do this        
      else
      {
        surface.pixels[p] = level1.pixels[p];
      }
    }
  }
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------
