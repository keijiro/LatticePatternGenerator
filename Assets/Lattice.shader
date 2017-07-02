Shader "Hidden/Lattice"
{
    Properties
    {
        _MainTex("", 2D) = "" {}
        _Color1("", Color) = (0, 0, 0)
        _Color2("", Color) = (1, 1, 1)
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    sampler2D _MainTex;
    float4 _MainTex_TexelSize;

    float _Resolution;
    half3 _Color1;
    half3 _Color2;

    half4 frag(v2f_img i) : SV_Target
    {
        const float inv_aspect = _MainTex_TexelSize.y / _MainTex_TexelSize.x;

        float2 p = i.uv * float2(inv_aspect, 1) * _Resolution;

        float rnd = frac(sin(dot(floor(p), float2(12.9898, 78.233))) * 43758.5453);
        rnd = floor(rnd * 2) / 2;

        float phi = UNITY_PI * (rnd + 0.25);
        float2 dir = float2(cos(phi), sin(phi));

        float2 pf = frac(p);
        float d1 = abs(dot(pf - float2(0.5, 0), dir)); // line 1
        float d2 = abs(dot(pf - float2(0.5, 1), dir)); // line 2

        float br = 0.2 - min(d1, d2);
        br = saturate(br * _MainTex_TexelSize.w / _Resolution);

        return half4(lerp(_Color1, _Color2, br), 1);
    }

    ENDCG

    SubShader
    {
        Cull Off ZWrite Off ZTest Always
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            ENDCG
        }
    }
}
