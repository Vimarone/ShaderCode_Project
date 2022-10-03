Shader "LearnLambert/LambertTestShader"
{
    Properties
    {
        _mainTex("Albedo (RGB)", 2D) = "white" {}
        _normalTex("Normal map", 2D) = "bump"{}
        _gloss ("Gloss", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert
        #pragma target 3.0


        struct Input
        {
            float2 uv_mainTex;
            float2 uv_normalTex;
        };

        sampler2D _mainTex;
        sampler2D _normalTex;
        fixed _gloss;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));
            o.Albedo = tex1.rgb;
            o.Normal = nor1;
            o.Gloss = _gloss;
            o.Alpha = tex1.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
