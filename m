From: Joe Perches <joe@perches.com>
Subject: [PATCH 14/21] crypto/: use pr_<level> and add pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:41 -0700
Message-ID: <54b5f845a373de2c37933c2afd83cf7ee35b9c08.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Maciej Sosnowski <maciej.sosnowski@intel.com>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1730 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758257AbZJEAzT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:19 -0400
In-Reply-To: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Added #define pr_fmt(fmt) as "alg: ", "PRNG: " and KBUILD_MODNAME ": " fmt
Converted printk(KERN_<level> to pr_<level>(
Removed "alg: " and "PRNG: " prefixes
Some files now use KBUILD_MODNAME
print_hex_dump now uses KERN_CRIT instead of KERN_CONT

Signed-off-by: Joe Perches <joe@perches.com>
---
 crypto/algapi.c            |    4 +-
 crypto/ansi_cprng.c        |   39 +++----
 crypto/async_tx/async_tx.c |    5 +-
 crypto/fips.c              |    4 +-
 crypto/tcrypt.c            |   75 ++++++------
 crypto/testmgr.c           |  286 +++++++++++++++++++-------------------------
 crypto/xor.c               |   17 ++--
 7 files changed, 198 insertions(+), 232 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f149b1c..c0d03cb 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) "alg: " fmt
+
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -258,7 +260,7 @@ void crypto_alg_tested(const char *name, int err)
 			goto found;
 	}
 
-	printk(KERN_ERR "alg: Unexpected test result for %s: %d\n", name, err);
+	pr_err("Unexpected test result for %s: %d\n", name, err);
 	goto unlock;
 
 found:
diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 3aa6e38..9a7e50b 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) "PRNG: " fmt
+
 #include <crypto/internal/rng.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -57,20 +59,18 @@ struct prng_context {
 
 static int dbg;
 
-static void hexdump(char *note, unsigned char *buf, unsigned int len)
+static void hexdump(const char *note, const unsigned char *buf,
+		    unsigned int len)
 {
 	if (dbg) {
-		printk(KERN_CRIT "%s", note);
-		print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
-				16, 1,
-				buf, len, false);
+		print_hex_dump(KERN_CRIT, note, DUMP_PREFIX_OFFSET,
+			       16, 1,
+			       buf, len, false);
 	}
 }
 
-#define dbgprint(format, args...) do {\
-if (dbg)\
-	printk(format, ##args);\
-} while (0)
+#define dbgprint(format, args...) \
+	do { if (dbg) pr_crit(format, ##args); } while (0)
 
 static void xor_vectors(unsigned char *in1, unsigned char *in2,
 			unsigned char *out, unsigned int size)
@@ -92,8 +92,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 	unsigned char *output = NULL;
 
 
-	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
-		ctx);
+	dbgprint("Calling _get_more_prng_bytes for context %p\n", ctx);
 
 	hexdump("Input DT: ", ctx->DT, DEFAULT_BLK_SZ);
 	hexdump("Input I: ", ctx->I, DEFAULT_BLK_SZ);
@@ -137,9 +136,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 						ctx);
 				}
 
-				printk(KERN_ERR
-					"ctx %p Failed repetition check!\n",
-					ctx);
+				pr_err("ctx %p Failed repetition check!\n",
+				       ctx);
 
 				ctx->flags |= PRNG_NEED_RESET;
 				return -EINVAL;
@@ -214,8 +212,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
 
 	err = byte_count;
 
-	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",
-		byte_count, ctx);
+	dbgprint("getting %d random bytes for context %p\n", byte_count, ctx);
 
 
 remainder:
@@ -268,8 +265,7 @@ empty_rbuf:
 
 done:
 	spin_unlock_bh(&ctx->prng_lock);
-	dbgprint(KERN_CRIT "returning %d from get_prng_bytes in context %p\n",
-		err, ctx);
+	dbgprint("returning %d from get_prng_bytes in context %p\n", err, ctx);
 	return err;
 }
 
@@ -310,8 +306,8 @@ static int reset_prng_context(struct prng_context *ctx,
 
 	ret = crypto_cipher_setkey(ctx->tfm, prng_key, klen);
 	if (ret) {
-		dbgprint(KERN_CRIT "PRNG: setkey() failed flags=%x\n",
-			crypto_cipher_get_flags(ctx->tfm));
+		dbgprint("setkey() failed flags=%x\n",
+			 crypto_cipher_get_flags(ctx->tfm));
 		goto out;
 	}
 
@@ -329,8 +325,7 @@ static int cprng_init(struct crypto_tfm *tfm)
 	spin_lock_init(&ctx->prng_lock);
 	ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(ctx->tfm)) {
-		dbgprint(KERN_CRIT "Failed to alloc tfm for context %p\n",
-				ctx);
+		dbgprint("Failed to alloc tfm for context %p\n", ctx);
 		return PTR_ERR(ctx->tfm);
 	}
 
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index f9cdf04..e57e7a5 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -23,6 +23,9 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/rculist.h>
 #include <linux/kernel.h>
 #include <linux/async_tx.h>
