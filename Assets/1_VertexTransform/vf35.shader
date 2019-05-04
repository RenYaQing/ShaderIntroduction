// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sbin/vf35"
{
    Properties
    {
        _Radius ("Radius", Range(1, 3)) = 1
        _MoveX ("MoveX", Range(-3, 3)) = 1
    }
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
            float _Radius;
            float _MoveX;
            
            v2f vert(appdata_base base)
            {
                float4 worldPos = mul(unity_ObjectToWorld, base.vertex);
                float2 xy = worldPos.xz;
                v2f o;
                // float2 xy = base.vertex.xz;
                
                float displacement = _Radius - length(xy - float2(_MoveX, 0));
                float d = displacement > 0?displacement: 0;
                float4 v = float4(base.vertex.x, d, base.vertex.z, base.vertex.w);
                o.pos = UnityObjectToClipPos(v);
                float posY = o.pos.y / o.pos.w;
                o.col = fixed4(v.y, v.y, v.y, 1);
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