Shader "Learn/UVTestShader"
{
    Properties
    {
        _mainTex("Albedo", 2D) = "white" {}
        _offset("Texture Offset", Range(0, 1)) = 0
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
        };

        sampler2D _mainTex;
        float _offset;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        // 빌트인 변수 중 시간 관련 변수
        // _Time : 씬이 열린 다음부터 지나온 시간 [(x, y, z, w) : (t/20, t, t*2, t*3)]
        // _SinTime : 시간이 사인 그래프에 맞춰서 움직이도록 한다 [(x, y, z, w) : (t/8, t/4, t/2, t)] (-1 ~ 1)
        // _CosTime : 시간이 코사인 그래프에 맞춰서 움직이도록 한다 [(x, y, z, w) : (t/8, t/4, t/2, t)] (-1 ~ 1)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 tex = tex2D(_mainTex, float2(IN.uv_mainTex.x + _Time.y, IN.uv_mainTex.y + _SinTime.y));
            //o.Emission = float3(IN.uv_mainTex.x, IN.uv_mainTex.y, 0);
            o.Emission = tex.rgb;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
