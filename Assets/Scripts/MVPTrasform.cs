using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MVPTrasform : MonoBehaviour
{
	Matrix4x4 mvpMatrix = new Matrix4x4();
	Matrix4x4 rotateMatrix = new Matrix4x4();
	Matrix4x4 scaleMatrix = new Matrix4x4();
	// Update is called once per frame
	void Update()
	{
		// mvpMatrix = Camera.main.projectionMatrix * Camera.main.worldToCameraMatrix * transform.localToWorldMatrix;
		rotateMatrix[0, 0] = Mathf.Cos(Time.realtimeSinceStartup);
		rotateMatrix[0, 2] = Mathf.Sin(Time.realtimeSinceStartup);
		rotateMatrix[1, 1] = 1;
		rotateMatrix[2, 0] = -Mathf.Sin(Time.realtimeSinceStartup);
		rotateMatrix[2, 2] = Mathf.Cos(Time.realtimeSinceStartup);
		rotateMatrix[3, 3] = 1;

		//scale change
		scaleMatrix[0, 0] = Mathf.Sin(Time.realtimeSinceStartup) + 0.5f;
		scaleMatrix[1, 1] = Mathf.Cos(Time.realtimeSinceStartup) + 0.5f;
		scaleMatrix[2, 2] = Mathf.Sin(Time.realtimeSinceStartup) + 0.5f;
		scaleMatrix[3, 3] = 1;
		transform.GetComponent<Renderer>().material.SetMatrix("rm", rotateMatrix);
		transform.GetComponent<Renderer>().material.SetMatrix("sm", scaleMatrix);
	}
}