Shader "Custom/ClockPaintSurface"
{
    Properties
    {
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        _SecondColor ("SecondColor", Color) = (1, 1, 1, 1)
        _Center ("Center", Range(-2.73, 2.73)) = 0
        _R ("R", Range(0, 0.5)) = 0.2
        _Fill ("Fill", Range(0, 1)) = 0

        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _Glossiness ("Smoothness", Range(0, 1)) = 0.5
        _Metallic ("Metallic", Range(0, 1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        float4 _MainColor;
        float4 _SecondColor;
        float _Center;
        float _R;
        float _Fill;
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard vertex:vert fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;

        struct Input
        {
            float2 uv_MainTex;
            float x;
            float z;
        };
        void vert(inout appdata_full v, out Input o)
        {
            o.uv_MainTex = v.texcoord.xy;
            o.x = v.vertex.x;
            o.z = v.vertex.z;
        }

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;

            if (_Fill < 0.5)
            {
                //将_Fill 0-0.5的值，映射给0-pie，只处理左半边，右半边全部按照 _MainColor处理
                float compare = (_Fill * 2 - 0.5) * 3.1415926;
                float theta = -atan(IN.z / IN.x);
                if (theta > compare)
                {
                    o.Albedo *= _MainColor;
                }
                if(IN.x > 0)
                {
                    o.Albedo *=  _MainColor;
                }
            }
            else
            {
                //将_Fill 0.5-1映射给0-pie，左半边按照 _SecondColor处理
                float compare = ((_Fill - 0.5) * 2 - 0.5) * 3.1415926;
                float theta = -atan(IN.z / IN.x);
                if (IN.x > 0)
                {
                    if(theta > compare)
                    {
                        o.Albedo *=  _MainColor;
                    }
                }
            }
            o.Albedo *= _SecondColor;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}
