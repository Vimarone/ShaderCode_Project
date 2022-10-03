Shader "LearnRimLight/RimLightSampleShader"
{
    Properties
    {
        //_mainTex ("Albedo (RGB)", 2D) = "white"{}
        _normalTex("Normal map", 2D) = "bump"{}
        _rimColor("Rim Color", Color) = (1, 1, 1, 1)
        _rimPower("Rim Power", Range(1, 10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert// noambient
        #pragma target 3.0

        struct Input
        {
            float2 uv_normalTex;
            float3 viewDir;
        };

        sampler2D _normalTex;
        fixed4 _rimColor;
        float _rimPower;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));
            o.Normal = nor1;
            float rim = dot(o.Normal, IN.viewDir);
            //o.Albedo = fixed3(1, 1, 1);
            o.Emission = pow(1 - rim, _rimPower) * _rimColor.rgb;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
