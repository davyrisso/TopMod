# version info : code from -- http://wiki.qtcentre.org/index.php?title=Version_numbering_using_QMake
#VERSION = $$system(git log -1 --pretty=format:%H | cut -c 1-8)
#!isEmpty(VERSION){
	VERSION = $${VERSION}
	VERSTR = '\\"$${VERSION}\\"'  # place quotes around the version string
	DEFINES += VER=\"$${VERSTR}\" # create a VER macro containing the version string
#}

#qt version
QTVERSION = $$[QT_VERSION]
QT_VERSTR = '\\"$${QTVERSION}\\"'  # place quotes around the version string
DEFINES += QT_VER=\"$${QT_VERSTR}\" # create a QT_VER macro containing the version string

# main stuff
QT += opengl xml
CONFIG += qt debug warn_off link_prl
CONFIG += c++11

#QMAKE_CXXFLAGS_DEBUG += -pg
#QMAKE_LFLAGS_DEBUG += -pg

# exclude verse python or spacenav drivers
# or include them with CONFIG += 
CONFIG -= WITH_PYTHON WITH_SPACENAV WITH_VERSE
CONFIG += WITH_PYTHON

# to include the popup command line interface leave the following line uncommented
DEFINES *= QCOMPLETER

# DEFINES += TOPMOD_VERSION
DEFINES -= GPU_OK

TEMPLATE = app

SUBDIRS = include

MOC_DIR = tmp
OBJECTS_DIR = tmp
# UI_DIR = tmp

# TopModd will be the name for the debug version,
# and TopMod will be the release version
CONFIG(debug, debug|release) {
 TARGET = TopMod# -$${VERSION}
} else {
 TARGET = TopMod# -$${VERSION}
}
CONFIG(debug)
{
CONFIG += console
}

INCLUDEPATH += \
	include \
	#include/arcball \
	include/dlflaux \
	include/dlflcore \
	include/Graphics \
	include/Light \
	include/vecmat \
	include/verse

CONFIG(WITH_VERSE){
	message("VERSE will be included")
	DEFINES *= WITH_VERSE
}

CONFIG(WITH_PYTHON){
	message("PYTHON support will be included")
	DEFINES *= WITH_PYTHON
}

CONFIG(WITH_SPACENAV){
	message("SPACENAV support will be included")
	DEFINES *= WITH_SPACENAV
}

macx {
	#mac icon when not using a custom info.plist file
	ICON = topmod.icns

	# either compile the mac version as an app bundle or a console app
	# tell it to load a custom info.plist file here
	QMAKE_INFO_PLIST    = Info.plist
	#MACOSX_DEPLOYMENT_TARGET = 10.12
	# compile release + universal binary 
	#CONFIG += x86 ppc

	CONFIG(GPU_OK){# for cg gpu shading
		INCLUDEPATH += /Library/Frameworks/Cg.framework/Versions/1.0
		QMAKE_LFLAGS += -L/Library/Frameworks/Cg.framework 
		LIBS += -framework Cg
	}

	#QMAKE_LFLAGS += -F./lib
	#LIBS += -framework vecmat -framework dlflcore -framework dlflaux
	#QMAKE_LFLAGS += -L./lib
	LIBS += -L"$$PWD/lib" -lvecmat -ldlflcore -ldlflaux

	#PRIVATE_FRAMEWORKS.files = ./lib/vecmat.framework ./lib/dlflcore.framework ./lib/dlflaux.framework
	#PRIVATE_FRAMEWORKS.path = Contents/Frameworks
	#QMAKE_BUNDLE_DATA += PRIVATE_FRAMEWORKS

	INCLUDEPATH += /usr/include
	QMAKE_LFLAGS += -L/usr/lib

	CONFIG(WITH_PYTHON){
	INCLUDEPATH += /System/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7
	QMAKE_LFLAGS += -L/System/Library/Frameworks/Python.framework
		LIBS += -framework Python
	}
	CONFIG(WITH_SPACENAV){
		INCLUDEPATH += /Library/Frameworks/3DconnexionClient.framework/Versions/A/Headers
		LIBS += -framework 3DconnexionClient
		QMAKE_LFLAGS += -L/Library/Frameworks/3DconnexionClient.framework
	}
	CONFIG(WITH_VERSE){
		LIBS += -lverse
	}
} else:unix {
	CONFIG -= WITH_SPACENAV WITH_VERSE
	QMAKE_LFLAGS += -L./lib
	LIBS += -lvecmat -ldlflcore -ldlflaux
	DEFINES *= LINUX
	
	CONFIG(WITH_PYTHON){
		INCLUDEPATH += /usr/include/python2.7
		LIBS += -lpython2.7 -L/usr/lib/python2.7/config
	}
	CONFIG(WITH_SPACENAV){

	}
	CONFIG(WITH_VERSE){

	}
} else:win32 {

	# TopModd will be the name for the debug version,
	# and TopMod will be the release version
	CONFIG(debug, debug|release) {
	 TARGET = TopMod# -$${VERSION}
	} else {
	 TARGET = TopMod# -$${VERSION}
	}
	CONFIG+=suppress_vcproj_warnings
	
	#application icon windows
	RC_FILE = topmod.rc

	CONFIG -= WITH_SPACENAV

	#QMAKE_LFLAGS += -L"$$PWD/lib"
	LIBS += -L"$$PWD/lib" -lvecmat -ldlflcore -ldlflaux
	LIBS += -lopengl32 -lglu32

	CONFIG(WITH_PYTHON){
	 INCLUDEPATH += "C:/Python27/include"
	 QMAKE_LFLAGS += -L"C:/Python27/libs"
	 LIBS += -L"C:/Python27/libs" python27.lib
	}
	CONFIG (GPU_OK){
		
	}
	CONFIG(WITH_SPACENAV){

	}
	CONFIG(WITH_VERSE){
		LIBS += -lverse
		INCLUDEPATH += C:/verse/include
		QMAKE_LFLAGS += -LC:/verse/lib
	}
}

