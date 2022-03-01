`tic` works with the `toc` function to measure elapsed time. The `tic` function records the current time, and the `toc` function uses the recorded value to calculate the elapsed time.



Use a `VideoReader` object to read files containing video data. The object contains information about the video file and enables you to read data from the video. You can create a `VideoReader` object using the `VideoReader` function, query information about the video using the object properties, and then read the video using object functions.

videoreader  https://www.mathworks.com/help/matlab/ref/videoreader.html

**parfor**

Execute `for`-loop iterations in parallel on workers

也是用来循环的，但是实现应该和for不太一样，具体细节不清楚



**read**

Read one or more video frames



Read only the first video frame.

```matlab
frame = read(v,1);
```

Read only the last video frame.

```matlab
frame = read(v,Inf);
```

Read frames 5 through 10.

```matlab
frames = read(v,[5 10]);
```

Read from the 50th frame to the end of the video file.

```matlab
frames = read(v,[50 Inf]);
```



`SE = strel('disk',r,n)` creates a disk-shaped structuring element, where `r` specifies the radius and `n` specifies the number of line structuring elements used to approximate the disk shape. Morphological operations using disk approximations run much faster when the structuring element uses approximations.



`imsubtract`

Subtract one image from another or subtract constant from image



`Z = imadd(X,Y)` adds each element in array `X` with the corresponding element in array `Y` and returns the sum in the corresponding element of the output array `Z`.



`J = imopen(I,SE)` performs morphological opening on the grayscale or binary image `I`, returning the opened image, `J`. `SE` is a single structuring element object returned by the [`strel`](https://www.mathworks.com/help/images/ref/strel.html) or [`offsetstrel`](https://www.mathworks.com/help/images/ref/offsetstrel.html) functions. The morphological open operation is an erosion followed by a dilation, using the same structuring element for both operations.



```matlab
f2 = imsubtract(imadd(im,imtophat(im,se)),imbothat(im,se));
```

can use to enhance contrast

imbothat:

https://www.mathworks.com/help/images/ref/imbothat.html

https://www.mathworks.com/matlabcentral/answers/41572-help-understanding-the-imbothat-function

https://blogs.mathworks.com/pick/2012/04/27/calculating-arclengths-made-easy/



`BW = im2bw(I,level)` converts the grayscale image `I` to binary image `BW`, by replacing all pixels in the input image with luminance greater than `level` with the value `1` (white) and replacing all other pixels with the value `0` (black).

matlab docs recommend us to use `imbinarize` instead of `im2bw` 

https://www.mathworks.com/help/images/ref/imbinarize.html



把相近的点连起来

`J = imclose(I,SE)` performs morphological closing on the grayscale or binary image `I`, returning the closed image, `J`. `SE` is a single structuring element object returned by the [`strel`](https://www.mathworks.com/help/images/ref/strel.html) or [`offsetstrel`](https://www.mathworks.com/help/images/ref/offsetstrel.html) functions. The morphological close operation is a dilation followed by an erosion, using the same structuring element for both operations.





Tilde `~` is the `NOT` operator in Matlab, and it has nothing special with images, it just treats them as matrices.

`~` as operator return a boolean form of the matrix it's called against, that the result matrix is `1` for `0` in the original matrix and `0` otherwise.

Examples:

```matlab
a = magic(2)
a =

     1     3
     4     2

~a
ans =

     0     0
     0     0
```



```matlab
L = bwlabel(BW)
```

Label matrix of contiguous regions, returned as matrix of nonnegative integers with the same size as [`BW`](https://www.mathworks.com/help/images/ref/bwlabel.html#bupqqy6-1-BW). The pixels labeled `0` are the background. The pixels labeled `1` make up one object; the pixels labeled `2` make up a second object; and so on.



`stats = regionprops(BW,properties)` returns measurements for the set of properties for each 8-connected component (object) in the binary image, `BW`. You can use `regionprops` on contiguous regions and discontiguous regions 

property: https://www.mathworks.com/help/images/ref/regionprops.html#buoixjn-1-properties



**deal**

Distribute inputs to outputs

`[B1,...,Bn] = deal(A1,...,An)` copies the input arguments `A1,...,An` and returns them as the output arguments `B1,...,Bn`. It is the same as `B1 = A1`, …, `Bn = An`. In this syntax, the numbers of input and output arguments must be the same.

`[B1,...,Bn] = deal(A)` copies the single input argument `A` and returns it as the output arguments `B1,...,Bn`. It is the same as `B1 = A`, …, `Bn = A`. In this syntax, you can specify an arbitrary number of output arguments.



**cell array**

A *cell array* is a data type with indexed data containers called *cells*, where each cell can contain any type of data. Cell arrays commonly contain either lists of text, combinations of text and numbers, or numeric arrays of different sizes. Refer to sets of cells by enclosing indices in smooth parentheses, `()`. Access the contents of cells by indexing with curly braces, `{}`.



**isempty**

`TF = isempty(A)` returns logical `1` (`true`) if `A` is empty, and logical `0` (`false`) otherwise. An empty array, table, or timetable has at least one dimension with length 0, such as 0-by-0 or 0-by-5.



**if**

```
if expression
    statements
elseif expression
    statements
else
    statements
end
```



**cat**

Concatenate arrays

`C = cat(dim,A,B)` concatenates `B` to the end of `A` along dimension `dim` when `A` and `B` have compatible sizes (the lengths of the dimensions match except for the operating dimension `dim`).

example:

https://www.mathworks.com/help/matlab/ref/double.cat.html



`X = zeros(n)` returns an `n`-by-`n` matrix of zeros.

`X = ones(n)` returns an `n`-by-`n` matrix of ones.

`k = find(X)` returns a vector containing the [linear indices](https://www.mathworks.com/help/matlab/ref/find.html#buf0c2r-8) of each nonzero element in array `X`.





`C = setdiff(A,B)` returns the data in `A` that is not in `B`, with no repetitions. `C` is in sorted order.





title

```matlab
figure
plot((1:10).^2)
f = 70;
c = (f-32)/1.8;
title(['Temperature is ',num2str(c),' C'])
```



num2str  

将数字转换为字符数组

语法

```matlab
s = num2str(A)
```



text()  is similar to title