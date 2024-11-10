#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QtQml/qqml.h>

namespace NCR {

class Controller : public QObject
{
  Q_OBJECT
  QML_ELEMENT
public:
  explicit Controller (QObject *parent = nullptr) : QObject(parent) { }

  Q_INVOKABLE void info(QString msg);
  Q_INVOKABLE void debug(QString msg) { }
  Q_INVOKABLE void error(QString msg) { }
  Q_INVOKABLE void warn(QString msg) { }

private:

};

}
#endif // CONTROLLER_H
