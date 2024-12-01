/*
Module: BS842 Matrices
File: module.jai
Author: Brock Salmon
Created: 08APR2024
Last Edit: 08APR2024
*/

#module_parameters(IS_DEV := false, API : $I/interface API_Type) {
    API_Type :: enum {
    	OpenGL;
    	DirectX11;
    	Vulkan;
    }
};

perspective :: (vFOV : float, aspect : float, near : float, far : float) -> Matrix4 #must {
    tanHalfFOV := tan(to_radians(vFOV) / 2.0);
    #if #complete API == {
        case .OpenGL; {
            assert(false, "Not Implemented!");
        }
        case .Vulkan; {
        	return Matrix4.{
                1.0 / (tanHalfFOV * aspect), 0,                  0,                   0,
                0,                           -1.0 / tanHalfFOV,  0,                   0,
                0,                           0,                  far / (near - far), -(far * near) / (far - near),
                0,                           0,                  1,                   0,
        	};
        }
        case .DirectX11; {
            assert(false, "Not Implemented!");
        }
	}
}

view :: (direction : Quaternion, position : Vector3, forwardAxis : Vector3, upAxis : Vector3) -> Matrix4 #must {
    rotationMat := rotation_matrix(Matrix4, direction);
    lookVector := multiply(rotationMat, forwardAxis);
    zAxis := normalize(lookVector);
    xAxis := normalize(cross(upAxis, zAxis));
    yAxis := normalize(cross(zAxis, xAxis));
    
    #if #complete API == {
        case .OpenGL; {
            assert(false, "Not Implemented!");
        }
        case .Vulkan; {
        	return Matrix4.{
                 xAxis.x, xAxis.y, xAxis.z, -dot(xAxis, position),
                 yAxis.x, yAxis.y, yAxis.z, -dot(yAxis, position),
                 zAxis.x, zAxis.y, zAxis.z, -dot(zAxis, position),
                 0,       0,       0,        1,
        	};
        }
        case .DirectX11; {
            assert(false, "Not Implemented!");
        }
	}
}

translation :: (using offset : Vector3) -> Matrix4 #must {
    #if #complete API == {
        case .OpenGL; {
            assert(false, "Not Implemented!");
        }
        case .Vulkan; {
        	return Matrix4.{
                1, 0, 0, x,
                0, 1, 0, y,
                0, 0, 1, z,
                0, 0, 0, 1,
        	};
        }
        case .DirectX11; {
            assert(false, "Not Implemented!");
        }
	}
}

scaling :: (using scale : Vector3) -> Matrix4 #must {
    #if #complete API == {
        case .OpenGL; {
            assert(false, "Not Implemented!");
        }
        case .Vulkan; {
        	return Matrix4.{
                x, 0, 0, 0,
                0, y, 0, 0,
                0, 0, z, 0,
                0, 0, 0, 1,
        	};
        }
        case .DirectX11; {
            assert(false, "Not Implemented!");
        }
	}
}

#scope_module
to_radians :: inline (theta : float) -> float #must #expand {
    return (TAU / 360.0) * theta;
}

#import "Math";