// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sbin/vf32" {
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
			float dis;
			float r;
			v2f vert(appdata_base base)
			{
				v2f OUT;
				OUT.pos=UnityObjectToClipPos(base.vertex);
				float posX = OUT.pos.x/OUT.pos.w;
				
				if(posX > dis && posX < dis + r)
				{
					OUT.col = fixed4(1, 0, 0, 1);
				}
				else
				{
					OUT.col = fixed4(posX / 2 + 0.5 , posX/2 + 0.5, posX / 2 , 1);
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