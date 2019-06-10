// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

Shader "Custom/8_Tex2D/LightMap"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
                float2 lightmap_uv: TEXCOORD1;
            };

            struct v2f
            {
                float2 uv: TEXCOORD0;
                float2 lightmap_uv: TEXCOORD1;
                float4 vertex: POSITION;
            };

            sampler2D _MainTex;
            // sampler2D unity_Lightmap;
            float4 _MainTex_ST;
            // float4 unity_LightmapST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.lightmap_uv = v.lightmap_uv * unity_LightmapST.xy + unity_LightmapST.zw;
                return o;
            }

            fixed4 frag(v2f i): Color
            {
                fixed4 col;
                col = tex2D(_MainTex, i.uv);
                col *= UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmap_uv) * 2;
                return col;
            }
            ENDCG
            
        }
    }
}
