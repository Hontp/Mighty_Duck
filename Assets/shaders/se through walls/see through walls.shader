﻿Shader "test/see through walls"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _colour("always visable colour",Color)=(0,0,0,0)
        
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100
        
        Pass
        {
        Cull off
        ZWrite off
        
        ZTest always
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
             
            struct appdata
            {
                float4 vertex : POSITION;
                
            };

            struct v2f
            {
                
                float4 vertex : SV_POSITION;
            };
            
            float4 _colour;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _colour;
            }
            
            ENDCG
             
        }
             
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                return col;
            }
            ENDCG
        }
    }
}
