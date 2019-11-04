module Entities.TextureShader exposing (PlayerUniformTextured, UniformTextured, Varying, Vertex, box, fragmentShader, texturedFragmentShader, texturedVertexShader, vertexShader)

import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL exposing (..)
import WebGL.Texture exposing (..)


type alias Varying =
    { texturePos : Vec2 }


type alias Vertex =
    { position : Vec2 }


type alias UniformTextured a =
    { a
        | texture : Texture
        , textureSize : Vec2
        , textureOffset : Vec2
        , frameSize : Vec2
    }


type alias PlayerUniformTextured =
    { frameSize : Vec2
    , offset : Vec3
    , texture : Texture
    , mirror : Float
    , textureSize : Vec2
    , textureOffset : Vec2
    , scale : Float
    }


texturedVertexShader : Shader Vertex PlayerUniformTextured Varying
texturedVertexShader =
    [glsl|
        precision mediump float;
        attribute vec2 position;
        uniform vec3 offset;
        uniform float mirror;
        uniform float scale;
        uniform vec2 frameSize;
        varying vec2 texturePos;
        void main () {
          vec2 clipSpace = ((position * frameSize * scale  + offset.xy ) * vec2 (1,1.77778)    - 960.0 ) ;
          gl_Position = vec4(clipSpace.x, -clipSpace.y, offset.z, 960);
          texturePos = vec2((position.x - 0.5) * mirror + 0.5, position.y) * frameSize;
        }
    |]


texturedFragmentShader : Shader {} (UniformTextured a) Varying
texturedFragmentShader =
    [glsl|
        precision mediump float;
        uniform sampler2D texture;
        uniform vec2 textureSize;
        uniform vec2 textureOffset;
        uniform vec2 frameSize;
        varying vec2 texturePos;
        void main () {
          vec2 pos = vec2(
            float(int(texturePos.x) - int(texturePos.x) / int(frameSize.x) * int(frameSize.x)),
            float(int(texturePos.y) - int(texturePos.y) / int(frameSize.y) * int(frameSize.y))
          );
          vec2 offset = (pos + textureOffset ) / textureSize  ;
          gl_FragColor = texture2D(texture, offset);
          if (gl_FragColor.a <= 0.1) discard;
        }
    |]


box : Mesh Vertex
box =
    WebGL.triangles
        [ ( Vertex (vec2 0 0)
          , Vertex (vec2 1 1)
          , Vertex (vec2 1 0)
          )
        , ( Vertex (vec2 0 0)
          , Vertex (vec2 0 1)
          , Vertex (vec2 1 1)
          )
        ]


type alias Uniforms =
    { color : Vec3
    , offset : Vec3
    , frameSize : Vec2
    , scale : Float
    }


vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
    [glsl|
        attribute vec2 position;
        uniform vec3 color;
        uniform vec3 offset;
        varying vec3 vcolor;
        uniform float scale;
        uniform vec2 frameSize;
        void main () {
          vec2 clipSpace = ((position * frameSize * scale  + offset.xy ) * vec2 (1,1.77778)    - 960.0 ) ;
          gl_Position = vec4(clipSpace.x, -clipSpace.y, offset.z, 960);
          vcolor = color;
        }
    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
    [glsl|
        precision mediump float;
        varying vec3 vcolor;
        void main () {
            gl_FragColor = vec4(vcolor, 1.0);
        }
    |]
