#ifndef QMLQSETTINGS_H
#define QMLQSETTINGS_H

#include <QSettings>
#include <QtQml/qqml.h>

class QmlQSettings: public QSettings {
  Q_OBJECT
  QML_NAMED_ELEMENT(QSettings)
public:
  explicit QmlQSettings(QObject *parent = nullptr) : QSettings(parent) {}

public slots:
  inline void setValue(const QString &key, const QVariant &value) {
    QSettings::setValue(key, value);
    emit valueChanged(key, value);
  }
  inline QVariant value(const QString &key, const QVariant &defaultValue) const {
    return QSettings::value(key, defaultValue);
  }
  inline QVariant value(const QString &key) const {
    return QSettings::value(key);
  }

signals:
    void valueChanged(QAnyStringView key, const QVariant& value);
};

#endif // QMLQSETTINGS_H
