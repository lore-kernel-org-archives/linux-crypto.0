From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2] crypto: tcrypt - Fix memory leaks/crashes in multibuffer
 hash speed test
Date: Tue, 28 Jun 2016 20:33:52 +0800
Message-ID: <20160628123352.GA17844@gondor.apana.org.au>
References: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
 <1467098587-1038-2-git-send-email-k.kozlowski@samsung.com>
 <20160628084138.GD15985@gondor.apana.org.au>
 <57723A08.1010704@samsung.com>
 <20160628095511.GA16644@gondor.apana.org.au>
 <CAJKOXPexSTvfPtEhaSFQ5-igtE0DbgnVeOPzFPkXaSv5r+vZHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Megha Dey <megha.dey@linux.intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJKOXPexSTvfPtEhaSFQ5-igtE0DbgnVeOPzFPkXaSv5r+vZHw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jun 28, 2016 at 12:15:43PM +0200, Krzysztof Kozlowski wrote:
> Oops:

Thanks, there was a typo where it said k instead of j in the second
loop.

---8<---
This patch resolves a number of issues with the mb speed test
function:

* The tfm is never freed.
* Memory is allocated even when we're not using mb.
* When an error occurs we don't wait for completion for other requests.
* When an error occurs during allocation we may leak memory.
* The test function ignores plen but still runs for plen != blen.
* The backlog flag is incorrectly used (may crash).

This patch tries to resolve all these issues as well as making
the code consistent with the existing hash speed testing function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1537a1c..68064fc 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -409,54 +409,61 @@ static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 	return ret;
 }
 
-char ptext[4096];
-struct scatterlist sg[8][8];
-char result[8][64];
-struct ahash_request *req[8];
-struct tcrypt_result tresult[8];
-char *xbuf[8][XBUFSIZE];
-unsigned long start[8], end[8], mid;
+struct test_mb_ahash_data {
+	struct scatterlist sg[TVMEMSIZE];
+	char result[64];
+	struct ahash_request *req;
+	struct tcrypt_result tresult;
+	char *xbuf[XBUFSIZE];
+};
 
 static void test_mb_ahash_speed(const char *algo, unsigned int sec,
-					struct hash_speed *speed)
+				struct hash_speed *speed)
 {
-	unsigned int i, j, k;
-	void *hash_buff;
-	int ret = -ENOMEM;
+	struct test_mb_ahash_data *data;
 	struct crypto_ahash *tfm;
+	unsigned long start, end;
 	unsigned long cycles;
+	unsigned int i, j, k;
+	int ret;
+
+	data = kzalloc(sizeof(*data) * 8, GFP_KERNEL);
+	if (!data)
+		return;
 
 	tfm = crypto_alloc_ahash(algo, 0, 0);
 	if (IS_ERR(tfm)) {
 		pr_err("failed to load transform for %s: %ld\n",
 			algo, PTR_ERR(tfm));
-		return;
+		goto free_data;
 	}
+
 	for (i = 0; i < 8; ++i) {
-		if (testmgr_alloc_buf(xbuf[i]))
-			goto out_nobuf;
+		if (testmgr_alloc_buf(data[i].xbuf))
+			goto out;
 
-		init_completion(&tresult[i].completion);
+		init_completion(&data[i].tresult.completion);
 
-		req[i] = ahash_request_alloc(tfm, GFP_KERNEL);
-		if (!req[i]) {
+		data[i].req = ahash_request_alloc(tfm, GFP_KERNEL);
+		if (!data[i].req) {
 			pr_err("alg: hash: Failed to allocate request for %s\n",
 			       algo);
-			goto out_noreq;
+			goto out;
 		}
-		ahash_request_set_callback(req[i], CRYPTO_TFM_REQ_MAY_BACKLOG,
-					   tcrypt_complete, &tresult[i]);
 
-		hash_buff = xbuf[i][0];
-		memcpy(hash_buff, ptext, 4096);
+		ahash_request_set_callback(data[i].req, 0,
+					   tcrypt_complete, &data[i].tresult);
+		test_hash_sg_init(data[i].sg);
 	}
 
-	j = 0;
-
-	pr_err("\ntesting speed of %s (%s)\n", algo,
-	       get_driver_name(crypto_ahash, tfm));
+	pr_info("\ntesting speed of multibuffer %s (%s)\n", algo,
+		get_driver_name(crypto_ahash, tfm));
 
 	for (i = 0; speed[i].blen != 0; i++) {
+		/* For some reason this only tests digests. */
+		if (speed[i].blen != speed[i].plen)
+			continue;
+
 		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
 			pr_err("template (%u) too big for tvmem (%lu)\n",
 			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
@@ -466,53 +473,59 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 		if (speed[i].klen)
 			crypto_ahash_setkey(tfm, tvmem[0], speed[i].klen);
 
-		for (k = 0; k < 8; ++k) {
-			sg_init_one(&sg[k][0], (void *) xbuf[k][0],
-				    speed[i].blen);
-			ahash_request_set_crypt(req[k], sg[k],
-						result[k], speed[i].blen);
-		}
+		for (k = 0; k < 8; k++)
+			ahash_request_set_crypt(data[k].req, data[k].sg,
+						data[k].result, speed[i].blen);
 
-		pr_err("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
+		pr_info("test%3u "
+			"(%5u byte blocks,%5u bytes per update,%4u updates): ",
 			i, speed[i].blen, speed[i].plen,
 			speed[i].blen / speed[i].plen);
 
-		for (k = 0; k < 8; ++k) {
-			start[k] = get_cycles();
-			ret = crypto_ahash_digest(req[k]);
-			if (ret == -EBUSY || ret == -EINPROGRESS)
+		start = get_cycles();
+
+		for (k = 0; k < 8; k++) {
+			ret = crypto_ahash_digest(data[k].req);
+			if (ret == -EINPROGRESS)
 				continue;
-			if (ret) {
-				pr_err("alg (%s) something wrong, ret = %d ...\n",
-				       algo, ret);
-				goto out;
-			}
+
+			if (ret)
+				break;
+
+			complete(&data[k].tresult.completion);
+			data[k].tresult.err = 0;
 		}
-		mid = get_cycles();
 
-		for (k = 0; k < 8; ++k) {
-			struct tcrypt_result *tr = &tresult[k];
+		for (j = 0; j < k; j++) {
+			struct tcrypt_result *tr = &data[j].tresult;
 
-			ret = wait_for_completion_interruptible(&tr->completion);
-			if (ret)
-				pr_err("alg(%s): hash: digest failed\n", algo);
-			end[k] = get_cycles();
+			wait_for_completion(&tr->completion);
+			if (tr->err)
+				ret = tr->err;
 		}
 
-		cycles = end[7] - start[0];
-		printk("\nBlock: %6lu cycles (%4lu cycles/byte)\n",
-		       cycles, cycles / (8 * speed[i].blen));
+		end = get_cycles();
+		cycles = end - start;
+		pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
+			cycles, cycles / (8 * speed[i].blen));
+
+		if (ret) {
+			pr_err("At least one hashing failed ret=%d\n", ret);
+			break;
+		}
 	}
-	ret = 0;
 
 out:
 	for (k = 0; k < 8; ++k)
-		ahash_request_free(req[k]);
-out_noreq:
+		ahash_request_free(data[k].req);
+
 	for (k = 0; k < 8; ++k)
-		testmgr_free_buf(xbuf[k]);
-out_nobuf:
-	return;
+		testmgr_free_buf(data[k].xbuf);
+
+	crypto_free_ahash(tfm);
+
+free_data:
+	kfree(data);
 }
 
 static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
