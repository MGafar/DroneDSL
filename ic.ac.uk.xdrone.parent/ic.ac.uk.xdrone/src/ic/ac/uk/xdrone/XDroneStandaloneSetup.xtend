/*
 * generated by Xtext 2.14.0
 */
package ic.ac.uk.xdrone


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class XDroneStandaloneSetup extends XDroneStandaloneSetupGenerated {

	def static void doSetup() {
		new XDroneStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
