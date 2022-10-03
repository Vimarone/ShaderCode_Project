Shader "Learn/NormalMapSampleShader"
{
    Properties
    {
        _mainTex("Main Texture", 2D) = "white"{}
        _normalTex("Normal Map", 2D) = "bump"{}
        _occlusionTex("Occlusion Map", 2D) = "bump" {}
        _metallicTex("Metallic Map", 2D) = "bump" {}
        //_metallic("Metallic", Range(0, 1)) = 0
        _smoothness("Smoothness", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float2 uv_mainTex;
            float2 uv_normalTex;
            float2 uv_occlusionTex;
            float2 uv_metallicTex;
        };

        sampler2D _mainTex;
        sampler2D _normalTex;
        sampler2D _occlusionTex;
        sampler2D _metallicTex;
        //half _metallic;
        float _smoothness;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex)); // UnpackNormal 필수
            fixed4 occ1 = tex2D(_occlusionTex, IN.uv_occlusionTex);
            fixed4 met1 = tex2D(_metallicTex, IN.uv_metallicTex);

            o.Albedo = tex1.rgb;
            o.Normal = nor1;
            o.Metallic = met1;  //_metallic;
            o.Smoothness = _smoothness;
            o.Occlusion = occ1;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
