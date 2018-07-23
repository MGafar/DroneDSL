/*
 * generated by Xtext 2.14.0
 */
package ic.ac.uk.xdrone.web

import java.net.InetSocketAddress
import org.eclipse.jetty.annotations.AnnotationConfiguration
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.util.log.Slf4jLog
import org.eclipse.jetty.webapp.MetaInfConfiguration
import org.eclipse.jetty.webapp.WebAppContext
import org.eclipse.jetty.webapp.WebInfConfiguration
import org.eclipse.jetty.webapp.WebXmlConfiguration
import java.net.Inet4Address
import java.net.NetworkInterface
import java.net.InetAddress
import java.net.SocketException
import java.net.UnknownHostException
import java.util.Enumeration

class ServerLauncher {
	
	def static InetAddress getIPv4InetAddress() throws SocketException, UnknownHostException{
		
		val ni = NetworkInterface.getByName("wlan0");
		
//		val ni = NetworkInterface.getByName("wlp3s0");
		
		val ias = ni.getInetAddresses();
		
		var iaddress = ias.nextElement();
		
		while(!(iaddress instanceof Inet4Address))
		{
			iaddress = ias.nextElement();
		}
		
		return iaddress;
	}

	def static void main(String[] args) {
			
		val server = new Server(new InetSocketAddress(getIPv4InetAddress(), 8080))
		
		server.handler = new WebAppContext => [
			resourceBase = 'WebRoot'
			welcomeFiles = #["index.html"]
			contextPath = "/"
			configurations = #[
				new AnnotationConfiguration,
				new WebXmlConfiguration,
				new WebInfConfiguration,
				new MetaInfConfiguration
			]
			setAttribute(WebInfConfiguration.CONTAINER_JAR_PATTERN, '.*/ic\\.ac\\.uk\\.xdrone\\.web/.*,.*\\.jar')
			setInitParameter("org.mortbay.jetty.servlet.Default.useFileMappedBuffer", "false")
		]
		val log = new Slf4jLog(ServerLauncher.name)
		try {
			server.start
			log.info('Server started ' + server.getURI + '...')
			log.info(Inet4Address.getLocalHost().getHostAddress())
			new Thread[
				log.info('Press enter to stop the server...')
				val key = System.in.read
				if (key != -1) {
					server.stop
				} else {
					log.warn('Console input is not available. In order to stop the server, you need to cancel process manually.')
				}
			].start
			server.join
		} catch (Exception exception) {
			log.warn(exception.message)
			System.exit(1)
		}
	}
}
