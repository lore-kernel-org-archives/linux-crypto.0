Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E6D386566;
	Tue,  7 Jul 2026 05:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402641; cv=none; b=PMLamiiuqoG2k3/ipHtvS6Ry3rXUcE97BoOs09BOFfSne9H6Vhow8Kqspnav7Vc6De6wSRp6kcTudFuXKDoOLKAc3j4gEhX0azLAbjKQJss8sTi9yKP5nw0jXOA9X+KKucu/tQHr2JJA/9+IshHpLtYHHDEuOSbnhlVK5V7Aoh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402641; c=relaxed/simple;
	bh=3idooVUCpOfF8MGF2lFYw/ZKmOwhbHb53B2ZDW3DBS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eulcwMTBC5giTWMFEw3+72L4ityM1VM1socT7/UsGCmQClBh58PF/8L9lYBv92TXBWs0JTLgg4Ttw7F9A7j33iVpHwRijVh1DXuceChW1JpZZd6OWZUctB8yfexANW9HJZ4CSlkSNmDvxqZMkniaYirrpBA625pKD/X7Jmyclao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9dt/VBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9dt/VBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B021D1F00AC4;
	Tue,  7 Jul 2026 05:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402639;
	bh=EuYQXEpkWtlXYRPUu98zordFTYnkO5UG3gNDEIwTAzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9dt/VBJTEdlZ3m4vyAgE4p821yQb2X52kiTF7lgY0qVkapIhjTHm4Igde+7J/TUL
	 bv/U7CoLcloFGKYT4haD2VrpgCx6Y95KpQi48YeMvI/diQgJPJirJLSvzXDpwmV4cY
	 6v0qkTTLPBtzXaj57cKZmYFPBnmnZjKDnweJCKJi+7sypaI3mLp2KESvq9G01xcAnE
	 roR+T3oiXEUaph7mYzGeBaw7MQ09Z4S2m6EOs8IEMwloFrJAL6ol6oUAXKr3FhN65n
	 WaKdXKCF2/p2CIm/IetNdfvBbR20nlGbIQHNC+x2wWOfDMgUe51V0AxhIbgZ0WuRPA
	 DSIMSLoZQjRLg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 13/33] crypto: aes - Add CCM support using library
Date: Mon,  6 Jul 2026 22:34:43 -0700
Message-ID: <20260707053503.209874-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the "ccm(aes)" crypto_aead algorithm using the corresponding
library functions.

Among other benefits, this allows the architecture-optimized AES-CCM
code to be migrated into the library while still leaving it accessible
via crypto_aead, eliminating lots of boilerplate code.

For now the cra_priority is set to just 110, since the
architecture-optimized implementations of this algorithm haven't yet
been migrated into the library.  It will be boosted once that happens.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig |   3 +-
 crypto/aes.c   | 138 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 74dfe969216d..e6b894dc784a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -360,11 +360,12 @@ config CRYPTO_AES
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_AES_CBC if CRYPTO_CBC || CRYPTO_CTS
 	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
+	select CRYPTO_LIB_AES_CCM if CRYPTO_CCM
 	select CRYPTO_LIB_AES_CTR if CRYPTO_CTR || CRYPTO_XCTR
 	select CRYPTO_LIB_AES_ECB if CRYPTO_ECB
 	select CRYPTO_LIB_AES_GCM if CRYPTO_GCM
 	select CRYPTO_LIB_AES_XTS if CRYPTO_XTS
-	select CRYPTO_AEAD if CRYPTO_GCM
+	select CRYPTO_AEAD if CRYPTO_GCM || CRYPTO_CCM
 	select CRYPTO_HASH if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
 	# CRYPTO_SKCIPHER should be selected only if a mode that needs it is
 	# enabled, but that doesn't work due to a recursive dependency caused by
diff --git a/crypto/aes.c b/crypto/aes.c
index 621ceed3d587..ac5190292b3c 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -7,6 +7,7 @@
 
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/aes-cbc.h>
+#include <crypto/aes-ccm.h>
 #include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
 #include <crypto/aes-gcm.h>
@@ -861,6 +862,122 @@ static __maybe_unused int crypto_aes_rfc4106_decrypt(struct aead_request *req)
 					     req->assoclen - 8);
 }
 
