#!/bin/bash
cliphist list | tofi --auto-accept-single false --prompt-text "> " | cliphist decode | wl-copy
