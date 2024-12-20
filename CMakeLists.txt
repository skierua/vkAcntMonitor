cmake_minimum_required(VERSION 3.16)

project(vkAcntMonitor5 VERSION 2.7 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)
find_package(Qt6 6.4 REQUIRED COMPONENTS QuickControls2)

qt_standard_project_setup()

qt_add_executable(appvkAcntMonitor5
    main.cpp
)

qt_add_qml_module(appvkAcntMonitor5
    URI vkAcntMonitor5
    VERSION 2.7
    QML_FILES qt/qml/Main.qml qt/qml/VkAcntAmnt.qml qt/qml/VkReloadBtn.qml qt/qml/WebDocum.qml lib.js
    RESOURCES README.md
    # RESOURCES icon/reload.svg
)
qt_add_resources(appvkAcntMonitor5 "app_icons"
    PREFIX "/"
    FILES
        icon/reload.svg
    )
# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appvkAcntMonitor5 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appvkAcntMonitor5
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appvkAcntMonitor5
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appvkAcntMonitor5
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
