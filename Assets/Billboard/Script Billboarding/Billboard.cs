using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[ExecuteAlways]
public class Billboard : MonoBehaviour
{
    //Variables
    [Header("Settings")]
    [SerializeField] private bool m_lockX = false;
    [SerializeField] private bool m_lockY = false;
    [SerializeField] private bool m_lockZ = false;

    //Methods
    /// <summary>
    /// Update is called every frame, if the MonoBehaviour is enabled.
    /// </summary>
    private void Update()
    {
        Transform camera = Camera.main.transform;
        transform.LookAt(camera);

        Vector3 cameraLook;
        cameraLook.x = m_lockX ? 0 : transform.localEulerAngles.x;
        cameraLook.y = m_lockY ? 0 : transform.localEulerAngles.y;
        cameraLook.z = m_lockZ ? 0 : transform.localEulerAngles.z;

        transform.localEulerAngles = cameraLook;
    }
}
