Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936823D565C;
	Wed, 15 Jul 2026 22:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153567; cv=none; b=O/olFGVOir31+BzRPV+IbgjYu7i/gr4W1rsiooUeML8XQqko0aFGSgDxyfZIgHJLzCA4X0NKDt6NQdstRrbJKzaN8yFl+9SBHMgaBW3RF1uR4+cnSATm9USqVSL3CEKazX4KxM5R0xT2uswaT/XZOkYYotPObi1fsVztgW/0vj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153567; c=relaxed/simple;
	bh=vcGKxXmkS6XVthF37CKhxW3nqxFgjm/e5+nXfHGT4EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYKhtir2PKb0hOA3jDEzpweqOBlgR6vtAxmVchBDbbasf6uigTO1lisxxd/fHIdEMDtw7D40YhGp94Z1pbtWhhM0k0zHvpo1jSgHJ6SM1viNBRXQVexRuHfU4810ub/qKX3P/IzjPjImNBxF2C+jJlMlP+WlY50EYTv15KJzatY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imBYCprs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imBYCprs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1CC1F00A3E;
	Wed, 15 Jul 2026 22:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153565;
	bh=XeOTaAPmNI8eOCg7n0Yrq+hUMtt5GyeW653IENyPOdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=imBYCprsRhyZms9JtAU+tcapzOBJ7GFKqHxV4yyHi+l608hREChmOp5ZcJbkgITuO
	 0NyaiOOXIrNPloSYY4KdYGtmvzLzKriCKnhhhYjAH9YmUKFzY4+gSelf2VfBoAWvJD
	 sY9VA47fxTEW8ZpRG4IbWsWYKarXmuODVJrkvCfj2A2UlNk3XYAMi5miTCLFEYHaRO
	 zsbUUhCSOsPLsP6ANaEUj8HKr0/dU2gKRW4Msmw2CTMUd0EFnstlL7sPkYKvej4U8S
	 HXS+u3DYAryO/Ht+97V/G7lXFbuw8GZVT9RvwqITcFwdx7tuwdt7RQBlexO3W+Q65K
	 XMtbnJ7cXtMgA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 11/13] crypto: aes - Add XTS support using library
Date: Wed, 15 Jul 2026 15:11:51 -0700
Message-ID: <20260715221153.246410-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260715221153.246410-1-ebiggers@kernel.org>
References: <20260715221153.246410-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the "xts(aes)" crypto_skcipher algorithm using the
corresponding library functions.

Among other benefits, this allows the architecture-optimized AES-XTS
code to be migrated into the library while still leaving it accessible
via crypto_skcipher, eliminating lots of boilerplate code.

Fast paths similar to what x86_64 uses (to eliminate the scatterlist
walking overhead) are included.  So we'll get that optimization for all
architectures.

For now the cra_priority is set to just 110, since the
architecture-optimized implementations of this algorithm haven't yet
been migrated into the library.  It will be boosted once that happens.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig |   1 +
 crypto/aes.c   | 117 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5a198275e4fc..567b719c8a44 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -362,6 +362,7 @@ config CRYPTO_AES
 	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
 	select CRYPTO_LIB_AES_CTR if CRYPTO_CTR != n || CRYPTO_XCTR != n
 	select CRYPTO_LIB_AES_ECB if CRYPTO_ECB != n
+	select CRYPTO_LIB_AES_XTS if CRYPTO_XTS != n
 	select CRYPTO_HASH if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
 	# CRYPTO_SKCIPHER should be selected only if a mode that needs it is
 	# enabled, but that doesn't work due to a recursive dependency caused by
diff --git a/crypto/aes.c b/crypto/aes.c
index 6b298e788630..eb22840a68f0 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -9,6 +9,7 @@
 #include <crypto/aes-cbc.h>
 #include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
+#include <crypto/aes-xts.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
@@ -482,6 +483,102 @@ static __maybe_unused int crypto_aes_xctr_crypt(struct skcipher_request *req)
 	return 0;
 }
 
