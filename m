From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH][RFC] crypto: tcrypt - Ahash tests changed to run in parallel.
Date: Wed, 2 Jan 2013 16:09:33 +0530
Message-ID: <1357123173-32534-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [207.46.163.25] ([207.46.163.25]:44594 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab3ABKnK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Jan 2013 05:43:10 -0500
Received: from mail36-co9 (localhost [127.0.0.1])	by mail36-co9-R.bigfish.com
 (Postfix) with ESMTP id 7FEAB700255	for <linux-crypto@vger.kernel.org>; Wed,
  2 Jan 2013 10:41:49 +0000 (UTC)
Received: from CO9EHSMHS009.bigfish.com (unknown [10.236.132.252])	by
 mail36-co9.bigfish.com (Postfix) with ESMTP id ACC7F9000B0	for
 <linux-crypto@vger.kernel.org>; Wed,  2 Jan 2013 10:41:46 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by az84smr01.freescale.net
 (8.14.3/8.14.0) with ESMTP id r02Affkk025011	for
 <linux-crypto@vger.kernel.org>; Wed, 2 Jan 2013 03:41:44 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This allows to test & run multiple parallel crypto ahash contexts.
Each of the test vector under the ahash speed test template is started
under a separate kthread.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---
 crypto/tcrypt.c |  164 +++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 129 insertions(+), 35 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 7ae2130..e879de9 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -33,6 +33,7 @@
 #include <linux/jiffies.h>
 #include <linux/timex.h>
 #include <linux/interrupt.h>
+#include <linux/kthread.h>
 #include "tcrypt.h"
 #include "internal.h"
 
@@ -497,9 +498,9 @@ static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 	}
 	return ret;
 }
-
 static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
-				     char *out, int sec)
+				     char *out, int sec,
+				     struct completion *comp)
 {
 	unsigned long start, end;
 	int bcount;
@@ -512,6 +513,11 @@ static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
 			return ret;
 	}
 
+	wait_for_completion_interruptible(comp);
+
+	pr_info("test (%5u byte blocks,%5u bytes per update,%4u updates): ",
+		blen, blen, blen/blen);
+
 	printk("%6u opers/sec, %9lu bytes/sec\n",
 	       bcount / sec, ((long)bcount * blen) / sec);
 
@@ -519,14 +525,15 @@ static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
 }
 
 static int test_ahash_jiffies(struct ahash_request *req, int blen,
-			      int plen, char *out, int sec)
+			      int plen, char *out, int sec,
+			      struct completion *comp)
 {
 	unsigned long start, end;
 	int bcount, pcount;
 	int ret;
 
 	if (plen == blen)
-		return test_ahash_jiffies_digest(req, blen, out, sec);
+		return test_ahash_jiffies_digest(req, blen, out, sec, comp);
 
 	for (start = jiffies, end = start + sec * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
@@ -544,6 +551,11 @@ static int test_ahash_jiffies(struct ahash_request *req, int blen,
 			return ret;
 	}
 
+	wait_for_completion_interruptible(comp);
+
+	pr_info("test (%5u byte blocks,%5u bytes per update,%4u updates): ",
+		blen, plen, blen/plen);
+
 	pr_cont("%6u opers/sec, %9lu bytes/sec\n",
 		bcount / sec, ((long)bcount * blen) / sec);
 
@@ -551,7 +563,7 @@ static int test_ahash_jiffies(struct ahash_request *req, int blen,
 }
 
 static int test_ahash_cycles_digest(struct ahash_request *req, int blen,
-				    char *out)
+				    char *out, struct completion *comp)
 {
 	unsigned long cycles = 0;
 	int ret, i;
@@ -582,6 +594,11 @@ out:
 	if (ret)
 		return ret;
 
+	wait_for_completion_interruptible(comp);
+
+	pr_info("test (%5u byte blocks,%5u bytes per update,%4u updates): ",
+		blen, blen, blen/blen);
+
 	pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
 		cycles / 8, cycles / (8 * blen));
 
@@ -589,13 +606,13 @@ out:
 }
 
 static int test_ahash_cycles(struct ahash_request *req, int blen,
-			     int plen, char *out)
+			     int plen, char *out, struct completion *comp)
 {
 	unsigned long cycles = 0;
 	int i, pcount, ret;
 
 	if (plen == blen)
-		return test_ahash_cycles_digest(req, blen, out);
+		return test_ahash_cycles_digest(req, blen, out, comp);
 
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
@@ -636,51 +653,119 @@ static int test_ahash_cycles(struct ahash_request *req, int blen,
 	}
 
 out:
+
 	if (ret)
 		return ret;
 
+	wait_for_completion_interruptible(comp);
+
+	pr_info("test (%5u byte blocks,%5u bytes per update,%4u updates): ",
+		blen, plen, blen/plen);
+
 	pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
 		cycles / 8, cycles / (8 * blen));
 
 	return 0;
 }
 
