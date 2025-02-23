cmake_minimum_required(VERSION 3.16)

project(GSC_Operations VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Mqtt)
find_package(spdlog REQUIRED)

qt_standard_project_setup()

option(ENABLE_TESTS "Build with Tests" ON)
if (ENABLE_TESTS)
  enable_testing()
  include(GoogleTest)
  add_subdirectory(Tests)
  qt_add_library(libGSC_Operations
    commandservice.h
    commandservice.cpp
    command.h
    command.cpp
    action.h
    action.cpp
  )
  target_link_libraries(libGSC_Operations PRIVATE
    Qt6::Quick
  )
endif(ENABLE_TESTS)

qt_add_executable(appGSC_Operations
    main.cpp
)

qt_add_qml_module(appGSC_Operations
    URI GSC_Operations
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES Tile.qml
        QML_FILES ArmingControls.qml
        QML_FILES OnOffControls.qml
        QML_FILES MockTile.qml
        SOURCES commandservice.h commandservice.cpp
        SOURCES command.h command.cpp
        SOURCES mqttcommandservice.h mqttcommandservice.cpp
        SOURCES mqttcommand.h mqttcommand.cpp
        SOURCES qmlmqttclient.h qmlmqttclient.cpp
        QML_FILES ArmingTile.qml
        QML_FILES CommandTile.qml
        SOURCES controller.h controller.cpp
        SOURCES action.h action.cpp
        QML_FILES CommandPairTile.qml
        SOURCES qmlqsettings.h qmlqsettings.cpp
        QML_FILES Indicator.qml
        QML_FILES StatusIndicator.qml
        QML_FILES MqttSubscriber.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appGSC_Operations PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appGSC_Commanding_Utility
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appGSC_Operations
    PRIVATE Qt6::Quick Qt6::Mqtt spdlog::spdlog
)

include(GNUInstallDirs)
install(TARGETS appGSC_Operations
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