+/* AES-XTS */
+
+static __maybe_unused int crypto_aes_xts_setkey(struct crypto_skcipher *tfm,
+						const u8 *in_key,
+						unsigned int key_len)
+{
+	struct aes_xts_key *key = crypto_skcipher_ctx(tfm);
+	int flags = (crypto_skcipher_get_flags(tfm) &
+		     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) ?
+			    XTS_FORBID_WEAK_KEYS :
+			    0;
+
+	return aes_xts_preparekey(key, in_key, key_len, flags);
+}
+
+static void aes_xts_crypt_wrapper(u8 *dst, const u8 *src, size_t len,
+				  u8 iv[AES_BLOCK_SIZE],
+				  const struct aes_xts_key *key, bool enc,
+				  bool *cont)
+{
+	if (enc)
+		aes_xts_encrypt(dst, src, len, iv, key, *cont);
+	else
+		aes_xts_decrypt(dst, src, len, iv, key, *cont);
+	*cont = true;
+}
+
+/*
+ * This handles AES-XTS en/decryption requests that use a nonlinear scatterlist
+ * layout or where HIGHMEM is enabled.  It is explicitly 'noinline' to keep the
+ * temporary buffer out of the stack frame of the fast path.
+ */
+static noinline int crypto_aes_xts_crypt_nonlinear(struct skcipher_request *req,
+						   bool enc)
+{
+	const struct aes_xts_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	u8 tmp[2 * AES_BLOCK_SIZE] __aligned(__alignof__(long));
+	unsigned int main_len = req->cryptlen;
+	unsigned int tail_len = main_len % AES_BLOCK_SIZE;
+	bool cont = false;
+
+	if (unlikely(tail_len)) {
+		/*
+		 * Ciphertext stealing is needed.
+		 * Just do the last two blocks separately.
+		 */
+		tail_len += AES_BLOCK_SIZE;
+		main_len -= tail_len;
+	}
+
+	AES_CRYPT_SG(aes_xts_crypt_wrapper, req->dst, req->src, main_len, 0,
+		     req->iv, key, enc, &cont);
+
+	if (unlikely(tail_len)) {
+		memcpy_from_sglist(tmp, req->src, main_len, tail_len);
+		aes_xts_crypt_wrapper(tmp, tmp, tail_len, req->iv, key, enc,
+				      &cont);
+		memcpy_to_sglist(req->dst, main_len, tmp, tail_len);
+		memzero_explicit(tmp, sizeof(tmp));
+	}
+	return 0;
+}
+
+static __maybe_unused int crypto_aes_xts_encrypt(struct skcipher_request *req)
+{
+	const struct aes_xts_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen < AES_BLOCK_SIZE))
+		return -EINVAL;
+	if (likely(skcipher_request_is_linear_lowmem(req))) {
+		/* Fast path */
+		aes_xts_encrypt(sg_virt(req->dst), sg_virt(req->src),
+				req->cryptlen, req->iv, key, /* cont= */ false);
+		return 0;
+	}
+	return crypto_aes_xts_crypt_nonlinear(req, /* enc= */ true);
+}
+
+static __maybe_unused int crypto_aes_xts_decrypt(struct skcipher_request *req)
+{
+	const struct aes_xts_key *key =
+		crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+
+	if (unlikely(req->cryptlen < AES_BLOCK_SIZE))
+		return -EINVAL;
+	if (likely(skcipher_request_is_linear_lowmem(req))) {
+		/* Fast path */
+		aes_xts_decrypt(sg_virt(req->dst), sg_virt(req->src),
+				req->cryptlen, req->iv, key, /* cont= */ false);
+		return 0;
+	}
+	return crypto_aes_xts_crypt_nonlinear(req, /* enc= */ false);
+}
+
 static struct skcipher_alg skcipher_algs[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_ECB)
 	{
@@ -564,6 +661,22 @@ static struct skcipher_alg skcipher_algs[] = {
 		.decrypt = crypto_aes_xctr_crypt,
 	},
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_XTS)
+	{
+		.base.cra_name = "xts(aes)",
+		.base.cra_driver_name = "xts-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = AES_BLOCK_SIZE,
+		.base.cra_ctxsize = sizeof(struct aes_xts_key),
+		.base.cra_module = THIS_MODULE,
+		.min_keysize = 2 * AES_MIN_KEY_SIZE,
+		.max_keysize = 2 * AES_MAX_KEY_SIZE,
+		.ivsize = AES_BLOCK_SIZE,
+		.setkey = crypto_aes_xts_setkey,
+		.encrypt = crypto_aes_xts_encrypt,
+		.decrypt = crypto_aes_xts_decrypt,
+	},
+#endif
 };
 
 static int __init crypto_aes_mod_init(void)
@@ -644,3 +757,7 @@ MODULE_ALIAS_CRYPTO("ctr-aes-lib");
 MODULE_ALIAS_CRYPTO("xctr(aes)");
 MODULE_ALIAS_CRYPTO("xctr-aes-lib");
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_XTS)
+MODULE_ALIAS_CRYPTO("xts(aes)");
+MODULE_ALIAS_CRYPTO("xts-aes-lib");
+#endif
-- 
2.55.0

