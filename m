Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE3A4CDDD0
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356569; cv=none; b=apXPdEhV6f68UnN8DlM+j5Sb/nwPYOJXEh09cHzfNvzYUdNkjtMRaUnxkUnMT1xOdkJFaO83M9gV6sklHbp63M92vUzLCLUIAxZ5YWdPHNgExp/JASdmNQ6YMbsGtIo+0d+IUrlAm1Wp/FgmpNi0OvUkhkNw4oJnyk9fnoUtmz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356569; c=relaxed/simple;
	bh=jbjyH9530ba9cj23ukEnEIFe6yt9TREtAk0k5jri9Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXh+ya0kU2l1E3TeovCe/rkL0i5lMPCOsJFPPOKYxTADP1gDfc+gcObOnUZW1Z3YL24apit9egZ04KMADUEWAPUmJRAJ3j7UAhomBpvfFx0eN1IxkFTYn1vljIQgn1T+UOs/vWeb9UzfsWrj+xfoOoVgOTKxbQxHzBYfATeF4eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niYcRIZe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niYcRIZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3141F000C7;
	Sun, 18 Oct 2026 20:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356568;
	bh=ugezJdA9pECNx49coeIbvL25jFpoNE6t78V20o0WwUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niYcRIZe8zgFYLW852vJFmitDVlIsMChXIr7GkcBD0tHGuonhIcQ04uuSjWIYoQNz
	 ktme7NjC8um8E4lYXA0VNJ8zqEn6y2AyZnNAS2c9Pg+F2VCHKW3CowD4lSTVhpIBaj
	 POXwi0Yq2XoAUfla0lmrI4YdmDBR1d1iZo12j0mmEn/6SWZU1S7hO1kVJHtnnNeuwo
	 mYAvoySRodo/KMDPv6phzfDfkeAJ9sMdL9VOBwxZTPThOpQAkvjb5ysANOTbhbpPBY
	 YEEfUXPWAQBVdZXEOvGYNh2ETS9eGvPjJz7VZBqS87YmjDgQhJPPqtixQdHf/ipERe
	 bVeQUqSkpzJRg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 08/14] crypto: algif_rng - Use DRBG and jitterentropy library APIs
Date: Sun, 18 Oct 2026 13:46:12 -0700
Message-ID: <20261018204618.104876-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261018204618.104876-1-ebiggers@kernel.org>
References: <20261018204618.104876-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the overly-general crypto_rng API will be removed, reimplement the
"rng" algorithm type of AF_ALG using the DRBG and jitterentropy library
functions instead of crypto_rng.

This preserves the behavior of all algorithm names that actually worked
with this API (assuming af_alg_restrict=0 to make it available in the
first place).  Note: the only known use case for this is algorithm
testing and entropy evaluation for FIPS 140-3 certification.

Make CRYPTO_USER_API_RNG depend on CRYPTO_DRBG to reflect the
now-explicit dependency.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig     |   4 +-
 crypto/algif_rng.c | 109 +++++++++++++++++++++++++++++----------------
 2 files changed, 73 insertions(+), 40 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 981d5dc422d4c..5b0806432694f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1288,7 +1288,7 @@ config CRYPTO_USER_API_SKCIPHER
 config CRYPTO_USER_API_RNG
 	tristate "Random number generation algorithms (deprecated)"
 	depends on NET
-	select CRYPTO_RNG
+	depends on CRYPTO_DRBG
 	select CRYPTO_USER_API
 	help
 	  Enable the AF_ALG userspace interface for random number generation
@@ -1305,7 +1305,7 @@ config CRYPTO_USER_API_RNG
 
 config CRYPTO_USER_API_RNG_CAVP
 	bool "Enable CAVP testing of DRBG"
-	depends on CRYPTO_USER_API_RNG && CRYPTO_DRBG
+	depends on CRYPTO_USER_API_RNG
 	help
 	  Enable extra APIs in the userspace interface for NIST CAVP
 	  (Cryptographic Algorithm Validation Program) testing:
diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index bd522915d56d7..7fe76479a6bdc 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -40,11 +40,11 @@
 
 #include <linux/capability.h>
 #include <linux/module.h>
-#include <crypto/rng.h>
-#include <linux/random.h>
 #include <crypto/if_alg.h>
 #include <linux/net.h>
 #include <net/sock.h>
+#include "drbg.h"
+#include "jitterentropy-kcapi.h"
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
@@ -54,17 +54,26 @@ static const struct af_alg_allowlist_entry rng_allowlist[] = {
 	{},
 };
 
+enum rng_type {
+	RNG_JITTERENTROPY = 1,
+	RNG_DRBG = 2,
+};
+
+struct rng_parent_ctx {
+	enum rng_type type;
+	union {
+		struct jitterentropy *jent;
+		struct drbg_state *drbg;
+	};
+	u8 *entropy;
+};
+
 struct rng_ctx {
 #define MAXSIZE 128
 	unsigned int len;
-	struct crypto_rng *drng;
 	u8 *addtl;
 	size_t addtl_len;
-};
-
-struct rng_parent_ctx {
-	struct crypto_rng *drng;
-	u8 *entropy;
+	struct rng_parent_ctx *pctx;
 };
 
 static void rng_reset_addtl(struct rng_ctx *ctx)
@@ -74,11 +83,10 @@ static void rng_reset_addtl(struct rng_ctx *ctx)
 	ctx->addtl_len = 0;
 }
 
