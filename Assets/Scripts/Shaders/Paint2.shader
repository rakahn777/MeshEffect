Shader "Unlit/Paint2"
{
    Properties
    {
        _Strength ("Strength", Float) = 1
    }
    SubShader
    {
        BlendOp [_BlendOp]
        Blend One One

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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
                float3 worldPos : TEXCOORD1;
            };

            float4 _Center;
            float _Hardness;
            float _Radius;
            float _Strength;
            
            float SphereMask(float3 position, float3 center, float radius, float hardness)
            {
                return 1 - saturate((distance(position, center) - radius) / (1 - hardness));
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;
                float4 uv = float4(0, 0, 0, 1);
                uv.xy = float2(1, _ProjectionParams.x) * (v.uv.xy * float2(2, 2) - float2(1, 1));
                //uv.xy = float2(1, _ProjectionParams.x) * (v.uv.xy);
                o.vertex = uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float falloff = SphereMask(i.worldPos, _Center, _Radius, _Hardness);
                return float4(falloff * _Strength, 0, 0, 0);
            }
            
            ENDCG
        }
    }
}
