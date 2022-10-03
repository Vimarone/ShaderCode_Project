Shader "LearnRimLight/CustomRimLightShader"
{
    Properties
    {
        _baseTex ("Albedo (RGB)", 2D) = "white"{}
        _normalTex("Normal map", 2D) = "bump"{}
        _rimColor("Rim Color", Color) = (1, 1, 1, 1)
        _rimPower("Rim Power", Range(1, 10)) = 3
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf CustomLambert// noambient
        #pragma target 3.0

        struct Input
        {
            float2 uv_baseTex;
            float2 uv_normalTex;
                
        };

        sampler2D _baseTex;
        sampler2D _normalTex;
        fixed4 _rimColor;
        half _rimPower;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 baseTex = tex2D(_baseTex, IN.uv_baseTex);
            o.Albedo = baseTex.rgb;
            o.Normal = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));
            o.Alpha = baseTex.a;
        }

        float4 LightingCustomLambert(SurfaceOutput s, float3 lightDir, float3 viewDir, float3 atten)
        {
            float4 final;

            //float ndotl = saturate(dot(s.Normal, lightDir));
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            float3 albedo = ndotl * s.Albedo * _LightColor0.rgb * atten;

            float rim = dot(s.Normal, viewDir);
            float3 emission = pow(1 - rim, _rimPower) * _rimColor.rgb;

            final.rgb = albedo + emission;
            final.a = s.Alpha;
                
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}