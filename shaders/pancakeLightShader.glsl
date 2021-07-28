//Shader that is used for light
//Let's rework the whole fkn system so it works on pancake pixels :)
uniform vec4 lights[100];
uniform vec4 lightsColors[100];
uniform vec2 limits[100];
uniform vec2 camera;
uniform vec4 pancakeWindow;
uniform vec2 renderExtension;

float sigma(float a){
  if (a==0.0){
    return 0.0;
  }else{
    return a/abs(a);
  }
}

vec2 canvasToPancake(vec2 givenCoords){
  return vec2((givenCoords.x)*float(pancakeWindow.b+renderExtension.x*2.0) - camera.x, givenCoords.y*float(pancakeWindow.a + renderExtension.y*2.0) - camera.y);
}

vec2 pancakeToCanvas(vec2 givenCoords){
  return vec2((givenCoords.x + camera.x)/(pancakeWindow.b+renderExtension.x*2.0), (givenCoords.y + camera.y)/(pancakeWindow.a + renderExtension.y*2.0));
}

float calcDistance(vec2 pos1, vec2 pos2){
  return sqrt((pos1.x - pos2.x)*(pos1.x - pos2.x) + (pos1.y - pos2.y)*(pos1.y - pos2.y));
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{ vec4 texturecolor = Texel(tex, texture_coords);
  vec2 pancakeCoords = canvasToPancake(texture_coords);
  vec4 colorSum = vec4(0.0,0.0,0.0,0.0);
  float powerSum = 1.0;
  for (int i=0;i<100;i++){
    if (lights[i].a != 0.0){
      vec4 light = lights[i];
      vec2 lightPos = vec2(light.r + renderExtension.x, light.g + renderExtension.y);
      float dist = calcDistance(vec2(lightPos.x,lightPos.y), pancakeCoords);
      if (dist <= light.b){
        bool applyLight = texturecolor.a != 0.0;
        applyLight = true;
        if (applyLight){
          vec4 lightColor = lightsColors[i];
          float start = limits[i].x;
          float finish = limits[i].y;
          float lightStrength = start - (start - finish)*calcDistance(vec2(lightPos.x,lightPos.y), pancakeCoords)/light.b;
          if (lightColor.r == 1.0 && lightColor.g == 1.0 && lightColor.b == 1.0){
            powerSum = powerSum - lightStrength;
            colorSum = vec4(colorSum.r + (1.0 - lightColor.r)*lightStrength, colorSum.g + (1.0 - lightColor.g)*lightStrength, colorSum.b + (1.0 - lightColor.b)*lightStrength, 1.0);
          }else{
            powerSum = powerSum + lightStrength;
            colorSum = vec4(colorSum.r + lightColor.r*lightStrength, colorSum.g + lightColor.g*lightStrength, colorSum.b + lightColor.b*lightStrength, 1.0);
          }
        }

      }
    }
  }
  return vec4(colorSum.r,colorSum.g,colorSum.b, powerSum);
}
