#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFont>

#include <spdlog/spdlog.h>

int main (int argc, char *argv[])
{
  spdlog::info("Starting GSC Operations Application...");

  QCoreApplication::setOrganizationName("Norco College Rocketry");
  QCoreApplication::setOrganizationDomain("github.com/Norco-College-Rocketry");
  QCoreApplication::setApplicationName("GSC Operations");

  QGuiApplication app (argc, argv);
  QFont font("Source Code Pro");
  app.setFont(font);

  QQmlApplicationEngine engine;
  QObject::connect (
    &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
    [] () { QCoreApplication::exit (-1); }, Qt::QueuedConnection);
  engine.loadFromModule ("GSC_Operations", "Main");

  return app.exec ();
}
