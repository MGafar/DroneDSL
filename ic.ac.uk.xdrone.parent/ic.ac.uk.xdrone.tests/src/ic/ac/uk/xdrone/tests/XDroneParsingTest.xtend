/*
 * generated by Xtext 2.14.0
 */
package ic.ac.uk.xdrone.tests

import com.google.inject.Inject
import ic.ac.uk.xdrone.xDrone.Program
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(XDroneInjectorProvider)
class XDroneParsingTest {
	@Inject
	ParseHelper<Program> parseHelper
	
//	@Test
//	def void loadModel() {
//		val result = parseHelper.parse('''
//			xdrone Test
//			begin
//			end
//		''')
//		Assert.assertNotNull(result)
//		val errors = result.eResource.errors
//		Assert.assertTrue('''Unexpected errors: «errors.join(", ")»''', errors.isEmpty)
//	}
}