@@ -32,7 +35,7 @@ static int __init async_tx_init(void)
 {
 	async_dmaengine_get();
 
-	printk(KERN_INFO "async_tx: api initialized (async)\n");
+	pr_info("api initialized (async)\n");
 
 	return 0;
 }
diff --git a/crypto/fips.c b/crypto/fips.c
index 5539700..7ef178d 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "internal.h"
 
 int fips_enabled;
@@ -19,7 +21,7 @@ EXPORT_SYMBOL_GPL(fips_enabled);
 static int fips_enable(char *str)
 {
 	fips_enabled = !!simple_strtol(str, NULL, 0);
-	printk(KERN_INFO "fips mode: %s\n",
+	pr_info("fips mode: %s\n",
 		fips_enabled ? "enabled" : "disabled");
 	return 1;
 }
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index aa3f84c..dc5a2bd 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -15,6 +15,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <crypto/hash.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -78,8 +80,8 @@ static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
 			return ret;
 	}
 
-	printk("%d operations in %d seconds (%ld bytes)\n",
-	       bcount, sec, (long)bcount * blen);
+	pr_info("%d operations in %d seconds (%ld bytes)\n",
+		bcount, sec, (long)bcount * blen);
 	return 0;
 }
 
@@ -126,8 +128,8 @@ out:
 	local_bh_enable();
 
 	if (ret == 0)
-		printk("1 operation in %lu cycles (%d bytes)\n",
-		       (cycles + 4) / 8, blen);
+		pr_info("1 operation in %lu cycles (%d bytes)\n",
+			(cycles + 4) / 8, blen);
 
 	return ret;
 }
@@ -150,13 +152,13 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 	else
 		e = "decryption";
 
-	printk("\ntesting speed of %s %s\n", algo, e);
+	pr_info("\ntesting speed of %s %s\n", algo, e);
 
 	tfm = crypto_alloc_blkcipher(algo, 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
-		printk("failed to load transform for %s: %ld\n", algo,
-		       PTR_ERR(tfm));
+		pr_info("failed to load transform for %s: %ld\n",
+			algo, PTR_ERR(tfm));
 		return;
 	}
 	desc.tfm = tfm;
@@ -170,14 +172,14 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 			struct scatterlist sg[TVMEMSIZE];
 
 			if ((*keysize + *b_size) > TVMEMSIZE * PAGE_SIZE) {
-				printk("template (%u) too big for "
-				       "tvmem (%lu)\n", *keysize + *b_size,
-				       TVMEMSIZE * PAGE_SIZE);
+				pr_info("template (%u) too big for tvmem (%lu)\n",
+					*keysize + *b_size,
+					TVMEMSIZE * PAGE_SIZE);
 				goto out;
 			}
 
-			printk("test %u (%d bit key, %d byte blocks): ", i,
-					*keysize * 8, *b_size);
+			pr_info("test %u (%d bit key, %d byte blocks): ",
+				i, *keysize * 8, *b_size);
 
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
@@ -192,8 +194,8 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 
 			ret = crypto_blkcipher_setkey(tfm, key, *keysize);
 			if (ret) {
-				printk("setkey() failed flags=%x\n",
-						crypto_blkcipher_get_flags(tfm));
+				pr_info("setkey() failed flags=%x\n",
+					crypto_blkcipher_get_flags(tfm));
 				goto out;
 			}
 
@@ -219,7 +221,8 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int sec,
 							 *b_size);
 
 			if (ret) {
-				printk("%s() failed flags=%x\n", e, desc.flags);
+				pr_info("%s() failed flags=%x\n",
+					e, desc.flags);
 				break;
 			}
 			b_size++;
@@ -247,8 +250,8 @@ static int test_hash_jiffies_digest(struct hash_desc *desc,
 			return ret;
 	}
 
-	printk("%6u opers/sec, %9lu bytes/sec\n",
-	       bcount / sec, ((long)bcount * blen) / sec);
+	pr_info("%6u opers/sec, %9lu bytes/sec\n",
+		bcount / sec, ((long)bcount * blen) / sec);
 
 	return 0;
 }
@@ -279,8 +282,8 @@ static int test_hash_jiffies(struct hash_desc *desc, struct scatterlist *sg,
 			return ret;
 	}
 
-	printk("%6u opers/sec, %9lu bytes/sec\n",
-	       bcount / sec, ((long)bcount * blen) / sec);
+	pr_info("%6u opers/sec, %9lu bytes/sec\n",
+		bcount / sec, ((long)bcount * blen) / sec);
 
 	return 0;
 }
@@ -324,8 +327,8 @@ out:
 	if (ret)
 		return ret;
 
-	printk("%6lu cycles/operation, %4lu cycles/byte\n",
-	       cycles / 8, cycles / (8 * blen));
+	pr_info("%6lu cycles/operation, %4lu cycles/byte\n",
+		cycles / 8, cycles / (8 * blen));
 
 	return 0;
 }
@@ -388,8 +391,8 @@ out:
 	if (ret)
 		return ret;
 
