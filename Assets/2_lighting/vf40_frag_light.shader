// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sbin/vf40_frag_light"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        
        pass
        {
            tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            float4 _Diffuse;
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            struct v2f
            {
                float4 pos: POSITION;
                fixed4 worlNormal: TEXCOORD0;
            };
            v2f vert(a2v a)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(a.vertex);
                o.worlNormal = mul(float4(a.normal, 0), unity_WorldToObject);
                return o;
            }
            
            fixed4 frag(v2f f): COLOR
            {
                float4 worldLight = normalize(_WorldSpaceLightPos0);
                float nDot = saturate(dot(normalize(f.worlNormal), worldLight));
                float4 diffuse = _LightColor0 * nDot + UNITY_LIGHTMODEL_AMBIENT;
                return diffuse;
            }
            ENDCG
            
        }
    }
}