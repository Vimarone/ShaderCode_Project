Shader "LearnCartoon/TwoPassNPRShader"
{
    Properties
    {
        [Header(MainTex)]
        _mainTex ("Albedo (RGB)", 2D) = "white" {}
        _normalTex ("Normal Map", 2D) = "bump" {}
        [Header(Parameta)]
        _outlineColor ("Outline Color", Color) = (1, 1, 1, 1)
        _outlineWeight ("Outline Weight", Range(1, 20)) = 5
        _breakingStage("Breaking Stage", Range(3, 10)) = 5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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

        void surf (Input IN, inout SurfaceOutput o)
        {
            //o.Albedo = fixed3(1, 1, 1);
            //o.Alpha = 1;
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
        #pragma surface surf Toon
        #pragma target 3.0

        struct Input
        {
            float2 uv_mainTex;
            float2 uv_normalTex;
        };
        sampler2D _mainTex;
        sampler2D _normalTex;
        int _breakingStage;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 tex1 = tex2D(_mainTex, IN.uv_mainTex);
            fixed3 nor1 = UnpackNormal(tex2D(_normalTex, IN.uv_normalTex));
            o.Albedo = tex1.rgb;
            o.Normal = nor1;
            o.Alpha = tex1.a;
        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten) 
        {
            // Lambert  형태
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

            // 노가다
            //if (ndotl > 0.7)
            //{
            //    ndotl = 1;
            //}
            //else if (ndotl > 0.4)
            //{
            //    ndotl = 0.3;
            //}
            //else
            //{
            //    ndotl = 0;
            //}

            // 좀 더 쉬운 방법
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
