Shader "Custom/Frag/ClockFragColor"
{
    Properties
    {
        _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        
        _SecondColor ("SecondColor", Color) = (1, 1, 1, 1)
        
        _Center ("Center", Range(-0.5, 0.5)) = 0
        _Fill ("Fill", Range(0, 1)) = 0
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
            float _Fill;
            
            struct appdata
            {
                float4 vertex: POSITION;
            };
            
            struct v2f
            {
                float4 pos: POSITION;
                float x: TEXCOORD0;
                float z: TEXCOORD1;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.x = v.vertex.x;
                o.z = v.vertex.z;
                return o;
            }
            
            fixed4 frag(v2f i): COLOR
            {
                if (_Fill < 0.5)
                {
                    //将_Fill 0-0.5的值，映射给0-pie，只处理左半边，右半边全部按照 _MainColor处理
                    float compare = (_Fill * 2 - 0.5) * 3.1415926;
                    float theta = -atan(i.z / i.x);
                    if (theta > compare)
                    {
                        return _MainColor;
                    }
                    if(i.x > 0)
                    {
                        return _MainColor;
                    }
                }
                else
                {
                    //将_Fill 0.5-1映射给0-pie，左半边按照 _SecondColor处理
                    float compare = ((_Fill - 0.5) * 2 - 0.5) * 3.1415926;
                    float theta = -atan(i.z / i.x);
                    if(i.x > 0)
                    {
                        if(theta > compare)
                        {
                            return _MainColor;
                        }
                    }
                }
                return _SecondColor;
                
                // float d = i.y - _Center;//d小于0，则y在center的下方
                // d = d / abs(d);//正负1
                // d = d / 2 + 0.5;//(0,1)
                // return lerp(_MainColor, _SecondColor, d);
            }
            ENDCG
            
        }
    }
}
