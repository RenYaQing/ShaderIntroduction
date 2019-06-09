// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/7_UV/BlendAnim"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i): SV_Target
            {
                float2 uv = i.uv;
                float offset = 0.05 * sin(uv * 5 + _Time.x * 2);
                uv += offset;
                fixed4 col = tex2D(_MainTex, uv);

                uv = i.uv;
                uv -= offset * 1.5;
                fixed4 col1 = tex2D(_MainTex, uv);
                return(col + col1) / 1.5;
            }
            ENDCG
            
        }
    }
}
