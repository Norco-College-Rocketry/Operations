#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFont>

#include <spdlog/spdlog.h>

int main (int argc, char *argv[])
{
  spdlog::info("Starting GSC Operations Application...");

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