-	printk("%6lu cycles/operation, %4lu cycles/byte\n",
-	       cycles / 8, cycles / (8 * blen));
+	pr_info("%6lu cycles/operation, %4lu cycles/byte\n",
+		cycles / 8, cycles / (8 * blen));
 
 	return 0;
 }
@@ -404,13 +407,13 @@ static void test_hash_speed(const char *algo, unsigned int sec,
 	int i;
 	int ret;
 
-	printk(KERN_INFO "\ntesting speed of %s\n", algo);
+	pr_info("\ntesting speed of %s\n", algo);
 
 	tfm = crypto_alloc_hash(algo, 0, CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "failed to load transform for %s: %ld\n", algo,
-		       PTR_ERR(tfm));
+		pr_err("failed to load transform for %s: %ld\n",
+		       algo, PTR_ERR(tfm));
 		return;
 	}
 
@@ -418,7 +421,7 @@ static void test_hash_speed(const char *algo, unsigned int sec,
 	desc.flags = 0;
 
 	if (crypto_hash_digestsize(tfm) > sizeof(output)) {
-		printk(KERN_ERR "digestsize(%u) > outputbuffer(%zu)\n",
+		pr_err("digestsize(%u) > outputbuffer(%zu)\n",
 		       crypto_hash_digestsize(tfm), sizeof(output));
 		goto out;
 	}
@@ -431,15 +434,14 @@ static void test_hash_speed(const char *algo, unsigned int sec,
 
 	for (i = 0; speed[i].blen != 0; i++) {
 		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
-			printk(KERN_ERR
-			       "template (%u) too big for tvmem (%lu)\n",
+			pr_err("template (%u) too big for tvmem (%lu)\n",
 			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
 			goto out;
 		}
 
-		printk(KERN_INFO "test%3u "
-		       "(%5u byte blocks,%5u bytes per update,%4u updates): ",
-		       i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
+		pr_info("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
+			i, speed[i].blen,
+			speed[i].plen, speed[i].blen / speed[i].plen);
 
 		if (sec)
 			ret = test_hash_jiffies(&desc, sg, speed[i].blen,
@@ -449,7 +451,7 @@ static void test_hash_speed(const char *algo, unsigned int sec,
 					       speed[i].plen, output);
 
 		if (ret) {
-			printk(KERN_ERR "hashing failed ret=%d\n", ret);
+			pr_err("hashing failed ret=%d\n", ret);
 			break;
 		}
 	}
@@ -463,9 +465,8 @@ static void test_available(void)
 	char **name = check;
 
 	while (*name) {
-		printk("alg %s ", *name);
-		printk(crypto_has_alg(*name, 0, 0) ?
-		       "found\n" : "not found\n");
+		pr_info("alg %s %sfound\n",
+			*name, crypto_has_alg(*name, 0, 0) ? "" : "not ");
 		name++;
 	}
 }
@@ -915,7 +916,7 @@ static int __init tcrypt_mod_init(void)
 		err = do_test(mode);
 
 	if (err) {
-		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
+		pr_err("one or more tests failed!\n");
 		goto err_free_tv;
 	}
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6d5b746..31ea9df 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) "alg: " fmt
+
 #include <crypto/hash.h>
 #include <linux/err.h>
 #include <linux/module.h>
@@ -173,8 +175,7 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 
 	req = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		printk(KERN_ERR "alg: hash: Failed to allocate request for "
-		       "%s\n", algo);
+		pr_err("hash: Failed to allocate request for %s\n", algo);
 		goto out_noreq;
 	}
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
@@ -198,9 +199,8 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 			ret = crypto_ahash_setkey(tfm, template[i].key,
 						  template[i].ksize);
 			if (ret) {
-				printk(KERN_ERR "alg: hash: setkey failed on "
-				       "test %d for %s: ret=%d\n", j, algo,
-				       -ret);
+				pr_err("hash: setkey failed on test %d for %s: ret=%d\n",
+				       j, algo, -ret);
 				goto out;
 			}
 		}
@@ -220,14 +220,14 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 			}
 			/* fall through */
 		default:
-			printk(KERN_ERR "alg: hash: digest failed on test %d "
-			       "for %s: ret=%d\n", j, algo, -ret);
+			pr_err("hash: digest failed on test %d for %s: ret=%d\n",
+			       j, algo, -ret);
 			goto out;
 		}
 
 		if (memcmp(result, template[i].digest,
 			   crypto_ahash_digestsize(tfm))) {
-			printk(KERN_ERR "alg: hash: Test %d failed for %s\n",
+			pr_err("hash: Test %d failed for %s\n",
 			       j, algo);
 			hexdump(result, crypto_ahash_digestsize(tfm));
 			ret = -EINVAL;
@@ -263,10 +263,8 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 							  template[i].ksize);
 
 				if (ret) {
-					printk(KERN_ERR "alg: hash: setkey "
-					       "failed on chunking test %d "
-					       "for %s: ret=%d\n", j, algo,
-					       -ret);
+					pr_err("hash: setkey failed on chunking test %d for %s: ret=%d\n",
+					       j, algo, -ret);
 					goto out;
 				}
 			}
