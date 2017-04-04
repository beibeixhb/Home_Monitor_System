
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * Created by Haobo_X on 02/12/2016.
 */
public class latencyServer {
    public static void main(String[] args) throws Exception {
        InetAddress bindAddress = null;
        if (args.length > 0) {
            bindAddress = InetAddress.getByName(args[0]);
        }
        int port = 2016;
        ServerSocket ss = new ServerSocket(port, 0, bindAddress);
        while (true) {
            Socket client = ss.accept();
            BufferedReader in = new BufferedReader(new InputStreamReader(client.getInputStream()));
            // PrintWriter out = new PrintWriter(client.getOutputStream());
            BufferedWriter out = new BufferedWriter(new OutputStreamWriter(client.getOutputStream()));

            // out.print("HTTP/1.1 200 \r\n");
            // out.print("Content-Type: text/plain\r\n");
            // out.print("Connection: close\r\n");
            // out.print("\r\n");

            String line;
            while ((line = in.readLine()) != null) {
                if (line.length() == 0) {
                    break;
                }
                System.out.println("Message from client: " + line);
                out.write(line);
                out.newLine();
                out.flush();
                System.out.println("sending complete");
            }

            out.close();
            in.close();
            client.close();
        }
    }
}

