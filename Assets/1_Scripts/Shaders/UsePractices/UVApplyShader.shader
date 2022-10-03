Shader "Learn/UVApplyShader"
{
    Properties
    {
        _mainTex("Main Texture", 2D) = "white" {}
        _subTex("Sub Texture", 2D) = "white" {}
        _slingTex("Sling Texture", 2D) = "black"{}
        _slingVal("Sling Value", Range(1, 5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0

        struct Input
        {
            float2 uv_mainTex;
            float2 uv_subTex;
            float2 uv_slingTex;
        };

        sampler2D _mainTex;
        sampler2D _subTex;
        sampler2D _slingTex;
        float _slingVal;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 tex3 = tex2D(_slingTex, float2(IN.uv_slingTex.x + _SinTime.z, IN.uv_slingTex.y - _Time.y));
            fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex + (tex3.r * _slingVal));    // 중앙으로 갈수록 큰 위치값(slingTex의 색상값)이 더해지므로 중앙에서 번짐(왜곡) 현상이 일어남
            fixed4 tex2 = tex2D(_subTex, float2(IN.uv_subTex.x, IN.uv_subTex.y - _Time.x) + (tex3.r / 2));

            o.Emission = (tex1.rgb + tex2.rgb) * 0.5;   // 두 값을 곱했을 때보다 밝아짐(tex1.rgb * tex2.rgb)
            o.Alpha = tex1.a * tex2.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
