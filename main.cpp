#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFont>

int
main (int argc, char *argv[])
{
  QGuiApplication app (argc, argv);
  QFont font("Source Code Pro");
  app.setFont(font);

  QQmlApplicationEngine engine;
  QObject::connect (
    &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
    [] () { QCoreApplication::exit (-1); }, Qt::QueuedConnection);
  engine.loadFromModule ("GSC_Commanding_Utility", "Main");

  return app.exec ();
}
