﻿using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class Manipulator : MonoBehaviour
{
    public Transform anchor;
    public Transform handle;
    [Range(0, 1)] public float hardness;
    public float radius;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 anchorPos = anchor.position;
        Matrix4x4 transformationMatrix = handle.localToWorldMatrix * anchor.worldToLocalMatrix;

        Shader.SetGlobalMatrix("_TransformationMatrix", transformationMatrix);
        
        Shader.SetGlobalVector("_Center", (Vector4) anchorPos);
        Shader.SetGlobalFloat("_Hardness", hardness);
        Shader.SetGlobalFloat("_Radius", radius);
    }

    [ContextMenu("Reset Matrix")]
    public void ResetMatrix()
    {
        Shader.SetGlobalMatrix("_TransformationMatrix", Matrix4x4.identity);
    }

    [ContextMenu("Debug Matrix")]
    public void DebugMatrix()
    {
        Matrix4x4 handleMatrix = handle.localToWorldMatrix;
        Matrix4x4 anchorMatrix = anchor.worldToLocalMatrix;
        Matrix4x4 transformationMatrix = handleMatrix * anchorMatrix;
        
        Debug.Log("handle: localToWorldMatrix");
        Debug.Log(handleMatrix);
        Debug.Log("anchor: worldToLocalMatrix");
        Debug.Log(anchorMatrix);
        Debug.Log("transformationMatrix");
        Debug.Log(transformationMatrix);
    }
}
