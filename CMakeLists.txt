cmake_minimum_required(VERSION 3.16)

project(GSC_Commanding_Utility VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Mqtt)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appGSC_Commanding_Utility
    main.cpp
)

qt_add_qml_module(appGSC_Commanding_Utility
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
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appGSC_Commanding_Utility PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appGSC_Commanding_Utility
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appGSC_Commanding_Utility
    PRIVATE Qt6::Quick Qt6::Mqtt
)

include(GNUInstallDirs)
install(TARGETS appGSC_Commanding_Utility
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
