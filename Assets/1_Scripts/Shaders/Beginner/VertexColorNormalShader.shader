Shader "Learn/VertexColorNormalShader"
{
    Properties
    {
        [Header(Base Map)]
        _mainTex("Main Texture", 2D) = "white" {}
        _normalTex("Normal Map", 2D) = "bump"{}
        [Header(Sub Maps)]
        _redTex("Red Texture", 2D) = "white"{}
        _greenTex("Green Texture", 2D) = "white"{}
        _blueTex("Blue Texture", 2D) = "white"{}
        [Header(Parameters)]
        _gloss("Gloss Value", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 4.0

        struct Input
        {
            float2 uv_mainTex;
            float2 uv_normalTex;
            float2 uv_redTex;
            float2 uv_greenTex;
            float2 uv_blueTex;
            float4 color:COLOR;
        };

        sampler2D _mainTex;
        sampler2D _normalTex;
        sampler2D _redTex;
        sampler2D _greenTex;
        sampler2D _blueTex;
        half _gloss;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, float2(IN.uv_normalTex.x - _Time.y/3, IN.uv_normalTex.y + _Time.x)));
            fixed4 color1 = tex2D(_redTex, IN.uv_redTex);
            fixed4 color2 = tex2D(_greenTex, IN.uv_greenTex);
            fixed4 color3 = tex2D(_blueTex, IN.uv_blueTex);

            nor1 = lerp(nor1, o.Normal, IN.color.r);
            nor1 = lerp(nor1, o.Normal, IN.color.g);
            nor1 = lerp(nor1, o.Normal, IN.color.b);

            o.Albedo = lerp(tex1, color1.rgb, IN.color.r);
            o.Albedo = lerp(o.Albedo, color2.rgb, IN.color.g);
            o.Albedo = lerp(o.Albedo, color3.rgb, IN.color.b);
            o.Albedo *= 0.5;
            o.Normal = nor1;
            o.Smoothness = _gloss;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}