@@ -287,16 +285,15 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 				}
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: hash: digest failed "
-				       "on chunking test %d for %s: "
-				       "ret=%d\n", j, algo, -ret);
+				pr_err("hash: digest failed on chunking test %d for %s: ret=%d\n",
+				       j, algo, -ret);
 				goto out;
 			}
 
 			if (memcmp(result, template[i].digest,
 				   crypto_ahash_digestsize(tfm))) {
-				printk(KERN_ERR "alg: hash: Chunking test %d "
-				       "failed for %s\n", j, algo);
+				pr_err("hash: Chunking test %d failed for %s\n",
+				       j, algo);
 				hexdump(result, crypto_ahash_digestsize(tfm));
 				ret = -EINVAL;
 				goto out;
@@ -348,8 +345,7 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		printk(KERN_ERR "alg: aead: Failed to allocate request for "
-		       "%s\n", algo);
+		pr_err("aead: Failed to allocate request for %s\n", algo);
 		goto out;
 	}
 
@@ -388,9 +384,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			ret = crypto_aead_setkey(tfm, key,
 						 template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: aead: setkey failed on "
-				       "test %d for %s: flags=%x\n", j, algo,
-				       crypto_aead_get_flags(tfm));
+				pr_err("aead: setkey failed on test %d for %s: flags=%x\n",
+				       j, algo, crypto_aead_get_flags(tfm));
 				goto out;
 			} else if (ret)
 				continue;
@@ -398,8 +393,7 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			authsize = abs(template[i].rlen - template[i].ilen);
 			ret = crypto_aead_setauthsize(tfm, authsize);
 			if (ret) {
-				printk(KERN_ERR "alg: aead: Failed to set "
-				       "authsize to %u on test %d for %s\n",
+				pr_err("aead: Failed to set authsize to %u on test %d for %s\n",
 				       authsize, j, algo);
 				goto out;
 			}
@@ -422,9 +416,7 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			case 0:
 				if (template[i].novrfy) {
 					/* verification was supposed to fail */
-					printk(KERN_ERR "alg: aead: %s failed "
-					       "on test %d for %s: ret was 0, "
-					       "expected -EBADMSG\n",
+					pr_err("aead: %s failed on test %d for %s: ret was 0, expected -EBADMSG\n",
 					       e, j, algo);
 					/* so really, we got a bad message */
 					ret = -EBADMSG;
@@ -445,15 +437,15 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					continue;
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: aead: %s failed on test "
-				       "%d for %s: ret=%d\n", e, j, algo, -ret);
+				pr_err("aead: %s failed on test %d for %s: ret=%d\n",
+				       e, j, algo, -ret);
 				goto out;
 			}
 
 			q = input;
 			if (memcmp(q, template[i].result, template[i].rlen)) {
-				printk(KERN_ERR "alg: aead: Test %d failed on "
-				       "%s for %s\n", j, e, algo);
+				pr_err("aead: Test %d failed on %s for %s\n",
+				       j, e, algo);
 				hexdump(q, template[i].rlen);
 				ret = -EINVAL;
 				goto out;
@@ -478,9 +470,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 			ret = crypto_aead_setkey(tfm, key, template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: aead: setkey failed on "
-				       "chunk test %d for %s: flags=%x\n", j,
-				       algo, crypto_aead_get_flags(tfm));
+				pr_err("aead: setkey failed on chunk test %d for %s: flags=%x\n",
+				       j, algo, crypto_aead_get_flags(tfm));
 				goto out;
 			} else if (ret)
 				continue;
@@ -512,9 +503,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 
 			ret = crypto_aead_setauthsize(tfm, authsize);
 			if (ret) {
-				printk(KERN_ERR "alg: aead: Failed to set "
-				       "authsize to %u on chunk test %d for "
-				       "%s\n", authsize, j, algo);
+				pr_err("aead: Failed to set authsize to %u on chunk test %d for %s\n",
+				       authsize, j, algo);
 				goto out;
 			}
 
@@ -558,9 +548,7 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 			case 0:
 				if (template[i].novrfy) {
 					/* verification was supposed to fail */
-					printk(KERN_ERR "alg: aead: %s failed "
-					       "on chunk test %d for %s: ret "
-					       "was 0, expected -EBADMSG\n",
+					pr_err("aead: %s failed on chunk test %d for %s: ret was 0, expected -EBADMSG\n",
 					       e, j, algo);
 					/* so really, we got a bad message */
 					ret = -EBADMSG;
@@ -581,9 +569,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					continue;
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: aead: %s failed on "
-				       "chunk test %d for %s: ret=%d\n", e, j,
-				       algo, -ret);
+				pr_err("aead: %s failed on chunk test %d for %s: ret=%d\n",
+				       e, j, algo, -ret);
 				goto out;
 			}
 
@@ -597,9 +584,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 					n += enc ? authsize : -authsize;
 
 				if (memcmp(q, template[i].result + temp, n)) {
-					printk(KERN_ERR "alg: aead: Chunk "
-					       "test %d failed on %s at page "
-					       "%u for %s\n", j, e, k, algo);
+					pr_err("aead: Chunk test %d failed on %s at page %u for %s\n",
+					       j, e, k, algo);
 					hexdump(q, n);
 					goto out;
 				}
@@ -617,11 +603,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 						;
 				}
 				if (n) {
-					printk(KERN_ERR "alg: aead: Result "
-					       "buffer corruption in chunk "
-					       "test %d on %s at page %u for "
-					       "%s: %u bytes:\n", j, e, k,
-					       algo, n);
+					pr_err("aead: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
+					       j, e, k, algo, n);
 					hexdump(q, n);
 					goto out;
 				}
