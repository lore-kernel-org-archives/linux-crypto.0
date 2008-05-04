From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 2/3]CRYPTO] RIPEMD: add test vectors for RIPEMD-128 and RIPEMD-160.
Date: Sun,  4 May 2008 17:03:32 +0200
Message-ID: <1209913413-8229-3-git-send-email-rueegsegger@swiss-it.ch>
References: <>
 <1209913413-8229-1-git-send-email-rueegsegger@swiss-it.ch>
 <1209913413-8229-2-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2525 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYEDPDk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 May 2008 11:03:40 -0400
In-Reply-To: <1209913413-8229-2-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds test vectors for RIPEMD-128 and
RIPEMD-160 hash algorithms and digests (HMAC).

The test vectors are taken from ISO:IEC 10118-3 (2004)
and RFC2286.

Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
---
 crypto/tcrypt.c |   31 ++++++-
 crypto/tcrypt.h |  292 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 321 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6beabc5..8495023 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -13,6 +13,7 @@
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
+ * 2008-04-27 Added RIPEMD tests
  * 2007-11-13 Added GCM tests
  * 2007-11-13 Added AEAD support
  * 2007-11-06 Added SHA-224 and SHA-224-HMAC tests
@@ -83,7 +84,7 @@ static char *check[] = {
 	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
-	"camellia", "seed", "salsa20", "lzo", "cts", NULL
+	"camellia", "seed", "salsa20", "rmd128", "rmd160", "lzo", "cts", NULL
 };
 
 static void hexdump(unsigned char *buf, unsigned int len)
@@ -1558,7 +1559,7 @@ static void do_test(void)
 	case 29:
 		test_hash("tgr128", tgr128_tv_template, TGR128_TEST_VECTORS);
 		break;
-		
+
 	case 30:
 		test_cipher("ecb(xeta)", ENCRYPT, xeta_enc_tv_template,
 			    XETA_ENC_TEST_VECTORS);
@@ -1623,6 +1624,14 @@ static void do_test(void)
 			    CTS_MODE_DEC_TEST_VECTORS);
 		break;
 
+        case 39:
+		test_hash("rmd128", rmd128_tv_template, RMD128_TEST_VECTORS);
+		break;
+
+        case 40:
+		test_hash("rmd160", rmd160_tv_template, RMD160_TEST_VECTORS);
+		break;
+
 	case 100:
 		test_hash("hmac(md5)", hmac_md5_tv_template,
 			  HMAC_MD5_TEST_VECTORS);
@@ -1658,6 +1667,16 @@ static void do_test(void)
 			  XCBC_AES_TEST_VECTORS);
 		break;
 
