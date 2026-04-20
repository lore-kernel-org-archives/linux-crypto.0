Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A0438734E;
	Mon, 20 Apr 2026 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667025; cv=none; b=qp1jJKmPDvXCBofDYzFBs4n49bdlYvQz4UWh5MNU4ByeRxvcR3ECjSfvRZNxaEYGIDP45n/CsM4zffjXvJRLUOLPFj64/qA+8JJ29MzjVBB1TTFmuAGZfyyalbREVhBC1Pu8OX6SI1qn9NY2KMwA0qpe6Ozf9RqYsg1qUcGn/cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667025; c=relaxed/simple;
	bh=/u+lRTImvLueD/+PSvEGy3iqrgX6BJzcHarFIttsMV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpHZYgz3+Qq0pDl4qtuK85/ijBahydJ43Uhs5NKqY3xJ7joyIDoJTko5/crjCphvpI/ZJ/LA+jbHlGhuXh7KSGkiZ4Vltex8gOXivsrxyIguLu7kk/MBMMjxcOL1OLE5gFuLNweBMGwbba6BceBAVSBjd+y8dSrVhfkfpK3ANIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n5BtpE2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5BtpE2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECB0C2BCB9;
	Mon, 20 Apr 2026 06:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667025;
	bh=/u+lRTImvLueD/+PSvEGy3iqrgX6BJzcHarFIttsMV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5BtpE2u8ubAw+5sN5HzYNJPxuntFInlg55edxdp9H5QeDA+re2ngA+aPlsbhNmLu
	 Q8bo+kwPFTIkU7DhQLQfTIxj7jB9+IGmHT8+koF3QQXFWvg1upFrVmj/uwg4+EOWFP
	 sEWTxCJY3qkiNDq2UwC66bUFr+isj6r5pxcT9w8rkF5uLdnm8Ev7TbCX9DoXeXmeH0
	 fIDB0hN5k4enQ2zealLjH+TptK6pHgZC/fD8zBebVKUc/MazefRGiSvho3ziV2SPkd
	 7mY8HDFUcY1JZMKM9Ll+Copbtpvv9+EgwIoUSQa2PVbeZia36GyptcQAm0EdfO1xJG
	 JY7OzwCUOVlrw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 18/38] crypto: drbg - Simplify algorithm registration
Date: Sun, 19 Apr 2026 23:34:02 -0700
Message-ID: <20260420063422.324906-19-ebiggers@kernel.org>
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

Now that "drbg_pr_hmac_sha512" and "drbg_nopr_hmac_sha512" are the only
crypto_rng algorithms left in crypto/drbg.c, simplify the algorithm
registration logic to register these more directly without relying on
the drbg_cores[] array (which will be removed).

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 100 ++++++++++++++++++--------------------------------
 1 file changed, 35 insertions(+), 65 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 81bccacd3595..4a778d0d1fc4 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1143,90 +1143,60 @@ static inline int __init drbg_healthcheck_sanity(void)
 
 	kfree(drbg);
 	return rc;
 }
 
