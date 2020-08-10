using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class Painter : MonoBehaviour
{
    [Range(0, 1)] public float hardness;
    public bool erase = false;
    public RenderTexture renderTexture;
    public Renderer renderer;
    public Material uvMat;
    
    private Transform painter;
    
    // Start is called before the first frame update
    void Start()
    {
        painter = transform;
    }

    // Update is called once per frame
    void Update()
    {
        Shader.SetGlobalVector("_Center", (Vector4) painter.position);
        Shader.SetGlobalFloat("_Hardness", hardness);
        Shader.SetGlobalFloat("_Radius", painter.localScale.x);

        if (erase)
        {
            Shader.SetGlobalInt("_BlendOp", (int) BlendOp.ReverseSubtract);
        }
        else
        {
            Shader.SetGlobalInt("_BlendOp", (int) BlendOp.Add);
        }

        CommandBuffer commandBuffer = new CommandBuffer {name = "UV Space Renderer"};
        commandBuffer.SetRenderTarget(renderTexture);
        commandBuffer.DrawRenderer(renderer, uvMat);
        
        Graphics.ExecuteCommandBuffer(commandBuffer);
    }
}
