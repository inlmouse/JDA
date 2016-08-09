JDA
===

C++ implementation of Joint Cascade Face Detection and Alignment.

### Fetech Code

This is a modified version of [luoyetx-JDA](https://github.com/luoyetx/JDA).

I recommend using [Git](https://git-scm.com/) to fetch the source code. If you are not familiar with Git, there is a [tutorial](https://git-scm.com/book/en/v2) you can follow.

```
$ git clone --recursive https://github.com/inlmouse/JDA.git
```

OR

```
$ git clone https://github.com/inlmouse/JDA.git
$ cd JDA
$ git submodule update --init
```

~~If you directly download the zip file, please remember to download [luoyetx/liblinear][luoyetx/liblinear] and [luoyetx/jsmnpp][luoyetx/jsmnpp], then extract the source code to `3rdparty`.~~ liblinear is used for global regression training and jsmnpp is used for json config parsing.

**liblinear** and **jsmnpp** have been added to `.\3rdparty`. And I add some (missing?) source code to *.\3rdparty\jsmnpp\jsmn.h* to ensure the project can be compiled correctly.

### Build

I add the Visual Studio 2013 solution file to this project and just config OpenCV before compile. 3.0 or later versions of OpenCV are allowed to be used in this project.

### Config

We use `config.json` for configuration. `config.template.json` is a template, please copy one and rename it to `config.json`. **Attention**, all relative path is start from `build` directory, and please use `/` instead of `\\` even if you are on Windows platform.

### Data

You should prepare your own data. You need two kinds of data, face with landmarks and background images. You also need to create a text file `face.txt` and  some `background.txt` text files which can be changed in `config.json`. Every line of `face.txt` indicates a face image's path with its landmarks and face bounding box, all points are aligned to the left top of the image. The number of landmarks can be changed in `config.json` and the order of landmarks does not matter.

```
../data/face/00001.jpg bbox_x bbox_y bbox_w bbox_h x1 y1 x2 y2 ........
../data/face/00002.jpg bbox_x bbox_y bbox_w bbox_h x1 y1 x2 y2 ........
....
....
```

bbox in `face.txt` indicate the face region. You can turn on data augment which will flip the face, but you also need to give **symmetric landmarks index** for flip operation. If bbox is out of range of the original image, the program will fill the rest region with black.

`background.txt` is much more simpler. Every line indicates where the background image in the file system.

```
../data/bg/000001.jpg
../data/bg/000002.jpg
../data/bg/000003.jpg
....
....
```

Background images should have no face and we will do data augment during the hard negative mining. Of course, you can use absolute path to indicate where is your face images and background images. However, don't use any space character in your image path or non ASCII characters.

After loading the face images, the code will snapshot a binary data under `data/dump` with file name like `jda_data_%s_stage_1_cart_1080.data`, you can copy the data file to `data/jda_train_data.data`. Next time you start the training, it will load data directly from this binary data file.

##### Optional Init negative samples

It's a good idea to prepare the initial negative samples by yourself rather than scan from the background images. You can turn on the optional hard negative in `config.json` and provide a text file like `background.txt`, every line indicts a negative patch and will be loaded and resized. The initial negative samples will also be snapshotted to a binary file `data/dump/hard.data`. The config `config.data.background[0]` should be `hard.txt` or `hard.data` even if you turn off `use_hard`.

**UPDATE** I have shared the data I have collected. For more details, see this [issue][jda-data].

### Train

```
$ ./jda train
```

If you are using Visual Studio, make sure you know how to pass command line arguments to the program. All trained model file will be saved to `model` directory.

### Model Layout

All model file is saved as a binary file. The model parameters have two data type, 4 byte `int` and 8 byte `double`, please pay attention to the [endianness][endianness] of you CPU.

```
|-- mask (int)
|-- meta
|    |-- T (int)
|    |-- K (int)
|    |-- landmark_n (int)
|    |-- tree_depth (int)
|    |-- current_stage_idx (int) // training status
|    |-- current_cart_idx (int)
|-- mean_shape (double, size = 2*landmark_n)
|-- stages
|    |-- stage_1
|    |    |-- cart_1
|    |    |-- cart_2
|    |    |-- ...
|    |    |-- cart_K
|    |    |-- global regression weight
|    |-- stage_2
|    |-- ...
|    |-- stage_T
|-- mask (int)
```

For more details of the model file layout, please refer to `cascador.cpp` and `cart.cpp`.

### FDDB Benchmark

[FDDB][fddb] is widely used for face detection evaluation, download the data and extract to `data` directory.

```
|-- data
|    |-- fddb
|         |-- images
|         |    |-- 2002
|         |    |-- 2003
|         |-- FDDB-folds
|         |    |-- FDDB-fold-01.txt
|         |    |-- FDDB-fold-01-ellipseList.txt
|         |    |-- ....
|         |-- result
```

You should prepare fddb data and model file. All result text file used by [npinto/fddb-evaluation][npinto/fddb-evaluation] is under `result` directory.

```
$ ./jda fddb
```

### Attention

Welcome any bug report and any question or idea through the [issues](https://github.com/luoyetx/JDA/issues).

I may rewrite some code into CUDA for acceleration. So you may need CUDA Toolkit 7.5 or later version in later version.

### QQ Group

There is a QQ group 347185749. If you are a [Tencent QQ][qq] user, welcome to join this group and we can discuss more there.

### License

BSD 3-Clause

### References

- [Joint Cascade Face Detection and Alignment](http://home.ustc.edu.cn/~chendong/JointCascade/ECCV14_JointCascade.pdf)
- [Face Alignment at 3000 FPS via Regressing Local Binary Features](http://research.microsoft.com/en-us/people/yichenw/cvpr14_facealignment.pdf)
- [FaceDetect/jointCascade_py](https://github.com/FaceDetect/jointCascade_py)
- [luoyetx/face-alignment-at-3000fps](https://github.com/luoyetx/face-alignment-at-3000fps)
- [cjlin1/liblinear](https://github.com/cjlin1/liblinear)
- [luoyetx/jsmnpp](https://github.com/luoyetx/jsmnpp)


[opencv]: http://opencv.org/
[luoyetx/jsmnpp]: https://github.com/luoyetx/jsmnpp
[luoyetx/liblinear]: https://github.com/luoyetx/liblinear
[cmake]: https://cmake.org/
[vs]: https://www.visualstudio.com/
[endianness]: https://en.wikipedia.org/wiki/Endianness
[qq]: http://im.qq.com/
[fddb]: http://vis-www.cs.umass.edu/fddb/
[npinto/fddb-evaluation]: https://github.com/npinto/fddb-evaluation
[jda-data]: https://github.com/luoyetx/JDA/issues/22
