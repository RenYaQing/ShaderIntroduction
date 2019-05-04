// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sbin/vf31" {
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
				float4 pos:POSITION;
				fixed4 col:COLOR;
			};
			float4x4 mvp;
			float4x4 rm;
			float4x4 sm;
			v2f vert(appdata_base base)
			{
				v2f OUT;
				// OUT.pos=UnityObjectToClipPos(base.vertex);
				OUT.pos = mul(mvp,base.vertex);
				float4x4 mvp = UNITY_MATRIX_MVP;
				float4x4 mvpr = mul(mvp, rm);
				float4x4 mvprs = mul(mvpr, sm);
				OUT.pos = mul(mvprs, base.vertex);
				if(base.vertex.x == 0.5 && base.vertex.y == 0.5 && base.vertex.z == 0.5)
				{
					OUT.col = fixed4(_SinTime.w/2 + 0.5f, _CosTime.x/2 + 0.5f, _SinTime.x/2 + 0.5f, 1);
				}
				else
				{
					OUT.col = fixed4(0, 0, 1, 1);
				}
				return OUT;
			}

			fixed4 frag(v2f IN):SV_TARGET
			{
				return IN.col;
			}
			ENDCG
		}
	}
}