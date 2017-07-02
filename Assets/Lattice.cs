using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class Lattice : MonoBehaviour
{
    [SerializeField] float _resolution = 50;
    [SerializeField, ColorUsage(false)] Color _color1 = Color.black;
    [SerializeField, ColorUsage(false)] Color _color2 = Color.white;

    [SerializeField, HideInInspector] Shader _shader;

    Material _material;

    void OnDestroy()
    {
        if (_material != null)
        {
            if (Application.isPlaying)
                Destroy(_material);
            else
                DestroyImmediate(_material);
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_material == null)
        {
            _material = new Material(_shader);
            _material.hideFlags = HideFlags.DontSave;
        }

        _material.SetFloat("_Resolution", _resolution);
        _material.SetColor("_Color1", _color1);
        _material.SetColor("_Color2", _color2);

        Graphics.Blit(source, destination, _material, 0);
    }
}
