Shader "LearnRimLight/CustomRimLightSpecColorShader"
{
    Properties
    {
        _baseTex("Albedo (RGB)", 2D) = "white"{}
        _color("Main Color", Color) = (1, 1, 1, 1)
        _normalTex("Normal map", 2D) = "bump"{}
        _rimColor("Rim Color", Color) = (1, 1, 1, 1)
        _rimPower("Rim Power", Range(1, 10)) = 3
        _SpecColor("Specular Color", Color) = (1, 1, 1, 1)
        _specularPow("Specular Power", Range(10, 200)) = 10
        _gloss("Gloss", Range(0, 1)) = 1
        _brightNDark("Brightness & Darkness", Range(-1, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf CustomBlinnPhong

        struct Input
        {
            float2 uv_baseTex;
            float2 uv_normalTex;
        };

        sampler2D _baseTex;
        fixed4 _color;
        sampler2D _normalTex;
        fixed4 _rimColor;
        float _rimPower;
        half _specularPow;
        fixed _gloss;
        float _brightNDark;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 baseTex = tex2D(_baseTex, IN.uv_baseTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));
            o.Albedo = baseTex.rgb;
            o.Normal = nor1;
            o.Specular = _specularPow;
            o.Gloss = _gloss;
            o.Alpha = baseTex.a;
        }

        float4 LightingCustomBlinnPhong(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;

            float rim = dot(s.Normal, viewDir);
            float3 albedo = saturate(s.Albedo * _color.rgb + pow(1 - rim, _rimPower) * _rimColor.rgb + _brightNDark);

            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            float3 color = ndotl * albedo * _LightColor0.rgb * atten;

            float3 halfVec = normalize(lightDir + viewDir);
            float spec = saturate(dot(halfVec, s.Normal));
            spec = pow(spec, _specularPow);
            float3 specColor = spec * _SpecColor.rgb * s.Gloss;

            final.rgb = color + specColor;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
