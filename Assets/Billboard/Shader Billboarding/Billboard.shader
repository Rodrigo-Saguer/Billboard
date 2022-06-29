Shader "Unlit/Billboard"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[MaterialToggle] _Billboard("Bill Board", Float) = 1
		_ValueX("Value X", Float) = 0
		_ValueY("Value Y", Float) = 0
		_ValueZ("Value Z", Float) = 0

		_ValueXY("Value XY", Float) = 0
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};
			
			float _ValueX;
			float _ValueY;
			float _ValueZ;
			float _ValueXY;

			sampler2D _MainTex;
			float _Billboard;
			float4 _MainTex_ST;
			
			fixed4 TransformMatrix(fixed4 vertex) 
			{
				fixed4x4 _matrix = fixed4x4  
				(
					1, 0, 0, _ValueX,
					_ValueXY, 1, 0, _ValueY,
					0, 0, 1, _ValueZ,
					0, 0, 0, 0
				);

				return mul(_matrix, vertex);
			}

			v2f vert (float4 vertex : POSITION, float2 uv : TEXCOORD0)
			{
				v2f o;

                // Transforms a point from object space to the camera’s
                // clip space in homogeneous coordinates. 
                // This is the equivalent of mul(UNITY_MATRIX_MVP, float4(pos, 1.0)), and should be used in its place.
				// o.pos = UnityObjectToClipPos(vertex);     

				o.uv = uv.xy;    
                
				//Matrix
				// XX, YX, ZX, X
				// XY, YY, ZY, Y
				// XZ, YZ, ZZ, Z
				// 0,  0,  0,  0

                //MVP
                //M = Model Matrix
                //V = View Matrix
                //P = Projection Matrix
                          
				//Local -> M -> World -> V -> View -> P -> Clip -> Screen

				if (_Billboard == 1) 
				{
					// Detect the origin position of the world, using the model matrix
					float4 worldOrigin = mul(UNITY_MATRIX_M, float4(0, 0, 0, 1));

					// Transform the unity object to the view position, using a function called UnityObjectToViewPos() 
					// which is equivalent to multiplying the projection matrix.
					// The unity function uses a float3 so to use it as the source you must
					// transform from float3 to float4.

					float4 viewOrigin = float4(UnityObjectToViewPos(float3(0, 0, 0)), 1);  //mul(UNITY_MATRIX_P, float4(0,0,0,1));
					float4 worldPos = mul(UNITY_MATRIX_M, vertex);

					//float4 viewPos = mul(UNITY_MATRIX_V,worldPos);
					float4 viewPos = worldPos - worldOrigin + viewOrigin;

					float4 clipPos = mul(UNITY_MATRIX_P, viewPos);

					//float3 vpos = mul((float3x3)unity_ObjectToWorld, vertex.xyz);
					//float4 worldCoord = float4(unity_ObjectToWorld._m03, unity_ObjectToWorld._m13, unity_ObjectToWorld._m23, 1);
					//float4 viewPos = mul(UNITY_MATRIX_V, worldCoord) + float4(vpos, 0);
					//float4 outPos = mul(UNITY_MATRIX_P, viewPos);

					o.pos = clipPos;
				}
				else 
				{
					o.pos = UnityObjectToClipPos(TransformMatrix(vertex));     
				}

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}

			ENDCG
		}
	}
}