-static void test_ahash_speed(const char *algo, unsigned int sec,
-			     struct hash_speed *speed)
+struct hash_test {
+	const char *algo;
+	unsigned int blen;
+	unsigned int plen;
+	unsigned int klen;
+	unsigned int sec;
+	struct completion print;
+	struct completion finish;
+};
+
+static int test_ahash_speed_thread(void *data)
 {
 	struct scatterlist sg[TVMEMSIZE];
 	struct tcrypt_result tresult;
 	struct ahash_request *req;
 	struct crypto_ahash *tfm;
 	static char output[1024];
-	int i, ret;
-
-	printk(KERN_INFO "\ntesting speed of async %s\n", algo);
+	int ret;
+	struct hash_test *test = data;
 
-	tfm = crypto_alloc_ahash(algo, 0, 0);
+	tfm = crypto_alloc_ahash(test->algo, 0, 0);
 	if (IS_ERR(tfm)) {
 		pr_err("failed to load transform for %s: %ld\n",
-		       algo, PTR_ERR(tfm));
-		return;
+		       test->algo, PTR_ERR(tfm));
+		ret = PTR_ERR(tfm);
+		goto stop;
 	}
 
 	if (crypto_ahash_digestsize(tfm) > sizeof(output)) {
 		pr_err("digestsize(%u) > outputbuffer(%zu)\n",
 		       crypto_ahash_digestsize(tfm), sizeof(output));
-		goto out;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	test_hash_sg_init(sg);
 	req = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		pr_err("ahash request allocation failure\n");
-		goto out;
+		ret = PTR_ERR(req);
+		goto err;
 	}
 
 	init_completion(&tresult.completion);
 	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   tcrypt_complete, &tresult);
 
+
+	ahash_request_set_crypt(req, sg, output, test->plen);
+
+	if (sec)
+		ret = test_ahash_jiffies(req, test->blen,
+					 test->plen, output, sec,
+					 &test->print);
+	else
+		ret = test_ahash_cycles(req, test->blen,
+					test->plen, output, &test->print);
+
+	if (ret)
+		pr_err("hashing failed ret=%d\n", ret);
+
+	ahash_request_free(req);
+
+err:
+	crypto_free_ahash(tfm);
+
+stop:
+	complete(&test->finish);
+
+	return ret;
+}
+
+
+static void test_ahash_speed(const char *algo, unsigned int sec,
+			     struct hash_speed *speed)
+{
+	int i, num_tests;
+	struct hash_test *tests;
+	struct task_struct **threads;
+
+	pr_info("\ntesting speed of async %s\n", algo);
+
+	/* Count the number of tests to be done */
+	for (i = 0; speed[i].blen != 0; i++)
+		;
+
+	threads = kzalloc(i * sizeof(struct task_struct *), GFP_KERNEL);
+	if (!threads) {
+		pr_err("Memory alloc for threads failed\n");
+		return;
+	}
+
+	tests = kzalloc(i * sizeof(struct hash_test), GFP_KERNEL);
+	if (!threads) {
+		pr_err("Memory alloc for hash tests failed\n");
+		goto err;
+	}
+
 	for (i = 0; speed[i].blen != 0; i++) {
 		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
 			pr_err("template (%u) too big for tvmem (%lu)\n",
@@ -688,29 +773,38 @@ static void test_ahash_speed(const char *algo, unsigned int sec,
 			break;
 		}
 
-		pr_info("test%3u "
-			"(%5u byte blocks,%5u bytes per update,%4u updates): ",
-			i, speed[i].blen, speed[i].plen, speed[i].blen / speed[i].plen);
-
-		ahash_request_set_crypt(req, sg, output, speed[i].plen);
-
-		if (sec)
-			ret = test_ahash_jiffies(req, speed[i].blen,
-						 speed[i].plen, output, sec);
-		else
-			ret = test_ahash_cycles(req, speed[i].blen,
-						speed[i].plen, output);
-
-		if (ret) {
-			pr_err("hashing failed ret=%d\n", ret);
+		tests[i].algo = algo;
+		tests[i].blen = speed[i].blen;
+		tests[i].plen = speed[i].plen;
+		tests[i].klen = speed[i].klen;
+		init_completion(&tests[i].print);
+		init_completion(&tests[i].finish);
+
+		/* Create a kthread for the test vector in template */
+		threads[i] = kthread_run(test_ahash_speed_thread, &tests[i],
+					 "tcrypt_ahash_%d", i);
+		if (IS_ERR(threads[i])) {
+			pr_err("tcrypt_ahash_%d creation failed\n", i);
 			break;
 		}
 	}
 
-	ahash_request_free(req);
+	num_tests = i;
 
-out:
-	crypto_free_ahash(tfm);
+	/* TODO: Let all threads pass a barrier so that they start
+	 * crypto tests together.
+	 */
+
+	/* Signal threads one by one for printing results and stop them*/
+	for (i = 0; i < num_tests; i++) {
+		complete(&tests[i].print);
+		/*kthread_stop(threads[i]);*/
+		wait_for_completion_interruptible(&tests[i].finish);
+	}
+
+err:
+	kfree(threads);
+	kfree(tests);
 }
 
 static inline int do_one_acipher_op(struct ablkcipher_request *req, int ret)
-- 
1.7.7.6