@@ -682,9 +665,8 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 		ret = crypto_cipher_setkey(tfm, template[i].key,
 					   template[i].klen);
 		if (!ret == template[i].fail) {
-			printk(KERN_ERR "alg: cipher: setkey failed "
-			       "on test %d for %s: flags=%x\n", j,
-			       algo, crypto_cipher_get_flags(tfm));
+			pr_err("cipher: setkey failed on test %d for %s: flags=%x\n",
+			       j, algo, crypto_cipher_get_flags(tfm));
 			goto out;
 		} else if (ret)
 			continue;
@@ -701,8 +683,8 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 
 		q = data;
 		if (memcmp(q, template[i].result, template[i].rlen)) {
-			printk(KERN_ERR "alg: cipher: Test %d failed "
-			       "on %s for %s\n", j, e, algo);
+			pr_err("cipher: Test %d failed on %s for %s\n",
+			       j, e, algo);
 			hexdump(q, template[i].rlen);
 			ret = -EINVAL;
 			goto out;
@@ -745,8 +727,7 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 	req = ablkcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		printk(KERN_ERR "alg: skcipher: Failed to allocate request "
-		       "for %s\n", algo);
+		pr_err("skcipher: Failed to allocate request for %s\n", algo);
 		goto out;
 	}
 
@@ -778,9 +759,9 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
 						       template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: skcipher: setkey failed "
-				       "on test %d for %s: flags=%x\n", j,
-				       algo, crypto_ablkcipher_get_flags(tfm));
+				pr_err("skcipher: setkey failed on test %d for %s: flags=%x\n",
+				       j, algo,
+				       crypto_ablkcipher_get_flags(tfm));
 				goto out;
 			} else if (ret)
 				continue;
@@ -806,16 +787,15 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				}
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: skcipher: %s failed on "
-				       "test %d for %s: ret=%d\n", e, j, algo,
-				       -ret);
+				pr_err("skcipher: %s failed on test %d for %s: ret=%d\n",
+				       e, j, algo, -ret);
 				goto out;
 			}
 
 			q = data;
 			if (memcmp(q, template[i].result, template[i].rlen)) {
-				printk(KERN_ERR "alg: skcipher: Test %d "
-				       "failed on %s for %s\n", j, e, algo);
+				pr_err("skcipher: Test %d failed on %s for %s\n",
+				       j, e, algo);
 				hexdump(q, template[i].rlen);
 				ret = -EINVAL;
 				goto out;
@@ -842,8 +822,7 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
 						       template[i].klen);
 			if (!ret == template[i].fail) {
-				printk(KERN_ERR "alg: skcipher: setkey failed "
-				       "on chunk test %d for %s: flags=%x\n",
+				pr_err("skcipher: setkey failed on chunk test %d for %s: flags=%x\n",
 				       j, algo,
 				       crypto_ablkcipher_get_flags(tfm));
 				goto out;
@@ -893,9 +872,8 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				}
 				/* fall through */
 			default:
-				printk(KERN_ERR "alg: skcipher: %s failed on "
-				       "chunk test %d for %s: ret=%d\n", e, j,
-				       algo, -ret);
+				pr_err("skcipher: %s failed on chunk test %d for %s: ret=%d\n",
+				       e, j, algo, -ret);
 				goto out;
 			}
 
@@ -907,9 +885,8 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 
 				if (memcmp(q, template[i].result + temp,
 					   template[i].tap[k])) {
-					printk(KERN_ERR "alg: skcipher: Chunk "
-					       "test %d failed on %s at page "
-					       "%u for %s\n", j, e, k, algo);
+					pr_err("skcipher: Chunk test %d failed on %s at page %u for %s\n",
+					       j, e, k, algo);
 					hexdump(q, template[i].tap[k]);
 					goto out;
 				}
@@ -918,11 +895,8 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 				for (n = 0; offset_in_page(q + n) && q[n]; n++)
 					;
 				if (n) {
-					printk(KERN_ERR "alg: skcipher: "
-					       "Result buffer corruption in "
-					       "chunk test %d on %s at page "
-					       "%u for %s: %u bytes:\n", j, e,
-					       k, algo, n);
+					pr_err("skcipher: Result buffer corruption in chunk test %d on %s at page %u for %s: %u bytes:\n",
+					       j, e, k, algo, n);
 					hexdump(q, n);
 					goto out;
 				}
