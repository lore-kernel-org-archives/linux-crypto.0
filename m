From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 4/5][CRYPTO] tcrypt: Add test vectors for RIPEMD-256 and RIPEMD-320
Date: Wed,  7 May 2008 23:58:38 +0200
Message-ID: <1210197519-18432-5-git-send-email-rueegsegger@swiss-it.ch>
References: <>
 <1210197519-18432-1-git-send-email-rueegsegger@swiss-it.ch>
 <1210197519-18432-2-git-send-email-rueegsegger@swiss-it.ch>
 <1210197519-18432-3-git-send-email-rueegsegger@swiss-it.ch>
 <1210197519-18432-4-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2379 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbYEGV6s (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 17:58:48 -0400
In-Reply-To: <1210197519-18432-4-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds test vectors for RIPEMD-256 and
RIPEMD-320 hash algorithms.

The test vectors are taken from
<http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
---
 crypto/tcrypt.c |   21 ++++++++-
 crypto/tcrypt.h |  136 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 155 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 70f9ba7..257832b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -76,7 +76,8 @@ static char *check[] = {
 	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
-	"camellia", "seed", "salsa20", "rmd128", "rmd160", "lzo", "cts", NULL
+	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
+	"lzo", "cts", NULL
 };
 
 static void hexdump(unsigned char *buf, unsigned int len)
@@ -1551,7 +1552,7 @@ static void do_test(void)
 	case 29:
 		test_hash("tgr128", tgr128_tv_template, TGR128_TEST_VECTORS);
 		break;
-		
+
 	case 30:
 		test_cipher("ecb(xeta)", ENCRYPT, xeta_enc_tv_template,
 			    XETA_ENC_TEST_VECTORS);
@@ -1624,6 +1625,14 @@ static void do_test(void)
 		test_hash("rmd160", rmd160_tv_template, RMD160_TEST_VECTORS);
 		break;
 
+	case 41:
+		test_hash("rmd256", rmd256_tv_template, RMD256_TEST_VECTORS);
+		break;
+
+	case 42:
+		test_hash("rmd320", rmd320_tv_template, RMD320_TEST_VECTORS);
+		break;
+
 	case 100:
 		test_hash("hmac(md5)", hmac_md5_tv_template,
 			  HMAC_MD5_TEST_VECTORS);
@@ -1815,6 +1824,14 @@ static void do_test(void)
 		test_hash_speed("rmd160", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
+	case 316:
+		test_hash_speed("rmd256", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
+	case 317:
+		test_hash_speed("rmd320", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index af91f0c..20bd5fe 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -294,6 +294,142 @@ static struct hash_testvec rmd160_tv_template[] = {
 };
 
 /*
+ * RIPEMD-256 test vectors
+ */
+#define RMD256_TEST_VECTORS     8
+
+static struct hash_testvec rmd256_tv_template[] = {
+	{
+		.digest	= "\x02\xba\x4c\x4e\x5f\x8e\xcd\x18"
+			  "\x77\xfc\x52\xd6\x4d\x30\xe3\x7a"
+			  "\x2d\x97\x74\xfb\x1e\x5d\x02\x63"
+			  "\x80\xae\x01\x68\xe3\xc5\x52\x2d",
+	}, {
+		.plaintext = "a",
+		.psize	= 1,
+		.digest	= "\xf9\x33\x3e\x45\xd8\x57\xf5\xd9"
+			  "\x0a\x91\xba\xb7\x0a\x1e\xba\x0c"
+			  "\xfb\x1b\xe4\xb0\x78\x3c\x9a\xcf"
+			  "\xcd\x88\x3a\x91\x34\x69\x29\x25",
+	}, {
+		.plaintext = "abc",
+		.psize	= 3,
+		.digest	= "\xaf\xbd\x6e\x22\x8b\x9d\x8c\xbb"
+			  "\xce\xf5\xca\x2d\x03\xe6\xdb\xa1"
+			  "\x0a\xc0\xbc\x7d\xcb\xe4\x68\x0e"
+			  "\x1e\x42\xd2\xe9\x75\x45\x9b\x65",
+	}, {
+		.plaintext = "message digest",
+		.psize	= 14,
+		.digest	= "\x87\xe9\x71\x75\x9a\x1c\xe4\x7a"
+			  "\x51\x4d\x5c\x91\x4c\x39\x2c\x90"
+			  "\x18\xc7\xc4\x6b\xc1\x44\x65\x55"
+			  "\x4a\xfc\xdf\x54\xa5\x07\x0c\x0e",
+	}, {
+		.plaintext = "abcdefghijklmnopqrstuvwxyz",
+		.psize	= 26,
+		.digest	= "\x64\x9d\x30\x34\x75\x1e\xa2\x16"
+			  "\x77\x6b\xf9\xa1\x8a\xcc\x81\xbc"
+			  "\x78\x96\x11\x8a\x51\x97\x96\x87"
+			  "\x82\xdd\x1f\xd9\x7d\x8d\x51\x33",
+	}, {
+		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
+			     "fghijklmnopqrstuvwxyz0123456789",
+		.psize	= 62,
+		.digest	= "\x57\x40\xa4\x08\xac\x16\xb7\x20"
+			  "\xb8\x44\x24\xae\x93\x1c\xbb\x1f"
+			  "\xe3\x63\xd1\xd0\xbf\x40\x17\xf1"
+			  "\xa8\x9f\x7e\xa6\xde\x77\xa0\xb8",
+	}, {
+		.plaintext = "1234567890123456789012345678901234567890"
+			     "1234567890123456789012345678901234567890",
+		.psize	= 80,
+		.digest	= "\x06\xfd\xcc\x7a\x40\x95\x48\xaa"
+			  "\xf9\x13\x68\xc0\x6a\x62\x75\xb5"
+			  "\x53\xe3\xf0\x99\xbf\x0e\xa4\xed"
+			  "\xfd\x67\x78\xdf\x89\xa8\x90\xdd",
+        }, {
+		.plaintext = "abcdbcdecdefdefgefghfghighij"
+			     "hijkijkljklmklmnlmnomnopnopq",
+		.psize	= 56,
+		.digest	= "\x38\x43\x04\x55\x83\xaa\xc6\xc8"
+			  "\xc8\xd9\x12\x85\x73\xe7\xa9\x80"
+			  "\x9a\xfb\x2a\x0f\x34\xcc\xc3\x6e"
+			  "\xa9\xe7\x2f\x16\xf6\x36\x8e\x3f",
+		.np	= 2,
+		.tap	= { 28, 28 },
+	}
+};
+
+/*
+ * RIPEMD-320 test vectors
+ */
+#define RMD320_TEST_VECTORS     8
+
+static struct hash_testvec rmd320_tv_template[] = {
+	{
+		.digest	= "\x22\xd6\x5d\x56\x61\x53\x6c\xdc\x75\xc1"
+			  "\xfd\xf5\xc6\xde\x7b\x41\xb9\xf2\x73\x25"
+			  "\xeb\xc6\x1e\x85\x57\x17\x7d\x70\x5a\x0e"
+			  "\xc8\x80\x15\x1c\x3a\x32\xa0\x08\x99\xb8",
+	}, {
+		.plaintext = "a",
+		.psize	= 1,
+		.digest	= "\xce\x78\x85\x06\x38\xf9\x26\x58\xa5\xa5"
+			  "\x85\x09\x75\x79\x92\x6d\xda\x66\x7a\x57"
+			  "\x16\x56\x2c\xfc\xf6\xfb\xe7\x7f\x63\x54"
+			  "\x2f\x99\xb0\x47\x05\xd6\x97\x0d\xff\x5d",
+	}, {
+		.plaintext = "abc",
+		.psize	= 3,
+		.digest	= "\xde\x4c\x01\xb3\x05\x4f\x89\x30\xa7\x9d"
+			  "\x09\xae\x73\x8e\x92\x30\x1e\x5a\x17\x08"
+			  "\x5b\xef\xfd\xc1\xb8\xd1\x16\x71\x3e\x74"
+			  "\xf8\x2f\xa9\x42\xd6\x4c\xdb\xc4\x68\x2d",
+	}, {
+		.plaintext = "message digest",
+		.psize	= 14,
+		.digest	= "\x3a\x8e\x28\x50\x2e\xd4\x5d\x42\x2f\x68"
+			  "\x84\x4f\x9d\xd3\x16\xe7\xb9\x85\x33\xfa"
+			  "\x3f\x2a\x91\xd2\x9f\x84\xd4\x25\xc8\x8d"
+			  "\x6b\x4e\xff\x72\x7d\xf6\x6a\x7c\x01\x97",
+	}, {
+		.plaintext = "abcdefghijklmnopqrstuvwxyz",
+		.psize	= 26,
+		.digest	= "\xca\xbd\xb1\x81\x0b\x92\x47\x0a\x20\x93"
+			  "\xaa\x6b\xce\x05\x95\x2c\x28\x34\x8c\xf4"
+			  "\x3f\xf6\x08\x41\x97\x51\x66\xbb\x40\xed"
+			  "\x23\x40\x04\xb8\x82\x44\x63\xe6\xb0\x09",
+	}, {
+		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
+			     "fghijklmnopqrstuvwxyz0123456789",
+		.psize	= 62,
+		.digest	= "\xed\x54\x49\x40\xc8\x6d\x67\xf2\x50\xd2"
+			  "\x32\xc3\x0b\x7b\x3e\x57\x70\xe0\xc6\x0c"
+			  "\x8c\xb9\xa4\xca\xfe\x3b\x11\x38\x8a\xf9"
+			  "\x92\x0e\x1b\x99\x23\x0b\x84\x3c\x86\xa4",
+	}, {
+		.plaintext = "1234567890123456789012345678901234567890"
+			     "1234567890123456789012345678901234567890",
+		.psize	= 80,
+		.digest	= "\x55\x78\x88\xaf\x5f\x6d\x8e\xd6\x2a\xb6"
+			  "\x69\x45\xc6\xd2\xa0\xa4\x7e\xcd\x53\x41"
+			  "\xe9\x15\xeb\x8f\xea\x1d\x05\x24\x95\x5f"
+			  "\x82\x5d\xc7\x17\xe4\xa0\x08\xab\x2d\x42",
+        }, {
+		.plaintext = "abcdbcdecdefdefgefghfghighij"
+			     "hijkijkljklmklmnlmnomnopnopq",
+		.psize	= 56,
+		.digest	= "\xd0\x34\xa7\x95\x0c\xf7\x22\x02\x1b\xa4"
+			  "\xb8\x4d\xf7\x69\xa5\xde\x20\x60\xe2\x59"
+			  "\xdf\x4c\x9b\xb4\xa4\x26\x8c\x0e\x93\x5b"
+			  "\xbc\x74\x70\xa9\x69\xc9\xd0\x72\xa1\xac",
+		.np	= 2,
+		.tap	= { 28, 28 },
+	}
+};
+
+/*
  * SHA1 test vectors  from from FIPS PUB 180-1
  */
 #define SHA1_TEST_VECTORS	2
-- 
1.5.2.5

