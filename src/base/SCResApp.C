#include "SCResApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
SCResApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

SCResApp::SCResApp(InputParameters parameters) : MooseApp(parameters)
{
  SCResApp::registerAll(_factory, _action_factory, _syntax);
}

SCResApp::~SCResApp() {}

void 
SCResApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<SCResApp>(f, af, s);
  Registry::registerObjectsTo(f, {"SCResApp"});
  Registry::registerActionsTo(af, {"SCResApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
SCResApp::registerApps()
{
  registerApp(SCResApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
SCResApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  SCResApp::registerAll(f, af, s);
}
extern "C" void
SCResApp__registerApps()
{
  SCResApp::registerApps();
}
