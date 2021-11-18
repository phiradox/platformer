//
//  Shaders.metal
//  Platformer
//
//  Created by Ariston Kalpaxis on 2/26/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms {
    float4x4 projectionMatrix;
    float4x4 viewMatrix;
    float4x4 modelMatrix;
};

struct VertexIn {
    packed_float4 position;
    packed_float4 color;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut passThroughVertex(uint vid [[ vertex_id ]],
                                   const device VertexIn* vertex_array  [[ buffer(0) ]],
                                   const device Uniforms& uniforms [[ buffer(1) ]])
{
    VertexOut outVertex;
    
    outVertex.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * float4(vertex_array[vid].position);
    outVertex.color = vertex_array[vid].color;
    
    return outVertex;
};

constexpr constant uint MAX_LIGHTS = 4;

struct Lights {
    float2 position[MAX_LIGHTS];
    float3 color[MAX_LIGHTS];
    float radius[MAX_LIGHTS];
    float softness[MAX_LIGHTS];
    float strength[MAX_LIGHTS];
};

/*vertex VertexOut vignette(uint vid [[ vertex_id ]],
                          const device VertexIn* vertex_array  [[ buffer(0) ]],
                          const device Uniforms& uniforms [[ buffer(1) ]],
                          const device Lights& lights [[ buffer(2) ]]) {
    VertexOut outVertex;
    
    outVertex.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * float4(vertex_array[vid].position);
    
    for (uint c = 0; c < MAX_LIGHTS; c++) {
        float4 position = float4(lights.position[c].xy, 0, 1) * uniforms.viewMatrix * uniforms.modelMatrix;
        float len = distance(outVertex.position.xy, position.xy);
        float vignette = smoothstep(lights.radius[c], lights.radius[c] - lights.softness[c], len);
        outVertex.color = mix(vertex_array[vid].color, float4(lights.color[c]*vignette, 1), 0.5);
    }
    
    return outVertex;
};*/

struct FragOut {
    float4 color [[ color(0) ]];
};

fragment FragOut passThroughFragment(VertexOut interpolated [[stage_in]]) {
    FragOut out;
    out.color = float4(interpolated.color[0], interpolated.color[1], interpolated.color[2], interpolated.color[3]);
    
    return out;
};

struct Offset {
    float2 position;
};

fragment FragOut bgLightingFragment(VertexOut interpolated [[stage_in]],
                                    uint sid [[ sample_id ]],
                                    const device Lights& lights [[ buffer(0) ]],
                                    const device Offset& offset [[ buffer(1) ]]) {
    FragOut outFrag;
    outFrag.color = interpolated.color;
    for (uint c = 0; c < MAX_LIGHTS; c++) {
        float2 position = interpolated.position.xy;
        //position -= offset.position;
        float len = distance(position, lights.position[c]);
        float vignette = smoothstep(lights.radius[c], lights.softness[c], len);
        
        //vignette *= lights.strength[c];
        
        outFrag.color += float4(lights.color[c], 1) * vignette;
    }
    return outFrag;
};

vertex VertexOut offsetVertex(uint vid [[ vertex_id ]],
                                   const device VertexIn* vertex_array  [[ buffer(0) ]],
                                   const device Uniforms& uniforms [[ buffer(1) ]],
                                   const device Offset& offset [[ buffer(2) ]])
{
    VertexOut outVertex;
    float4 position = float4(vertex_array[vid].position);
    position.x += offset.position.x;
    position.y += offset.position.y;
    outVertex.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * position;
    //float len = length(outVertex.position.xy);
    //len /= M_SQRT2_F;
    //outVertex.position.x += len * outVertex.position.x/3;
    //outVertex.position.y += len * outVertex.position.y/3;
    outVertex.color = vertex_array[vid].color;
    
    return outVertex;
};

struct DistortionUniforms {
    float counter;
    float size;
};

vertex VertexOut bgDistortion(uint vid [[ vertex_id ]],
                              const device VertexIn* vertex_array  [[ buffer(0) ]],
                              const device Uniforms& uniforms [[ buffer(1) ]],
                              const device DistortionUniforms& dUnims [[ buffer(2) ]]) {
    VertexOut outVertex;
    outVertex.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * float4(vertex_array[vid].position);
    float addX = sin((outVertex.position.x + dUnims.counter)*6)*dUnims.size;
    float addY = cos((outVertex.position.y + dUnims.counter)*6)*dUnims.size;
    outVertex.position.x += addX;
    outVertex.position.y += addY;
    outVertex.color = vertex_array[vid].color*(1-(addX+addY-0.1)*4);
    return outVertex;
}

struct ShadowColorUniform {
    float4 color;
};

struct ShadowFragmentOut {
    float4 color [[ color(1) ]];
};

fragment ShadowFragmentOut shadowFragment(VertexOut interpolated [[stage_in]],
                              const device ShadowColorUniform& shadow [[ buffer(0) ]]) {
    ShadowFragmentOut outFrag;
    
    // drawing color of shadow
    if (interpolated.color.a == 1) {
        outFrag.color = float4(shadow.color.r, shadow.color.g, shadow.color.b, shadow.color.a);
    } else {
        outFrag.color = float4(shadow.color.r*interpolated.color.r, shadow.color.g*interpolated.color.g, shadow.color.b*interpolated.color.b, shadow.color.a*interpolated.color.a);
    }
    
    return outFrag;
};

kernel void multiplyShader(
                          texture2d<float, access::read> source [[ texture(0) ]],
                          texture2d<float, access::read> mask [[ texture(1) ]],
                          texture2d<float, access::write> dest [[ texture(2) ]],
                          uint2 gid [[ thread_position_in_grid ]])
{
    float4 source_color = source.read(gid);
    float4 mask_color = mask.read(gid);
    float4 result_color = source_color * mask_color;
    
    dest.write(result_color, gid);
};

struct Instance {
    float2 position;
    float2 scale;
    float4 color;
};

vertex VertexOut ambience(ushort vid [[ vertex_id ]],
                          ushort iid [[ instance_id ]],
                          const device VertexIn* vertex_array  [[ buffer(0) ]],
                          const device Uniforms& uniforms [[ buffer(1) ]],
                          const device Instance *perInstanceVars [[ buffer(2) ]] ) {
    Instance instance = perInstanceVars[iid];
    float4x4 transformations = uniforms.viewMatrix * uniforms.modelMatrix;
    transformations[3][0] *= (instance.scale.x * instance.scale.y);
    transformations[3][1] *= (instance.scale.x * instance.scale.y);
    float4x4 instanceCoefficients = float4x4(float4(instance.scale.x, 0, 0, 0), float4(0, instance.scale.y, 0, 0), float4(0, 0, 1, 0), float4(instance.position.x, instance.position.y, 0, 1));
    VertexOut outVertex;
    outVertex.position = uniforms.projectionMatrix * transformations * instanceCoefficients * float4(vertex_array[vid].position);
    outVertex.position.x += sin(outVertex.position.y*3)/5;
    //outVertex.color.r = abs(smoothstep(0, -1, outVertex.position.x));
    //outVertex.color.g = abs(smoothstep(-1, 0, outVertex.position.x)) + abs(smoothstep(0, 1, outVertex.position.x));
    //outVertex.color.b = smoothstep(0, 1, outVertex.position.x);
    //outVertex.color.a = 1;
    outVertex.color = instance.color;
    return outVertex;
}

struct AmbienceFragOut {
    float4 color [[color(2)]];
};

fragment AmbienceFragOut ambienceFragment(VertexOut interpolated [[stage_in]]) {
    AmbienceFragOut outFrag;
    outFrag.color = interpolated.color;
    return outFrag;
};

struct CloudBloomFragOut {
    float4 color [[color(1)]];
};

fragment CloudBloomFragOut cloudBloomFragment(VertexOut interpolated [[stage_in]]) {
    CloudBloomFragOut outFrag;
    outFrag.color = interpolated.color;
    return outFrag;
};

kernel void addShader(
                           texture2d<float, access::read> source [[ texture(0) ]],
                           texture2d<float, access::read> mask [[ texture(1) ]],
                           texture2d<float, access::write> dest [[ texture(2) ]],
                           uint2 gid [[ thread_position_in_grid ]])
{
    float4 source_color = source.read(gid);
    float4 mask_color = mask.read(gid);
    float4 result_color = source_color + mask_color;
    
    dest.write(result_color, gid);
};
