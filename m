From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] sign-file: Fix inplace signing when src and dst names
 are both specified
Date: Tue, 13 Dec 2016 09:26:25 +0000
Message-ID: <148162118593.19689.10958229431557794889.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Alex Yashchenko <alexhoppus111@gmail.com>,
        linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Alex Yashchenko <alexhoppus111@gmail.com>

When src and dst both are specified and they point to the same file
the sign-file utility will write only signature to the dst file and
the module (.ko file) body will not be written.
That happens because we open the same file with "rb" and "wb" flags,
from fopen man:

 w      Truncate file to zero length or create text file for writing.
The stream is positioned at the beginning of the file.
...
	bm = BIO_new_file(module_name, "rb");
...
	bd = BIO_new_file(dest_name, "wb");
...
	while ((n = BIO_read(bm, buf, sizeof(buf))),
	       n > 0) {
		ERR(BIO_write(bd, buf, n) < 0, "%s", dest_name);
	}
...

Signed-off-by: Alex Yashchenko <alexhoppus111@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/sign-file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 53af6dc3e6c1..19ec468b1168 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -267,7 +267,7 @@ int main(int argc, char **argv)
 	}
 	x509_name = argv[2];
 	module_name = argv[3];
-	if (argc == 5) {
+	if (argc == 5 && strcmp(argv[3], argv[4]) != 0) {
 		dest_name = argv[4];
 		replace_orig = false;
 	} else {
