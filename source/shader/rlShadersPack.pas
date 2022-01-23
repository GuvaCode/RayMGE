unit rlShadersPack;

{$mode ObjFPC}{$H+}

interface
const LE = #10; // line end;

const base_lighting_vs = '#version 330' + LE +
           // Input vertex attributes
           'in vec3 vertexPosition;'    + LE +
           'in vec2 vertexTexCoord;'    + LE +
           'in vec3 vertexNormal;'      + LE +
           'in vec4 vertexColor;'       + LE +

           // Input uniform values
           'uniform mat4 mvp;'          + LE +
           'uniform mat4 matModel;'     + LE +
           'uniform mat4 matNormal;'    + LE +

           // Output vertex attributes (to fragment shader)
           'out vec3 fragPosition;'     + LE +
           'out vec2 fragTexCoord;'     + LE +
           'out vec4 fragColor;'        + LE +
           'out vec3 fragNormal;'       + LE +

           // NOTE: Add here your custom variables
           'void main()'                + LE +
           '{'                          + LE +
           // Send vertex attributes to fragment shader
           'fragPosition = vec3(matModel*vec4(vertexPosition, 1.0));' + LE +
           'fragTexCoord = vertexTexCoord;'                           + LE +
           'fragColor = vertexColor;'   + LE +
           'fragNormal = normalize(vec3(matNormal*vec4(vertexNormal, 1.0)));' + LE +

           // Calculate final vertex position
           'gl_Position = mvp*vec4(vertexPosition, 1.0);'             + LE +
           '}';

