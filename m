Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E091384257;
	Mon, 20 Apr 2026 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667022; cv=none; b=bWJ5kXfSmurBwLyYbOW1IiS8QWpBXvM46gXJ1gXqk+rp2vfqXk41KcCCiSdYuzgQ2oZDHFnnw+npaMhX5QyrrMcu/DhpNDTwc9CTnKCTQbdaMy+8sNJ2Yy27pa13JlZezLzVE2ng9AY9x/zuA0XJL5IW2+cFyAYSvpVwEYYcrZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667022; c=relaxed/simple;
	bh=2LYwWJGPTmXrhei3+Y4NanvqZ9IlSajbocXmC4fcKwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxTVROhIXfVse0j575ZZUFduTi99oMT9hoOr4sHvNF+MRC31qsjEv/0OTPIqm7OR/4CkWR2IfyLdX+NBTUpsx740uTzRcroPJN70EFutII/ZOC5FfeZG68AgrKr0B6DqTY/2FvP0ozwTLu+lmqdonsgBmEWQL5DZLI7vkBnxmZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pH4yhT+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pH4yhT+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFCDC2BCB7;
	Mon, 20 Apr 2026 06:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667021;
	bh=2LYwWJGPTmXrhei3+Y4NanvqZ9IlSajbocXmC4fcKwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pH4yhT+TbH9ZyPCRvCzEnGq8in0CRYLXKV6DLlwsovWhnnCfqVYb/I6pEf/+syQDA
	 zygT+2BTMSBnlQFZWvoEtQAR0QltsH6hUQ6t6FqRAIeiytm7Bi6LiDlMTi8SUEs7Iw
	 1wIgH5q7gePMotLovqpKi1SsZGuyMg0h3fCWG16Lm8F5lZqJ7QRPysEe0KTl4xsBA0
	 RAxAEl5CUG/fCXt654nLQP6VSwEHb23XLW4yIjv+LTZRIFo7lJtSScmpXBJtiFWR2k
	 t8+oMpZm2hPZhiFz8UyZ0Nn4ukoYzy/MVPArbmFCmPnFRi0PGsW7KLaX4WQAuFZU0R
	 0Wom2jGNp8CPg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 08/38] crypto: drbg - Remove unhelpful helper functions
Date: Sun, 19 Apr 2026 23:33:52 -0700
Message-ID: <20260420063422.324906-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fold the contents of the inline functions crypto_drbg_get_bytes_addtl(),
crypto_drbg_get_bytes_addtl_test(), and crypto_drbg_reset_test() into
their only caller in drbg_cavs_test().  It ends up being much simpler.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c         | 15 +++------
 crypto/testmgr.c      | 34 ++++++-------------
 include/crypto/drbg.h | 76 -------------------------------------------
 3 files changed, 15 insertions(+), 110 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index bb8ddc090307..83cb6c1bbac0 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -53,44 +53,39 @@
  * struct crypto_rng *drng;
  * int err;
  * char data[DATALEN];
  *
  * drng = crypto_alloc_rng(drng_name, 0, 0);
- * err = crypto_rng_get_bytes(drng, &data, DATALEN);
+ * err = crypto_rng_get_bytes(drng, data, DATALEN);
  * crypto_free_rng(drng);
  *
  *
  * Usage with personalization string during initialization
  * -------------------------------------------------------
  * struct crypto_rng *drng;
  * int err;
  * char data[DATALEN];
- * struct drbg_string pers;
  * char personalization[11] = "some-string";
  *
- * drbg_string_fill(&pers, personalization, strlen(personalization));
  * drng = crypto_alloc_rng(drng_name, 0, 0);
  * // The reset completely re-initializes the DRBG with the provided
  * // personalization string
- * err = crypto_rng_reset(drng, &personalization, strlen(personalization));
- * err = crypto_rng_get_bytes(drng, &data, DATALEN);
+ * err = crypto_rng_reset(drng, personalization, strlen(personalization));
+ * err = crypto_rng_get_bytes(drng, data, DATALEN);
  * crypto_free_rng(drng);
  *
  *
  * Usage with additional information string during random number request
  * ---------------------------------------------------------------------
  * struct crypto_rng *drng;
  * int err;
  * char data[DATALEN];
  * char addtl_string[11] = "some-string";
- * string drbg_string addtl;
  *
- * drbg_string_fill(&addtl, addtl_string, strlen(addtl_string));
  * drng = crypto_alloc_rng(drng_name, 0, 0);
- * // The following call is a wrapper to crypto_rng_get_bytes() and returns
- * // the same error codes.
- * err = crypto_drbg_get_bytes_addtl(drng, &data, DATALEN, &addtl);
+ * err = crypto_rng_generate(drng, addtl_string, strlen(addtl_string),
+			     data, DATALEN);
  * crypto_free_rng(drng);
  *
  *
  * Usage with personalization and additional information strings
  * -------------------------------------------------------------
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4d86efae65b2..35ff2b50e3c2 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3485,12 +3485,10 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 			  const char *driver, u32 type, u32 mask)
 {
 	int ret = -EAGAIN;
 	struct crypto_rng *drng;
-	struct drbg_test_data test_data;
-	struct drbg_string addtl, pers, testentropy;
 	unsigned char *buf = kzalloc(test->expectedlen, GFP_KERNEL);
 
 	if (!buf)
 		return -ENOMEM;
 
@@ -3502,43 +3500,31 @@ static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
 		return PTR_ERR(drng);
 	}
 
