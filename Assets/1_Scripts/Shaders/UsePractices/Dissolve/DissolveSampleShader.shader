Shader "LearnDissolve/DissolveSampleShader"
{
    Properties
    {
        _mainTex ("Albedo (RGB)", 2D) = "white" {}
        _noiseTex ("Noise Map", 2D) = "white" {}
        _outThikness("OutThikness", Range(1, 1.15)) = 1.15
        [HDR]_outColor ("OutColor", Color) = (1, 1, 1, 1)
        _cut("Alpha Cut", Range(0, 1)) = 0

        _normalTex ("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        #pragma target 3.0

        struct Input
        {
            float2 uv_mainTex;
            float2 uv_noiseTex;
            float2 uv_normalTex;
        };

        sampler2D _mainTex;
        sampler2D _noiseTex;
        sampler2D _normalTex;
        float _outThikness;
        fixed4 _outColor;
        half _cut;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed4 noise = tex2D(_noiseTex, IN.uv_noiseTex);
            fixed3 norm = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));

            o.Albedo = tex1.rgb;
            o.Normal = norm;

            float alpha;

            // 알파 컷(디졸브) 연산 : 실질적으로 사라지게 하는 부분
            // 삼항 연산자를 못써서 if 씀(+=, ++ 이런것도 안됨)
            if (noise.r >= _cut)
                alpha = 1;
            else
                alpha = 0;

            // 아웃라인 컬러 연산 : 사라지는 라인에 색상 넣기
            float outline;
            // 기준 알파값이 더 커지는 효과 : 원래 지워지지 않는 부분도 지워지는 부분으로 인식시키고 그 부분을 컬러로 채우는 것
            if (noise.r >= _cut * _outThikness)
                outline = 0;
            else
                outline = 1;
            o.Emission = outline * _outColor.rgb;

            o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}