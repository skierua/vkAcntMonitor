#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtCore/qhash.h>
#include <QtCore/qstring.h>

namespace QmlCacheGeneratedCode {
namespace _vkAcntMonitor5_qt_qml_Main_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _vkAcntMonitor5_qt_qml_ModelAcnt_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _vkAcntMonitor5_qt_qml_VkAcntAmnt_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _vkAcntMonitor5_qt_qml_VkReloadBtn_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _vkAcntMonitor5_qt_qml_ModelDcms_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _vkAcntMonitor5_qt_qml_LogView_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _vkAcntMonitor5_qt_qml_WebDocum_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _vkAcntMonitor5_lib_js { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
    resourcePathToCachedUnit.insert(QStringLiteral("/vkAcntMonitor5/qt/qml/Main.qml"), &QmlCacheGeneratedCode::_vkAcntMonitor5_qt_qml_Main_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/vkAcntMonitor5/qt/qml/ModelAcnt.qml"), &QmlCacheGeneratedCode::_vkAcntMonitor5_qt_qml_ModelAcnt_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/vkAcntMonitor5/qt/qml/VkAcntAmnt.qml"), &QmlCacheGeneratedCode::_vkAcntMonitor5_qt_qml_VkAcntAmnt_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/vkAcntMonitor5/qt/qml/VkReloadBtn.qml"), &QmlCacheGeneratedCode::_vkAcntMonitor5_qt_qml_VkReloadBtn_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/vkAcntMonitor5/qt/qml/ModelDcms.qml"), &QmlCacheGeneratedCode::_vkAcntMonitor5_qt_qml_ModelDcms_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/vkAcntMonitor5/qt/qml/LogView.qml"), &QmlCacheGeneratedCode::_vkAcntMonitor5_qt_qml_LogView_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/vkAcntMonitor5/qt/qml/WebDocum.qml"), &QmlCacheGeneratedCode::_vkAcntMonitor5_qt_qml_WebDocum_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/vkAcntMonitor5/lib.js"), &QmlCacheGeneratedCode::_vkAcntMonitor5_lib_js::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.structVersion = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appvkAcntMonitor5)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appvkAcntMonitor5))
int QT_MANGLE_NAMESPACE(qCleanupResources_qmlcache_appvkAcntMonitor5)() {
    return 1;
}
