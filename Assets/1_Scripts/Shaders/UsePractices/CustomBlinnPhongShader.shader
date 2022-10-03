Shader "LearnBlinn/CustomBlinnPhongShader"
{
    Properties
    {
        _mainTex("Albedo (RGB)", 2D) = "white" {}
        _normalTex("Normal map", 2D) = "bump"{}
        _specColor("Specular Color", Color) = (1, 1, 1, 1)
        _specularPow("Specular Power", Range(10, 200)) = 100
        //_gloss("Gloss", Range(0, 1)) = 0
        _glossTex("Gloss Map", 2D) = "white" {}
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }

            CGPROGRAM
            #pragma surface surf CustomBlinnPhong// noambient

            struct Input
            {
                float2 uv_mainTex;
                float2 uv_normalTex;
                float2 uv_glossTex;
            };

            sampler2D _mainTex;
            sampler2D _normalTex;
            fixed4 _specColor;
            half _specularPow;
            //fixed _gloss;
            sampler2D _glossTex;

            UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_INSTANCING_BUFFER_END(Props)

            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex);
                fixed4 tex2 = tex2D(_glossTex, IN.uv_glossTex);
                fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));
                o.Albedo = tex1.rgb;
                o.Normal = nor1;
                o.Gloss = tex2; //_gloss;
                o.Alpha = tex1.a;
            }

            float4 LightingCustomBlinnPhong(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) 
            {
                float4 final;

                //// 전반적인 라이팅 계산
                //float ndotl = saturate(dot(s.Normal, lightDir));

                // half vector를 사용하는 경우
                float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
                float3 diffColor = ndotl * s.Albedo * _LightColor0.rgb * atten;

                

                // Specular Lighting 계산 (H dot N)
                float3 halfVec = normalize(lightDir + viewDir);
                float spec = saturate(dot(halfVec, s.Normal));
                spec = pow(spec, _specularPow);
                float3 specColor = spec * _specColor.rgb * s.Gloss;

                // 최종 색 결정
                final.rgb = diffColor + specColor;
                final.a = s.Alpha;

                return final;
            }
            ENDCG
        }
            FallBack "Diffuse"
}