-static struct rng_alg drbg_algs[22];
-
-/*
- * Fill the array drbg_algs used to register the different DRBGs
- * with the kernel crypto API. To fill the array, the information
- * from drbg_cores[] is used.
- */
-static inline void __init drbg_fill_array(struct rng_alg *alg,
-					  const struct drbg_core *core, int pr)
-{
-	int pos = 0;
-	static int priority = 200;
-
-	memcpy(alg->base.cra_name, "stdrng", 6);
-	if (pr) {
-		memcpy(alg->base.cra_driver_name, "drbg_pr_", 8);
-		pos = 8;
-	} else {
-		memcpy(alg->base.cra_driver_name, "drbg_nopr_", 10);
-		pos = 10;
-	}
-	memcpy(alg->base.cra_driver_name + pos, core->cra_name,
-	       strlen(core->cra_name));
-
-	alg->base.cra_priority = priority;
-	priority++;
-	/*
-	 * If FIPS mode enabled, the selected DRBG shall have the
-	 * highest cra_priority over other stdrng instances to ensure
-	 * it is selected.
-	 */
-	if (fips_enabled)
-		alg->base.cra_priority += 2000;
-
-	alg->base.cra_ctxsize 	= sizeof(struct drbg_state);
-	alg->base.cra_module	= THIS_MODULE;
-	alg->base.cra_init	= drbg_kcapi_init;
-	alg->base.cra_exit	= drbg_kcapi_cleanup;
-	alg->generate		= drbg_kcapi_random;
-	alg->seed		= drbg_kcapi_seed;
-	alg->set_ent		= drbg_kcapi_set_entropy;
-	alg->seedsize		= 0;
-}
+static struct rng_alg drbg_algs[] = {
+	{
+		.base.cra_name		= "stdrng",
+		.base.cra_driver_name	= "drbg_pr_hmac_sha512",
+		.base.cra_priority	= 200,
+		.base.cra_ctxsize	= sizeof(struct drbg_state),
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_init		= drbg_kcapi_init,
+		.set_ent		= drbg_kcapi_set_entropy,
+		.seed			= drbg_kcapi_seed,
+		.generate		= drbg_kcapi_random,
+		.base.cra_exit		= drbg_kcapi_cleanup,
+	},
+	{
+		.base.cra_name		= "stdrng",
+		.base.cra_driver_name	= "drbg_nopr_hmac_sha512",
+		.base.cra_priority	= 201,
+		.base.cra_ctxsize	= sizeof(struct drbg_state),
+		.base.cra_module	= THIS_MODULE,
+		.base.cra_init		= drbg_kcapi_init,
+		.set_ent		= drbg_kcapi_set_entropy,
+		.seed			= drbg_kcapi_seed,
+		.generate		= drbg_kcapi_random,
+		.base.cra_exit		= drbg_kcapi_cleanup,
+	},
+};
 
 static int __init drbg_init(void)
 {
-	unsigned int i = 0; /* pointer to drbg_algs */
-	unsigned int j = 0; /* pointer to drbg_cores */
 	int ret;
 
 	ret = drbg_healthcheck_sanity();
 	if (ret)
 		return ret;
 
-	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
-		pr_info("DRBG: Cannot register all DRBG types"
-			"(slots needed: %zu, slots available: %zu)\n",
-			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
-		return -EFAULT;
-	}
-
 	/*
-	 * each DRBG definition can be used with PR and without PR, thus
-	 * we instantiate each DRBG in drbg_cores[] twice.
-	 *
-	 * As the order of placing them into the drbg_algs array matters
-	 * (the later DRBGs receive a higher cra_priority) we register the
-	 * prediction resistance DRBGs first as the should not be too
-	 * interesting.
+	 * In FIPS mode, boost the algorithm priorities to ensure that when
+	 * users request "stdrng", they really get an algorithm from here.
 	 */
-	for (j = 0; ARRAY_SIZE(drbg_cores) > j; j++, i++)
-		drbg_fill_array(&drbg_algs[i], &drbg_cores[j], 1);
-	for (j = 0; ARRAY_SIZE(drbg_cores) > j; j++, i++)
-		drbg_fill_array(&drbg_algs[i], &drbg_cores[j], 0);
-	return crypto_register_rngs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
+	if (fips_enabled) {
+		for (size_t i = 0; i < ARRAY_SIZE(drbg_algs); i++)
+			drbg_algs[i].base.cra_priority += 2000;
+	}
+
+	return crypto_register_rngs(drbg_algs, ARRAY_SIZE(drbg_algs));
 }
 
 static void __exit drbg_exit(void)
 {
-	crypto_unregister_rngs(drbg_algs, (ARRAY_SIZE(drbg_cores) * 2));
+	crypto_unregister_rngs(drbg_algs, ARRAY_SIZE(drbg_algs));
 }
 
 module_init(drbg_init);
 module_exit(drbg_exit);
 MODULE_LICENSE("GPL");
-- 
2.53.0

