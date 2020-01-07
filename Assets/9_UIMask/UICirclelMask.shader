// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UIMask/CircleMask"
{
	Properties
	{
		_Color("Main Color", Color) = (0,0,0,0)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Radius("ViewRadius", float) = 0.0
	}

		SubShader
		{
			Blend SrcAlpha OneMinusSrcAlpha
		Cull Off ZWrite Off ZTest Always
			Pass
			{
				CGPROGRAM
					#include "UnityCG.cginc"
					#pragma vertex vert_img
					#pragma fragment frag			

					fixed4 _Color;
					sampler2D _MainTex;
					float _Radius;

					float4 frag(v2f_img i) : COLOR
					{
						float2 centerPoint = float2(_ScreenParams.x / 2, _ScreenParams.y / 2);
						
						float4 d = distance(i.pos.xy, centerPoint) > _Radius ?  tex2D(_MainTex, i.uv): tex2D(_MainTex, i.uv) * _Color ;
						return d;
					}
				ENDCG
			}
		}
		Fallback off
}