# Input
HEADERS += \
	#include/Camera2.hh \
	#include/Graphics/Camera.hh \
	include/Base/BaseObject.hh \
	include/Base/Constants.hh \
	include/Base/Inlines.hh \
	include/Base/StreamIO.hh \
	include/Camera3.hh \
	include/Graphics/Color.hh \
	include/Graphics/Grid.hh \
	include/Graphics/Texture.hh \
	include/Graphics/Transform.hh \
	include/Light/AmbientLight.hh \
	include/Light/Light.hh \
	include/Light/PointLight.hh \
	include/Light/SpotLight.hh \
	BasicsMode.h \
	CgData.hh \
	CommandCompleter.hh \
	ConicalMode.h \ 
	DLFLLighting.hh \
	DLFLLocator.hh \
	DLFLRenderer.hh \
	DLFLScriptEditor.hh \
	DLFLSelection.hh \
	editor.h \
	ExperimentalModes.h \
	ExtrusionsMode.h \ 
	GeometryRenderer.hh \
	GLWidget.h \
	HighgenusMode.h \
	MainWindow.h \
	PythonHighlighter.h \
	qcumber.hh \
	qshortcutdialog.h \
	qshortcutmanager.h \
	RemeshingMode.h \
	stylesheeteditor.h \
	TdxDeviceWrappers.hh \
	TexturingMode.h \
	TMPatch.hh \
	TMPatchFace.hh \
	TMPatchObject.hh \
	TopMod.h \
	TopModPreferences.h \
	Viewport.hh

FORMS += shortcutdialog.ui stylesheeteditor.ui

SOURCES += \
	# DLFLSculpting.cc \
	BasicsMode.cc \
	CgData.cc \
	CommandCompleter.cc \
	ConicalMode.cc \ 
	DLFLLighting.cc \
	DLFLLocator.cc \
	DLFLRenderer.cc \
	DLFLScriptEditor.cc \
	DLFLSelection.cc \
	DLFLUndo.cc \
	editor.cc \
	ExperimentalModes.cc \
	ExtrusionsMode.cc \
	GeometryRenderer.cc \
	GLWidget.cc \
	HighgenusMode.cc \
	include/Camera3.cc \
	main.cc \
	MainWindow.cc \
	MainWindowCallbacks.cc \
	MainWindowRemeshingCallbacks.cc \
	PythonHighlighter.cc \
	qshortcutdialog.cc \
	qshortcutmanager.cc \
	RemeshingMode.cc \ 
	stylesheeteditor.cc \
	TdxDeviceWrappers.cc \
	TexturingMode.cc \
	TMPatchFace.cc \
	TMPatchObject.cc \
	TopMod.cc \
	TopModPreferences.cc

RESOURCES += application.qrc

TRANSLATIONS += \
	lang/topmod_ca.ts \
	lang/topmod_de.ts \
	lang/topmod_en.ts \
	lang/topmod_es.ts \
	lang/topmod_fr.ts \
	lang/topmod_hi.ts \
	lang/topmod_it.ts \
	lang/topmod_tr.ts

CONFIG(WITH_VERSE){

HEADERS += \
	include/verse/DNA_ID.h \
	include/verse/DNA_listBase.h \
	include/verse/DNA_mesh_types.h \
	include/verse/DNA_meshdata_types.h \
	include/verse/DNA_object_types.h \
	include/verse/DNA_scriptlink_types.h \
	include/verse/MEM_guardedalloc.h \
	include/verse/mydevice.h \
	include/verse/TIF_editmesh.h \
	include/verse/TIF_space.h \
	include/verse/TIF_verse.h \
	include/verse/TKE_depsgraph.h \
	include/verse/TKE_global.h \
	include/verse/TKE_mesh.h \
	include/verse/TKE_object.h \
	include/verse/TKE_utildefines.h \
	include/verse/TKE_verse.h \
	include/verse/TLI_arithb.h \
	include/verse/TLI_dynamiclist.h \
	include/verse/TLI_editVert.h \
	include/verse/TLI_toplib.h \
	include/verse/TLI_util.h \
	VerseTopMod.hh

SOURCES += \
	include/verse/mallocn.cc \
	include/verse/util.cc \
	include/verse/verse_common.cc \
	include/verse/verse_geometry_node.cc \
	include/verse/verse_mesh.cc \
	include/verse/verse_node.cc \
	include/verse/verse_object.cc \
	include/verse/verse_object_node.cc \
	include/verse/verse_session.cc \
	VerseTopMod.cc

}
