Shader "Learn/BasicTextureShader"
{
    Properties
    {
        _mainTex("Main Texture", 2D) = "black" {}
        _subTex("Sub Texture", 2D) = "white" {}
        [HDR]_color("Main Color", Color) = (1, 1, 1, 1)
        _sliderVal("Slider Value", Range(0, 1)) = 0.5
        //_brightNDark("Brightness & Darkness", Range(-1, 1)) = 0
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
            float2 uv_subTex;
        };

        sampler2D _mainTex;
        sampler2D _subTex;
        fixed4 _color;
        float _sliderVal;
        //float _brightNDark;


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 color1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed4 color2 = tex2D(_subTex, IN.uv_subTex);
            //o.Emission = color1.rgb * 0.3 + color2.rgb * 0.7;       // 보간
            o.Emission = lerp(color1.rgb, color2.rgb, _sliderVal) * _color.rgb;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
