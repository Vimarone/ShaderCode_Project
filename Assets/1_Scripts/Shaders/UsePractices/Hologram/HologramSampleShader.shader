Shader "LearnHologram/HologramSampleShader"
{
    Properties
    {
        _baseTex("Albedo (RGB)", 2D) = "white" {}
        _normalTex("Normal map", 2D) = "bump"{}
        _rimColor("Rim Color", Color) = (1, 1, 1, 1)
        _rimPower("Rim Power", Range(1, 10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Transparent" }
        
        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade
        #pragma target 3.0

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

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 baseTex = tex2D(_baseTex, IN.uv_baseTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));

            float rim = dot(nor1, IN.viewDir) * 0.5 + 0.5;
            rim = pow(1 - rim, _rimPower);

            o.Normal = nor1;
            o.Emission = baseTex.rgb + _rimColor.rgb;
            o.Alpha = rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
