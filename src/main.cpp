#include "utilities.h"
#include <emscripten/bind.h>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>

#include <iostream>
#include <regex>
#include <sstream>

std::string setImage(std::string buffer)
{
    using namespace cv;
    cv::Mat inputImage, grayImage;
    const auto bufferData = buffer.c_str();
    auto dataLen = (int)buffer.size();
    auto offset = 0;

    static const std::regex re(R"(^data:([a-z]+\/[a-z]+(;[a-z\-]+\=[a-z\-]+)?)?(;base64)?,)");
    std::cmatch cm; // same as std::match_results<const char*> cm;
    if (std::regex_search(bufferData, cm, re))
    {
        offset = cm[0].length();
        dataLen -= offset;
    }
    auto decodedBytes = base64Decode(bufferData + offset, dataLen);
    const auto decodedBytesSize = static_cast<int>(decodedBytes.size());
    const cv::_InputArray inputArray(decodedBytes.data(), decodedBytesSize);
    inputImage = imdecode(inputArray, cv::IMREAD_COLOR);
    std::stringstream ss;
    std::cout << "Image Size: " << inputImage.cols << " x " << inputImage.rows << std::endl;

    cvtColor(inputImage, grayImage, cv::COLOR_BGR2GRAY);
    return encodeImageAsPng(grayImage);
}

std::string getOpenCvVersion()
{

    std::stringstream ss;
    ss << "OpenCV version : " << CV_VERSION << std::endl;
    ss << "Major version : " << CV_MAJOR_VERSION << std::endl;
    ss << "Minor version : " << CV_MINOR_VERSION << std::endl;
    ss << "Subminor version : " << CV_SUBMINOR_VERSION << std::endl;
    return ss.str();
}

EMSCRIPTEN_BINDINGS(my_module)
{
    emscripten::function("getOpenCvVersion", &getOpenCvVersion);
    emscripten::function("setImage", &setImage);
}
