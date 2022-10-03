Shader "LearnHologram/CustomHologramShader"
{
    Properties
    {
        _baseTex("Albedo (RGB)", 2D) = "white" {}
        _normalTex("Normal map", 2D) = "bump"{}
        _rimColor("Rim Color", Color) = (1, 1, 1, 1)
        _rimPower("Rim Power", Range(1, 10)) = 3
        _SpecColor("Specular Color", Color) = (1, 1, 1, 1)
        _specularPow("Specular Power", Range(10, 200)) = 100
        _gloss("Gloss", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf CustomBlinnPhong noambient alpha:fade
        #pragma target 3.0

        struct Input
        {
            float2 uv_baseTex;
            float2 uv_normalTex;
        };

        sampler2D _baseTex;
        sampler2D _normalTex;
        fixed4 _rimColor;
        float _rimPower;
        fixed4 _specColor;
        half _specularPow;
        half _gloss;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 baseTex = tex2D(_baseTex, IN.uv_baseTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));

            o.Normal = nor1;
            o.Emission = baseTex.rgb;
            o.Gloss = _gloss;
            o.Alpha = baseTex.a;
        }

        float4 LightingCustomBlinnPhong(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float3 DiffColor;
            float4 final;

            // Lambert
            float ndotl = dot(s.Normal, lightDir);
            DiffColor = ndotl * s.Emission * _LightColor0.rgb * atten;

            // Specular
            float3 specCol;
            float3 halfVec = normalize(lightDir + viewDir);
            float spec = saturate(dot(halfVec, s.Normal));
            spec = pow(spec, _specularPow);
            specCol = spec * _SpecColor.rgb * s.Gloss;

            //RimLight
            float rim = dot(s.Normal, viewDir);
            rim = pow(1 - rim, _rimPower);
            float3 rimColor = rim * _rimColor.rgb;

            // final
            final.rgb = DiffColor.rgb + rimColor.rgb +specCol.rgb;
            final.a = rim;
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}