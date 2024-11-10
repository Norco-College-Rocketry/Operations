cmake_minimum_required(VERSION 3.16)

project(GSC_Operations VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Mqtt)

qt_standard_project_setup(REQUIRES 6.5)

option(ENABLE_TESTS "Build with Tests" ON)
if (ENABLE_TESTS)
  enable_testing()
  include(GoogleTest)
  add_subdirectory(Tests)
  add_library(libGSC_Operations
    commandservice.h
    commandservice.cpp
    command.h
    command.cpp
    mqttcommandservice.h
    mqttcommandservice.cpp
  )

  target_link_libraries(libGSC_Operations
      PRIVATE Qt6::Mqtt
  )
endif(ENABLE_TESTS)

qt_add_executable(appGSC_Operations
    main.cpp
)

qt_add_qml_module(appGSC_Operations
    URI GSC_Commanding_Utility
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES Tile.qml
        QML_FILES ArmedAction.qml
        QML_FILES OnOffControls.qml
        QML_FILES MockActionTile.qml
        SOURCES commandservice.h commandservice.cpp
        SOURCES command.h command.cpp
        SOURCES mqttcommandservice.h mqttcommandservice.cpp
        SOURCES mqttcommand.h mqttcommand.cpp
        SOURCES qmlmqttclient.h qmlmqttclient.cpp
        QML_FILES ArmedActionTile.qml
        QML_FILES CommandTestTile.qml
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
    PRIVATE Qt6::Quick Qt6::Mqtt
)

include(GNUInstallDirs)
install(TARGETS appGSC_Operations
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
