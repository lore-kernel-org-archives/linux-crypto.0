From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 4/5] crypto: testmgr - add zlib test
Date: Wed, 18 Feb 2009 16:53:21 +0100
Message-ID: <1234972402-24298-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1234972402-24298-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1234972402-24298-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57313 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752035AbZBRPx0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 10:53:26 -0500
In-Reply-To: <1234972402-24298-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/Kconfig   |    1 +
 crypto/tcrypt.c  |    6 +++-
 crypto/testmgr.c |   15 +++++++++
 crypto/testmgr.h |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 114 insertions(+), 1 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 85cc7fa..87c7530 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -91,6 +91,7 @@ config CRYPTO_MANAGER2
 	select CRYPTO_AEAD2
 	select CRYPTO_HASH2
 	select CRYPTO_BLKCIPHER2
+	select CRYPTO_PCOMP
 
 config CRYPTO_GF128MUL
 	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 28a45a1..c3c9124 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -53,7 +53,7 @@ static char *check[] = {
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
 	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
-	"lzo", "cts", NULL
+	"lzo", "cts", "zlib", NULL
 };
 
 static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
@@ -661,6 +661,10 @@ static void do_test(int m)
 		tcrypt_test("ecb(seed)");
 		break;
 
+	case 44:
+		tcrypt_test("zlib");
+		break;
+
 	case 100:
 		tcrypt_test("hmac(md5)");
 		break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 54b96ed..4703137 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2016,6 +2016,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 				}
 			}
 		}
+	}, {
+		.alg = "zlib",
+		.test = alg_test_pcomp,
+		.suite = {
+			.pcomp = {
+				.comp = {
+					.vecs = zlib_comp_tv_template,
+					.count = ZLIB_COMP_TEST_VECTORS
+				},
+				.decomp = {
+					.vecs = zlib_decomp_tv_template,
+					.count = ZLIB_DECOMP_TEST_VECTORS
+				}
+			}
+		}
 	}
 };
 
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 81b7eb0..098c033 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15,6 +15,7 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
 
+#include <linux/zlib.h>
 #include <crypto/compress.h>
 
 #define MAX_DIGEST_SIZE		64
@@ -8360,6 +8361,7 @@ struct pcomp_testvec {
  * Deflate test vectors (null-terminated strings).
  * Params: winbits=-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
  */
+
 #define DEFLATE_COMP_TEST_VECTORS 2
 #define DEFLATE_DECOMP_TEST_VECTORS 2
 
@@ -8435,6 +8437,97 @@ static struct comp_testvec deflate_decomp_tv_template[] = {
 	},
 };
 
+#define ZLIB_COMP_TEST_VECTORS 2
+#define ZLIB_DECOMP_TEST_VECTORS 2
+
+static const struct zlib_comp_params deflate_comp_params = {
+	.level			= Z_DEFAULT_COMPRESSION,
+	.method			= Z_DEFLATED,
+	.windowBits		= -11,
+	.memLevel		= MAX_MEM_LEVEL,
+	.strategy		= Z_DEFAULT_STRATEGY
+};
+
+static const struct zlib_decomp_params deflate_decomp_params = {
+	.windowBits		= -11,
+};
+
+static struct pcomp_testvec zlib_comp_tv_template[] = {
+	{
+		.params = &deflate_comp_params,
+		.inlen	= 70,
+		.outlen	= 38,
+		.input	= "Join us now and share the software "
+			"Join us now and share the software ",
+		.output	= "\xf3\xca\xcf\xcc\x53\x28\x2d\x56"
+			  "\xc8\xcb\x2f\x57\x48\xcc\x4b\x51"
+			  "\x28\xce\x48\x2c\x4a\x55\x28\xc9"
+			  "\x48\x55\x28\xce\x4f\x2b\x29\x07"
+			  "\x71\xbc\x08\x2b\x01\x00",
+	}, {
+		.params = &deflate_comp_params,
+		.inlen	= 191,
+		.outlen	= 122,
+		.input	= "This document describes a compression method based on the DEFLATE"
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+		.output	= "\x5d\x8d\x31\x0e\xc2\x30\x10\x04"
+			  "\xbf\xb2\x2f\xc8\x1f\x10\x04\x09"
+			  "\x89\xc2\x85\x3f\x70\xb1\x2f\xf8"
+			  "\x24\xdb\x67\xd9\x47\xc1\xef\x49"
+			  "\x68\x12\x51\xae\x76\x67\xd6\x27"
+			  "\x19\x88\x1a\xde\x85\xab\x21\xf2"
+			  "\x08\x5d\x16\x1e\x20\x04\x2d\xad"
+			  "\xf3\x18\xa2\x15\x85\x2d\x69\xc4"
+			  "\x42\x83\x23\xb6\x6c\x89\x71\x9b"
+			  "\xef\xcf\x8b\x9f\xcf\x33\xca\x2f"
+			  "\xed\x62\xa9\x4c\x80\xff\x13\xaf"
+			  "\x52\x37\xed\x0e\x52\x6b\x59\x02"
+			  "\xd9\x4e\xe8\x7a\x76\x1d\x02\x98"
+			  "\xfe\x8a\x87\x83\xa3\x4f\x56\x8a"
+			  "\xb8\x9e\x8e\x5c\x57\xd3\xa0\x79"
+			  "\xfa\x02",
+	},
+};
+
+static struct pcomp_testvec zlib_decomp_tv_template[] = {
+	{
+		.params = &deflate_decomp_params,
+		.inlen	= 122,
+		.outlen	= 191,
+		.input	= "\x5d\x8d\x31\x0e\xc2\x30\x10\x04"
+			  "\xbf\xb2\x2f\xc8\x1f\x10\x04\x09"
+			  "\x89\xc2\x85\x3f\x70\xb1\x2f\xf8"
+			  "\x24\xdb\x67\xd9\x47\xc1\xef\x49"
+			  "\x68\x12\x51\xae\x76\x67\xd6\x27"
+			  "\x19\x88\x1a\xde\x85\xab\x21\xf2"
+			  "\x08\x5d\x16\x1e\x20\x04\x2d\xad"
+			  "\xf3\x18\xa2\x15\x85\x2d\x69\xc4"
+			  "\x42\x83\x23\xb6\x6c\x89\x71\x9b"
+			  "\xef\xcf\x8b\x9f\xcf\x33\xca\x2f"
+			  "\xed\x62\xa9\x4c\x80\xff\x13\xaf"
+			  "\x52\x37\xed\x0e\x52\x6b\x59\x02"
+			  "\xd9\x4e\xe8\x7a\x76\x1d\x02\x98"
+			  "\xfe\x8a\x87\x83\xa3\x4f\x56\x8a"
+			  "\xb8\x9e\x8e\x5c\x57\xd3\xa0\x79"
+			  "\xfa\x02",
+		.output	= "This document describes a compression method based on the DEFLATE"
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+	}, {
+		.params = &deflate_decomp_params,
+		.inlen	= 38,
+		.outlen	= 70,
+		.input	= "\xf3\xca\xcf\xcc\x53\x28\x2d\x56"
+			  "\xc8\xcb\x2f\x57\x48\xcc\x4b\x51"
+			  "\x28\xce\x48\x2c\x4a\x55\x28\xc9"
+			  "\x48\x55\x28\xce\x4f\x2b\x29\x07"
+			  "\x71\xbc\x08\x2b\x01\x00",
+		.output	= "Join us now and share the software "
+			"Join us now and share the software ",
+	},
+};
+
 /*
  * LZO test vectors (null-terminated strings).
  */
-- 
1.6.0.4

