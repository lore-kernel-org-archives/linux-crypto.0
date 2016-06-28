From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] crypto: tcrypt: Fix mixing printk/pr_err and obvious
 indentation issues
Date: Tue, 28 Jun 2016 09:23:06 +0200
Message-ID: <1467098587-1038-1-git-send-email-k.kozlowski@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The recently added test_mb_ahash_speed() has clearly serious coding
style issues. Try to fix some of them:
1. Don't mix pr_err() and printk();
2. Don't wrap strings;
3. Properly align goto statement in if() block;
4. Align wrapped arguments on new line;
5. Don't wrap functions on first argument;

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 crypto/tcrypt.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 6ef78157a0ab..3788a607921e 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -608,12 +608,12 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 
 		req[i] = ahash_request_alloc(tfm, GFP_KERNEL);
 		if (!req[i]) {
-			printk(KERN_ERR "alg: hash: Failed to allocate "
-				"request for %s\n", algo);
+			pr_err("alg: hash: Failed to allocate request for %s\n",
+			       algo);
 			goto out_noreq;
 		}
 		ahash_request_set_callback(req[i], CRYPTO_TFM_REQ_MAY_BACKLOG,
-				tcrypt_complete, &tresult[i]);
+					   tcrypt_complete, &tresult[i]);
 
 		hash_buff = xbuf[i][0];
 		memcpy(hash_buff, ptext, 4096);
@@ -621,15 +621,14 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 
 	j = 0;
 
-	printk(KERN_INFO "\ntesting speed of %s (%s)\n", algo,
-				get_driver_name(crypto_ahash, tfm));
+	pr_err("\ntesting speed of %s (%s)\n", algo,
+	       get_driver_name(crypto_ahash, tfm));
 
 	for (i = 0; speed[i].blen != 0; i++) {
 		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
-			printk(KERN_ERR
-				"template (%u) too big for tvmem (%lu)\n",
-					speed[i].blen, TVMEMSIZE * PAGE_SIZE);
-		goto out;
+			pr_err("template (%u) too big for tvmem (%lu)\n",
+			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
+			goto out;
 		}
 
 		if (speed[i].klen)
@@ -637,13 +636,12 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 
 		for (k = 0; k < 8; ++k) {
 			sg_init_one(&sg[k][0], (void *) xbuf[k][0],
-						speed[i].blen);
+				    speed[i].blen);
 			ahash_request_set_crypt(req[k], sg[k],
 						result[k], speed[i].blen);
 		}
 
-		printk(KERN_INFO "test%3u "
-			"(%5u byte blocks,%5u bytes per update,%4u updates): ",
+		pr_err("test%3u (%5u byte blocks,%5u bytes per update,%4u updates): ",
 			i, speed[i].blen, speed[i].plen,
 			speed[i].blen / speed[i].plen);
 
@@ -653,9 +651,8 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 			if (ret == -EBUSY || ret == -EINPROGRESS)
 				continue;
 			if (ret) {
-				printk(KERN_ERR
-				"alg (%s) something wrong, ret = %d ...\n",
-								algo, ret);
+				pr_err("alg (%s) something wrong, ret = %d ...\n",
+				       algo, ret);
 				goto out;
 			}
 		}
@@ -664,11 +661,9 @@ static void test_mb_ahash_speed(const char *algo, unsigned int sec,
 		for (k = 0; k < 8; ++k) {
 			struct tcrypt_result *tr = &tresult[k];
 
-			ret = wait_for_completion_interruptible
-						(&tr->completion);
+			ret = wait_for_completion_interruptible(&tr->completion);
 			if (ret)
-				printk(KERN_ERR
-				"alg(%s): hash: digest failed\n", algo);
+				pr_err("alg(%s): hash: digest failed\n", algo);
 			end[k] = get_cycles();
 		}
 
-- 
1.9.1
