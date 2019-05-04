using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shiney : MonoBehaviour
{
	private float dis = -1;
	private float r = 0.3f;
	// Update is called once per frame

	void Update()
	{
		dis += Time.deltaTime;
		transform.GetComponent<Renderer>().material.SetFloat("dis", dis);
		transform.GetComponent<Renderer>().material.SetFloat("r", r);
	}
}