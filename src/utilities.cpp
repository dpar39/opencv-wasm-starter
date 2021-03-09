#include "utilities.h"
#include <opencv2/imgcodecs.hpp>
using namespace cv;

static uint8_t fromChar(const char ch)
{
    if (ch >= 'A' && ch <= 'Z')
    {
        return ch - 'A';
    }
    if (ch >= 'a' && ch <= 'z')
    {
        return 26 + (ch - 'a');
    }
    if (ch >= '0' && ch <= '9')
    {
        return 52 + (ch - '0');
    }
    if (ch == '+')
    {
        return 62;
    }
    if (ch == '/')
    {
        return 63;
    }
    throw std::runtime_error("Invalid character in base64 string");
}

std::vector<BYTE> base64Decode(const char * base64Str, const size_t base64Len)
{
    BYTE charBlock4[4], byteBlock3[3];
    std::vector<BYTE> result;
    result.reserve(base64Len * 3 / 4);
    auto i = 0;
    for (size_t k = 0; k < base64Len; ++k)
    {
        const auto ch64 = base64Str[k];
        if (ch64 == '=')
        {
            break;
        }
        charBlock4[i++] = ch64;
        if (i == 4)
        {
            for (i = 0; i < 4; i++)
            {
                charBlock4[i] = fromChar(charBlock4[i]);
            }
            byteBlock3[0] = (charBlock4[0] << 2) + ((charBlock4[1] & 0x30) >> 4);
            byteBlock3[1] = ((charBlock4[1] & 0xf) << 4) + ((charBlock4[2] & 0x3c) >> 2);
            byteBlock3[2] = ((charBlock4[2] & 0x3) << 6) + charBlock4[3];
            result.insert(result.end(), byteBlock3, byteBlock3 + 3);
            i = 0;
        }
    }

    if (i > 0)
    {
        std::fill(charBlock4 + i, charBlock4 + 4, '\0');
        std::transform(charBlock4, charBlock4 + i, charBlock4, fromChar);

        byteBlock3[0] = (charBlock4[0] << 2) + ((charBlock4[1] & 0x30) >> 4);
        byteBlock3[1] = ((charBlock4[1] & 0xf) << 4) + ((charBlock4[2] & 0x3c) >> 2);
        byteBlock3[2] = ((charBlock4[2] & 0x3) << 6) + charBlock4[3];
        result.insert(result.end(), byteBlock3, byteBlock3 + i - 1);
    }
    return result;
}

std::string base64Encode(const std::vector<BYTE> & rawStr)
{
    auto byteIter = rawStr.data();
    auto bufferSize = rawStr.size();
    const std::string Base64CharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    std::string result;
    result.reserve(static_cast<size_t>(ceil(bufferSize * 4 / 3.0)));
    auto i = 0;
    int j;
    uint8_t charArray3[3];
    uint8_t charArray4[4];

    while (bufferSize--)
    {
        charArray3[i++] = *byteIter++;
        if (i == 3)
        {
            charArray4[0] = (charArray3[0] & 0xfc) >> 2;
            charArray4[1] = ((charArray3[0] & 0x03) << 4) + ((charArray3[1] & 0xf0) >> 4);
            charArray4[2] = ((charArray3[1] & 0x0f) << 2) + ((charArray3[2] & 0xc0) >> 6);
            charArray4[3] = charArray3[2] & 0x3f;
            for (i = 0; i < 4; i++)
            {
                const auto idx = charArray4[i];
                result.push_back(Base64CharSet[idx]);
            }
            i = 0;
        }
    }

    if (i > 0)
    {
        for (j = i; j < 3; j++)
        {
            charArray3[j] = 0;
        }
        charArray4[0] = (charArray3[0] & 0xfc) >> 2;
        charArray4[1] = ((charArray3[0] & 0x03) << 4) + ((charArray3[1] & 0xf0) >> 4);
        charArray4[2] = ((charArray3[1] & 0x0f) << 2) + ((charArray3[2] & 0xc0) >> 6);
        charArray4[3] = charArray3[2] & 0x3f;
        for (j = 0; j < i + 1; j++)
        {
            const auto idx = charArray4[j];
            result.push_back(Base64CharSet[idx]);
        }
        while (i++ < 3)
        {
            result.push_back('=');
        }
    }
    return result;
}

std::string encodeImageAsPng(const cv::Mat & image)
{
    std::vector<BYTE> pictureData;
    imencode(".png", image, pictureData);
    return base64Encode(pictureData);
}