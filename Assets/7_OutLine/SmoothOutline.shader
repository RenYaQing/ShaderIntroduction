Shader "Custom/7_OutLine/SmoothOutline"
{
    Properties
    {
        _Color ("Main Color", color) = (0.5, 0.5, 0.5, 1)
        _MainTex ("Texture", 2D) = "white" { }
        _OutlineColor ("OutlineColor", Color) = (1, 1, 1, 1)
        _OutlineWidth ("OutlineWidth", Range(1, 5)) = 1
    }
    CGINCLUDE
    #include "UnityCG.cginc"
    struct appdata
    {
        float4 vertex: POSITION;
        float3 normal: NORMAL;
    };
    struct v2f
    {
        float4 pos: POSITION;
    };
    float _OutlineWidth;
    float4 _OutlineColor;
    v2f vert(appdata v)
    {
        v.vertex.xyz *= _OutlineWidth;
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);
        return o;
    }
    ENDCG
    
    SubShader
    {
        Tags{"Queue"="Transparent"}
        pass
        {
            ZWrite Off
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            half4 frag(v2f i): COLOR
            {
                return _OutlineColor;
            }
            ENDCG
        }
        pass
        {
            ZWrite On
            Material
            {
                Diffuse[_Color]
                Ambient[_Color]
            }
            Lighting On
            SetTexture[_MainTex]
            {
                ConstantColor[_Color]
            }
            SetTexture[_MainTex]
            {
                Combine previous * primary DOUBLE
            }
        }
    }
    FallBack "Diffuse"
}
