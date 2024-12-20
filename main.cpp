#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QCoreApplication::setOrganizationName("vksoft");
    QCoreApplication::setApplicationName("vkPOS3");
    // QCoreApplication::setApplicationName("TEST-vkPOS3");

    // QCoreApplication::setOrganizationName("vksoftme");
    //    QCoreApplication::setApplicationName("vkcheck3");

    // qmlRegisterType<UploadManager>("com.vkeeper", 3, 0, "UploadManager");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/vkAcntMonitor5/qt/qml/Main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);



/*    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("vkAcntMonitor5", "Main.qml");
*/

    return app.exec();
}
