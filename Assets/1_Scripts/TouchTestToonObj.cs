using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TouchTestToonObj : MonoBehaviour
{
    bool _isClicked = false;
    float _timer = 0;

    void Update()
    {
        if (_isClicked)
        {
            if (_timer <= 1)
            {
                _timer += Time.deltaTime;
                gameObject.GetComponent<Renderer>().material.SetFloat("_cut", _timer);
            }
            else
                _isClicked = false;
        }
        else
        {
            if (_timer > 0)
            {
                _timer -= Time.deltaTime;
                gameObject.GetComponent<Renderer>().material.SetFloat("_cut", _timer);
            }
        }
    }

    void OnMouseDown()
    {
        _isClicked = true;    
    }
}
