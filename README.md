# Macrodata Refinement

A SwiftUI pet project inspired by Apple TV series [Severance](https://tv.apple.com/ru/show/severance/umc.cmc.1srk2goyh2q2zdxcx605w8vtx)

## Demo 

https://github.com/user-attachments/assets/d50c6bd8-bec0-430a-a9b6-cd2cf41a1974


## Features & Technical Details

- Box is implemented with `Path` and `animatableData`. It was a tricky one, I didn't find a solution just with `Rectangle`s and `.rotation`. The problem was "connectors" for lids. Also filling path leads to animation glithces - that's why I use 2 boxes: stroked and filled. 
- Each number is floating randomly in horizontal or vertical direction. 
- For numbers selection I use `.onHover` and `DragGesture`
- For older look `.overlay` with pixels grid immitation is used. 
