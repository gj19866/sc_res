//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "SCResTestApp.h"
#include "SCResApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
SCResTestApp::validParams()
{
  InputParameters params = SCResApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

SCResTestApp::SCResTestApp(InputParameters parameters) : MooseApp(parameters)
{
  SCResTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

SCResTestApp::~SCResTestApp() {}

void
SCResTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  SCResApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"SCResTestApp"});
    Registry::registerActionsTo(af, {"SCResTestApp"});
  }
}

void
SCResTestApp::registerApps()
{
  registerApp(SCResApp);
  registerApp(SCResTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
SCResTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  SCResTestApp::registerAll(f, af, s);
}
extern "C" void
SCResTestApp__registerApps()
{
  SCResTestApp::registerApps();
}
