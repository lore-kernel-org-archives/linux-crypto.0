From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH v2 7/7] crypto: tcrypt: Fix AEAD speed tests
Date: Tue, 7 Jul 2015 21:01:49 +0530
Message-ID: <1436283109-13318-8-git-send-email-lokeshvutla@ti.com>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>, <lokeshvutla@ti.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The AEAD speed tests doesn't do a wait_for_completition,
if the return value is EINPROGRESS or EBUSY.
Fixing it here.
Also add a test case for gcm(aes).

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 crypto/tcrypt.c | 65 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9f6f10b..3603c7c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -73,6 +73,22 @@ static char *check[] = {
 	"lzo", "cts", "zlib", NULL
 };
 
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
 static int test_cipher_jiffies(struct blkcipher_desc *desc, int enc,
 			       struct scatterlist *sg, int blen, int secs)
 {
@@ -143,6 +159,20 @@ out:
 	return ret;
 }
 
+static inline int do_one_aead_op(struct aead_request *req, int ret)
+{
+	if (ret == -EINPROGRESS || ret == -EBUSY) {
+		struct tcrypt_result *tr = req->base.data;
+
+		ret = wait_for_completion_interruptible(&tr->completion);
+		if (!ret)
+			ret = tr->err;
+		reinit_completion(&tr->completion);
+	}
+
+	return ret;
+}
+
 static int test_aead_jiffies(struct aead_request *req, int enc,
 				int blen, int secs)
 {
@@ -153,9 +183,9 @@ static int test_aead_jiffies(struct aead_request *req, int enc,
 	for (start = jiffies, end = start + secs * HZ, bcount = 0;
 	     time_before(jiffies, end); bcount++) {
 		if (enc)
-			ret = crypto_aead_encrypt(req);
+			ret = do_one_aead_op(req, crypto_aead_encrypt(req));
 		else
-			ret = crypto_aead_decrypt(req);
+			ret = do_one_aead_op(req, crypto_aead_decrypt(req));
 
 		if (ret)
 			return ret;
@@ -177,9 +207,9 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 	/* Warm-up run. */
 	for (i = 0; i < 4; i++) {
 		if (enc)
-			ret = crypto_aead_encrypt(req);
+			ret = do_one_aead_op(req, crypto_aead_encrypt(req));
 		else
-			ret = crypto_aead_decrypt(req);
+			ret = do_one_aead_op(req, crypto_aead_decrypt(req));
 
 		if (ret)
 			goto out;
@@ -191,9 +221,9 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 
 		start = get_cycles();
 		if (enc)
-			ret = crypto_aead_encrypt(req);
+			ret = do_one_aead_op(req, crypto_aead_encrypt(req));
 		else
-			ret = crypto_aead_decrypt(req);
+			ret = do_one_aead_op(req, crypto_aead_decrypt(req));
 		end = get_cycles();
 
 		if (ret)
@@ -286,6 +316,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	char *axbuf[XBUFSIZE];
 	unsigned int *b_size;
 	unsigned int iv_len;
+	struct tcrypt_result result;
 
 	iv = kzalloc(MAX_IVLEN, GFP_KERNEL);
 	if (!iv)
@@ -321,6 +352,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 		goto out_notfm;
 	}
 
+	init_completion(&result.completion);
 	printk(KERN_INFO "\ntesting speed of %s (%s) %s\n", algo,
 			get_driver_name(crypto_aead, tfm), e);
 
@@ -331,6 +363,9 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 		goto out_noreq;
 	}
 
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  tcrypt_complete, &result);
+
 	i = 0;
 	do {
 		b_size = aead_sizes;
@@ -749,22 +784,6 @@ out:
 	crypto_free_hash(tfm);
 }
 
-struct tcrypt_result {
-	struct completion completion;
-	int err;
-};
-
-static void tcrypt_complete(struct crypto_async_request *req, int err)
-{
-	struct tcrypt_result *res = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	res->err = err;
-	complete(&res->completion);
-}
-
 static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 {
 	if (ret == -EINPROGRESS || ret == -EBUSY) {
@@ -1760,6 +1779,8 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 	case 211:
 		test_aead_speed("rfc4106(gcm(aes))", ENCRYPT, sec,
 				NULL, 0, 16, 8, aead_speed_template_20);
+		test_aead_speed("gcm(aes)", ENCRYPT, sec,
+				NULL, 0, 16, 8, aead_speed_template_20);
 		break;
 
 	case 212:
-- 
1.9.1
