#pragma once

#include <opencv2/core.hpp>
#include <string>
#include <vector>

using BYTE = uint8_t;

std::vector<BYTE> base64Decode(const char * base64Str, const size_t base64Len);
std::string encodeImageAsPng(const cv::Mat & image);
std::string base64Encode(const std::vector<BYTE> & rawStr);