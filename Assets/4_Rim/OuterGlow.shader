// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Frag/OuterGlow"
{
    Properties
    {
        _Scale ("Scale", Range(1, 10)) = 5
        _Outer ("Outer", Range(0, 2)) = 0.2
        _MainColor ("MainColor", color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        Pass
        {
            blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _Scale;
            float _Outer;
            fixed4 _MainColor;
            struct v2f
            {
                float4 pos: POSITION;
                float3 normal: TEXCOORD0;
                float3 vertex: TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v.vertex.xyz += v.normal * _Outer;//每个顶点按法线方向向外扩展一定距离
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
                // float bright = 1 - saturate(dot(N, V));//向内衰减
                float bright = saturate(dot(N, V));//向外衰减，越外越透明
                bright = pow(bright, _Scale);
                // return fixed4(1, 1, 1, 1) * bright;//边缘成黑色
                return fixed4(_MainColor.rgb, bright);
            }
            ENDCG
            
        }
        //=====================
        Pass
        {
            blendop RevSub
            blend dstalpha one
            ZWrite Off
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct v2f
            {
                float4 pos: POSITION;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i): COLOR
            {
                return fixed4(1, 1, 1, 1);
            }
            ENDCG
        }
        //=====================
        Pass
        {
            // blend Zero One //本通道不显示，上个通道完全显示
            blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
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