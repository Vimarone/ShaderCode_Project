Shader "Learn/ExampleOneShader"
{
    Properties
    {
        _mainTex("Main Texture", 2D) = "black" {}
        _subTex("Sub Texture", 2D) = "white" {}
        [HDR]_color("Color", Color) = (1, 1, 1, 1)
        _interPolationVal("Interpolation Value", Range(0, 1)) = 0.5
        _mainBrightNDark("Main Bright & Dark", Range(-1, 1)) = 0
        _subBrightNDark("Sub Bright & Dark", Range(-1, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _mainTex;
        sampler2D _subTex;
        fixed4 _color;
        float _interPolationVal;
        float _mainBrightNDark;
        float _subBrightNDark;

        struct Input
        {
            float2 uv_mainTex;
            float2 uv_subTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 color1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed4 color2 = tex2D(_subTex, IN.uv_subTex);

            o.Emission = lerp(saturate(color1.rgb + _mainBrightNDark), saturate(color2.rgb + _subBrightNDark), 1 - _interPolationVal) * _color.rgb;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