const lighting_fs = '#version 330'      + LE +
            // Input vertex attributes (from vertex shader)
           'in vec3 fragPosition;'                 + LE +
           'in vec2 fragTexCoord;'                 + LE +
           'in vec4 fragColor;'                    + LE +
           'in vec3 fragNormal;'                   + LE +

            // Input uniform values
           'uniform sampler2D texture0;'           + LE +
           'uniform vec4 colDiffuse;'              + LE +

            // Output fragment color
           'out vec4 finalColor;'                  + LE +

           // NOTE: Add here your custom variables
           '#define     MAX_LIGHTS              4' + LE +
           '#define     LIGHT_DIRECTIONAL       0' + LE +
           '#define     LIGHT_POINT             1' + LE +

           'struct MaterialProperty {'             + LE +
               'vec3 color;'                       + LE +
               'int useSampler;'                   + LE +
               'sampler2D sampler;'                + LE +
           '};'                                    + LE +

           'struct Light {'                        + LE +
               'int enabled;'                      + LE +
               'int type;'                         + LE +
               'vec3 position;'                    + LE +
               'vec3 target;'                      + LE +
               'vec4 color;'                       + LE +
           '};'                                    + LE +

           // Input lighting values
           'uniform Light lights[MAX_LIGHTS];'     + LE +
           'uniform vec4 ambient;'                 + LE +
           'uniform vec3 viewPos;'                 + LE +

           'void main()'                           + LE +
           '{'                                     + LE +
               // Texel color fetching from texture sampler
               'vec4 texelColor = texture(texture0, fragTexCoord);' + LE +
               'vec3 lightDot = vec3(0.0);'                         + LE +
               'vec3 normal = normalize(fragNormal);'               + LE +
               'vec3 viewD = normalize(viewPos - fragPosition);'    + LE +
               'vec3 specular = vec3(0.0);'                         + LE +

               // NOTE: Implement here your fragment shader code

               'for (int i = 0; i < MAX_LIGHTS; i++)'                              + LE +
               '{'                                                                 + LE +
                   'if (lights[i].enabled == 1)'                                   + LE +
                   '{'                                                             + LE +
                       'vec3 light = vec3(0.0);'                                   + LE +

                       'if (lights[i].type == LIGHT_DIRECTIONAL)'                  + LE +
                       '{'                                                         + LE +
                           'light = -normalize(lights[i].target - lights[i].position);' + LE +
                       '}'                                                         + LE +

                       'if (lights[i].type == LIGHT_POINT)'                        + LE +
                       '{'                                                         + LE +
                           'light = normalize(lights[i].position - fragPosition);' + LE +
                       '}'                                                         + LE +

                       'float NdotL = max(dot(normal, light), 0.0);'               + LE +
                       'lightDot += lights[i].color.rgb*NdotL;'                    + LE +

                       'float specCo = 0.0;'                                       + LE +
                       'if (NdotL > 0.0) specCo = pow(max(0.0, dot(viewD, reflect(-(light), normal))), 16.0);' + LE + // 16 refers to shine
                       'specular += specCo;'                                       + LE +
                   '}'                                                             + LE +
               '}'                                                                 + LE +

               'finalColor = (texelColor*((colDiffuse + vec4(specular, 1.0))*vec4(lightDot, 1.0)));' + LE +
               'finalColor += texelColor*(ambient/10.0)*colDiffuse;' + LE +

               // Gamma correction
               'finalColor = pow(finalColor, vec4(1.0/2.2));' + LE +
           '}';

 const fog_fs = '#version 330'  + LE +
      // Input vertex attributes (from vertex shader)
      'in vec2 fragTexCoord;'  + LE +
      'in vec4 fragColor;'     + LE +
      'in vec3 fragPosition;'  + LE +
      'in vec3 fragNormal;'    + LE +
      // Input uniform values
      'uniform sampler2D texture0;' + LE +
      'uniform vec4 colDiffuse;'    + LE +
      // Output fragment color
      'out vec4 finalColor;'        + LE +
      // NOTE: Add here your custom variables
      '#define     MAX_LIGHTS              4' + LE +
      '#define     LIGHT_DIRECTIONAL       0' + LE +
      '#define     LIGHT_POINT             1' + LE +

      'struct MaterialProperty {'   + LE +
          'vec3 color;'             + LE +
          'int useSampler;'         + LE +
          'sampler2D sampler;'      + LE +
      '};'                          + LE +
      'struct Light {'              + LE +
          'int enabled;'            + LE +
          'int type;'               + LE +
          'vec3 position;'          + LE +
          'vec3 target;'            + LE +
          'vec4 color;'             + LE +
      '};'                          + LE +

      // Input lighting values
      'uniform Light lights[MAX_LIGHTS];' + LE +
      'uniform vec4 ambient;'             + LE +
      'uniform vec3 viewPos;'             + LE +
      'uniform float fogDensity;'         + LE +
      'void main()'                       + LE +
      '{'                                 + LE +
          'vec4 texelColor = texture(texture0, fragTexCoord);' + LE +
          'vec3 lightDot = vec3(0.0);'                         + LE +
          'vec3 normal = normalize(fragNormal);'               + LE +
          'vec3 viewD = normalize(viewPos - fragPosition);'    + LE +
          'vec3 specular = vec3(0.0);'                         + LE +
          'for (int i = 0; i < MAX_LIGHTS; i++)'               + LE +
          '{'                                                  + LE +
              'if (lights[i].enabled == 1)'                    + LE +
              '{'                                              + LE +
                  'vec3 light = vec3(0.0);'                    + LE +
                  'if (lights[i].type == LIGHT_DIRECTIONAL) light = -normalize(lights[i].target - lights[i].position);' + LE +
                  'if (lights[i].type == LIGHT_POINT) light = normalize(lights[i].position - fragPosition);' + LE +
                  'float NdotL = max(dot(normal, light), 0.0);'+ LE +
                  'lightDot += lights[i].color.rgb*NdotL;'     + LE +
                  'float specCo = 0.0;'                        + LE +
                  'if (NdotL > 0.0) specCo = pow(max(0.0, dot(viewD, reflect(-(light), normal))), 16.0); // Shine: 16.0' + LE +
                  'specular += specCo;'                        + LE +
              '}'                                              + LE +
          '}'                                                  + LE +

          'finalColor = (texelColor*((colDiffuse + vec4(specular,1))*vec4(lightDot, 1.0)));' + LE +
          'finalColor += texelColor*(ambient/10.0);'                                         + LE +
          'finalColor = pow(finalColor, vec4(1.0/2.2));'                                     + LE +
          'float dist = length(viewPos - fragPosition);'                                     + LE +
          'const vec4 fogColor = vec4(0.5, 0.5, 0.5, 1.0);'                                  + LE +
          'float fogFactor = 1.0/exp((dist*fogDensity)*(dist*fogDensity));'                  + LE +
          'fogFactor = clamp(fogFactor, 0.0, 1.0);'                                          + LE +
          'finalColor = mix(fogColor, finalColor, fogFactor);'                               + LE +
      '}';

implementation

end.


