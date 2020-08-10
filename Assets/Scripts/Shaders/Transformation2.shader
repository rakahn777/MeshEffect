Shader "Unlit/Transformation2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4x4 _TransformationMatrix;
            float4 _Center;
            float _Hardness;
            float _Radius;
            
            float SphereMask(float3 position, float3 center, float radius, float hardness)
            {
                return 1 - saturate((distance(position, center) - radius) / (1 - hardness));
            }
            
            float4 ApplyManipulator(float4 position)
            {
                float4 manipulatedPos = mul(_TransformationMatrix, position);
                
                float falloff = SphereMask(position, _Center.xyz, _Radius, _Hardness);
                manipulatedPos = lerp(position, manipulatedPos, falloff);
                
                return manipulatedPos;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                float4 manipulatedPos = ApplyManipulator(o.worldPos);
                o.worldPos = manipulatedPos;
                float4 objectPos = mul(unity_WorldToObject, o.worldPos);
                
                o.vertex = UnityObjectToClipPos(objectPos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