+/* AES-CCM */
+
+static __maybe_unused int crypto_aes_ccm_setkey(struct crypto_aead *tfm,
+						const u8 *in_key,
+						unsigned int key_len)
+{
+	struct aes_ccm_key *key = crypto_aead_ctx(tfm);
+
+	return aes_ccm_preparekey(key, in_key, key_len,
+				  crypto_aead_authsize(tfm));
+}
+
+static __maybe_unused int crypto_aes_ccm_setauthsize(struct crypto_aead *tfm,
+						     unsigned int authsize)
+{
+	struct aes_ccm_key *key = crypto_aead_ctx(tfm);
+
+	if (authsize < 4 || authsize > 16 || authsize % 2)
+		return -EINVAL;
+	/* Synchronize the tag length to the struct aes_ccm_key. */
+	key->authtag_len = authsize;
+	return 0;
+}
+
+static void aes_ccm_encrypt_update_helper(u8 *dst, const u8 *src,
+					  unsigned int len,
+					  struct aes_ccm_ctx *ctx)
+{
+	aes_ccm_encrypt_update(ctx, dst, src, len);
+}
+
+static void aes_ccm_decrypt_update_helper(u8 *dst, const u8 *src,
+					  unsigned int len,
+					  struct aes_ccm_ctx *ctx)
+{
+	aes_ccm_decrypt_update(ctx, dst, src, len);
+}
+
+/*
+ * CCM accepts a variable-length nonce between 7 and 13 bytes inclusively, while
+ * crypto_aead assumes a fixed-length nonce.  This is worked around by storing
+ * '14 - nonce_len' in the first byte.
+ */
+static inline bool crypto_aes_ccm_extract_nonce(struct aead_request *req,
+						const u8 **nonce_ret,
+						size_t *nonce_len_ret)
+{
+	int nonce_len = 14 - req->iv[0];
+
+	if (unlikely(nonce_len < 7 || nonce_len > 13))
+		return false;
+	*nonce_ret = &req->iv[1];
+	*nonce_len_ret = nonce_len;
+	return true;
+}
+
+static __maybe_unused int crypto_aes_ccm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aes_ccm_key *key = crypto_aead_ctx(tfm);
+	struct aes_ccm_ctx ctx;
+	const u8 *nonce;
+	size_t nonce_len;
+	u8 authtag[16];
+	int err;
+
+	if (!crypto_aes_ccm_extract_nonce(req, &nonce, &nonce_len))
+		return -EINVAL;
+
+	err = aes_ccm_init(&ctx, nonce, nonce_len, req->assoclen, req->cryptlen,
+			   key);
+	if (err)
+		return err;
+	AES_PROCESS_ASSOC_DATA(aes_ccm_auth_update, req->src, req->assoclen,
+			       &ctx);
+	AES_CRYPT_SG(aes_ccm_encrypt_update_helper, req->dst, req->src,
+		     req->cryptlen, req->assoclen, &ctx);
+	aes_ccm_encrypt_final(&ctx, authtag);
+	memcpy_to_sglist(req->dst, req->assoclen + req->cryptlen, authtag,
+			 key->authtag_len);
+	memzero_explicit(authtag, sizeof(authtag));
+	return 0;
+}
+
+static __maybe_unused int crypto_aes_ccm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aes_ccm_key *key = crypto_aead_ctx(tfm);
+	struct aes_ccm_ctx ctx;
+	const u8 *nonce;
+	size_t nonce_len;
+	unsigned int data_len;
+	u8 authtag[16];
+	int err;
+
+	if (!crypto_aes_ccm_extract_nonce(req, &nonce, &nonce_len))
+		return -EINVAL;
+
+	/* crypto_aead_decrypt() already checked cryptlen >= authsize. */
+	data_len = req->cryptlen - key->authtag_len;
+
+	err = aes_ccm_init(&ctx, nonce, nonce_len, req->assoclen, data_len,
+			   key);
+	if (err)
+		return err;
+	AES_PROCESS_ASSOC_DATA(aes_ccm_auth_update, req->src, req->assoclen,
+			       &ctx);
+	AES_CRYPT_SG(aes_ccm_decrypt_update_helper, req->dst, req->src,
+		     data_len, req->assoclen, &ctx);
+	memcpy_from_sglist(authtag, req->src, req->assoclen + data_len,
+			   key->authtag_len);
+	err = aes_ccm_decrypt_final(&ctx, authtag);
+	memzero_explicit(authtag, sizeof(authtag));
+	return err;
+}
+
 static struct aead_alg aead_algs[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_GCM)
 	{
@@ -894,6 +1011,23 @@ static struct aead_alg aead_algs[] = {
 		.chunksize = AES_BLOCK_SIZE,
 	},
 #endif /* CONFIG_CRYPTO_GCM */
+#if IS_ENABLED(CONFIG_CRYPTO_CCM)
+	{
+		.base.cra_name = "ccm(aes)",
+		.base.cra_driver_name = "ccm-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = 1,
+		.base.cra_ctxsize = sizeof(struct aes_ccm_key),
+		.base.cra_module = THIS_MODULE,
+		.setkey = crypto_aes_ccm_setkey,
+		.setauthsize = crypto_aes_ccm_setauthsize,
+		.encrypt = crypto_aes_ccm_encrypt,
+		.decrypt = crypto_aes_ccm_decrypt,
+		.ivsize = 16,
+		.maxauthsize = 16,
+		.chunksize = AES_BLOCK_SIZE,
+	},
+#endif /* CONFIG_CRYPTO_CCM */
 };
 
 static int __init crypto_aes_mod_init(void)
@@ -996,3 +1130,7 @@ MODULE_ALIAS_CRYPTO("gcm-aes-lib");
 MODULE_ALIAS_CRYPTO("rfc4106(gcm(aes))");
 MODULE_ALIAS_CRYPTO("rfc4106-gcm-aes-lib");
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_CCM)
+MODULE_ALIAS_CRYPTO("ccm(aes)");
+MODULE_ALIAS_CRYPTO("ccm-aes-lib");
+#endif
-- 
2.54.0

