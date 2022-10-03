Shader "Learn/VertexColorSampleShader"
{
    Properties
    {
        _mainTex ("Main Texture", 2D) = "white" {}
        _redTex("Red Texture", 2D) = "white" {}
        _greenTex("Green Texture", 2D) = "white" {}
        _blueTex("Blue Texture", 2D) = "white" {}
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
            float2 uv_redTex;
            float2 uv_greenTex;
            float2 uv_blueTex;
            float4 color:COLOR; // model의 vertexColor를 받아오는 방법
        };

        sampler2D _mainTex;
        sampler2D _redTex;
        sampler2D _greenTex;
        sampler2D _blueTex;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed4 color1 = tex2D(_redTex, IN.uv_redTex);
            fixed4 color2 = tex2D(_greenTex, IN.uv_greenTex);
            fixed4 color3 = tex2D(_blueTex, IN.uv_blueTex);

            //o.Albedo = tex1.rgb * IN.color.rgb; // 곱하면 어둡게, 더하면 밝게
            //o.Emission = IN.color.rgb;

            o.Emission = lerp(tex1, color1.rgb, IN.color.r);
            o.Emission = lerp(o.Emission, color2.rgb, IN.color.g);
            o.Emission = lerp(o.Emission, color3.rgb, IN.color.b);
            

            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
