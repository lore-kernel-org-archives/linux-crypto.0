From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH] crypto, Speed testing support for ghash
Date: Mon, 01 Mar 2010 16:06:44 +0800
Message-ID: <1267430804.1640.85.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62073 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0CAIGr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Mar 2010 03:06:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Because ghash needs setkey, the setkey and keysize template support
for test_hash_speed is added.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 crypto/tcrypt.c |  122 +++++++++++++++++++++++++++++++++++---------------------
 crypto/tcrypt.h |    1 
 2 files changed, 78 insertions(+), 45 deletions(-)

--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -395,12 +395,13 @@ out:
 }
 
 static void test_hash_speed(const char *algo, unsigned int sec,
-			    struct hash_speed *speed)
+			    struct hash_speed *speed, u8 *keysize)
 {
 	struct scatterlist sg[TVMEMSIZE];
 	struct crypto_hash *tfm;
 	struct hash_desc desc;
 	static char output[1024];
+	static u8 null_keysize[] = {0, 0};
 	int i;
 	int ret;
 
@@ -423,36 +424,47 @@ static void test_hash_speed(const char *
 		goto out;
 	}
 
-	sg_init_table(sg, TVMEMSIZE);
-	for (i = 0; i < TVMEMSIZE; i++) {
-		sg_set_buf(sg + i, tvmem[i], PAGE_SIZE);
-		memset(tvmem[i], 0xff, PAGE_SIZE);
-	}
-
-	for (i = 0; speed[i].blen != 0; i++) {
-		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
-			printk(KERN_ERR
-			       "template (%u) too big for tvmem (%lu)\n",
-			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
-			goto out;
+	keysize = keysize ? keysize : null_keysize;
+	do {
+		sg_init_table(sg, TVMEMSIZE);
+		for (i = 0; i < TVMEMSIZE; i++) {
+			sg_set_buf(sg + i, tvmem[i], PAGE_SIZE);
+			memset(tvmem[i], 0xff, PAGE_SIZE);
 		}
 
-		printk(KERN_INFO "test%3u "
-		       "(%5u byte blocks,%5u bytes per update,%4u updates): ",
-		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
-
-		if (sec)
-			ret = test_hash_jiffies(&desc, sg, speed[i].blen,
-						speed[i].plen, output, sec);
-		else
-			ret = test_hash_cycles(&desc, sg, speed[i].blen,
-					       speed[i].plen, output);
-
-		if (ret) {
-			printk(KERN_ERR "hashing failed ret=%d\n", ret);
-			break;
+		for (i = 0; speed[i].blen != 0; i++) {
+			if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
+				printk(KERN_ERR
+				"template (%u) too big for tvmem (%lu)\n",
+				       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
+				goto out;
+			}
+
+			if (*keysize)
+				crypto_hash_setkey(tfm, tvmem[0], *keysize);
+
+			printk(KERN_INFO "test%3u (%5u byte blocks,"
+			       "%5u bytes per update,%4u updates): ",
+			       i, speed[i].blen, speed[i].plen,
+			       speed[i].blen / speed[i].plen);
+
+			if (sec)
+				ret = test_hash_jiffies(&desc, sg,
+							speed[i].blen,
+							speed[i].plen,
+							output, sec);
+			else
+				ret = test_hash_cycles(&desc, sg,
+						       speed[i].blen,
+						       speed[i].plen, output);
+
+			if (ret) {
+				printk(KERN_ERR "hashing failed ret=%d\n", ret);
+				break;
+			}
 		}
-	}
+		keysize++;
+	} while (*keysize);
 
 out:
 	crypto_free_hash(tfm);
@@ -814,71 +826,91 @@ static int do_test(int m)
 		/* fall through */
 
 	case 301:
-		test_hash_speed("md4", sec, generic_hash_speed_template);
+		test_hash_speed("md4", sec, generic_hash_speed_template, NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 302:
-		test_hash_speed("md5", sec, generic_hash_speed_template);
+		test_hash_speed("md5", sec, generic_hash_speed_template, NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 303:
-		test_hash_speed("sha1", sec, generic_hash_speed_template);
+		test_hash_speed("sha1", sec, generic_hash_speed_template, NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 304:
-		test_hash_speed("sha256", sec, generic_hash_speed_template);
+		test_hash_speed("sha256", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 305:
-		test_hash_speed("sha384", sec, generic_hash_speed_template);
+		test_hash_speed("sha384", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 306:
-		test_hash_speed("sha512", sec, generic_hash_speed_template);
+		test_hash_speed("sha512", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 307:
-		test_hash_speed("wp256", sec, generic_hash_speed_template);
+		test_hash_speed("wp256", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 308:
-		test_hash_speed("wp384", sec, generic_hash_speed_template);
+		test_hash_speed("wp384", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 309:
-		test_hash_speed("wp512", sec, generic_hash_speed_template);
+		test_hash_speed("wp512", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 310:
-		test_hash_speed("tgr128", sec, generic_hash_speed_template);
+		test_hash_speed("tgr128", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 311:
-		test_hash_speed("tgr160", sec, generic_hash_speed_template);
+		test_hash_speed("tgr160", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 312:
-		test_hash_speed("tgr192", sec, generic_hash_speed_template);
+		test_hash_speed("tgr192", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 313:
-		test_hash_speed("sha224", sec, generic_hash_speed_template);
+		test_hash_speed("sha224", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 314:
-		test_hash_speed("rmd128", sec, generic_hash_speed_template);
+		test_hash_speed("rmd128", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 315:
-		test_hash_speed("rmd160", sec, generic_hash_speed_template);
+		test_hash_speed("rmd160", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 316:
-		test_hash_speed("rmd256", sec, generic_hash_speed_template);
+		test_hash_speed("rmd256", sec, generic_hash_speed_template,
+				NULL);
 		if (mode > 300 && mode < 400) break;
 
 	case 317:
-		test_hash_speed("rmd320", sec, generic_hash_speed_template);
+		test_hash_speed("rmd320", sec, generic_hash_speed_template,
+				NULL);
+		if (mode > 300 && mode < 400) break;
+
+	case 318:
+		test_hash_speed("ghash-generic", sec,
+				generic_hash_speed_template,
+				speed_template_16);
 		if (mode > 300 && mode < 400) break;
 
 	case 399:
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -45,6 +45,7 @@ static struct cipher_speed_template des3
  * Cipher speed tests
  */
 static u8 speed_template_8[] = {8, 0};
+static u8 speed_template_16[] = {16, 0};
 static u8 speed_template_24[] = {24, 0};
 static u8 speed_template_8_32[] = {8, 32, 0};
 static u8 speed_template_16_32[] = {16, 32, 0};


