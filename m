From: David Miller <davem@davemloft.net>
Subject: [PATCH 3/6] crypto: Add speed tests for async hashing.
Date: Mon, 17 May 2010 22:22:42 -0700 (PDT)
Message-ID: <20100517.222242.71584566.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50950
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab0ERFWd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 May 2010 01:22:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


These are invoked in the 'mode' range of 400 to 499.

The cost of async vs. sync for the software algorithm implementations
varies.  It can be as low as 16 cycles but as much as a couple hundred.

Here two runs of md5 testing, async then sync:

testing speed of async md5
test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   2448 cycles/operation,  153 cycles/byte
test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   4992 cycles/operation,   78 cycles/byte
test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   3808 cycles/operation,   59 cycles/byte
test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  14000 cycles/operation,   54 cycles/byte
test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   8480 cycles/operation,   33 cycles/byte
test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   7280 cycles/operation,   28 cycles/byte
test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  50016 cycles/operation,   48 cycles/byte
test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  22496 cycles/operation,   21 cycles/byte
test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  21232 cycles/operation,   20 cycles/byte
test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates): 117184 cycles/operation,   57 cycles/byte
test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  43008 cycles/operation,   21 cycles/byte
test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  40176 cycles/operation,   19 cycles/byte
test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  39888 cycles/operation,   19 cycles/byte
test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates): 194176 cycles/operation,   47 cycles/byte
test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  84096 cycles/operation,   20 cycles/byte
test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  78336 cycles/operation,   19 cycles/byte
test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  77120 cycles/operation,   18 cycles/byte
test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 403056 cycles/operation,   49 cycles/byte
test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates): 166112 cycles/operation,   20 cycles/byte
test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates): 154768 cycles/operation,   18 cycles/byte
test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates): 151904 cycles/operation,   18 cycles/byte
test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 155456 cycles/operation,   18 cycles/byte

testing speed of md5
test  0 (   16 byte blocks,   16 bytes per update,   1 updates):   2208 cycles/operation,  138 cycles/byte
test  1 (   64 byte blocks,   16 bytes per update,   4 updates):   5008 cycles/operation,   78 cycles/byte
test  2 (   64 byte blocks,   64 bytes per update,   1 updates):   3600 cycles/operation,   56 cycles/byte
test  3 (  256 byte blocks,   16 bytes per update,  16 updates):  14080 cycles/operation,   55 cycles/byte
test  4 (  256 byte blocks,   64 bytes per update,   4 updates):   8560 cycles/operation,   33 cycles/byte
test  5 (  256 byte blocks,  256 bytes per update,   1 updates):   7040 cycles/operation,   27 cycles/byte
test  6 ( 1024 byte blocks,   16 bytes per update,  64 updates):  50592 cycles/operation,   49 cycles/byte
test  7 ( 1024 byte blocks,  256 bytes per update,   4 updates):  22736 cycles/operation,   22 cycles/byte
test  8 ( 1024 byte blocks, 1024 bytes per update,   1 updates):  24960 cycles/operation,   24 cycles/byte
test  9 ( 2048 byte blocks,   16 bytes per update, 128 updates):  99312 cycles/operation,   48 cycles/byte
test 10 ( 2048 byte blocks,  256 bytes per update,   8 updates):  43520 cycles/operation,   21 cycles/byte
test 11 ( 2048 byte blocks, 1024 bytes per update,   2 updates):  40704 cycles/operation,   19 cycles/byte
test 12 ( 2048 byte blocks, 2048 bytes per update,   1 updates):  39552 cycles/operation,   19 cycles/byte
test 13 ( 4096 byte blocks,   16 bytes per update, 256 updates): 196720 cycles/operation,   48 cycles/byte
test 14 ( 4096 byte blocks,  256 bytes per update,  16 updates):  85152 cycles/operation,   20 cycles/byte
test 15 ( 4096 byte blocks, 1024 bytes per update,   4 updates):  79408 cycles/operation,   19 cycles/byte
test 16 ( 4096 byte blocks, 4096 bytes per update,   1 updates):  76816 cycles/operation,   18 cycles/byte
test 17 ( 8192 byte blocks,   16 bytes per update, 512 updates): 391520 cycles/operation,   47 cycles/byte
test 18 ( 8192 byte blocks,  256 bytes per update,  32 updates): 168464 cycles/operation,   20 cycles/byte
test 19 ( 8192 byte blocks, 1024 bytes per update,   8 updates): 156912 cycles/operation,   19 cycles/byte
test 20 ( 8192 byte blocks, 4096 bytes per update,   2 updates): 154016 cycles/operation,   18 cycles/byte
test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates): 153856 cycles/operation,   18 cycles/byte

