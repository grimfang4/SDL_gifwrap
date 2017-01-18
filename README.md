SDL_gifwrap
by Jonathan Dearborn

Pronounce it however you like...  I dare you.

SDL_gifwrap is a wrapper for giflib that makes loading and saving multi-frame GIF files reasonable.
It does not attempt to duplicate animation features, but rather loads and stores all the information you need
in a convenient container.

SDL_gifwrap manipulates the following objects:
Image - GIF_Image is the container for all GIF data
Frame - GIF_Frame is the container for a single frame of GIF bitmap data
Surface - SDL_Surface is used to store GIF bitmap data when loading a GIF_Image
Palette - SDL_Palette is used to store GIF palette data
Indices - These represent a single frame of GIF bitmap data and each index into a palette to refer to an RGB color

// TODO: Support indices on load, surfaces on save.
// Maybe remove surface from struct and rely on functions to do the conversion to/from indices.
 
Limitations:
* Color resolution is not handled.  Instead, it is assumed that the image is stored as 8 bits per color channel (a color resolution value of binary 111).
In particular, this means that images with reduced color resolutions, say, optimized black & white images, may not be loaded correctly and may not be saved that way.
* Saving to and loading from arbitrary (non-file) data sources via SDL_rwops is not implemented yet.


== Typical loading usage ==

Load image data
    GIF_LoadImage()
Access gif->frames[i]->surface and gif->frames[i]->delay
Free image data
    GIF_FreeImage()



== Typical saving usage ==

Create data buffer
    GIF_CreateImage()
Set size of GIF screen
    GIF_SetCanvasSize()
Set global palette
    GIF_CreatePalette() if using an array of SDL_Color objects
    GIF_SetGlobalPalette()
Set animation loop count, GIF_LOOP_FOREVER is normal
    GIF_SetLooping()
Create and add frames
    Fill an array of indices or an SDL_Surface with bitmap data
    Create frame buffer
        GIF_CreateFrameIndexed() or GIF_CreateFrame()
    Set local palette if using per-frame palette
        GIF_SetLocalPalette()
    Set frame delay (in milliseconds, though GIF will truncate to hundredths)
        GIF_SetDelay()
    Set frame's transparent color
    GIF_SetTransparentIndex() or GIF_SetTransparentColor()
    Add frame to image container
        GIF_AddFrame()
Write GIF file to disk
    GIF_SaveImage()
Free image data
    GIF_FreeImage()


Descriptions of other useful functions can be found in this header file.



== EXAMPLE ==

GIF_Image* gif = GIF_LoadImage("my_animation.gif");

Uint16 i;
for(i = 0; i < gif->num_frames; ++i)
{
    SDL_Texture* texture = SDL_CreateTextureFromSurface(gif->frames[i]->surface);
    
    SDL_RenderCopy(renderer, texture, NULL, NULL);
    SDL_RenderPresent(renderer);
    
    SDL_DestroyTexture(texture);
    SDL_Delay(gif->frames[i]->delay);
}

// Make changes...
GIF_Frame* new_frame = GIF_CreateFrame(other_surface, SDL_TRUE);  // Ownership is transferred to gif
GIF_SetDelay(new_frame, 500);
GIF_AddFrame(image, new_frame);

// Then save.
GIF_Save(gif, "new_animation.gif");

GIF_FreeImage(gif);