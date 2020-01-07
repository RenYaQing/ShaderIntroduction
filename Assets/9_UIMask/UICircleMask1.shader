Shader "UIMask/CircleMask1" 
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Radius("Radius",Range(-0.5,1)) = -0.5
		_Center_X("Center_X", float) = 0.95
		_Center_Y("Center_Y", float) = 0.5
		_Sharp("Sharp", float) = 10.0
	}
	SubShader
	{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off ZWrite Off ZTest Always
		Pass
		{
			/*ZTest Always Cull Off ZWrite Off
			Fog{ Mode off }*/
			CGPROGRAM
			#pragma vertex vert_img        
			#pragma fragment frag             
			#include "UnityCG.cginc"  

			fixed4 _Color;
			sampler2D _MainTex;
			float1 _ChangeFloat;
			float _Radius;
			float _Center_X;
			float _Center_Y;
			float _Sharp;

			float _tanh(float x)
			{
				return 2.0f / (1.0f + exp(-2.0f * x)) - 1.0f;
			}

			float4 frag(v2f_img i) : COLOR
			{
				_Center_X = _Center_X * (_ScreenParams.x / _ScreenParams.y);
				float x = i.uv.x*(_ScreenParams.x / _ScreenParams.y);
				float y = i.uv.y;

				float dis = sqrt((x - _Center_X)*(x - _Center_X) + (y - _Center_Y)*(y - _Center_Y));
				float t =  dis- _Radius;
				float rt = 0.5f + _tanh (t * _Sharp) * 0.5f;
				//float4 col = float4(rt, rt, rt, rt);
				float4 col = float4(_Color.x, _Color.y, _Color.z, rt);
				return tex2D(_MainTex, i.uv) * col;
				//return col;

			}
			ENDCG
		}
	}
		Fallback off
}