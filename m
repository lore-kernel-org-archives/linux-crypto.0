From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 15/25] crypto: testmgr - Merge seed arrays in struct cprng_testvec
Date: Sun,  7 Dec 2014 07:26:23 -0500
Message-ID: <1450468de93a906f4750dc28fa507414b3306f2b.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:52461 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753210AbaLGM1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:07 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current code stores three pointers to three arrays, and three lengths,
and then has to kmalloc an array just to concatenate them.

This seems ridiculous.  Just store one combined array and combined
length, and don't do any reformatting at run-time.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/testmgr.c | 37 ++++++---------------
 crypto/testmgr.h | 98 +++++++++++++++++++++++++-------------------------------
 2 files changed, 53 insertions(+), 82 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9f4746eb..0e179c72 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1455,33 +1455,17 @@ static int test_cprng(struct crypto_rng *tfm,
 		      const struct cprng_testvec *template, unsigned int tcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
-	int err = 0, i, j, seedsize;
-	u8 *seed;
-	char result[32];
-
-	seedsize = crypto_rng_seedsize(tfm);
-
-	seed = kmalloc(seedsize, GFP_KERNEL);
-	if (!seed) {
-		printk(KERN_ERR "alg: cprng: Failed to allocate seed space "
-		       "for %s\n", algo);
-		return -ENOMEM;
-	}
+	int err = 0, i, j;
+	u8 result[32];
 
 	for (i = 0; i < tcount; i++) {
-		memset(result, 0, 32);
+		memset(result, 0, sizeof result);
 
-		memcpy(seed, template[i].v, template[i].vlen);
-		memcpy(seed + template[i].vlen, template[i].key,
-		       template[i].klen);
-		memcpy(seed + template[i].vlen + template[i].klen,
-		       template[i].dt, template[i].dtlen);
-
-		err = crypto_rng_reset(tfm, seed, seedsize);
+		err = crypto_rng_reset(tfm, template[i].seed, template[i].slen);
 		if (err) {
 			printk(KERN_ERR "alg: cprng: Failed to reset rng "
 			       "for %s\n", algo);
-			goto out;
+			break;
 		}
 
 		for (j = 0; j < template[i].loops; j++) {
@@ -1492,23 +1476,20 @@ static int test_cprng(struct crypto_rng *tfm,
 				       "the correct amount of random data for "
 				       "%s (requested %d, got %d)\n", algo,
 				       template[i].rlen, err);
-				goto out;
+				break;
 			}
 		}
 
-		err = memcmp(result, template[i].result,
-			     template[i].rlen);
+		err = memcmp(result, template[i].result, template[i].rlen);
 		if (err) {
 			printk(KERN_ERR "alg: cprng: Test %d failed for %s\n",
 			       i, algo);
 			hexdump(result, template[i].rlen);
 			err = -EINVAL;
-			goto out;
+			break;
 		}
 	}
 
-out:
-	kfree(seed);
 	return err;
 }
 
@@ -1730,6 +1711,8 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 
 	crypto_free_rng(rng);
 
+printk("alg_test_cprng: testing %s: err %d\n", driver, err);
+
 	return err;
 }
 
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 306a33b2..af346520 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -81,14 +81,10 @@ struct aead_testvec {
 };
 
 struct cprng_testvec {
-	const char *key;
-	const char *dt;
-	const char *v;
+	const char *seed;
 	const char *result;
-	unsigned char klen;
-	unsigned short dtlen;
-	unsigned short vlen;
-	unsigned short rlen;
+	unsigned char slen;
+	unsigned char rlen;
 	unsigned short loops;
 };
 