We can ditch the sync hash code at some point if we feel that makes
sense.  For now I've left it there.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 crypto/tcrypt.c |  336 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 330 insertions(+), 6 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ea610ad..3ca68f9 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -394,6 +394,17 @@ out:
 	return 0;
 }
 
+static void test_hash_sg_init(struct scatterlist *sg)
+{
+	int i;
+
+	sg_init_table(sg, TVMEMSIZE);
+	for (i = 0; i < TVMEMSIZE; i++) {
+		sg_set_buf(sg + i, tvmem[i], PAGE_SIZE);
+		memset(tvmem[i], 0xff, PAGE_SIZE);
+	}
+}
+
 static void test_hash_speed(const char *algo, unsigned int sec,
 			    struct hash_speed *speed)
 {
@@ -423,12 +434,7 @@ static void test_hash_speed(const char *algo, unsigned int sec,
 		goto out;
 	}
 
-	sg_init_table(sg, TVMEMSIZE);
-	for (i = 0; i < TVMEMSIZE; i++) {
-		sg_set_buf(sg + i, tvmem[i], PAGE_SIZE);
-		memset(tvmem[i], 0xff, PAGE_SIZE);
-	}
-
+	test_hash_sg_init(sg);
 	for (i = 0; speed[i].blen != 0; i++) {
 		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
 			printk(KERN_ERR
@@ -461,6 +467,250 @@ out:
 	crypto_free_hash(tfm);
 }
 
+struct tcrypt_result {
+	struct completion completion;
+	int err;
+};
+
+static void tcrypt_complete(struct crypto_async_request *req, int err)
+{
+	struct tcrypt_result *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&res->completion);
+}
+
+static inline int do_one_ahash_op(struct ahash_request *req, int ret)
+{
+	if (ret == -EINPROGRESS || ret == -EBUSY) {
+		struct tcrypt_result *tr = req->base.data;
+
+		ret = wait_for_completion_interruptible(&tr->completion);
+		if (!ret)
+			ret = tr->err;
+		INIT_COMPLETION(tr->completion);
+	}
+	return ret;
+}
+
+static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
+				     char *out, int sec)
+{
+	unsigned long start, end;
+	int bcount;
+	int ret;
+
+	for (start = jiffies, end = start + sec * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		ret = do_one_ahash_op(req, crypto_ahash_digest(req));
+		if (ret)
+			return ret;
+	}
+
+	printk("%6u opers/sec, %9lu bytes/sec\n",
+	       bcount / sec, ((long)bcount * blen) / sec);
+
+	return 0;
+}
+
+static int test_ahash_jiffies(struct ahash_request *req, int blen,
+			      int plen, char *out, int sec)
+{
+	unsigned long start, end;
+	int bcount, pcount;
+	int ret;
+
+	if (plen == blen)
+		return test_ahash_jiffies_digest(req, blen, out, sec);
+
+	for (start = jiffies, end = start + sec * HZ, bcount = 0;
+	     time_before(jiffies, end); bcount++) {
+		ret = crypto_ahash_init(req);
+		if (ret)
+			return ret;
+		for (pcount = 0; pcount < blen; pcount += plen) {
+			ret = do_one_ahash_op(req, crypto_ahash_update(req));
+			if (ret)
+				return ret;
+		}
+		/* we assume there is enough space in 'out' for the result */
+		ret = do_one_ahash_op(req, crypto_ahash_final(req));
+		if (ret)
+			return ret;
+	}
+
+	pr_cont("%6u opers/sec, %9lu bytes/sec\n",
+		bcount / sec, ((long)bcount * blen) / sec);
+
+	return 0;
+}
+
+static int test_ahash_cycles_digest(struct ahash_request *req, int blen,
+				    char *out)
+{
+	unsigned long cycles = 0;
+	int ret, i;
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		ret = do_one_ahash_op(req, crypto_ahash_digest(req));
+		if (ret)
+			goto out;
+	}
+
+	/* The real thing. */
+	for (i = 0; i < 8; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+
+		ret = do_one_ahash_op(req, crypto_ahash_digest(req));
+		if (ret)
+			goto out;
+
+		end = get_cycles();
+
+		cycles += end - start;
+	}
+
+out:
+	if (ret)
+		return ret;
+
+	pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
+		cycles / 8, cycles / (8 * blen));
+
+	return 0;
+}
+
+static int test_ahash_cycles(struct ahash_request *req, int blen,
+			     int plen, char *out)
+{
+	unsigned long cycles = 0;
+	int i, pcount, ret;
+
+	if (plen == blen)
+		return test_ahash_cycles_digest(req, blen, out);
+
+	/* Warm-up run. */
+	for (i = 0; i < 4; i++) {
+		ret = crypto_ahash_init(req);
+		if (ret)
+			goto out;
+		for (pcount = 0; pcount < blen; pcount += plen) {
+			ret = do_one_ahash_op(req, crypto_ahash_update(req));
+			if (ret)
+				goto out;
+		}
+		ret = do_one_ahash_op(req, crypto_ahash_final(req));
+		if (ret)
+			goto out;
+	}
+
+	/* The real thing. */
+	for (i = 0; i < 8; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+
+		ret = crypto_ahash_init(req);
+		if (ret)
+			goto out;
+		for (pcount = 0; pcount < blen; pcount += plen) {
+			ret = do_one_ahash_op(req, crypto_ahash_update(req));
+			if (ret)
+				goto out;
+		}
+		ret = do_one_ahash_op(req, crypto_ahash_final(req));
+		if (ret)
+			goto out;
+
+		end = get_cycles();
+
+		cycles += end - start;
+	}
+
+out:
+	if (ret)
+		return ret;
+
+	pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
+		cycles / 8, cycles / (8 * blen));
+
+	return 0;
+}
+
+static void test_ahash_speed(const char *algo, unsigned int sec,
+			     struct hash_speed *speed)
+{
+	struct scatterlist sg[TVMEMSIZE];
+	struct tcrypt_result tresult;
+	struct ahash_request *req;
+	struct crypto_ahash *tfm;
+	static char output[1024];
+	int i, ret;
+
+	printk(KERN_INFO "\ntesting speed of async %s\n", algo);
+
+	tfm = crypto_alloc_ahash(algo, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("failed to load transform for %s: %ld\n",
+		       algo, PTR_ERR(tfm));
+		return;
+	}
+
+	if (crypto_ahash_digestsize(tfm) > sizeof(output)) {
+		pr_err("digestsize(%u) > outputbuffer(%zu)\n",
+		       crypto_ahash_digestsize(tfm), sizeof(output));
+		goto out;
+	}
+
+	test_hash_sg_init(sg);
+	req = ahash_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		pr_err("ahash request allocation failure\n");
+		goto out;
+	}
+
+	init_completion(&tresult.completion);
+	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   tcrypt_complete, &tresult);
+
+	for (i = 0; speed[i].blen != 0; i++) {
+		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
+			pr_err("template (%u) too big for tvmem (%lu)\n",
+			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
+			break;
+		}
+
+		pr_info("test%3u "
+			"(%5u byte blocks,%5u bytes per update,%4u updates): ",
+			i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
+
+		ahash_request_set_crypt(req, sg, output, speed[i].plen);
+
+		if (sec)
+			ret = test_ahash_jiffies(req, speed[i].blen,
+						 speed[i].plen, output, sec);
+		else
+			ret = test_ahash_cycles(req, speed[i].blen,
+						speed[i].plen, output);
+
+		if (ret) {
+			pr_err("hashing failed ret=%d\n", ret);
+			break;
+		}
+	}
+
+	ahash_request_free(req);
+
+out:
+	crypto_free_ahash(tfm);
+}
+
 static void test_available(void)
 {
 	char **name = check;
@@ -891,6 +1141,80 @@ static int do_test(int m)
 	case 399:
 		break;
 
+	case 400:
+		/* fall through */
+
+	case 401:
+		test_ahash_speed("md4", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 402:
+		test_ahash_speed("md5", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 403:
+		test_ahash_speed("sha1", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 404:
+		test_ahash_speed("sha256", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 405:
+		test_ahash_speed("sha384", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 406:
+		test_ahash_speed("sha512", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 407:
+		test_ahash_speed("wp256", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 408:
+		test_ahash_speed("wp384", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 409:
+		test_ahash_speed("wp512", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 410:
+		test_ahash_speed("tgr128", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 411:
+		test_ahash_speed("tgr160", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 412:
+		test_ahash_speed("tgr192", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 413:
+		test_ahash_speed("sha224", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 414:
+		test_ahash_speed("rmd128", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 415:
+		test_ahash_speed("rmd160", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 416:
+		test_ahash_speed("rmd256", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 417:
+		test_ahash_speed("rmd320", sec, generic_hash_speed_template);
+		if (mode > 400 && mode < 500) break;
+
+	case 499:
+		break;
+
 	case 1000:
 		test_available();
 		break;
-- 
1.7.0.4
