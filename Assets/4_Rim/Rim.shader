// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Frag/Rim"
{
    Properties
    {
        _Scale ("Scale", Range(1, 10)) = 5
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _Scale;
            struct v2f
            {
                float4 pos: POSITION;
                float3 normal: TEXCOORD0;
                float3 vertex: TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.vertex = v.vertex;
                return o;
            }

            fixed4 frag(v2f i): COLOR
            {
                float3 N = mul(i.normal, (float3x3)unity_WorldToObject);
                N = normalize(N);
                float3 worldPos = mul(unity_ObjectToWorld, i.vertex).xyz;
                float3 V = _WorldSpaceCameraPos.xyz - worldPos;
                V = normalize(V);
                float bright = 1 - saturate(dot(N, V));
                bright = pow(bright, _Scale);
                return fixed4(1, 1, 1, 1) * bright;
            }
            ENDCG
            
        }
    }
}
