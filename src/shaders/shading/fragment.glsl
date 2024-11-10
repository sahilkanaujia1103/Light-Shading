uniform vec3 uColor;
varying vec3 vNormal;
varying vec3 vPosition;
 

vec3 ambientLight (vec3 lightColor, float lightIntensity){
    return( lightColor*lightIntensity);
}

vec3 directionlLight (vec3 lightColor, float lightIntensity,vec3 normal,vec3 lightPosition,vec3 viewDirection,float specularPower){
   
   vec3 lightDirection=normalize(lightPosition);
   vec3 lightReflection=reflect(-lightDirection,normal);
 
// shading
   float shading=dot(normal,lightDirection);
   shading=max(0.0,shading);
   //specular
   float specular=-dot(lightReflection,viewDirection);
   specular=max(0.0,specular);
   specular=pow(specular,specularPower);


    return( lightColor*lightIntensity*(shading+specular));
}
vec3 pointLight (vec3 lightColor, float lightIntensity,vec3 normal,vec3 lightPosition,vec3 viewDirection,float specularPower,vec3 position,float lightDecay){
   vec3 lightDelta=lightPosition-position;
   float lightDistance=length(lightDelta);
   vec3 lightDirection=normalize(lightDelta);
   vec3 lightReflection=reflect(-lightDirection,normal);
 
// shading
   float shading=dot(normal,lightDirection);
   shading=max(0.0,shading);
   //specular
   float specular=-dot(lightReflection,viewDirection);
   specular=max(0.0,specular);
   specular=pow(specular,specularPower);
   float decay=1.0-lightDistance*lightDecay;
   decay=max(0.0,decay);
   return( lightColor*lightIntensity*decay*(shading+specular));
  
}
void main()
{
    vec3 normal=normalize(vNormal);
    vec3 viewDirection=vPosition-cameraPosition;
    viewDirection=normalize(viewDirection);
    vec3 color = uColor;
    vec3 light=vec3(0.0);
    float specularPower=20.0;
    light+=ambientLight(vec3(1.0),0.03);
    light+=directionlLight(vec3(0.1,0.1,1.0),1.0,normal,vec3(0.0,0.0,3.0),viewDirection,specularPower);
    light+=pointLight(vec3(1.0,0.1,0.1),1.0,normal,vec3(0.0,2.5,0.0),viewDirection,specularPower,vPosition,0.25);
    light+=pointLight(vec3(0.1,1.0,0.5),1.0,normal,vec3(2.0,2.0,2.0),viewDirection,specularPower,vPosition,0.2);
    color*=light;

    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}