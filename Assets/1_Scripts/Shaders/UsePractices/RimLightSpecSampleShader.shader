Shader "LearnRimLight/RimLightSpecSampleShader"
{
    Properties
    {
        _baseTex("Albedo (RGB)", 2D) = "white"{}
        _normalTex("Normal map", 2D) = "bump"{}
        _rimColor("Rim Color", Color) = (1, 1, 1, 1)
        _rimPower("Rim Power", Range(1, 10)) = 3
        _SpecColor("Specular Color", Color) = (1, 1, 1, 1)
        _specularPow("Specular Power", Range(0, 10)) = 1
        _gloss("Gloss", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf BlinnPhong // noambient

        struct Input
        {
            float2 uv_baseTex;
            float2 uv_normalTex;
            float3 viewDir;
        };

        sampler2D _baseTex;
        sampler2D _normalTex;
        fixed4 _rimColor;
        float _rimPower;
        half _specularPow;
        fixed _gloss;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 baseTex = tex2D(_baseTex, IN.uv_baseTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));
            o.Normal = nor1;
            float rim = dot(o.Normal, IN.viewDir);

            o.Albedo = baseTex.rgb + pow(1 - rim, _rimPower) * _rimColor.rgb;
            o.Specular = _specularPow;
            o.Gloss = _gloss;
            o.Alpha = baseTex.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