+	case 107:
+		test_hash("hmac(rmd128)", hmac_rmd128_tv_template,
+			  HMAC_RMD128_TEST_VECTORS);
+		break;
+
+	case 108:
+		test_hash("hmac(rmd160)", hmac_rmd160_tv_template,
+			  HMAC_RMD160_TEST_VECTORS);
+		break;
+
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
@@ -1796,6 +1815,14 @@ static void do_test(void)
 		test_hash_speed("sha224", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 
+	case 314:
+		test_hash_speed("rmd128", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
+	case 315:
+		test_hash_speed("rmd160", sec, generic_hash_speed_template);
+		if (mode > 300 && mode < 400) break;
+
 	case 399:
 		break;
 
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 47bc0ec..8906823 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -13,6 +13,7 @@
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
+ * 2008-04-27 Added RIPEMD tests
  * 2007-11-13 Added GCM tests
  * 2007-11-13 Added AEAD support
  * 2006-12-07 Added SHA384 HMAC and SHA512 HMAC tests
@@ -168,6 +169,135 @@ static struct hash_testvec md5_tv_template[] = {
 		.digest	= "\x57\xed\xf4\xa2\x2b\xe3\xc9\x55"
 			  "\xac\x49\xda\x2e\x21\x07\xb6\x7a",
 	}
+
+};
+
+/*
+ * RIPEMD-128 test vectors from ISO/IEC 10118-3:2004(E)
+ */
+#define RMD128_TEST_VECTORS     10
+
+static struct hash_testvec rmd128_tv_template[] = {
+	{
+		.digest	= "\xcd\xf2\x62\x13\xa1\x50\xdc\x3e"
+			  "\xcb\x61\x0f\x18\xf6\xb3\x8b\x46",
+	}, {
+		.plaintext = "a",
+		.psize	= 1,
+		.digest	= "\x86\xbe\x7a\xfa\x33\x9d\x0f\xc7"
+			  "\xcf\xc7\x85\xe7\x2f\x57\x8d\x33",
+	}, {
+		.plaintext = "abc",
+		.psize	= 3,
+		.digest	= "\xc1\x4a\x12\x19\x9c\x66\xe4\xba"
+			  "\x84\x63\x6b\x0f\x69\x14\x4c\x77",
+	}, {
+		.plaintext = "message digest",
+		.psize	= 14,
+		.digest	= "\x9e\x32\x7b\x3d\x6e\x52\x30\x62"
+			  "\xaf\xc1\x13\x2d\x7d\xf9\xd1\xb8",
+	}, {
+		.plaintext = "abcdefghijklmnopqrstuvwxyz",
+		.psize	= 26,
+		.digest	= "\xfd\x2a\xa6\x07\xf7\x1d\xc8\xf5"
+			  "\x10\x71\x49\x22\xb3\x71\x83\x4e",
+	}, {
+		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
+			     "fghijklmnopqrstuvwxyz0123456789",
+		.psize	= 62,
+		.digest	= "\xd1\xe9\x59\xeb\x17\x9c\x91\x1f"
+			  "\xae\xa4\x62\x4c\x60\xc5\xc7\x02",
+	}, {
+		.plaintext = "1234567890123456789012345678901234567890"
+			     "1234567890123456789012345678901234567890",
+		.psize	= 80,
+		.digest	= "\x3f\x45\xef\x19\x47\x32\xc2\xdb"
+			  "\xb2\xc4\xa2\xc7\x69\x79\x5f\xa3",
+        }, {
+		.plaintext = "abcdbcdecdefdefgefghfghighij"
+			     "hijkijkljklmklmnlmnomnopnopq",
+		.psize	= 56,
+		.digest	= "\xa1\xaa\x06\x89\xd0\xfa\xfa\x2d"
+			  "\xdc\x22\xe8\x8b\x49\x13\x3a\x06",
+		.np	= 2,
+		.tap	= { 28, 28 },
+	}, {
+		.plaintext = "abcdefghbcdefghicdefghijdefghijkefghijklfghi"
+			     "jklmghijklmnhijklmnoijklmnopjklmnopqklmnopqr"
+			     "lmnopqrsmnopqrstnopqrstu",
+		.psize	= 112,
+		.digest	= "\xd4\xec\xc9\x13\xe1\xdf\x77\x6b"
+			  "\xf4\x8d\xe9\xd5\x5b\x1f\x25\x46",
+	}, {
+		.plaintext = "abcdbcdecdefdefgefghfghighijhijk",
+		.psize	= 32,
+		.digest	= "\x13\xfc\x13\xe8\xef\xff\x34\x7d"
+			  "\xe1\x93\xff\x46\xdb\xac\xcf\xd4",
+	}
+};
+
+/*
+ * RIPEMD-160 test vectors from ISO/IEC 10118-3:2004(E)
+ */
+#define RMD160_TEST_VECTORS     10
+
+static struct hash_testvec rmd160_tv_template[] = {
+	{
+		.digest	= "\x9c\x11\x85\xa5\xc5\xe9\xfc\x54\x61\x28"
+			  "\x08\x97\x7e\xe8\xf5\x48\xb2\x25\x8d\x31",
+	}, {
+		.plaintext = "a",
+		.psize	= 1,
+		.digest	= "\x0b\xdc\x9d\x2d\x25\x6b\x3e\xe9\xda\xae"
+			  "\x34\x7b\xe6\xf4\xdc\x83\x5a\x46\x7f\xfe",
+	}, {
+		.plaintext = "abc",
+		.psize	= 3,
+		.digest	= "\x8e\xb2\x08\xf7\xe0\x5d\x98\x7a\x9b\x04"
+			  "\x4a\x8e\x98\xc6\xb0\x87\xf1\x5a\x0b\xfc",
+	}, {
+		.plaintext = "message digest",
+		.psize	= 14,
+		.digest	= "\x5d\x06\x89\xef\x49\xd2\xfa\xe5\x72\xb8"
+			  "\x81\xb1\x23\xa8\x5f\xfa\x21\x59\x5f\x36",
+	}, {
+		.plaintext = "abcdefghijklmnopqrstuvwxyz",
+		.psize	= 26,
+		.digest	= "\xf7\x1c\x27\x10\x9c\x69\x2c\x1b\x56\xbb"
+			  "\xdc\xeb\x5b\x9d\x28\x65\xb3\x70\x8d\xbc",
+	}, {
+		.plaintext = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
+			     "fghijklmnopqrstuvwxyz0123456789",
+		.psize	= 62,
+		.digest	= "\xb0\xe2\x0b\x6e\x31\x16\x64\x02\x86\xed"
+			  "\x3a\x87\xa5\x71\x30\x79\xb2\x1f\x51\x89",
+	}, {
+		.plaintext = "1234567890123456789012345678901234567890"
+			     "1234567890123456789012345678901234567890",
+		.psize	= 80,
+		.digest	= "\x9b\x75\x2e\x45\x57\x3d\x4b\x39\xf4\xdb"
+			  "\xd3\x32\x3c\xab\x82\xbf\x63\x32\x6b\xfb",
+        }, {
+		.plaintext = "abcdbcdecdefdefgefghfghighij"
+			     "hijkijkljklmklmnlmnomnopnopq",
+		.psize	= 56,
+		.digest	= "\x12\xa0\x53\x38\x4a\x9c\x0c\x88\xe4\x05"
+			  "\xa0\x6c\x27\xdc\xf4\x9a\xda\x62\xeb\x2b",
+		.np	= 2,
+		.tap	= { 28, 28 },
+	}, {
+		.plaintext = "abcdefghbcdefghicdefghijdefghijkefghijklfghi"
+			     "jklmghijklmnhijklmnoijklmnopjklmnopqklmnopqr"
+			     "lmnopqrsmnopqrstnopqrstu",
+		.psize	= 112,
+		.digest	= "\x6f\x3f\xa3\x9b\x6b\x50\x3c\x38\x4f\x91"
+			  "\x9a\x49\xa7\xaa\x5c\x2c\x08\xbd\xfb\x45",
+	}, {
+		.plaintext = "abcdbcdecdefdefgefghfghighijhijk",
+		.psize	= 32,
+		.digest	= "\x94\xc2\x64\x11\x54\x04\xe6\x33\x79\x0d"
+			  "\xfc\xc8\x7b\x58\x7d\x36\x77\x06\x7d\x9f",
+	}
 };
 
 /*
@@ -817,6 +947,168 @@ static struct hash_testvec hmac_md5_tv_template[] =
 };
 
 /*
+ * HMAC-RIPEMD128 test vectors from RFC2286
+ */
+#define HMAC_RMD128_TEST_VECTORS	7
+
+static struct hash_testvec hmac_rmd128_tv_template[] = {
+	{
+		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
+		.ksize	= 16,
+		.plaintext = "Hi There",
+		.psize	= 8,
+		.digest	= "\xfb\xf6\x1f\x94\x92\xaa\x4b\xbf"
+			  "\x81\xc1\x72\xe8\x4e\x07\x34\xdb",
+	}, {
+		.key	= "Jefe",
+		.ksize	= 4,
+		.plaintext = "what do ya want for nothing?",
+		.psize	= 28,
+		.digest	= "\x87\x5f\x82\x88\x62\xb6\xb3\x34"
+			  "\xb4\x27\xc5\x5f\x9f\x7f\xf0\x9b",
+		.np	= 2,
+		.tap	= { 14, 14 },
+	}, {
+		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
+		.ksize	= 16,
+		.plaintext = "\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
+			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
+			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
+			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd",
+		.psize	= 50,
+		.digest	= "\x09\xf0\xb2\x84\x6d\x2f\x54\x3d"
+			  "\xa3\x63\xcb\xec\x8d\x62\xa3\x8d",
+	}, {
+		.key	= "\x01\x02\x03\x04\x05\x06\x07\x08"
+			  "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
+			  "\x11\x12\x13\x14\x15\x16\x17\x18\x19",
+		.ksize	= 25,
+		.plaintext = "\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd",
+		.psize	= 50,
+		.digest	= "\xbd\xbb\xd7\xcf\x03\xe4\x4b\x5a"
+			  "\xa6\x0a\xf8\x15\xbe\x4d\x22\x94",
+	}, {
+		.key	= "\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c",
+		.ksize	= 16,
+		.plaintext = "Test With Truncation",
+		.psize	= 20,
+		.digest	= "\xe7\x98\x08\xf2\x4b\x25\xfd\x03"
+			  "\x1c\x15\x5f\x0d\x55\x1d\x9a\x3a",
+	}, {
+		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa",
+		.ksize	= 80,
+		.plaintext = "Test Using Larger Than Block-Size Key - Hash Key First",
+		.psize	= 54,
+		.digest	= "\xdc\x73\x29\x28\xde\x98\x10\x4a"
+			  "\x1f\x59\xd3\x73\xc1\x50\xac\xbb",
+	}, {
+		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa",
+		.ksize	= 80,
+		.plaintext = "Test Using Larger Than Block-Size Key and Larger Than One "
+			   "Block-Size Data",
+		.psize	= 73,
+		.digest	= "\x5c\x6b\xec\x96\x79\x3e\x16\xd4"
+			  "\x06\x90\xc2\x37\x63\x5f\x30\xc5",
+	},
+};
+
+/*
+ * HMAC-RIPEMD160 test vectors from RFC2286
+ */
+#define HMAC_RMD160_TEST_VECTORS	7
+
+static struct hash_testvec hmac_rmd160_tv_template[] = {
+	{
+		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
+		.ksize	= 20,
+		.plaintext = "Hi There",
+		.psize	= 8,
+		.digest	= "\x24\xcb\x4b\xd6\x7d\x20\xfc\x1a\x5d\x2e"
+			  "\xd7\x73\x2d\xcc\x39\x37\x7f\x0a\x56\x68",
+	}, {
+		.key	= "Jefe",
+		.ksize	= 4,
+		.plaintext = "what do ya want for nothing?",
+		.psize	= 28,
+		.digest	= "\xdd\xa6\xc0\x21\x3a\x48\x5a\x9e\x24\xf4"
+			  "\x74\x20\x64\xa7\xf0\x33\xb4\x3c\x40\x69",
+		.np	= 2,
+		.tap	= { 14, 14 },
+	}, {
+		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
+		.ksize	= 20,
+		.plaintext = "\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
+			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
+			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
+			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd",
+		.psize	= 50,
+		.digest	= "\xb0\xb1\x05\x36\x0d\xe7\x59\x96\x0a\xb4"
+			  "\xf3\x52\x98\xe1\x16\xe2\x95\xd8\xe7\xc1",
+	}, {
+		.key	= "\x01\x02\x03\x04\x05\x06\x07\x08"
+			  "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
+			  "\x11\x12\x13\x14\x15\x16\x17\x18\x19",
+		.ksize	= 25,
+		.plaintext = "\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
+			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd",
+		.psize	= 50,
+		.digest	= "\xd5\xca\x86\x2f\x4d\x21\xd5\xe6\x10\xe1"
+			  "\x8b\x4c\xf1\xbe\xb9\x7a\x43\x65\xec\xf4",
+	}, {
+		.key	= "\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c\x0c",
+		.ksize	= 20,
+		.plaintext = "Test With Truncation",
+		.psize	= 20,
+		.digest	= "\x76\x19\x69\x39\x78\xf9\x1d\x90\x53\x9a"
+			  "\xe7\x86\x50\x0f\xf3\xd8\xe0\x51\x8e\x39",
+	}, {
+		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa",
+		.ksize	= 80,
+		.plaintext = "Test Using Larger Than Block-Size Key - Hash Key First",
+		.psize	= 54,
+		.digest	= "\x64\x66\xca\x07\xac\x5e\xac\x29\xe1\xbd"
+			  "\x52\x3e\x5a\xda\x76\x05\xb7\x91\xfd\x8b",
+	}, {
+		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
+			"\xaa\xaa",
+		.ksize	= 80,
+		.plaintext = "Test Using Larger Than Block-Size Key and Larger Than One "
+			   "Block-Size Data",
+		.psize	= 73,
+		.digest	= "\x69\xea\x60\x79\x8d\x71\x61\x6c\xce\x5f"
+			  "\xd0\x87\x1e\x23\x75\x4c\xd7\x5d\x5a\x0a",
+	},
+};
+
+/*
  * HMAC-SHA1 test vectors from RFC2202
  */
 #define HMAC_SHA1_TEST_VECTORS	7
-- 
1.5.2.5