@@ -958,23 +932,21 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 		ret = crypto_comp_compress(tfm, ctemplate[i].input,
 		                           ilen, result, &dlen);
 		if (ret) {
-			printk(KERN_ERR "alg: comp: compression failed "
-			       "on test %d for %s: ret=%d\n", i + 1, algo,
-			       -ret);
+			pr_err("comp: compression failed on test %d for %s: ret=%d\n",
+			       i + 1, algo, -ret);
 			goto out;
 		}
 
 		if (dlen != ctemplate[i].outlen) {
-			printk(KERN_ERR "alg: comp: Compression test %d "
-			       "failed for %s: output len = %d\n", i + 1, algo,
-			       dlen);
+			pr_err("comp: Compression test %d failed for %s: output len = %d\n",
+			       i + 1, algo, dlen);
 			ret = -EINVAL;
 			goto out;
 		}
 
 		if (memcmp(result, ctemplate[i].output, dlen)) {
-			printk(KERN_ERR "alg: comp: Compression test %d "
-			       "failed for %s\n", i + 1, algo);
+			pr_err("comp: Compression test %d failed for %s\n",
+			       i + 1, algo);
 			hexdump(result, dlen);
 			ret = -EINVAL;
 			goto out;
@@ -991,23 +963,21 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 		ret = crypto_comp_decompress(tfm, dtemplate[i].input,
 		                             ilen, result, &dlen);
 		if (ret) {
-			printk(KERN_ERR "alg: comp: decompression failed "
-			       "on test %d for %s: ret=%d\n", i + 1, algo,
-			       -ret);
+			pr_err("comp: decompression failed on test %d for %s: ret=%d\n",
+			       i + 1, algo, -ret);
 			goto out;
 		}
 
 		if (dlen != dtemplate[i].outlen) {
-			printk(KERN_ERR "alg: comp: Decompression test %d "
-			       "failed for %s: output len = %d\n", i + 1, algo,
-			       dlen);
+			pr_err("comp: Decompression test %d failed for %s: output len = %d\n",
+			       i + 1, algo, dlen);
 			ret = -EINVAL;
 			goto out;
 		}
 
 		if (memcmp(result, dtemplate[i].output, dlen)) {
-			printk(KERN_ERR "alg: comp: Decompression test %d "
-			       "failed for %s\n", i + 1, algo);
+			pr_err("comp: Decompression test %d failed for %s\n",
+			       i + 1, algo);
 			hexdump(result, dlen);
 			ret = -EINVAL;
 			goto out;
@@ -1037,15 +1007,15 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 		res = crypto_compress_setup(tfm, ctemplate[i].params,
 					    ctemplate[i].paramsize);
 		if (res) {
-			pr_err("alg: pcomp: compression setup failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: compression setup failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 
 		res = crypto_compress_init(tfm);
 		if (res) {
-			pr_err("alg: pcomp: compression init failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: compression init failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 
@@ -1058,8 +1028,8 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 
 		res = crypto_compress_update(tfm, &req);
 		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: compression update failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: compression update failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 		if (res > 0)
@@ -1070,8 +1040,8 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 
 		res = crypto_compress_update(tfm, &req);
 		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: compression update failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: compression update failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 		if (res > 0)
@@ -1082,30 +1052,29 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 
 		res = crypto_compress_final(tfm, &req);
 		if (res < 0) {
-			pr_err("alg: pcomp: compression final failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: compression final failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 		produced += res;
 
 		if (COMP_BUF_SIZE - req.avail_out != ctemplate[i].outlen) {
-			pr_err("alg: comp: Compression test %d failed for %s: "
-			       "output len = %d (expected %d)\n", i + 1, algo,
+			pr_err("comp: Compression test %d failed for %s: output len = %d (expected %d)\n",
+			       i + 1, algo,
 			       COMP_BUF_SIZE - req.avail_out,
 			       ctemplate[i].outlen);
 			return -EINVAL;
 		}
 
 		if (produced != ctemplate[i].outlen) {
-			pr_err("alg: comp: Compression test %d failed for %s: "
-			       "returned len = %u (expected %d)\n", i + 1,
-			       algo, produced, ctemplate[i].outlen);
+			pr_err("comp: Compression test %d failed for %s: returned len = %u (expected %d)\n",
+			       i + 1, algo, produced, ctemplate[i].outlen);
 			return -EINVAL;
 		}
 
 		if (memcmp(result, ctemplate[i].output, ctemplate[i].outlen)) {
-			pr_err("alg: pcomp: Compression test %d failed for "
-			       "%s\n", i + 1, algo);
+			pr_err("pcomp: Compression test %d failed for %s\n",
+			       i + 1, algo);
 			hexdump(result, ctemplate[i].outlen);
 			return -EINVAL;
 		}
@@ -1118,15 +1087,15 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 		res = crypto_decompress_setup(tfm, dtemplate[i].params,
 					      dtemplate[i].paramsize);
 		if (res) {
-			pr_err("alg: pcomp: decompression setup failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: decompression setup failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 
 		res = crypto_decompress_init(tfm);
 		if (res) {
-			pr_err("alg: pcomp: decompression init failed on test "
-			       "%d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: decompression init failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 
@@ -1139,8 +1108,8 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 
 		res = crypto_decompress_update(tfm, &req);
 		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: decompression update failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: decompression update failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 		if (res > 0)
@@ -1151,8 +1120,8 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 
 		res = crypto_decompress_update(tfm, &req);
 		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: decompression update failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: decompression update failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 		if (res > 0)
@@ -1163,31 +1132,30 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 
 		res = crypto_decompress_final(tfm, &req);
 		if (res < 0 && (res != -EAGAIN || req.avail_in)) {
-			pr_err("alg: pcomp: decompression final failed on "
-			       "test %d for %s: error=%d\n", i + 1, algo, res);
+			pr_err("pcomp: decompression final failed on test %d for %s: error=%d\n",
+			       i + 1, algo, res);
 			return res;
 		}
 		if (res > 0)
 			produced += res;
 
 		if (COMP_BUF_SIZE - req.avail_out != dtemplate[i].outlen) {
-			pr_err("alg: comp: Decompression test %d failed for "
-			       "%s: output len = %d (expected %d)\n", i + 1,
-			       algo, COMP_BUF_SIZE - req.avail_out,
+			pr_err("comp: Decompression test %d failed for %s: output len = %d (expected %d)\n",
+			       i + 1, algo,
+			       COMP_BUF_SIZE - req.avail_out,
 			       dtemplate[i].outlen);
 			return -EINVAL;
 		}
 
 		if (produced != dtemplate[i].outlen) {
-			pr_err("alg: comp: Decompression test %d failed for "
-			       "%s: returned len = %u (expected %d)\n", i + 1,
-			       algo, produced, dtemplate[i].outlen);
+			pr_err("comp: Decompression test %d failed for %s: returned len = %u (expected %d)\n",
+			       i + 1, algo, produced, dtemplate[i].outlen);
 			return -EINVAL;
 		}
 
 		if (memcmp(result, dtemplate[i].output, dtemplate[i].outlen)) {
-			pr_err("alg: pcomp: Decompression test %d failed for "
-			       "%s\n", i + 1, algo);
+			pr_err("pcomp: Decompression test %d failed for %s\n",
+			       i + 1, algo);
 			hexdump(result, dtemplate[i].outlen);
 			return -EINVAL;
 		}
@@ -1209,8 +1177,7 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 
 	seed = kmalloc(seedsize, GFP_KERNEL);
 	if (!seed) {
-		printk(KERN_ERR "alg: cprng: Failed to allocate seed space "
-		       "for %s\n", algo);
+		pr_err("cprng: Failed to allocate seed space for %s\n", algo);
 		return -ENOMEM;
 	}
 
@@ -1225,8 +1192,7 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 
 		err = crypto_rng_reset(tfm, seed, seedsize);
 		if (err) {
-			printk(KERN_ERR "alg: cprng: Failed to reset rng "
-			       "for %s\n", algo);
+			pr_err("cprng: Failed to reset rng for %s\n", algo);
 			goto out;
 		}
 
@@ -1234,10 +1200,8 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 			err = crypto_rng_get_bytes(tfm, result,
 						   template[i].rlen);
 			if (err != template[i].rlen) {
-				printk(KERN_ERR "alg: cprng: Failed to obtain "
-				       "the correct amount of random data for "
-				       "%s (requested %d, got %d)\n", algo,
-				       template[i].rlen, err);
+				pr_err("cprng: Failed to obtain the correct amount of random data for %s (requested %d, got %d)\n",
+				       algo, template[i].rlen, err);
 				goto out;
 			}
 		}
@@ -1245,8 +1209,7 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 		err = memcmp(result, template[i].result,
 			     template[i].rlen);
 		if (err) {
-			printk(KERN_ERR "alg: cprng: Test %d failed for %s\n",
-			       i, algo);
+			pr_err("cprng: Test %d failed for %s\n", i, algo);
 			hexdump(result, template[i].rlen);
 			err = -EINVAL;
 			goto out;
@@ -1266,8 +1229,8 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 
 	tfm = crypto_alloc_aead(driver, type, mask);
 	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: aead: Failed to load transform for %s: "
-		       "%ld\n", driver, PTR_ERR(tfm));
+		pr_err("aead: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
 
@@ -1295,8 +1258,8 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 
 	tfm = crypto_alloc_cipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: cipher: Failed to load transform for "
-		       "%s: %ld\n", driver, PTR_ERR(tfm));
+		pr_err("cipher: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
 
@@ -1324,8 +1287,8 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 
 	tfm = crypto_alloc_ablkcipher(driver, type, mask);
 	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
-		       "%s: %ld\n", driver, PTR_ERR(tfm));
+		pr_err("skcipher: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
 
@@ -1353,8 +1316,8 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 
 	tfm = crypto_alloc_comp(driver, type, mask);
 	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: comp: Failed to load transform for %s: "
-		       "%ld\n", driver, PTR_ERR(tfm));
+		pr_err("comp: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
 
@@ -1375,7 +1338,7 @@ static int alg_test_pcomp(const struct alg_test_desc *desc, const char *driver,
 
 	tfm = crypto_alloc_pcomp(driver, type, mask);
 	if (IS_ERR(tfm)) {
-		pr_err("alg: pcomp: Failed to load transform for %s: %ld\n",
+		pr_err("pcomp: Failed to load transform for %s: %ld\n",
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
@@ -1397,7 +1360,7 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 
 	tfm = crypto_alloc_ahash(driver, type, mask);
 	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: hash: Failed to load transform for %s: "
+		pr_err("hash: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
@@ -1421,8 +1384,8 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 
 	tfm = crypto_alloc_shash(driver, type, mask);
 	if (IS_ERR(tfm)) {
-		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
-		       "%ld\n", driver, PTR_ERR(tfm));
+		pr_err("crc32c: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(tfm));
 		err = PTR_ERR(tfm);
 		goto out;
 	}
@@ -1439,14 +1402,13 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 		*(u32 *)sdesc.ctx = le32_to_cpu(420553207);
 		err = crypto_shash_final(&sdesc.shash, (u8 *)&val);
 		if (err) {
-			printk(KERN_ERR "alg: crc32c: Operation failed for "
-			       "%s: %d\n", driver, err);
+			pr_err("crc32c: Operation failed for %s: %d\n",
+			       driver, err);
 			break;
 		}
 
 		if (val != ~420553207) {
-			printk(KERN_ERR "alg: crc32c: Test failed for %s: "
-			       "%d\n", driver, val);
+			pr_err("crc32c: Test failed for %s: %d\n", driver, val);
 			err = -EINVAL;
 		}
 	} while (0);
@@ -1465,8 +1427,8 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 
 	rng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(rng)) {
-		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
-		       "%ld\n", driver, PTR_ERR(rng));
+		pr_err("cprng: Failed to load transform for %s: %ld\n",
+		       driver, PTR_ERR(rng));
 		return PTR_ERR(rng);
 	}
 
@@ -2393,16 +2355,16 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 
 test_done:
 	if (fips_enabled && rc)
-		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
+		panic("%s: %s alg self test failed in fips mode!\n",
+		      driver, alg);
 
 	if (fips_enabled && !rc)
-		printk(KERN_INFO "alg: self-tests for %s (%s) passed\n",
-		       driver, alg);
+		pr_info("self-tests for %s (%s) passed\n", driver, alg);
 
 	return rc;
 
 notest:
-	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
+	pr_info("No test for %s (%s)\n", alg, driver);
 	return 0;
 non_fips_alg:
 	return -EINVAL;
diff --git a/crypto/xor.c b/crypto/xor.c
index fc5b836..4aea14d 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -16,6 +16,8 @@
  * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define BH_TRACE 0
 #include <linux/module.h>
 #include <linux/raid/xor.h>
@@ -91,8 +93,8 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 	speed = max * (HZ * BENCH_SIZE / 1024);
 	tmpl->speed = speed;
 
-	printk(KERN_INFO "   %-10s: %5d.%03d MB/sec\n", tmpl->name,
-	       speed / 1000, speed % 1000);
+	pr_info("   %-10s: %5d.%03d MB/sec\n", tmpl->name,
+		speed / 1000, speed % 1000);
 }
 
 static int __init
@@ -108,7 +110,7 @@ calibrate_xor_blocks(void)
 	 */
 	b1 = (void *) __get_free_pages(GFP_KERNEL | __GFP_NOTRACK, 2);
 	if (!b1) {
-		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
+		pr_warning("Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
 	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
@@ -127,12 +129,11 @@ calibrate_xor_blocks(void)
 #define xor_speed(templ)	do_xor_speed((templ), b1, b2)
 
 	if (fastest) {
-		printk(KERN_INFO "xor: automatically using best "
-			"checksumming function: %s\n",
+		pr_info("automatically using best checksumming function: %s\n",
 			fastest->name);
 		xor_speed(fastest);
 	} else {
-		printk(KERN_INFO "xor: measuring software checksum speed\n");
+		pr_info("measuring software checksum speed\n");
 		XOR_TRY_TEMPLATES;
 		fastest = template_list;
 		for (f = fastest; f; f = f->next)
@@ -140,8 +141,8 @@ calibrate_xor_blocks(void)
 				fastest = f;
 	}
 
-	printk(KERN_INFO "xor: using function: %s (%d.%03d MB/sec)\n",
-	       fastest->name, fastest->speed / 1000, fastest->speed % 1000);
+	pr_info("using function: %s (%d.%03d MB/sec)\n",
+		fastest->name, fastest->speed / 1000, fastest->speed % 1000);
 
 #undef xor_speed
 
-- 
1.6.3.1.10.g659a0.dirty

