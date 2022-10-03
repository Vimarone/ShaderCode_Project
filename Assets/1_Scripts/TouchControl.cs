using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using UnityEngine.EventSystems;

public class TouchControl : MonoBehaviour
{
    void Start()
    {
        
    }

    void Update()
    {
        
    }

    IEnumerator OnMouseDown()
    {
        // noise 생성
        yield return new WaitForSeconds(2f);
    }
}
