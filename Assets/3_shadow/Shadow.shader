// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sbin/Shadow"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
        _Specular ("Specular", color) = (1, 1, 1, 1)
        _Shininess ("Shininess", Range(1, 64)) = 8
    }
    SubShader
    {
        // pass
        // {
        //     tags { "LightMode" = "ShadowCaster" }
        // }
        pass
        {
            tags { "LightMode" = "ForwardBase" }
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase
            float4 _Diffuse;
            float4 _Specular;
            float _Shininess;
            struct a2v
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
            };
            struct v2f
            {
                float4 pos: POSITION;
                fixed4 col: COLOR;
                // LIGHTING_COORDS(0,1)
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
                o.col = diffuse + UNITY_LIGHTMODEL_AMBIENT + _Diffuse;
                float3 V = WorldSpaceViewDir(a.vertex);
                V = normalize(V);
                float3 H = normalize(V + worldLight);
                float3 specularScale = pow(saturate(dot(H, V)), _Shininess);
                o.col.rgb += _Specular * specularScale;
                float3 worldPos = mul(unity_ObjectToWorld, a.vertex).xyz;
                o.col.rgb += Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                unity_LightColor[0].rgb, unity_LightColor[1].rgb,
                unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                unity_4LightAtten0,
                worldPos, worldNormal);
                
                return o;
            }
            
            fixed4 frag(v2f f): COLOR
            {
                return f.col;
            }
            ENDCG
            
        }
    }
    fallback "Diffuse"
}