
import java.net.*;
import java.io.*;
import java.io.InputStreamReader;
import java.lang.*;

/**
 * Created by Haobo_X on 02/12/2016.
 */
public class latencyClient {
    public static void main(String[] args) throws Exception {
        int port = 2016;
        Socket sock = new Socket("127.0.0.1", port);
        BufferedReader in = new BufferedReader(new InputStreamReader(sock.getInputStream()));
        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(sock.getOutputStream()));

        BufferedReader sysin = new BufferedReader(new InputStreamReader(System.in));

        String line;
        while (true) {
            System.out.println("input a string: ");
            line = sysin.readLine();
            if ((line == null) || (line.length() == 0)) {
                break;
            }
            out.write(line);
            out.newLine();
            out.flush();
            System.out.println("Message from server: " + in.readLine());
        }
        sock.close();
    }
}
