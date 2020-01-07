Shader "UIMask/OvilMask1" {
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_ChangeFloat("¸Ä±äÑÕÉ«",Range(0,1)) = 1.0
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Radius("Radius",float) = 1.5
		_Center_X("Center_X", float) = 0.95
		_Center_Y("Center_Y", float) = 0.5
			_Sharp("Sharp", float) = 10.0
	}
		SubShader
		{
			Pass
		{
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
			/*float x = i.uv.x*(_ScreenParams.x / _ScreenParams.y);
			float y = i.uv.y;


			float dis = sqrt((x - _Center_X)*(x - _Center_X) + (y - _Center_Y)*(y - _Center_Y));
			if (dis > _Radius)
			{
				float4 col = (0, 0, 0, 0);
				return col;
			}

			return tex2D(_MainTex, i.uv);*/

			_Center_X = _Center_X * (_ScreenParams.x / _ScreenParams.y);
		float x = i.uv.x*(_ScreenParams.x / _ScreenParams.y);
		float y = i.uv.y;

		float dis = sqrt((x - _Center_X)*(x - _Center_X) + (y - _Center_Y)*(y - _Center_Y));
		float t = _Radius - dis;
		float rt = 0.5f + _tanh(t * _Sharp) * 0.5f;
		float col = float4(rt, rt, rt, rt);
		return tex2D(_MainTex, i.uv) * col;

		}
			ENDCG
		}
		}
			Fallback off
}