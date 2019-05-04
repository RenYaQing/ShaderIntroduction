// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sbin/vf36_warp"
{
    Properties { }
    SubShader
    {
        pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct v2f
            {
                float4 pos: POSITION;
                fixed4 col: COLOR;
            };
            v2f vert(appdata_base base)
            {
                v2f o;
                //rotate
                /* // float angle = length(base.vertex) + _Time.w;
                float angle = _Time.w;
                //rotate matrix around y
                float4x4 m = {
                    float4(cos(angle), 0, sin(angle), 0),
                    float4(0, 1, 0, 0),
                    float4(-sin(angle), 0, cos(angle), 0),
                    float4(0, 0, 0, 1)
                };
                float4 rotateVertex = mul(m, base.vertex);
                //optimize
                float x = cos(angle) * base.vertex.x + sin(angle) * base.vertex.z;
                float z = cos(angle) * base.vertex.z - sin(angle) * base.vertex.x;
                base.vertex.x = x;
                base.vertex.z = z;
                */
                //wave
                float angle = base.vertex.z + _Time.y;
                float x = (sin(angle) / 8 + 0.5) * base.vertex.x;
                float y = (sin(angle) / 2 + 0.5) + base.vertex.y;
                base.vertex.x = x;
                // base.vertex.y = y;
                o.pos = UnityObjectToClipPos(base.vertex);
                float posY = o.pos.y / o.pos.w;
                o.col = fixed4(0.3, 0.3, 0.5, 1);
                return o;
            }
            
            fixed4 frag(v2f IN): SV_TARGET
            {
                return IN.col;
            }
            ENDCG
            
        }
    }
}