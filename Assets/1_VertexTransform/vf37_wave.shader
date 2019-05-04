// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sbin/vf37_wave"
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
                //wave
                base.vertex.y += 0.2 * sin(base.vertex.x + base.vertex.z + _Time.y);
                base.vertex.y += 0.2 * sin(base.vertex.x - base.vertex.z + _SinTime.y);
                o.pos = UnityObjectToClipPos(base.vertex);
                float posY = o.pos.y / o.pos.w;
                o.col = fixed4(base.vertex.y, base.vertex.y / 8 + 0.5, base.vertex.y / 8 + 0.5, 1);
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