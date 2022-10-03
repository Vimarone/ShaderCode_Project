using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TouchTestObj : MonoBehaviour
{
    [SerializeField] Texture noiseTex;

    IEnumerator OnMouseDown()
    {
        Debug.Log(Shader.PropertyToID("_noiseTex"));
        // noise 생성
        gameObject.GetComponent<Renderer>().material.SetTexture(Shader.PropertyToID("_noiseTex"), noiseTex);
        yield return new WaitForSeconds(2f);
        gameObject.GetComponent<Renderer>().material.SetTexture(Shader.PropertyToID("_noiseTex"), null);
    }
}
