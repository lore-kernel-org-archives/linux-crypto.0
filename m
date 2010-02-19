From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 13/19] crypto: tcrypt - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:22:53 +0100
Message-ID: <1266538974-3509-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jarod Wilson <jarod@redhat.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	Shane Wang <shane.wang@intel.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/tcrypt.c |   65 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index aa3f84c..7022d6b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -135,8 +135,8 @@ out:
 static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
 
 static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
-			      struct cipher_speed_template *template,
-			      unsigned int tcount, u8 *keysize)
+                              struct cipher_speed_template *template,
+                              unsigned int tcount, u8 *keysize)
 {
 	unsigned int ret, i, j, iv_len;
 	const char *key, iv[128];
@@ -146,7 +146,7 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 	u32 *b_size;
 
 	if (enc == ENCRYPT)
-	        e = "encryption";
+		e = "encryption";
 	else
 		e = "decryption";
 
@@ -156,7 +156,7 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 
 	if (IS_ERR(tfm)) {
 		printk("failed to load transform for %s: %ld\n", algo,
-		       PTR_ERR(tfm));
+			PTR_ERR(tfm));
 		return;
 	}
 	desc.tfm = tfm;
@@ -202,7 +202,7 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 				   PAGE_SIZE - *keysize);
 			for (j = 1; j < TVMEMSIZE; j++) {
 				sg_set_buf(sg + j, tvmem[j], PAGE_SIZE);
-				memset (tvmem[j], 0xff, PAGE_SIZE);
+				memset(tvmem[j], 0xff, PAGE_SIZE);
 			}
 
 			iv_len = crypto_blkcipher_ivsize(tfm);
@@ -655,11 +655,11 @@ static int do_test(int m)
 		ret += tcrypt_test("cts(cbc(aes))");
 		break;
 
-        case 39:
+	case 39:
 		ret += tcrypt_test("rmd128");
 		break;
 
-        case 40:
+	case 40:
 		ret += tcrypt_test("rmd160");
 		break;
 
@@ -815,71 +815,88 @@ static int do_test(int m)
 
 	case 301:
 		test_hash_speed("md4", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 302:
 		test_hash_speed("md5", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 303:
 		test_hash_speed("sha1", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 304:
 		test_hash_speed("sha256", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 305:
 		test_hash_speed("sha384", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 306:
 		test_hash_speed("sha512", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 307:
 		test_hash_speed("wp256", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 308:
 		test_hash_speed("wp384", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 309:
 		test_hash_speed("wp512", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 310:
 		test_hash_speed("tgr128", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 311:
 		test_hash_speed("tgr160", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 312:
 		test_hash_speed("tgr192", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 313:
 		test_hash_speed("sha224", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 314:
 		test_hash_speed("rmd128", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 315:
 		test_hash_speed("rmd160", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 316:
 		test_hash_speed("rmd256", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 317:
 		test_hash_speed("rmd320", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
+		if (mode > 300 && mode < 400)
+			break;
 
 	case 399:
 		break;
-- 
1.6.6.1
