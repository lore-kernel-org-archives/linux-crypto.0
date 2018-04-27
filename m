From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] crypto: tcrypt: Remove VLA usage
Date: Thu, 26 Apr 2018 19:57:28 -0700
Message-ID: <20180427025728.GA38607@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
allocates the return code buffers before starting jiffie timers, rather
than using stack space for the array. Additionally cleans up some exit
paths and make sure that the num_mb module_param() is used only once
per execution to avoid possible races in the value changing.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/tcrypt.c | 118 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 79 insertions(+), 39 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 51fe7c8744ae..e721faab6fc8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -158,9 +158,9 @@ struct test_mb_aead_data {
 };
 
 static int do_mult_aead_op(struct test_mb_aead_data *data, int enc,
-				u32 num_mb)
+				u32 num_mb, int *rc)
 {
-	int i, rc[num_mb], err = 0;
+	int i, err = 0;
 
 	/* Fire up a bunch of concurrent requests */
 	for (i = 0; i < num_mb; i++) {
@@ -188,18 +188,26 @@ static int test_mb_aead_jiffies(struct test_mb_aead_data *data, int enc,
 {
 	unsigned long start, end;
 	int bcount;
-	int ret;
+	int ret = 0;
+	int *rc;
+
+	rc = kcalloc(num_mb, sizeof(*rc), GFP_KERNEL);
+	if (!rc)
+		return -ENOMEM;
 
 	for (start = jiffies, end = start + secs * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
-		ret = do_mult_aead_op(data, enc, num_mb);
+		ret = do_mult_aead_op(data, enc, num_mb, rc);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	pr_cont("%d operations in %d seconds (%ld bytes)\n",
 		bcount * num_mb, secs, (long)bcount * blen * num_mb);
-	return 0;
+
+out:
+	kfree(rc);
+	return ret;
 }
 
 static int test_mb_aead_cycles(struct test_mb_aead_data *data, int enc,
@@ -208,10 +216,15 @@ static int test_mb_aead_cycles(struct test_mb_aead_data *data, int enc,
 	unsigned long cycles = 0;
 	int ret = 0;
 	int i;
+	int *rc;
+
+	rc = kcalloc(num_mb, sizeof(*rc), GFP_KERNEL);
+	if (!rc)
+		return -ENOMEM;
 
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
-		ret = do_mult_aead_op(data, enc, num_mb);
+		ret = do_mult_aead_op(data, enc, num_mb, rc);
 		if (ret)
 			goto out;
 	}
@@ -221,7 +234,7 @@ static int test_mb_aead_cycles(struct test_mb_aead_data *data, int enc,
 		cycles_t start, end;
 
 		start = get_cycles();
-		ret = do_mult_aead_op(data, enc, num_mb);
+		ret = do_mult_aead_op(data, enc, num_mb, rc);
 		end = get_cycles();
 
 		if (ret)
@@ -230,11 +243,11 @@ static int test_mb_aead_cycles(struct test_mb_aead_data *data, int enc,
 		cycles += end - start;
 	}
 
-out:
-	if (ret == 0)
-		pr_cont("1 operation in %lu cycles (%d bytes)\n",
-			(cycles + 4) / (8 * num_mb), blen);
+	pr_cont("1 operation in %lu cycles (%d bytes)\n",
+		(cycles + 4) / (8 * num_mb), blen);
 
+out:
+	kfree(rc);
 	return ret;
 }
 
@@ -705,9 +718,10 @@ struct test_mb_ahash_data {
 	char *xbuf[XBUFSIZE];
 };
 
-static inline int do_mult_ahash_op(struct test_mb_ahash_data *data, u32 num_mb)
+static inline int do_mult_ahash_op(struct test_mb_ahash_data *data, u32 num_mb,
+				   int *rc)
 {
-	int i, rc[num_mb], err = 0;
+	int i, err = 0;
 
 	/* Fire up a bunch of concurrent requests */
 	for (i = 0; i < num_mb; i++)
@@ -731,18 +745,26 @@ static int test_mb_ahash_jiffies(struct test_mb_ahash_data *data, int blen,
 {
 	unsigned long start, end;
 	int bcount;
-	int ret;
+	int ret = 0;
+	int *rc;
+
+	rc = kcalloc(num_mb, sizeof(*rc), GFP_KERNEL);
+	if (!rc)
+		return -ENOMEM;
 
 	for (start = jiffies, end = start + secs * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
-		ret = do_mult_ahash_op(data, num_mb);
+		ret = do_mult_ahash_op(data, num_mb, rc);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	pr_cont("%d operations in %d seconds (%ld bytes)\n",
 		bcount * num_mb, secs, (long)bcount * blen * num_mb);
-	return 0;
+
+out:
+	kfree(rc);
+	return ret;
 }
 
 static int test_mb_ahash_cycles(struct test_mb_ahash_data *data, int blen,
@@ -751,10 +773,15 @@ static int test_mb_ahash_cycles(struct test_mb_ahash_data *data, int blen,
 	unsigned long cycles = 0;
 	int ret = 0;
 	int i;
+	int *rc;
+
+	rc = kcalloc(num_mb, sizeof(*rc), GFP_KERNEL);
+	if (!rc)
+		return -ENOMEM;
 
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
-		ret = do_mult_ahash_op(data, num_mb);
+		ret = do_mult_ahash_op(data, num_mb, rc);
 		if (ret)
 			goto out;
 	}
@@ -764,7 +791,7 @@ static int test_mb_ahash_cycles(struct test_mb_ahash_data *data, int blen,
 		cycles_t start, end;
 
 		start = get_cycles();
-		ret = do_mult_ahash_op(data, num_mb);
+		ret = do_mult_ahash_op(data, num_mb, rc);
 		end = get_cycles();
 
 		if (ret)
@@ -773,11 +800,11 @@ static int test_mb_ahash_cycles(struct test_mb_ahash_data *data, int blen,
 		cycles += end - start;
 	}
 
-out:
-	if (ret == 0)
-		pr_cont("1 operation in %lu cycles (%d bytes)\n",
-			(cycles + 4) / (8 * num_mb), blen);
+	pr_cont("1 operation in %lu cycles (%d bytes)\n",
+		(cycles + 4) / (8 * num_mb), blen);
 
+out:
+	kfree(rc);
 	return ret;
 }
 
@@ -1118,9 +1145,9 @@ struct test_mb_skcipher_data {
 };
 
 static int do_mult_acipher_op(struct test_mb_skcipher_data *data, int enc,
-				u32 num_mb)
+				u32 num_mb, int *rc)
 {
-	int i, rc[num_mb], err = 0;
+	int i, err = 0;
 
 	/* Fire up a bunch of concurrent requests */
 	for (i = 0; i < num_mb; i++) {
@@ -1148,18 +1175,26 @@ static int test_mb_acipher_jiffies(struct test_mb_skcipher_data *data, int enc,
 {
 	unsigned long start, end;
 	int bcount;
-	int ret;
+	int ret = 0;
+	int *rc;
+
+	rc = kcalloc(num_mb, sizeof(*rc), GFP_KERNEL);
+	if (!rc)
+		return -ENOMEM;
 
 	for (start = jiffies, end = start + secs * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
-		ret = do_mult_acipher_op(data, enc, num_mb);
+		ret = do_mult_acipher_op(data, enc, num_mb, rc);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	pr_cont("%d operations in %d seconds (%ld bytes)\n",
 		bcount * num_mb, secs, (long)bcount * blen * num_mb);
-	return 0;
+
+out:
+	kfree(rc);
+	return ret;
 }
 
 static int test_mb_acipher_cycles(struct test_mb_skcipher_data *data, int enc,
@@ -1168,10 +1203,15 @@ static int test_mb_acipher_cycles(struct test_mb_skcipher_data *data, int enc,
 	unsigned long cycles = 0;
 	int ret = 0;
 	int i;
+	int *rc;
+
+	rc = kcalloc(num_mb, sizeof(*rc), GFP_KERNEL);
+	if (!rc)
+		return -ENOMEM;
 
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
-		ret = do_mult_acipher_op(data, enc, num_mb);
+		ret = do_mult_acipher_op(data, enc, num_mb, rc);
 		if (ret)
 			goto out;
 	}
@@ -1181,7 +1221,7 @@ static int test_mb_acipher_cycles(struct test_mb_skcipher_data *data, int enc,
 		cycles_t start, end;
 
 		start = get_cycles();
-		ret = do_mult_acipher_op(data, enc, num_mb);
+		ret = do_mult_acipher_op(data, enc, num_mb, rc);
 		end = get_cycles();
 
 		if (ret)
@@ -1190,11 +1230,11 @@ static int test_mb_acipher_cycles(struct test_mb_skcipher_data *data, int enc,
 		cycles += end - start;
 	}
 
-out:
-	if (ret == 0)
-		pr_cont("1 operation in %lu cycles (%d bytes)\n",
-			(cycles + 4) / (8 * num_mb), blen);
+	pr_cont("1 operation in %lu cycles (%d bytes)\n",
+		(cycles + 4) / (8 * num_mb), blen);
 
+out:
+	kfree(rc);
 	return ret;
 }
 
@@ -1606,7 +1646,7 @@ static inline int tcrypt_test(const char *alg)
 	return ret;
 }
 
-static int do_test(const char *alg, u32 type, u32 mask, int m)
+static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 {
 	int i;
 	int ret = 0;
@@ -1621,7 +1661,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		}
 
 		for (i = 1; i < 200; i++)
-			ret += do_test(NULL, 0, 0, i);
+			ret += do_test(NULL, 0, 0, i, num_mb);
 		break;
 
 	case 1:
@@ -2903,7 +2943,7 @@ static int __init tcrypt_mod_init(void)
 			goto err_free_tv;
 	}
 
-	err = do_test(alg, type, mask, mode);
+	err = do_test(alg, type, mask, mode, num_mb);
 
 	if (err) {
 		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
-- 
2.7.4


-- 
Kees Cook
Pixel Security
