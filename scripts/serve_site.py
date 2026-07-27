"""Serve docs locally with HTTP byte ranges for podcast seeking."""

from __future__ import annotations

import argparse
import os
import re
import shutil
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path


RANGE_RE = re.compile(r"bytes=(\d*)-(\d*)$")


class RangeRequestHandler(SimpleHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def send_head(self):
        path = self.translate_path(self.path)
        if os.path.isdir(path):
            return super().send_head()

        content_type = self.guess_type(path)
        try:
            source = open(path, "rb")
        except OSError:
            self.send_error(404, "File not found")
            return None

        file_size = os.fstat(source.fileno()).st_size
        start, end = 0, max(file_size - 1, 0)
        range_header = self.headers.get("Range")
        if range_header:
            match = RANGE_RE.fullmatch(range_header.strip())
            if not match:
                source.close()
                self.send_error(416, "Invalid byte range")
                return None
            first, last = match.groups()
            if first:
                start = int(first)
                end = int(last) if last else end
            elif last:
                suffix_length = int(last)
                start = max(file_size - suffix_length, 0)
            if start >= file_size or end < start:
                source.close()
                self.send_response(416)
                self.send_header("Content-Range", f"bytes */{file_size}")
                self.end_headers()
                return None
            end = min(end, file_size - 1)
            self.send_response(206)
            self.send_header("Content-Range", f"bytes {start}-{end}/{file_size}")
        else:
            self.send_response(200)

        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(end - start + 1))
        self.send_header("Accept-Ranges", "bytes")
        self.send_header("Last-Modified", self.date_time_string(os.fstat(source.fileno()).st_mtime))
        self.end_headers()
        self._active_range = (start, end)
        return source

    def copyfile(self, source, outputfile):
        start, end = getattr(self, "_active_range", (0, None))
        source.seek(start)
        if end is None:
            shutil.copyfileobj(source, outputfile)
            return
        remaining = end - start + 1
        while remaining:
            chunk = source.read(min(64 * 1024, remaining))
            if not chunk:
                break
            outputfile.write(chunk)
            remaining -= len(chunk)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8787)
    parser.add_argument("--directory", type=Path, default=Path("docs"))
    args = parser.parse_args()
    directory = args.directory.resolve()
    handler = partial(RangeRequestHandler, directory=str(directory))
    server = ThreadingHTTPServer(("127.0.0.1", args.port), handler)
    print(f"Serving {directory} at http://127.0.0.1:{args.port}", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
