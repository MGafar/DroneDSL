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
import java.util.concurrent.Executors
import java.io.File
import java.io.PrintWriter
import java.util.concurrent.TimeUnit
import java.util.Arrays

class ServerLauncher {
	
	static boolean shutdown = false;

	def static InetAddress getIPv4InetAddress() throws SocketException, UnknownHostException{
		
		val ni = NetworkInterface.getByName("wlan0");
		
//		val ni = NetworkInterface.getByName("wlp3s0");
		
		try{
			ni.getInetAddresses();
		} catch (Exception e)
		{
			println("Unable to find NIC");
			println("Running on localhost");
			return InetAddress.getLocalHost();
		}
		
		val ias = ni.getInetAddresses();
		var iaddress = ias.nextElement();
		
		while(!(iaddress instanceof Inet4Address))
		{
			iaddress = ias.nextElement();
		}
		
		println("Reaches here");
		
		return iaddress;
	}
	
	def static void gallery_listener()
	{
		val executor = Executors.newSingleThreadScheduledExecutor();
			
		var Runnable gallery_thread = new Runnable() 
		{
			var File[] temp_files = null;
			
			override run() {
				
				if(shutdown)
					executor.shutdown()
					
				var PrintWriter writer
				try {
					var i = 1;

					var File[] files = new File("WebRoot/images").listFiles();
					
					Arrays.sort(files)
					
					//Checks if there's file changes in directory
					//If it's the same a new HTML Document isn't created
					if(Arrays.equals(files, temp_files))
						return;
					
					writer = new PrintWriter("WebRoot/html/lightbox.html", "UTF-8");
					temp_files = files.clone();
											
					writer.println("<div class=\"row\">");
					
					for (File file : files) {
					    if (file.isFile()) {
					    	writer.println("   <div class=\"column\">");
					    	writer.println("      <img src=\"images/" + file.getName() + "\" style=\"width:100%\" onclick=\"openModal();currentSlide(" + i + ")\" class=\"hover-shadow cursor\">");
					    	writer.println("   </div>");
					    	i++;
					    }
					}
					writer.println("</div>");
					
					writer.println("<div id=\"myModal\" class=\"modal\">");
					writer.println("  <span class=\"close cursor\" onclick=\"closeModal()\">&times;</span>");
					writer.println("  <div class=\"modal-content\">");
				
					var number_of_images = i-1;
					i = 1;
					for (File file : files) {
					    if (file.isFile()) {
							writer.println("    <div class=\"mySlides\">");
							writer.println("      <div class=\"numbertext\">" + i + " / " + number_of_images + "</div>");
							writer.println("      <img src=\"images/" + file.getName() + "\" style=\"width:100%\">");
							writer.println("    </div>");
					    	i++;
					    }
					}
					
					writer.println("	<a class=\"prev\" onclick=\"plusSlides(-1)\">&#10094;</a>");
					writer.println("    <a class=\"next\" onclick=\"plusSlides(1)\">&#10095;</a>");
					writer.println("    <div class=\"caption-container\">");
					writer.println("      <p id=\"caption\"></p>");
					writer.println("    </div>");					
				
					i = 1;
					for (File file : files) {
					    if (file.isFile()) {
							writer.println("	<div class=\"column\">");
							writer.println("      <img class=\"demo cursor\" src=\"images/" + file.getName() + "\" style=\"width:100%\" onclick=\"currentSlide("+ i +")\" alt=\"" + file.getName() + "\">");
							writer.println("    </div>");
					    	i++;
					    }
					}
				
					writer.println("   </div>");
					writer.println("</div>");
				
					writer.close();	
																
				} catch (Exception e) {
					e.printStackTrace()
					executor.shutdown();
				}
			}			
		}
		executor.scheduleAtFixedRate(gallery_thread, 0, 5, TimeUnit.SECONDS);
	}

	def static void main(String[] args) {
			
		val server = new Server(new InetSocketAddress(getIPv4InetAddress(), 8088))
		
		server.handler = new WebAppContext => [
			resourceBase = 'WebRoot'
			welcomeFiles = #["index.html"]
			contextPath = "/"
			configurations = #[
				new AnnotationConfiguration,
				new WebInfConfiguration,
				new WebXmlConfiguration,
				new MetaInfConfiguration
			]
			setAttribute(WebInfConfiguration.CONTAINER_JAR_PATTERN, '.*/ic\\.ac\\.uk\\.xdrone\\.web/.*,.*\\.jar')
			setInitParameter("org.mortbay.jetty.servlet.Default.useFileMappedBuffer", "false")
		]
		val log = new Slf4jLog(ServerLauncher.name)
		try {
			server.start
			gallery_listener();
			log.info('Server started ' + server.getURI + '...')
			log.info(Inet4Address.getLocalHost().getHostAddress())
			new Thread[
				log.info('Press enter to stop the server...')
				val key = System.in.read
				if (key != -1) {
					shutdown = true
					server.stop
				} else {
					log.warn('Console input is not available. In order to stop the server, you need to cancel process manually.')
				}
			].start
			server.join
		} catch (Exception exception) {
			log.warn(exception.message)
			shutdown = true
			System.exit(1)
		}
	}
}