@@ -20708,90 +20704,82 @@ static const struct aead_testvec aes_ccm_rfc4309_dec_tv_template[] = {
  * test vectors, taken from Appendix B.2.9 and B.2.10:
  *     http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
  * Only AES-128 is supported at this time.
+ *
+ * CPRNGs take a single seed argument.  For this algorithm, it consists
+ * of the concatenation of the initial vector V, the key, and (optional)
+ * the initial DT.
  */
 #define ANSI_CPRNG_AES_TEST_VECTORS	6
 
 static const struct cprng_testvec ansi_cprng_aes_tv_template[] = {
 	{
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+		.seed	= "\x80\x00\x00\x00\x00\x00\x00\x00"	/* V[16] */
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\xf3\xb1\x66\x6d\x13\x60\x72\x42"	/* Key[16] */
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02"
+			  "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"	/* DT[16] */
 			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xf9",
-		.dtlen	= 16,
-		.v	= "\x80\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
+		.slen	= 48,
 		.result	= "\x59\x53\x1e\xd1\x3b\xb0\xc0\x55"
 			  "\x84\x79\x66\x85\xc1\x2f\x76\x41",
 		.rlen	= 16,
 		.loops	= 1,
 	}, {
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+		.seed	= "\xc0\x00\x00\x00\x00\x00\x00\x00"	/* V */
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\xf3\xb1\x66\x6d\x13\x60\x72\x42"	/* Key */
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02"
+			  "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"	/* DT */
 			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfa",
-		.dtlen	= 16,
-		.v	= "\xc0\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
+		.slen	= 48,
 		.result	= "\x7c\x22\x2c\xf4\xca\x8f\xa2\x4c"
 			  "\x1c\x9c\xb6\x41\xa9\xf3\x22\x0d",
 		.rlen	= 16,
 		.loops	= 1,
 	}, {
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+		.seed	= "\xe0\x00\x00\x00\x00\x00\x00\x00"	/* V */
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\xf3\xb1\x66\x6d\x13\x60\x72\x42"	/* Key */
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02"
+			  "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"	/* DT */
 			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfb",
-		.dtlen	= 16,
-		.v	= "\xe0\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
+		.slen	= 48,
 		.result	= "\x8a\xaa\x00\x39\x66\x67\x5b\xe5"
 			  "\x29\x14\x28\x81\xa9\x4d\x4e\xc7",
 		.rlen	= 16,
 		.loops	= 1,
 	}, {
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+		.seed	= "\xf0\x00\x00\x00\x00\x00\x00\x00"	/* V */
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\xf3\xb1\x66\x6d\x13\x60\x72\x42"	/* Key */
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02"
+			  "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"	/* DT */
 			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfc",
-		.dtlen	= 16,
-		.v	= "\xf0\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
+		.slen	= 48,
 		.result	= "\x88\xdd\xa4\x56\x30\x24\x23\xe5"
 			  "\xf6\x9d\xa5\x7e\x7b\x95\xc7\x3a",
 		.rlen	= 16,
 		.loops	= 1,
 	}, {
-		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
-			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
-		.klen	= 16,
-		.dt	= "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"
+		.seed	= "\xf8\x00\x00\x00\x00\x00\x00\x00"	/* V */
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\xf3\xb1\x66\x6d\x13\x60\x72\x42"	/* Key */
+			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02"
+			  "\xe6\xb3\xbe\x78\x2a\x23\xfa\x62"	/* DT */
 			  "\xd7\x1d\x4a\xfb\xb0\xe9\x22\xfd",
-		.dtlen	= 16,
-		.v	= "\xf8\x00\x00\x00\x00\x00\x00\x00"
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.vlen	= 16,
+		.slen	= 48,
 		.result	= "\x05\x25\x92\x46\x61\x79\xd2\xcb"
 			  "\x78\xc4\x0b\x14\x0a\x5a\x9a\xc8",
 		.rlen	= 16,
 		.loops	= 1,
 	}, {	/* Monte Carlo Test */
-		.key	= "\x9f\x5b\x51\x20\x0b\xf3\x34\xb5"
-			  "\xd8\x2b\xe8\xc3\x72\x55\xc8\x48",
-		.klen	= 16,
-		.dt	= "\x63\x76\xbb\xe5\x29\x02\xba\x3b"
+		.seed	= "\x57\x2c\x8e\x76\x87\x26\x47\x97"	/* V */
+			  "\x7e\x74\xfb\xdd\xc4\x95\x01\xd1"
+			  "\x9f\x5b\x51\x20\x0b\xf3\x34\xb5"	/* Key */
+			  "\xd8\x2b\xe8\xc3\x72\x55\xc8\x48"
+			  "\x63\x76\xbb\xe5\x29\x02\xba\x3b"	/* DT */
 			  "\x67\xc9\x25\xfa\x70\x1f\x11\xac",
-		.dtlen	= 16,
-		.v	= "\x57\x2c\x8e\x76\x87\x26\x47\x97"
-			  "\x7e\x74\xfb\xdd\xc4\x95\x01\xd1",
-		.vlen	= 16,
+		.slen	= 48,
 		.result	= "\x48\xe9\xbd\x0d\x06\xee\x18\xfb"
 			  "\xe4\x57\x90\xd5\xc3\xfc\x9b\x73",
 		.rlen	= 16,
-- 
2.1.3
