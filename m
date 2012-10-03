From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] asymmetric keys: fix printk format warning
Date: Wed, 03 Oct 2012 16:04:46 -0700
Message-ID: <506CC48E.2020303@xenotime.net>
References: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20121003173007.c322d79c31676b9494a6bfd5@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning in x509_cert_parser.c:

crypto/asymmetric_keys/x509_cert_parser.c: In function 'x509_note_OID':
crypto/asymmetric_keys/x509_cert_parser.c:113:3: warning: format '%zu' expects type 'size_t', but argument 2 has type 'long unsigned int'

Builds cleanly on i386 and x86_64.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
---
 crypto/asymmetric_keys/x509_cert_parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20121003.orig/crypto/asymmetric_keys/x509_cert_parser.c
+++ linux-next-20121003/crypto/asymmetric_keys/x509_cert_parser.c
@@ -110,7 +110,7 @@ int x509_note_OID(void *context, size_t
 	if (ctx->last_oid == OID__NR) {
 		char buffer[50];
 		sprint_oid(value, vlen, buffer, sizeof(buffer));
-		pr_debug("Unknown OID: [%zu] %s\n",
+		pr_debug("Unknown OID: [%lu] %s\n",
 			 (unsigned long)value - ctx->data, buffer);
 	}
 	return 0;
