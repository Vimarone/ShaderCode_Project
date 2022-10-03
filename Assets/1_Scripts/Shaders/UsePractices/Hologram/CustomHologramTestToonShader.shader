Shader "Test/CustomHologramTestToonShader"
{
    Properties
    {
        [Header(MainTex)]
        _mainTex("Albedo (RGB)", 2D) = "white" {}
        _normalTex("Normal Map", 2D) = "bump" {}
        [Header(Parameta)]
        _outlineColor("Outline Color", Color) = (1, 1, 1, 1)
        _outlineWeight("Outline Weight", Range(1, 20)) = 5
        _breakingStage("Breaking Stage", Range(3, 10)) = 5

        [Header(Dissolve)]
        _noiseTex("Noise Map", 2D) = "white" {}
        _outThikness("OutThikness", Range(1, 1.15)) = 1.15
        [HDR]_outColor("OutColor", Color) = (1, 1, 1, 1)
        _cut("Alpha Cut", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        cull front
        CGPROGRAM
        #pragma surface surf Nolight noambient vertex:vert noshadow alpha:fade
        #pragma target 3.0

        struct Input
        {
            float2 uv_mainTex;
            float4 color:COLOR; // 핵심
            float2 uv_noiseTex;
        };

        sampler2D _mainTex;
        sampler2D _noiseTex;
        fixed4 _outlineColor;
        float _outlineWeight;
        half _cut;
        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            //o.Albedo = fixed3(1, 1, 1);
            fixed4 noise = tex2D(_noiseTex, IN.uv_noiseTex);
            float alpha;

            // 알파 컷(디졸브) 연산 : 실질적으로 사라지게 하는 부분
            // 삼항 연산자를 못써서 if 씀(+=, ++ 이런것도 안됨)
            if (noise.r >= _cut)
                alpha = 1;
            else
                alpha = 0;


            o.Alpha = alpha;
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
        #pragma surface surf Toon alpha:fade
        #pragma target 3.0

        struct Input
        {
            float2 uv_mainTex;
            float2 uv_noiseTex;
            float2 uv_normalTex;
        };
        sampler2D _mainTex;
        sampler2D _normalTex;
        int _breakingStage;
        sampler2D _noiseTex;
        float _outThikness;
        fixed4 _outColor;
        half _cut;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed4 noise = tex2D(_noiseTex, IN.uv_noiseTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));
            o.Albedo = tex1.rgb;
            o.Normal = nor1;
            //o.Alpha = tex1.a;

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

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
        {
            // Lambert  형태
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

            ndotl = ndotl * _breakingStage;
            ndotl = ceil(ndotl) / _breakingStage;

            float4 final;
            final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;
            final.a = s.Alpha;

            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
