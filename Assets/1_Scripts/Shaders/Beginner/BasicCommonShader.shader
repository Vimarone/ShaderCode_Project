Shader "Learn/BasicCommonShader"
{
    Properties
    {
        // 변수명 ("인스펙터 표시 이름", 표시 기능) = 초기화값
        /// 숫자
        _integer("Integer", Int) = 1
        _single("Float", Float) = 1.3
        _sliderVal("Slider Value", Range(0.5, 4.0)) = 1.2
        /// ===

        /// Vector 값을 받는 경우
        _color("Main Color", Color) = (1, 1, 1, 1)
        _vecVal("Vector Value", Vector) = (0, 0, 0)
        /// ===

        /// Texture Sampler
        _texture2d("2D Texture", 2D) = "white" {}   // "black"(0, 0, 0, 0), "gray"(0.5, 0.5, 0.5, 0.5), "bump"(0.5, 0.5, 1, 0.5), "red"(1, 0, 0, 0) 등
        _texture3d("3D Texture", 3D) = "" {}
        _cubeMap("Cube Map", Cube) = "" {}
        /// ===
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        //sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        //half _Glossiness;
        //half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //// Albedo comes from a texture tinted by color
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            //o.Albedo = c.rgb;
            //// Metallic and smoothness come from slider variables
            //o.Metallic = _Metallic;
            //o.Smoothness = _Glossiness;
            //o.Alpha = c.a;
            o.Albedo = float3(1, 0, 0);
            o.Alpha = 1;
            //o.Emission = float3(1, 0, 0);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
