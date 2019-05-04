Shader "Custom/Frag/BlendFragColor"
{
    Properties
    {
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        
        _SecondColor ("SecondColor", Color) = (1, 1, 1, 1)
        
        _Center ("Center", Range(-0.51, 0.51)) = 0
        _R ("R", Range(0, 0.5)) = 0.2
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            float4 _MainColor;
            float4 _SecondColor;
            float _Center;
            float _R;
            
            struct appdata
            {
                float4 vertex: POSITION;
            };
            
            struct v2f
            {
                float4 pos: POSITION;
                float y: TEXCOORD0;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.y = v.vertex.y;
                return o;
            }
            
            fixed4 frag(v2f i): COLOR
            {
                float d = i.y - _Center;//d小于0，则y在center的下方
                float s = abs(d);
                d = d / s;//正负1
                float rate = saturate(s / _R);
                d *= rate;
                d = d / 2 + 0.5;//(0,1)
                return lerp(_MainColor, _SecondColor, d);
            }
            ENDCG
            
        }
    }
}
