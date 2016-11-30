Shader "Hidden/VFX_0"
{
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Pass
		{
			Blend SrcAlpha One
			ZTest LEqual
			ZWrite Off
			Cull Off
			
			CGPROGRAM
			#pragma target 5.0
			
			#pragma vertex vert
			#pragma fragment frag
			
			#define VFX_LOCAL_SPACE
			
			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "HLSLSupport.cginc"
			#include "../VFXCommon.cginc"
			
			CBUFFER_START(outputUniforms)
				float outputUniform0;
			CBUFFER_END
			
			Texture2D outputSampler0Texture;
			SamplerState sampleroutputSampler0Texture;
			
			Texture2D gradientTexture;
			SamplerState samplergradientTexture;
			
			struct Attribute0
			{
				float lifetime;
			};
			
			struct Attribute1
			{
				float3 position;
				float age;
			};
			
			struct Attribute2
			{
				float2 size;
			};
			
			StructuredBuffer<Attribute0> attribBuffer0;
			StructuredBuffer<Attribute1> attribBuffer1;
			StructuredBuffer<Attribute2> attribBuffer2;
			StructuredBuffer<int> flags;
			
			struct ps_input
			{
				/*linear noperspective centroid*/ float4 pos : SV_POSITION;
				nointerpolation float4 col : COLOR0;
				float2 offsets : TEXCOORD0;
			};
			
			float4 sampleSignal(float v,float u) // sample gradient
			{
				return gradientTexture.SampleLevel(samplergradientTexture,float2(((0.9921875 * saturate(u)) + 0.00390625),v),0);
			}
			
			void VFXBlockFaceCameraPlane( inout float3 front,inout float3 side,inout float3 up)
			{
				float4x4 cameraMat = VFXCameraMatrix();
	front = -VFXCameraLook();
	side = cameraMat[0].xyz;
	up = cameraMat[1].xyz;
			}
			
			void VFXBlockSetColorGradientOverLifetime( inout float3 color,inout float alpha,float age,float lifetime,float Gradient)
			{
				float ratio = saturate(age / lifetime);
	float4 rgba = sampleSignal(Gradient,ratio);
	color = rgba.rgb;
	alpha = rgba.a;
			}
			
			void VFXBlockSubPixelAA( inout float alpha,float3 position,inout float2 size)
			{
				#ifdef VFX_WORLD_SPACE
	float clipPosW = mul(UNITY_MATRIX_VP,float4(position,1.0f)).w;
	#else
	float clipPosW = mul(UNITY_MATRIX_MVP,float4(position,1.0f)).w;
	#endif
	float minSize = clipPosW / (0.5f * min(UNITY_MATRIX_P[0][0] * _ScreenParams.x,-UNITY_MATRIX_P[1][1] * _ScreenParams.y)); // max size in one pixel
	float2 clampedSize = max(size,minSize);
	float fade = (size.x * size.y) / (clampedSize.x * clampedSize.y);
	alpha *= fade;
	size = clampedSize;
			}
			
			ps_input vert (uint id : SV_VertexID, uint instanceID : SV_InstanceID)
			{
				ps_input o;
				uint index = (id >> 2) + instanceID * 16384;
				if (flags[index] == 1)
				{
					Attribute0 attrib0 = attribBuffer0[index];
					Attribute1 attrib1 = attribBuffer1[index];
					Attribute2 attrib2 = attribBuffer2[index];
					
					float3 local_front = (float3)0;
					float3 local_side = (float3)0;
					float3 local_up = (float3)0;
					float3 local_color = (float3)0;
					float local_alpha = (float)0;
					
					VFXBlockFaceCameraPlane( local_front,local_side,local_up);
					VFXBlockSetColorGradientOverLifetime( local_color,local_alpha,attrib1.age,attrib0.lifetime,outputUniform0);
					VFXBlockSubPixelAA( local_alpha,attrib1.position,attrib2.size);
					
					float2 size = attrib2.size * 0.5f;
					o.offsets.x = 2.0 * float(id & 1) - 1.0;
					o.offsets.y = 2.0 * float((id & 2) >> 1) - 1.0;
					
					float3 position = attrib1.position;
					
					float2 posOffsets = o.offsets.xy;
					float3 cameraPos = mul(unity_WorldToObject,float4(_WorldSpaceCameraPos.xyz,1.0)).xyz; // TODO Put that in a uniform!
					float3 side = local_side;
					float3 up = local_up;
					
					position += side * (posOffsets.x * size.x);
					position += up * (posOffsets.y * size.y);
					o.offsets.xy = o.offsets.xy * 0.5 + 0.5;
					
					o.pos = mul (UNITY_MATRIX_MVP, float4(position,1.0f));
					o.col = float4(local_color.xyz,local_alpha);
				}
				else
				{
					o.pos = -1.0;
					o.col = 0;
				}
				
				return o;
			}
			
			struct ps_output
			{
				float4 col : SV_Target0;
			};
			
			ps_output frag (ps_input i)
			{
				ps_output o = (ps_output)0;
				
				float4 color = i.col;
				color *= outputSampler0Texture.Sample(sampleroutputSampler0Texture,i.offsets);
				
				o.col = color;
				return o;
			}
			
			ENDCG
		}
	}
	FallBack Off
}
