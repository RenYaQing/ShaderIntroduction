using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class CalculateMesh : MonoBehaviour
{
    public MeshFilter filter1;
    void Start()
    {
        Vector3[] vertices = filter1.mesh.vertices;
        float max = vertices.Max(v => v.x);
        float min = vertices.Min(v => v.x);
        Debug.Log("Max=" + max + " Min=" + min);
    }
}