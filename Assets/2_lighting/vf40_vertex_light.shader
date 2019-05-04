// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sbin/vf40_vertex_light"
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
                fixed4 col: COLOR;
            };
            v2f vert(a2v a)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(a.vertex);
                float3 worldLight = normalize(_WorldSpaceLightPos0);
                float3 normal = normalize(a.normal);
                float3 worldNormal = mul(float4(normal, 0), unity_WorldToObject).xyz;
                worldNormal = normalize(worldNormal);
                float4 diffuse = _LightColor0 * saturate(dot(worldLight, worldNormal));
                // half-lambert
                // float4 diffuse = _LightColor0 * (0.5 * dot(worldLight, worldNormal) + 0.5);
                o.col = diffuse + UNITY_LIGHTMODEL_AMBIENT;
                return o;
            }
            
            fixed4 frag(v2f f): COLOR
            {
                return f.col;
            }
            ENDCG
            
        }
    }
}