-	test_data.testentropy = &testentropy;
-	drbg_string_fill(&testentropy, test->entropy, test->entropylen);
-	drbg_string_fill(&pers, test->pers, test->perslen);
-	ret = crypto_drbg_reset_test(drng, &pers, &test_data);
+	crypto_rng_set_entropy(drng, test->entropy, test->entropylen);
+	ret = crypto_rng_reset(drng, test->pers, test->perslen);
 	if (ret) {
 		printk(KERN_ERR "alg: drbg: Failed to reset rng\n");
 		goto outbuf;
 	}
 
-	drbg_string_fill(&addtl, test->addtla, test->addtllen);
-	if (pr) {
-		drbg_string_fill(&testentropy, test->entpra, test->entprlen);
-		ret = crypto_drbg_get_bytes_addtl_test(drng,
-			buf, test->expectedlen, &addtl,	&test_data);
-	} else {
-		ret = crypto_drbg_get_bytes_addtl(drng,
-			buf, test->expectedlen, &addtl);
-	}
+	if (pr)
+		crypto_rng_set_entropy(drng, test->entpra, test->entprlen);
+	ret = crypto_rng_generate(drng, test->addtla, test->addtllen,
+				  buf, test->expectedlen);
 	if (ret < 0) {
 		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
 		goto outbuf;
 	}
 
-	drbg_string_fill(&addtl, test->addtlb, test->addtllen);
-	if (pr) {
-		drbg_string_fill(&testentropy, test->entprb, test->entprlen);
-		ret = crypto_drbg_get_bytes_addtl_test(drng,
-			buf, test->expectedlen, &addtl, &test_data);
-	} else {
-		ret = crypto_drbg_get_bytes_addtl(drng,
-			buf, test->expectedlen, &addtl);
-	}
+	if (pr)
+		crypto_rng_set_entropy(drng, test->entprb, test->entprlen);
+	ret = crypto_rng_generate(drng, test->addtlb, test->addtllen,
+				  buf, test->expectedlen);
 	if (ret < 0) {
 		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
 		goto outbuf;
 	}
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index c11eaf757ed0..486aa793688e 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -76,14 +76,10 @@ struct drbg_state_ops {
 	int (*crypto_init)(struct drbg_state *drbg);
 	int (*crypto_fini)(struct drbg_state *drbg);
 
 };
 
-struct drbg_test_data {
-	struct drbg_string *testentropy; /* TEST PARAMETER: test entropy */
-};
-
 enum drbg_seed_state {
 	DRBG_SEED_STATE_UNSEEDED,
 	DRBG_SEED_STATE_PARTIAL, /* Seeded with !rng_is_initialized() */
 	DRBG_SEED_STATE_FULL,
 };
@@ -163,82 +159,10 @@ static inline size_t drbg_max_requests(struct drbg_state *drbg)
 {
 	/* SP800-90A requires 2**48 maximum requests before reseeding */
 	return (1<<20);
 }
 
-/*
- * This is a wrapper to the kernel crypto API function of
- * crypto_rng_generate() to allow the caller to provide additional data.
- *
- * @drng DRBG handle -- see crypto_rng_get_bytes
- * @outbuf output buffer -- see crypto_rng_get_bytes
- * @outlen length of output buffer -- see crypto_rng_get_bytes
- * @addtl_input additional information string input buffer
- * @addtllen length of additional information string buffer
- *
- * return
- *	see crypto_rng_get_bytes
- */
-static inline int crypto_drbg_get_bytes_addtl(struct crypto_rng *drng,
-			unsigned char *outbuf, unsigned int outlen,
-			struct drbg_string *addtl)
-{
-	return crypto_rng_generate(drng, addtl->buf, addtl->len,
-				   outbuf, outlen);
-}
-
-/*
- * TEST code
- *
- * This is a wrapper to the kernel crypto API function of
- * crypto_rng_generate() to allow the caller to provide additional data and
- * allow furnishing of test_data
- *
- * @drng DRBG handle -- see crypto_rng_get_bytes
- * @outbuf output buffer -- see crypto_rng_get_bytes
- * @outlen length of output buffer -- see crypto_rng_get_bytes
- * @addtl_input additional information string input buffer
- * @addtllen length of additional information string buffer
- * @test_data filled test data
- *
- * return
- *	see crypto_rng_get_bytes
- */
-static inline int crypto_drbg_get_bytes_addtl_test(struct crypto_rng *drng,
-			unsigned char *outbuf, unsigned int outlen,
-			struct drbg_string *addtl,
-			struct drbg_test_data *test_data)
-{
-	crypto_rng_set_entropy(drng, test_data->testentropy->buf,
-			       test_data->testentropy->len);
-	return crypto_rng_generate(drng, addtl->buf, addtl->len,
-				   outbuf, outlen);
-}
-
-/*
- * TEST code
- *
- * This is a wrapper to the kernel crypto API function of
- * crypto_rng_reset() to allow the caller to provide test_data
- *
- * @drng DRBG handle -- see crypto_rng_reset
- * @pers personalization string input buffer
- * @perslen length of additional information string buffer
- * @test_data filled test data
- *
- * return
- *	see crypto_rng_reset
- */
-static inline int crypto_drbg_reset_test(struct crypto_rng *drng,
-					 struct drbg_string *pers,
-					 struct drbg_test_data *test_data)
-{
-	crypto_rng_set_entropy(drng, test_data->testentropy->buf,
-			       test_data->testentropy->len);
-	return crypto_rng_reset(drng, pers->buf, pers->len);
-}
-
 /* DRBG type flags */
 #define DRBG_CTR	((drbg_flag_t)1<<0)
 #define DRBG_HMAC	((drbg_flag_t)1<<1)
 #define DRBG_HASH	((drbg_flag_t)1<<2)
 #define DRBG_TYPE_MASK	(DRBG_CTR | DRBG_HMAC | DRBG_HASH)
-- 
2.53.0

