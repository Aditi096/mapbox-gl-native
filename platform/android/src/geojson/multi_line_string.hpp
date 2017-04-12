#pragma once

#include <mbgl/util/geojson.hpp>
#include <mbgl/util/noncopyable.hpp>

#include <jni/jni.hpp>

#include "../java/util.hpp"

namespace mbgl {
namespace android {
namespace geojson {

class MultiLineString : private mbgl::util::noncopyable {
public:
    static constexpr auto Name() { return "com/mapbox/services/commons/geojson/MultiLineString"; };

    static constexpr auto Type() { return "MultiLineString"; };

    static mapbox::geojson::multi_line_string convert(jni::JNIEnv&, jni::Object<MultiLineString>);

    static mapbox::geojson::multi_line_string convert(jni::JNIEnv&, java::util::List /* java::util::List<Position> */);

    static java::util::List getCoordinates(jni::JNIEnv&, jni::Object<MultiLineString>);

    static jni::Class<MultiLineString> javaClass;

    static void registerNative(jni::JNIEnv&);
};

} // namespace geojson
} // namespace android
} // namespace mbgl