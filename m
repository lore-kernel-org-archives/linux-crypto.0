From: Frank Seidel <fseidel@suse.de>
Subject: [PATCH] crypto: add missing KERN_* constants to printks
Date: Fri, 06 Feb 2009 15:19:10 +0100
Message-ID: <498C46DE.8040700@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Frank Seidel <fseidel@suse.de>,
	frank@f-seidel.de, herbert@gondor.apana.org.au, jarod@redhat.com
To: linux kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:48980 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbZBFOTd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2009 09:19:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Frank Seidel <frank@f-seidel.de>

According to kerneljanitors todo list all printk calls (beginning
a new line) should have an according KERN_* constant.
Those are the missing pieces here for the crypto subsystem.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 crypto/ansi_cprng.c |    2 +-
 crypto/tcrypt.c     |   48 +++++++++++++++++++++++++++---------------------
 2 files changed, 28 insertions(+), 22 deletions(-)

--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -74,7 +74,7 @@ static int test_cipher_jiffies(struct bl
 			return ret;
 	}
 
-	printk("%d operations in %d seconds (%ld bytes)\n",
+	printk(KERN_WARNING "%d operations in %d seconds (%ld bytes)\n",
 	       bcount, sec, (long)bcount * blen);
 	return 0;
 }
@@ -122,7 +122,7 @@ out:
 	local_bh_enable();
 
 	if (ret == 0)
-		printk("1 operation in %lu cycles (%d bytes)\n",
+		printk(KERN_WARNING "1 operation in %lu cycles (%d bytes)\n",
 		       (cycles + 4) / 8, blen);
 
 	return ret;
@@ -146,13 +146,13 @@ static void test_cipher_speed(const char
 	else
 		e = "decryption";
 
-	printk("\ntesting speed of %s %s\n", algo, e);
+	printk(KERN_WARNING "\ntesting speed of %s %s\n", algo, e);
 
 	tfm = crypto_alloc_blkcipher(algo, 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
-		printk("failed to load transform for %s: %ld\n", algo,
-		       PTR_ERR(tfm));
+		printk(KERN_WARNING "failed to load transform for %s: %ld\n",
+		       algo, PTR_ERR(tfm));
 		return;
 	}
 	desc.tfm = tfm;
@@ -166,14 +166,16 @@ static void test_cipher_speed(const char
 			struct scatterlist sg[TVMEMSIZE];
 
 			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
-				printk("template (%u) too big for "
+				printk(KERN_WARNING
+				       "template (%u) too big for "
 				       "tvmem (%lu)\n", *keysize + *b_size,
 				       TVMEMSIZE * PAGE_SIZE);
 				goto out;
 			}
 
-			printk("test %u (%d bit key, %d byte blocks): ", i,
-					*keysize * 8, *b_size);
+			printk(KERN_WARNING
+					"test %u (%d bit key, %d byte blocks): ",
+					i, *keysize * 8, *b_size);
 
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
@@ -188,7 +190,8 @@ static void test_cipher_speed(const char
 
 			ret = crypto_blkcipher_setkey(tfm, key, *keysize);
 			if (ret) {
-				printk("setkey() failed flags=%x\n",
+				printk(KERN_WARNING
+						"setkey() failed flags=%x\n",
 						crypto_blkcipher_get_flags(tfm));
 				goto out;
 			}
@@ -215,7 +218,8 @@ static void test_cipher_speed(const char
 							 *b_size);
 
 			if (ret) {
-				printk("%s() failed flags=%x\n", e, desc.flags);
+				printk(KERN_WARNING "%s() failed flags=%x\n",
+				       e, desc.flags);
 				break;
 			}
 			b_size++;
@@ -243,7 +247,7 @@ static int test_hash_jiffies_digest(stru
 			return ret;
 	}
 
-	printk("%6u opers/sec, %9lu bytes/sec\n",
+	printk(KERN_WARNING "%6u opers/sec, %9lu bytes/sec\n",
 	       bcount / sec, ((long)bcount * blen) / sec);
 
 	return 0;
@@ -275,7 +279,7 @@ static int test_hash_jiffies(struct hash
 			return ret;
 	}
 
-	printk("%6u opers/sec, %9lu bytes/sec\n",
+	printk(KERN_WARNING "%6u opers/sec, %9lu bytes/sec\n",
 	       bcount / sec, ((long)bcount * blen) / sec);
 
 	return 0;
@@ -320,7 +324,7 @@ out:
 	if (ret)
 		return ret;
 
-	printk("%6lu cycles/operation, %4lu cycles/byte\n",
+	printk(KERN_WARNING "%6lu cycles/operation, %4lu cycles/byte\n",
 	       cycles / 8, cycles / (8 * blen));
 
 	return 0;
@@ -384,7 +388,7 @@ out:
 	if (ret)
 		return ret;
 
-	printk("%6lu cycles/operation, %4lu cycles/byte\n",
+	printk(KERN_WARNING "%6lu cycles/operation, %4lu cycles/byte\n",
 	       cycles / 8, cycles / (8 * blen));
 
 	return 0;
@@ -400,13 +404,13 @@ static void test_hash_speed(const char *
 	int i;
 	int ret;
 
-	printk("\ntesting speed of %s\n", algo);
+	printk(KERN_WARNING "\ntesting speed of %s\n", algo);
 
 	tfm = crypto_alloc_hash(algo, 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
-		printk("failed to load transform for %s: %ld\n", algo,
-		       PTR_ERR(tfm));
+		printk(KERN_WARNING "failed to load transform for %s: %ld\n",
+		       algo, PTR_ERR(tfm));
 		return;
 	}
 
@@ -414,7 +418,7 @@ static void test_hash_speed(const char *
 	desc.flags = 0;
 
 	if (crypto_hash_digestsize(tfm) > sizeof(output)) {
-		printk("digestsize(%u) > outputbuffer(%zu)\n",
+		printk(KERN_WARNING "digestsize(%u) > outputbuffer(%zu)\n",
 		       crypto_hash_digestsize(tfm), sizeof(output));
 		goto out;
 	}
@@ -427,12 +431,14 @@ static void test_hash_speed(const char *
 
 	for (i = 0; speed[i].blen != 0; i++) {
 		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
-			printk("template (%u) too big for tvmem (%lu)\n",
+			printk(KERN_WARNING
+			       "template (%u) too big for tvmem (%lu)\n",
 			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
 			goto out;
 		}
 
-		printk("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
+		printk(KERN_WARNING
+		       "test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
 		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
 
 		if (sec)
@@ -443,7 +449,7 @@ static void test_hash_speed(const char *
 					       speed[i].plen, output);
 
 		if (ret) {
-			printk("hashing failed ret=%d\n", ret);
+			printk(KERN_WARNING "hashing failed ret=%d\n", ret);
 			break;
 		}
 	}
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -167,7 +167,7 @@ static int _get_more_prng_bytes(struct p
 			break;
 	}
 
-	dbgprint("Returning new block for context %p\n", ctx);
+	dbgprint(KERN_WARNING "Returning new block for context %p\n", ctx);
 	ctx->rand_data_valid = 0;
 
 	hexdump("Output DT: ", ctx->DT, DEFAULT_BLK_SZ);
