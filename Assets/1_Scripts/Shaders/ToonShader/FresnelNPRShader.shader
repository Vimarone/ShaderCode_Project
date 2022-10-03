Shader "LearnCartoon/FresnelNPRShader"
{
    Properties
    {
        [Header(MainTex)]
        _mainTex("Albedo (RGB)", 2D) = "white" {}
        _normalTex("Normal Map", 2D) = "bump" {}
        [Header(RimLight Param)]
        _rimColor("Rim Color", Color) = (1, 1, 1, 1)
        _rimPower("Rim Power", Range(1, 10)) = 3
        _SpecColor("Specular Color", Color) = (1, 1, 1, 1)
        _specularPow("Specular Power", Range(10, 200)) = 10
        _gloss("Gloss", Range(0, 1)) = 1
        [Header(Cartoon Param)]
        _outlineColor("Outline Color", Color) = (1, 1, 1, 1)
        _outlineWeight("Outline Weight", Range(1, 20)) = 5
        _breakingStage("Breaking Stage", Range(3, 10)) = 5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        cull front

        CGPROGRAM
        #pragma surface surf Nolight noambient vertex:vert noshadow
        #pragma target 3.0

        struct Input
        {
            float2 uv_mainTex;
            float4 color:COLOR; // 핵심
        };

        sampler2D _mainTex;
        fixed4 _outlineColor;
        float _outlineWeight;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {

        }

        float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return _outlineColor;
        }

        // 크기를 늘리는 함수(v.normal.xyz * (_outlineWeight / 1000) 만큼 증가)
        void vert(inout appdata_full v)
        {
            v.vertex.xyz = v.vertex.xyz + v.normal.xyz * (_outlineWeight / 1000);
        }
        ENDCG

        cull back
        CGPROGRAM
        #pragma surface surf CustomBlinnPhongToon
        #pragma target 3.0

        struct Input
        {
            float2 uv_mainTex;
            float2 uv_normalTex;
        };
        sampler2D _mainTex;
        sampler2D _normalTex;
        fixed4 _rimColor;
        float _rimPower;
        half _specularPow;
        fixed _gloss;
        int _breakingStage;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));
            o.Albedo = tex1.rgb;
            o.Normal = nor1;
            o.Specular = _specularPow;
            o.Gloss = _gloss;
            o.Alpha = tex1.a;
        }

        float4 LightingCustomBlinnPhongToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;

            // Lambert
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            ndotl = ndotl * _breakingStage;
            ndotl = ceil(ndotl) / _breakingStage;
            final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;

            // 외곽이 광원(색)이 들어가는 것
            // 그 외곽이 검은색이 들어가도록

            //RimLight
            float rim = dot(s.Normal, viewDir);
            float3 rimColor = pow(1 - rim, _rimPower) * _rimColor.rgb;

            // final
            final.rgb = final.rgb;
            final.a = s.Alpha;

            return final;

        }
        ENDCG
    }
    FallBack "Diffuse"
}