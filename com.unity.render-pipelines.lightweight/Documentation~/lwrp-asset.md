# Lightweight Render Pipeline Asset
To use the Lightweight Render Pipeline (LWRP), you have to [create a LWRP Asset and assign it in the Graphics settings](https://github.com/Unity-Technologies/ScriptableRenderPipeline/wiki/Configuring-LWRP-for-use). 

The LWRP Asset controls a bunch of graphical features for the Lightweight Render Pipeline.  It is a scriptable object that inherits from ‘RenderPipelineAsset’. When you assign it in the Graphics settings, Unity switches from the built-in render pipeline to the LWRP. You can then adjust the corresponding settings directly in the LWRP, instead of looking for them elsewhere.

**Note:** You can have multiple LWRP assets and switch between them. For example, you can have one with Shadows on and one with Shadows off. If you switch between the assets to see the effects, you don’t have to manually toggle the corresponding settings for shadows every time. You cannot, however, switch between HDRP/SRP and LWRP assets, as the different render pipelines are incompatible.


## UI overview
In the LWRP, you can configure settings for:
* [__General__](#general)
* [__Quality__](#quality)
* [__Lighting__](#lighting)
* [__Shadows__](#shadows)
* [__Advanced__](#advanced)
* [__XR Config__](#xr-config)

For more information about each group of settings, see the relevant paragraph below. 



### General
The __General__ settings control things that are a core part of the pipeline rendered frame.

| __Property__            | __Description__                                              |
| ----------------------- | ------------------------------------------------------------ |
| __Depth Texture__       | Enable this to make LWRP render a [depth texture](https://docs.unity3d.com/Manual/SL-DepthTextures.html). If you want to use Post Processing, Soft Particles or advanced shader effects, you must enable this. When this is enabled, you can access the Depth Texture in your custom shaders and in shader code via the `_CameraDepthTexture` element. |
| __Opaque Texture__      | Enable this to create a `_CameraOpaqueTexture`, which works like the [GrabPass](https://docs.unity3d.com/Manual/SL-GrabPass.html) in the built-in render pipeline. The __Opaque Texture__ provides a snapshot of the scene right before LWRP renders any transparent meshes. You can use this in transparent shaders to create effects like frosted glass, water refraction, or heat waves. |
| __Opaque Downsampling__ | This dropdown contains these options to set the sampling effect on the opaque texture.<br/>__None__:  Produces a copy of the opaque pass as the same resolution as the camera.<br/>__2x Bilinear__: Produces a half resolution image with bilinear filtering.<br/>__4x Box__: Produces a quarter resolution image with box filtering. This produces a softly blurred copy.<br/>__4x Bilinear__: Produces a quarter resolution image with bi-linear filtering. |


### Quality
These settings control the quality level of the LWRP. This is where you can make performance better on lower-end hardware or make graphics look better on  higher-end hardware. 

**Tip:** If you want to have different settings for different hardware, you can configure these settings across multiple Lightweight Render Pipeline assets, and switch them out as needed.

| Property         | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| __HDR__          | Enable this to allow rendering in High Dynamic Range (HDR), where the brightest part of the image can be greater than 1. This gives you a wider range of light intensities, so your lighting looks more realistic. With it, you can still see details and experience less saturation even with bright light. This is useful f you want a wide range of lighting or to use [bloom](https://docs.unity3d.com/Manual/PostProcessing-Bloom.html) effects.If you’re targeting lower-end hardware, you can disable this to skip HDR calculations and get better performance. |
| __MSAA__         | Use [Multi Sample Anti-aliasing](https://en.wikipedia.org/wiki/Multisample_anti-aliasing) while rendering. This softens edges of your geometry, so they’re not jagged or flickering. In the drop-down menu, select how many times the many times the MSAA effect is repeated: __2x__, __4x__, or __8x__. For example, __x2__ means that each pixel is split into a 2x2 grid, so 4 pixels are sampled. If you want to skip MSAA calculations, or you don’t need them in a 2D game, select __Disabled__. |
| __Render Scale__ | This slider acts as a multiplier of the resolution of your current device. Use this on modern mobile devices with high resolution screens, if you do not need to render at a full 1:1 resolution. This only scales the game rendering. UI rendering is left at the default resolution for the device. |



### Lighting
BLABLABLA, LIghts are good - link to lighting model? 

| Property              | Description                                                  |
| --------------------- | ------------------------------------------------------------ |
| __Main Light__        | Needs description.                                           |
| __Cast Shadows__      | Check this box to make this type of light cast shadows in your Scene. |
| __Shadow Resolution__ | This controls how large the texture that casts shadows for the main light is. High resolutions give sharper, more detailed shadows. If memory or rendering time is an issue, try a lower resolution. |
| __Additional Lights__ | Possible values are Vertex Lights, Pixel Lights, Both, or None. |
| __ Per Object Limit__ | Needs description.                                           |
| __Cast Shadows__      | Check this box to make this type of light cast shadows in your Scene. |
| __Shadow Resolution__ | This controls how large the textures that cast directional shadows for the additional lights are. This is an atlas that packs up to 16 shadow maps. High resolutions give sharper, more detailed shadows. If memory or rendering time is an issue, try a lower resolution. |




### Shadows

These settings affect how the shadows look and behave. These will also affect performance so here is where you will want to tweak settings to get the best balance between visual quality of and speed of the shadows.


| Property     | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| __Distance__ | This controls how far ahead of the camera objects still cast shadows, in Unity units. After this distance, Unity doesn’t render shadows. For example, the value 100 means that objects more than 100 meters away from the camera do not cast shadows. Use this in large, open worlds, where rendering shadows far away can consume lots of memory. Or use it in top-down games with limited view distance. |
| __Cascades__ | Select the [cascade](https://docs.unity3d.com/Manual/DirLightShadows.html) level for shadows. A high number of cascades gives you more detailed shadows nearer the camera. Further away from the camera, shadows become less detailed. The options are: __None__, __Two Cascades__ and __Four Cascades__. If you’re experiencing performance issues, try lowering the amount of cascades. |
| __Soft Shadows__ | If you have enabled either __Directional Shadows__ or __Local Shadows__, you can enable this to add a smother filtering on the shadow maps. This gives you smooth edges on shadows, without pixelation. When enabled, the render pipeline performs a 5x5 Tent filter on desktop platforms and a 4 Tap filter on mobile devices. When disabled, the render pipeline samples the shadow once with default hardware filtering. If you disable this feature, you’ll get faster rendering, but shadow edges sharper, and the edges may become pixellated. 














### Advanced
This section allow you to fine tune less commonly changed settings, these impact deeper rendering features and shader combinations. 

**Tip:** This section is where you can fine-tune your Project.

| Property             | Description                                                  |
| -------------------- | ------------------------------------------------------------ |
| __Dynamic Batching__ | Enable [Dynamic Batching](https://docs.unity3d.com/Manual/DrawCallBatching.html), to make the render pipeline automatically batch objects that share the same Material. This is useful for older platforms and graphics APIs that do not support GPU instancing. If your targeted hardware does support GPU instancing, disable Dynamic Batching. |
| __Mixed Lighting__   | MISSING DESCRIPTION.                                         |









### XR Config
These settings are for when you want to use the Lightweight Render Pipeline for virtual or augmented reality, commonly known as XR. If you have selected the LWRP VR template, or if you have enabled __XR Config__  for your Project in the __Player__, you can configure these settings in the LWRP Asset.  If you have not done either, these options are greyed out.

| Property | Description |
| ------------ | --- |
| __Use Occlusion Mesh__ | Enable this to use __Occlusion Mesh__ while rendering. This provides a mesh in your goggles, that borders each eye. The render pipeline uses [Occlusion Culling](https://docs.unity3d.com/Manual/OcclusionCulling.html) to cull objects on the mesh. This means that someone wearing the goggles only sees This is enabled by default.
| __Occlusion Mesh Scale__ | Needs description. | 