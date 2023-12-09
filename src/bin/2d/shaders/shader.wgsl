// Vertex shader




struct CameraUniform 
{
    view: mat4x4<f32>,
    proj: mat4x4<f32>,
};


@group(0) @binding(0) // 1.
var<uniform> camera: CameraUniform;
// Vertex shader





struct VertexInput 
{
    @location(0) position: vec3<f32>,
    @location(1) uv: vec2<f32>,
}

struct InstanceInput 
{
    @location(5) model_matrix_0: vec4<f32>,
    @location(6) model_matrix_1: vec4<f32>,
    @location(7) model_matrix_2: vec4<f32>,
    @location(8) model_matrix_3: vec4<f32>,
};


struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) uv: vec2<f32>,
    @location(1) world_position: vec4<f32>,
}




@vertex
fn vs_main( model: VertexInput, instance: InstanceInput) -> VertexOutput {
    let model_matrix = mat4x4<f32>(
        instance.model_matrix_0,
        instance.model_matrix_1,
        instance.model_matrix_2,
        instance.model_matrix_3,
    );    
    let translation = vec4<f32>(model_matrix[3].xyz, 1.0);
    let rotation = mat4x4<f32>(
        vec4<f32>(model_matrix[0].xyz, 0.0),
        vec4<f32>(model_matrix[1].xyz, 0.0),
        vec4<f32>(model_matrix[2].xyz, 0.0),
        vec4<f32>(0.0, 0.0, 0.0,1.0),
    );


    var out: VertexOutput;
    out.uv = model.uv;
    out.world_position = rotation * vec4<f32>(model.position, 1.0);
    out.clip_position =  camera.proj * camera.view * model_matrix *  vec4<f32>(model.position, 1.0);
    return out;
}


struct Color
{
    color: vec4<f32>,
};

@group(1) @binding(2)
var<uniform> c_diffuse: Color;
@group(1) @binding(1)
var t_diffuse: texture_2d<f32>;
@group(1)@binding(0)
var s_diffuse: sampler;





@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> 
{
    // draw circle white circle on quad
    let uv = in.uv * 2.0 - vec2<f32>(1.0, 1.0);
    let dist = length(uv);
    let circle = step(dist, 0.5);
    return vec4<f32>(circle, circle, circle, 1.0);

}
