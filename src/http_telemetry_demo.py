from http.server import BaseHTTPRequestHandler, HTTPServer
import time
from datetime import datetime

PORT = 8000
start_time = time.time()

HTML_TEMPLATE = """
<!DOCTYPE html>
<meta http-equiv="Refresh" content="5">
<html>
<head>
    <title>Demo: Telemetry Log Output</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            margin: 30px;
        }}
        table {{
            border-collapse: collapse;
            width: 100%;
            max-height: 400px;
            overflow-y: scroll;
            display: block;
            border: 1px solid #ddd;
        }}
        th, td {{
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
            white-space: nowrap;
        }}
        th {{
            background-color: #f2f2f2;
            position: sticky;
            top: 0;
        }}
    </style>
</head>
<body>
    <h1>Telemetry Log Output</h1>
    <p>New log entries are published every 10 seconds. Manually refresh to
    see new entries immeadiately. This page refreshes automatically every
    5 seconds.</p>
    <div style="max-height:400px; overflow-y:auto; border:1px solid #ccc;">
      <table>
          <thead>
              <tr>
                  <th>Timestamp</th>
                  <th>Message</th>
                  <th>Counter</th>
              </tr>
          </thead>
          <tbody>
          {rows}
          </tbody>
      </table>
    </div>
</body>
</html>
"""

def generate_log_rows(counter_max):
    rows = []
    for i in range(counter_max + 1):
        # Calculate timestamp for each "log" entry: start_time + i*10 seconds
        entry_time = start_time + i * 10
        timestamp_str = datetime.fromtimestamp(entry_time).strftime("%Y-%m-%d %H:%M:%S")
        rows.append(f"<tr><td>{timestamp_str}</td><td>test message</td><td>{i}</td></tr>")
    return "\n".join(rows)

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            elapsed_seconds = int(time.time() - start_time)
            counter = elapsed_seconds // 10

            rows_html = generate_log_rows(counter)

            content = HTML_TEMPLATE.format(rows=rows_html).encode('utf-8')

            self.send_response(200)
            self.send_header("Content-type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(content)))
            self.end_headers()
            self.wfile.write(content)
        else:
            self.send_response(404)
            self.end_headers()

def run():
    server_address = ('', PORT)
    httpd = HTTPServer(server_address, SimpleHandler)
    print(f'Serving on port {PORT}...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()