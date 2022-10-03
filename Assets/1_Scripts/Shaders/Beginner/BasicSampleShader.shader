Shader "Learn/BasicSampleShader"
{
    Properties
    {
        //_red1("Main Red Slider Value", Range(0, 1)) = 1
        //_green1("Main Green Slider Value", Range(0, 1)) = 1
        //_blue1("Main Blue Slider Value", Range(0, 1)) = 1
        //_red2("Sub Red Slider Value", Range(0, 1)) = 1
        //_green2("Sub Green Slider Value", Range(0, 1)) = 1
        //_blue2("Sub Blue Slider Value", Range(0, 1)) = 1
        [HDR]_color1("Main Color", Color) = (1, 1, 1, 1)
        _color2("Sub Color", Color) = (1, 1, 1, 1)
        _brightNDark("Brightness & Darkness", Range(-1, 1)) = 0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        //half _red1;
        //half _green1;
        //half _blue1;
        //half _red2;
        //half _green2;
        //half _blue2;
        fixed4 _color1;
        fixed4 _color2;
        float _brightNDark;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = saturate(_color1.rgb + _color2.rgb) + _brightNDark;

            //fixed4 color1 = fixed4(_red1, _green1, _blue1, 1);
            //fixed4 color2 = fixed4(_red2, _green2, _blue2, 1))
            //o.Albedo = saturate(color1.rgb + color2.rgb) + _brightNDark;
            // rgb 대신 grb도 사용 가능(가져오는 순서를 필요에 따라 변경 가능)
            // saturate = 범위가 넘어가는 수를 날림

            //o.Albedo = float3(_red, _green, _blue) + _brightNDark;
            // + : 커짐
            // - : 작아짐
            // * : -를 곱하면 커지고 +를 곱하면 작아짐
            // 작아진다 = 어두워진다
            // 색(곱셈)과 빛(덧셈)의 연산

            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
