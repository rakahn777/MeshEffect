Shader "Unlit/Transformation3"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Mask ("Texture", 2D) = "white" {}
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
            sampler2D _Mask;
            float4 _Mask_ST;
            float4x4 _TransformationMatrix;
            
            float4 ApplyManipulator(float4 position, float4 mask)
            {
                float4 manipulatedPos = mul(_TransformationMatrix, position);
                
                manipulatedPos = lerp(position, manipulatedPos, mask);
                
                return manipulatedPos;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float4 mask = tex2Dlod(_Mask, float4(o.uv, 0, 0));
                
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                float4 manipulatedPos = ApplyManipulator(o.worldPos, mask);
                
                o.worldPos = manipulatedPos;
                float4 objectPos = mul(unity_WorldToObject, o.worldPos);
                
                o.vertex = UnityObjectToClipPos(objectPos);
                
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