-static int _rng_recvmsg(struct crypto_rng *drng, struct msghdr *msg, size_t len,
+static int _rng_recvmsg(struct rng_ctx *ctx, struct msghdr *msg, size_t len,
 			u8 *addtl, size_t addtl_len)
 {
 	int err = 0;
-	int genlen = 0;
 	u8 result[MAXSIZE];
 
 	if (len == 0)
@@ -92,15 +100,18 @@ static int _rng_recvmsg(struct crypto_rng *drng, struct msghdr *msg, size_t len,
 	 */
 	memset(result, 0, len);
 
-	/*
-	 * The enforcement of a proper seeding of an RNG is done within an
-	 * RNG implementation. Some RNGs (DRBG, krng) do not need specific
-	 * seeding as they automatically seed. The X9.31 DRNG will return
-	 * an error if it was not seeded properly.
-	 */
-	genlen = crypto_rng_generate(drng, addtl, addtl_len, result, len);
-	if (genlen < 0)
-		return genlen;
+	err = -EINVAL;
+	switch (ctx->pctx->type) {
+	case RNG_JITTERENTROPY:
+		err = crypto_jent_get_bytes(ctx->pctx->jent, result, len);
+		break;
+	case RNG_DRBG:
+		err = crypto_drbg_get_bytes(ctx->pctx->drbg, result, len, addtl,
+					    addtl_len);
+		break;
+	}
+	if (err < 0)
+		return err;
 
 	err = memcpy_to_msg(msg, result, len);
 	memzero_explicit(result, len);
@@ -115,7 +126,7 @@ static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	struct alg_sock *ask = alg_sk(sk);
 	struct rng_ctx *ctx = ask->private;
 
-	return _rng_recvmsg(ctx->drng, msg, len, NULL, 0);
+	return _rng_recvmsg(ctx, msg, len, NULL, 0);
 }
 
 static int rng_test_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
@@ -127,7 +138,7 @@ static int rng_test_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	int ret;
 
 	lock_sock(sock->sk);
-	ret = _rng_recvmsg(ctx->drng, msg, len, ctx->addtl, ctx->addtl_len);
+	ret = _rng_recvmsg(ctx, msg, len, ctx->addtl, ctx->addtl_len);
 	rng_reset_addtl(ctx);
 	release_sock(sock->sk);
 
@@ -204,7 +215,6 @@ static struct proto_ops __maybe_unused algif_rng_test_ops = {
 static void *rng_bind(const char *name)
 {
 	struct rng_parent_ctx *pctx;
-	struct crypto_rng *rng;
 	int err;
 
 	err = af_alg_check_restriction(name, rng_allowlist);
@@ -215,14 +225,30 @@ static void *rng_bind(const char *name)
 	if (!pctx)
 		return ERR_PTR(-ENOMEM);
 
-	rng = crypto_alloc_rng(name, 0, AF_ALG_CRYPTOAPI_MASK);
-	if (IS_ERR(rng)) {
-		kfree(pctx);
-		return ERR_CAST(rng);
+	if (strcmp(name, "jitterentropy_rng") == 0) {
+		pctx->type = RNG_JITTERENTROPY;
+		pctx->jent = crypto_jent_alloc();
+		if (IS_ERR(pctx->jent)) {
+			err = PTR_ERR(pctx->jent);
+			goto error;
+		}
+	} else if (strcmp(name, "stdrng") == 0 ||
+		   strcmp(name, "drbg_nopr_hmac_sha512") == 0) {
+		pctx->type = RNG_DRBG;
+		pctx->drbg = crypto_drbg_alloc();
+		if (IS_ERR(pctx->drbg)) {
+			err = PTR_ERR(pctx->drbg);
+			goto error;
+		}
+	} else {
+		err = -ENOENT;
+		goto error;
 	}
-
-	pctx->drng = rng;
 	return pctx;
+
+error:
+	kfree_sensitive(pctx);
+	return ERR_PTR(err);
 }
 
 static void rng_release(void *private)
@@ -231,7 +257,14 @@ static void rng_release(void *private)
 
 	if (unlikely(!pctx))
 		return;
-	crypto_free_rng(pctx->drng);
+	switch (pctx->type) {
+	case RNG_JITTERENTROPY:
+		crypto_jent_free(pctx->jent);
+		break;
+	case RNG_DRBG:
+		crypto_drbg_free(pctx->drbg);
+		break;
+	}
 	kfree_sensitive(pctx->entropy);
 	kfree_sensitive(pctx);
 }
@@ -266,7 +299,7 @@ static int rng_accept_parent(void *private, struct sock *sk)
 	 * state of the RNG.
 	 */
 
-	ctx->drng = pctx->drng;
+	ctx->pctx = pctx;
 	ask->private = ctx;
 	sk->sk_destruct = rng_sock_destruct;
 
@@ -283,11 +316,10 @@ static int rng_accept_parent(void *private, struct sock *sk)
 static int rng_setkey(void *private, const u8 *seed, unsigned int seedlen)
 {
 	struct rng_parent_ctx *pctx = private;
-	/*
-	 * Check whether seedlen is of sufficient size is done in RNG
-	 * implementations.
-	 */
-	return crypto_rng_reset(pctx->drng, seed, seedlen);
+
+	if (pctx->type != RNG_DRBG)
+		return 0;
+	return crypto_drbg_seed(pctx->drbg, seed, seedlen);
 }
 
 static int __maybe_unused rng_setentropy(void *private, sockptr_t entropy,
@@ -299,7 +331,7 @@ static int __maybe_unused rng_setentropy(void *private, sockptr_t entropy,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (pctx->entropy)
+	if (pctx->entropy || pctx->type != RNG_DRBG)
 		return -EINVAL;
 
 	if (len > MAXSIZE)
@@ -311,9 +343,9 @@ static int __maybe_unused rng_setentropy(void *private, sockptr_t entropy,
 			return PTR_ERR(kentropy);
 	}
 
-	crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
+	crypto_drbg_set_entropy(pctx->drbg, kentropy, len);
 	/*
-	 * Since rng doesn't perform any memory management for the entropy
+	 * Since drbg doesn't perform any memory management for the entropy
 	 * buffer, save kentropy pointer to pctx now to free it after use.
 	 */
 	pctx->entropy = kentropy;
@@ -346,3 +378,4 @@ static void __exit rng_exit(void)
 
 module_init(rng_init);
 module_exit(rng_exit);
+MODULE_IMPORT_NS("CRYPTO_INTERNAL"); /* for drbg and jitterentropy */
-- 
2.56.0

