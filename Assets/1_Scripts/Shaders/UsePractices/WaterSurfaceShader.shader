Shader "Learn/WaterSurfaceShader"
{
    Properties
    {
        [Header(Base Map)]
        _waterTex("Water Texture", 2D) = "white" {}
        //_wNormTex("Normal Map", 2D) = "bump"{}
        [Header(Sub Maps)]
        _iceTex("Ice Texture", 2D) = "white"{}
        _iNormTex("Ice Normal Texture", 2D) = "bump"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 4.0

        struct Input
        {
            float2 uv_waterTex;
            //float2 uv_wNormTex;
            float2 uv_iceTex;
            float2 uv_iNormTex;
            float4 color:COLOR;
        };

        sampler2D _waterTex;
        //sampler2D _wNormTex;
        sampler2D _iceTex;
        sampler2D _iNormTex;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 water = tex2D(_waterTex, float2(IN.uv_waterTex.x - _Time.x * 5, IN.uv_waterTex.y));
            //fixed3 nor1 = UnpackNormal(tex2D(_normalTex, float2(IN.uv_normalTex.x - _Time.y / 3, IN.uv_normalTex.y + _Time.x)));
            fixed4 ice = tex2D(_iceTex, IN.uv_iceTex);
            fixed3 nor = UnpackNormal(tex2D(_iNormTex, IN.uv_iNormTex));

            o.Albedo = (water.rgb * ice.rgb) * ice.rgb;
            o.Normal = nor;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
