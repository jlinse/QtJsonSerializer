import qbs
import qbs.TextFile

Library {
  name: "QtJsonSerializer"
  targetName: "QtJsonSerializer"

  Depends { name: "Qt.core" }
  Depends { name: "Qt.core-private" }
  Depends { name: "cpp" }

  readonly property bool isMacOS: qbs.targetOS.contains("macos")
  readonly property bool isWindows: qbs.targetOS.contains("windows")
  type: ((isForAndroid || isMacOS) ? "staticlibrary" : "dynamiclibrary")
  //type: "staticlibrary"

  /*
        Group {
            condition: project.install
            fileTagsFilter: isBundle ? "bundle.content" : ["dynamiclibrary", "dynamiclibrary_symlink"]
            qbs.install: true
            qbs.installDir: project.installDir
            qbs.installSourceBase: isBundle ? destinationDirectory : outer
        }
        */

  cpp.cxxLanguageVersion: "c++17"
  cpp.includePaths: [
    ".",
    product.buildDirectory + "/include"
  ]
  cpp.defines: [
    "QT_BUILD_JSONSERIALIZER_LIB",
  ]

  files: [
    "qjsonconverterreg.cpp.template",
    "cborserializer.cpp",
    "cborserializer.h",
    "cborserializer_p.h",
    "exception.cpp",
    "exception.h",
    "exception_p.h",
    "exceptioncontext.cpp",
    "exceptioncontext_p.h",
    "jsonserializer.cpp",
    "jsonserializer.h",
    "jsonserializer_p.h",
    "metawriters.cpp",
    "metawriters.h",
    "metawriters_p.h",
    "qtjsonserializer_global.h",
    "qtjsonserializer_helpertypes.h",
    "serializerbase.cpp",
    "serializerbase.h",
    "serializerbase_p.h",
    "typeconverter.cpp",
    "typeconverter.h",
    "typeextractors.h",
    "typeconverters/bitarrayconverter.cpp",
    "typeconverters/bitarrayconverter_p.h",
    "typeconverters/bytearrayconverter.cpp",
    "typeconverters/bytearrayconverter_p.h",
    "typeconverters/cborconverter.cpp",
    "typeconverters/cborconverter_p.h",
    "typeconverters/datetimeconverter.cpp",
    "typeconverters/datetimeconverter_p.h",
    "typeconverters/enumconverter.cpp",
    "typeconverters/enumconverter_p.h",
    "typeconverters/gadgetconverter.cpp",
    "typeconverters/gadgetconverter_p.h",
    "typeconverters/geomconverter.cpp",
    "typeconverters/geomconverter_p.h",
    "typeconverters/legacygeomconverter.cpp",
    "typeconverters/legacygeomconverter_p.h",
    "typeconverters/listconverter.cpp",
    "typeconverters/listconverter_p.h",
    "typeconverters/localeconverter.cpp",
    "typeconverters/localeconverter_p.h",
    "typeconverters/mapconverter.cpp",
    "typeconverters/mapconverter_p.h",
    "typeconverters/multimapconverter.cpp",
    "typeconverters/multimapconverter_p.h",
    "typeconverters/objectconverter.cpp",
    "typeconverters/objectconverter_p.h",
    "typeconverters/pairconverter.cpp",
    "typeconverters/pairconverter_p.h",
    "typeconverters/smartpointerconverter.cpp",
    "typeconverters/smartpointerconverter_p.h",
    "typeconverters/stdchronodurationconverter.cpp",
    "typeconverters/stdchronodurationconverter_p.h",
    "typeconverters/stdoptionalconverter.cpp",
    "typeconverters/stdoptionalconverter_p.h",
    "typeconverters/stdtupleconverter.cpp",
    "typeconverters/stdtupleconverter_p.h",
    "typeconverters/stdvariantconverter.cpp",
    "typeconverters/stdvariantconverter_p.h",
    "typeconverters/versionnumberconverter.cpp",
    "typeconverters/versionnumberconverter_p.h",
  ]

  // create type registrations from template
  FileTagger {
    patterns: "*.template"
    fileTags: ["template"]
  }
  property varList types: [
    {className: "bool", modes: ["Basic"]},
    {className: "int", modes: ["Basic"]},
    {className: "uint", modes: ["Basic"]},
    {className: "qlonglong", modes: ["Basic"]},
    {className: "qulonglong", modes: ["Basic"]},
    {className: "double", modes: ["Basic"]},
    {className: "long", modes: ["Basic"]},
    {className: "short", modes: ["Basic"]},
    {className: "char", modes: ["Basic"]},
    {className: "signed char", modes: ["Basic"]},
    {className: "ulong", modes: ["Basic"]},
    {className: "ushort", modes: ["Basic"]},
    {className: "uchar", modes: ["Basic"]},
    {className: "float", modes: ["Basic"]},
    {className: "QObject*", modes: ["Basic"]},
    {className: "QChar", modes: ["Basic"]},
    {className: "QString", modes: ["Basic"]},
    {className: "QDate", modes: ["Basic"]},
    {className: "QTime", modes: ["Basic"]},
    {className: "QDateTime", modes: ["Basic"]},
    {className: "QUrl", modes: ["Basic"]},
    {className: "QUuid", modes: ["Basic"]},
    {className: "QJsonValue", modes: ["Basic"]},
    {className: "QJsonObject", modes: ["Basic"]},
    {className: "QJsonArray", modes: ["Basic"]},
    {className: "QVersionNumber", modes: ["Basic"]},
    {className: "QLocale", modes: ["Basic"]},
    {className: "QRegularExpression", modes: ["Basic"]},
    {className: "QSize", modes: ["List"]},
    {className: "QPoint", modes: ["List"]},
    {className: "QLine", modes: ["List"]},
    {className: "QRect", modes: ["List"]},
    {className: "QByteArray", modes: ["Map", "Set"]},

    {className: "QCborValue", modes: ["Basic"]},
    {className: "QCborMap", modes: ["Basic"]},
    {className: "QCborArray", modes: ["Basic"]},
    {className: "QMimeType", modes: ["Basic"]},

    {className: "QSizeF", modes: ["List"]},
    {className: "QPointF", modes: ["List"]},
    {className: "QLineF", modes: ["List"]},
    {className: "QRectF", modes: ["List"]},
  ]
  Rule {
    inputs: "template"
    outputFileTags: ["cpp"]

    outputArtifacts: {
      function myEscape(n) {
        return n.replace(/\W/g, '_');
      }
      var r = [];
      r.push({
               filePath: ".reggen/qjsonconverterreg_all.cpp",
               fileTags: ["cpp"],
             });
      product.types.forEach(function(type) {
        r.push({
                 filePath: ".reggen/qjsonconverterreg_"+ myEscape(type.className) +".cpp",
                 fileTags: ["cpp"],
               });
      });
      return r;
    }

    prepare: {
      var cmd = new JavaScriptCommand();
      cmd.description = "generating converters registrations";
      cmd.highlight = "codegen";
      cmd.typeList = product.types;
      cmd.sourceCode = function() {
        function myEscape(n) {
          return n.replace(/\W/g, '_');
        }

        {
          var out = outputs.cpp[0];
          var text = "#include \"qtjsonserializer_global.h\"\n";
          text += "\n";
          text += "namespace QtJsonSerializer::__private::converter_hooks {\n";
          text += "\n";
          typeList.forEach(function(type) {
            text += "void register_"+ myEscape(type.className) +"_converters();\n";
          });
          text += "}\n";
          text += "\n";
          text += "namespace QtJsonSerializer {\n\n";
          text += "void registerTypes() {\n";
          text += "    static bool wasCalled = false;\n";
          text += "    if (wasCalled)\n";
          text += "        return;\n";
          text += "    wasCalled = true;\n";
          typeList.forEach(function(type) {
            text += "\tQtJsonSerializer::__private::converter_hooks::register_"+myEscape(type.className)+"_converters();\n";
          });
          text += "}\n\n";
          text += "}\n";
          var outFile = new TextFile(out.filePath, TextFile.WriteOnly);
          outFile.write(text);
          outFile.close();
        }

        var i = 1;
        typeList.forEach(function(type) {
          var class_name = type.className;
          var modes = type.modes;
          var out = outputs.cpp[i];
          i++;
          var text = '#include "qtjsonserializer_global.h"\n';
          text += '#include "serializerbase.h"\n';
          text += "#include <QDebug>\n";
          text += "#include <QtCore/QtCore>\n";
          text += "\n";
          text += "#define QT_JSON_SERIALIZER_NAMED(T) #T\n";
          text += "\n";
          text += "namespace QtJsonSerializer::__private::converter_hooks {\n\n";
          text += "\n";

          text += "void register_"+myEscape(class_name)+"_converters() {\n";
          modes.forEach(function(mode) {
            if(mode == "Map") {
              var fn = "register"+mode+"Converters";
              text += "\tSerializerBase::"+fn+"<QString, "+class_name+">();\n";
            } else {
              var fn = "register"+mode+"Converters";
              text += "\tSerializerBase::"+fn+"<"+class_name+">();\n";
            }
            text += "\tqDebug() << \"Registering Serializer: "+ fn +" class: "+class_name+"\";";
          });
          text += "}\n\n";
          text += "} // namespace QtJsonSerializer::__private::converter_hooks\n";

          var outFile = new TextFile(out.filePath, TextFile.WriteOnly);
          outFile.write(text);
          outFile.close();
        });
      };
      return [cmd];
    }
  }

  // create public headers that are required for includes
  FileTagger {
    patterns: "*.h"
    fileTags: ["public_header"]
  }
  Rule {
    inputs: ["public_header"]
    outputFileTags: ["hpp"]
    Artifact {
      filePath: "include/" + product.targetName + '/' + input.fileName
      fileTags: ["hpp"]
    }
    prepare: {
      var cmd = new JavaScriptCommand();
      cmd.description = "publishing header " + input.fileName;
      cmd.highlight = "codegen";
      cmd.input = input.filePath;
      cmd.output = output.filePath;
      cmd.sourceCode = function() {
        var outFile = new TextFile(output, TextFile.WriteOnly);
        outFile.write("#include \""+ input +"\"");
        outFile.close();
      };
      return [cmd];
    }
  }

  Export {
    Depends { name: "Qt.core" }
    Depends { name: "cpp" }
    cpp.cxxLanguageVersion: "c++17"
    cpp.includePaths: [
      ".",
      product.buildDirectory + "/include"
    ]
  }
}
