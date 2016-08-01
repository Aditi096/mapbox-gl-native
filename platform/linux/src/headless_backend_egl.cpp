#include <mbgl/platform/default/headless_backend.hpp>
#include <mbgl/platform/default/headless_display.hpp>

#include <mbgl/platform/log.hpp>

#include <EGL/egl.h>

#include <cassert>

namespace mbgl {

struct EGLImpl : public HeadlessBackend::Impl {
    EGLImpl(EGLContext glContext_, EGLDisplay display_)
            : glContext(glContext_),
              display(display_) {
    }

    ~EGLImpl() {
        if (glContext != eglGetCurrentContext()) {
            activateContext();
        }
        if (!eglDestroyContext(display, glContext)) {
            throw std::runtime_error("Failed to destroy EGL context.\n");
        }
    }

    void activateContext() final {
        if (!eglMakeCurrent(display, EGL_NO_SURFACE, EGL_NO_SURFACE, glContext)) {
            throw std::runtime_error("Switching OpenGL context failed.\n");
        }
    }

    void deactivateContext() final {
        if (!eglMakeCurrent(display, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT)) {
            throw std::runtime_error("Removing OpenGL context failed.\n");
        }
    }

    EGLContext glContext = EGL_NO_CONTEXT;
    EGLDisplay display = EGL_NO_DISPLAY;
};

gl::glProc HeadlessBackend::initializeExtension(const char* name) {
    return eglGetProcAddress(name);
}

bool HeadlessBackend::hasDisplay() {
    if (!display) {
        display.reset(new HeadlessDisplay);
    }
    return bool(display);
};

void HeadlessBackend::createContext() {
    assert(!hasContext());
    assert(hasDisplay());

    EGLDisplay display_ = display->attribute<EGLDisplay>();
    EGLConfig& config = display->attribute<EGLConfig&>();

    if (!eglBindAPI(EGL_OPENGL_API)) {
        throw std::runtime_error("Error setting the EGL rendering API.\n");
    }

    EGLContext glContext = eglCreateContext(display_, config, EGL_NO_CONTEXT, NULL);
    if (glContext == EGL_NO_CONTEXT) {
        mbgl::Log::Error(mbgl::Event::OpenGL, "eglCreateContext() returned error 0x%04x",
                         eglGetError());
        throw std::runtime_error("Error creating the EGL context object.\n");
    }

    impl.reset(new EGLImpl(glContext, display_));
}

} // namespace mbgl