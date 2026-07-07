Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C756138642C;
	Tue,  7 Jul 2026 05:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402641; cv=none; b=EW8oZC6jbmix6diaK+Qb9xfrxAQfdFj4pZe0N0ueGnlKmVD0BTt/bBvLlCN1Hg6hqxwHxl+2mDEz0udGrnDKMzAt+PVBvcat/McAxixc/a+sUu7BhrUk48fioPh0hiifavWEeAusoM5oc99Sp7XOttPpO5ZobtOF5kvtGDuSDCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402641; c=relaxed/simple;
	bh=14Gk1sWQHzExmI0twHkO6rnnxHPtVIhWOmuvXiC4fwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwdhuHbO9stKrwr0j2iPrSKPfsMNCt46LZVccya6FK2IDZDYk+J1cgD3VoydbHuezb0NkjAe5DWBzexs3QxStU3T7s4Xf0ruXn9YOwpKruiumKluUCAM850dfHxabpChq5kzwNypx31xxufdQ9bUUt2A/OfkhOANeDbTp9792mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKHLRvr1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKHLRvr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F611F00A3A;
	Tue,  7 Jul 2026 05:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402639;
	bh=X2M+RyFDqCUA2n98mox1bOgzcCubo3CplXYD0iNG9P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKHLRvr1IVuoFjBwcGM3+9s+RhpNqclJ/M9auawTnI7pvyDAn5GgPC0f61aJqprh+
	 gEBFjh3vGmQLX10Aedij2IGik+uw5MRf9cuX3x44xK3FipQ0i97NkguBoJb0Gpz/QA
	 yiHCCyR9n8Iq9Z1iC74UHqa8QOsI8W/VOMNk11Nzn4QLGzd5yJmAazcuGmZF4cQNEN
	 E6VlFgTUirixod3AXCz7di4PYPq0YA58gSWL/PB6NElGXpZm6Mgz2XORx9YlMiRz0w
	 HqcNyfH7A5YFBoM7LosNA9jC2eNw9HjaNpxi8Qoo8DQx2ZZaXkNLjO16O4jUevYLzF
	 penHKFgXWua9g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 12/33] crypto: aes - Add GCM support using library
Date: Mon,  6 Jul 2026 22:34:42 -0700
Message-ID: <20260707053503.209874-13-ebiggers@kernel.org>
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

Implement the "gcm(aes)" and "rfc4106(gcm(aes))" crypto_aead algorithms
using the corresponding library functions.

Among other benefits, this allows the architecture-optimized AES-GCM
code to be migrated into the library while still leaving it accessible
via crypto_aead, eliminating lots of boilerplate code.

For now the cra_priority is set to just 110, since the
architecture-optimized implementations of these algorithms haven't yet
been migrated into the library.  It will be boosted once that happens.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig |   2 +
 crypto/aes.c   | 237 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 239 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5e573051c903..74dfe969216d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -362,7 +362,9 @@ config CRYPTO_AES
 	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
 	select CRYPTO_LIB_AES_CTR if CRYPTO_CTR || CRYPTO_XCTR
 	select CRYPTO_LIB_AES_ECB if CRYPTO_ECB
+	select CRYPTO_LIB_AES_GCM if CRYPTO_GCM
 	select CRYPTO_LIB_AES_XTS if CRYPTO_XTS
+	select CRYPTO_AEAD if CRYPTO_GCM
 	select CRYPTO_HASH if CRYPTO_CMAC || CRYPTO_XCBC || CRYPTO_CCM
 	# CRYPTO_SKCIPHER should be selected only if a mode that needs it is
 	# enabled, but that doesn't work due to a recursive dependency caused by
diff --git a/crypto/aes.c b/crypto/aes.c
index a59eb57c86de..621ceed3d587 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -9,9 +9,11 @@
 #include <crypto/aes-cbc.h>
 #include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
+#include <crypto/aes-gcm.h>
 #include <crypto/aes-xts.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
+#include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
@@ -305,6 +307,29 @@ crypto_aes_skcipher_setenckey(struct crypto_skcipher *tfm, const u8 *in_key,
 		}                                                              \
 	})
 
+/*
+ * Call ad_func() as needed to process the associated data in the first
+ * 'assoclen' bytes of the scatterlist 'src'.
+ */
+#define AES_PROCESS_ASSOC_DATA(ad_func, src, assoclen, ctx)                 \
+	({                                                                  \
+		unsigned int remaining = (assoclen);                        \
+                                                                            \
+		if (remaining != 0) {                                       \
+			struct scatter_walk walk;                           \
+                                                                            \
+			scatterwalk_start(&walk, (src));                    \
+			do {                                                \
+				unsigned int n =                            \
+					scatterwalk_next(&walk, remaining); \
+                                                                            \
+				ad_func((ctx), walk.addr, n);               \
+				scatterwalk_done_src(&walk, n);             \
+				remaining -= n;                             \
+			} while (remaining);                                \
+		}                                                           \
+	})
+
 /* AES-ECB */
 
 static __maybe_unused int crypto_aes_ecb_encrypt(struct skcipher_request *req)
@@ -677,6 +702,200 @@ static struct skcipher_alg skcipher_algs[] = {
 #endif
 };
 
+/* AES-GCM */
+
+static __maybe_unused int crypto_aes_gcm_setkey(struct crypto_aead *tfm,
+						const u8 *in_key,
+						unsigned int key_len)
+{
+	struct aes_gcm_key *key = crypto_aead_ctx(tfm);
+
+	return aes_gcm_preparekey(key, in_key, key_len,
+				  crypto_aead_authsize(tfm));
+}
+
+static __maybe_unused int crypto_aes_gcm_setauthsize(struct crypto_aead *tfm,
+						     unsigned int authsize)
+{
+	struct aes_gcm_key *key = crypto_aead_ctx(tfm);
+
+	if (crypto_gcm_check_authsize(authsize) != 0)
+		return -EINVAL;
+	/* Synchronize the tag length to the struct aes_gcm_key. */
+	key->authtag_len = authsize;
+	return 0;
+}
+
+static void aes_gcm_encrypt_update_helper(u8 *dst, const u8 *src,
+					  unsigned int len,
+					  struct aes_gcm_ctx *ctx)
+{
+	aes_gcm_encrypt_update(ctx, dst, src, len);
+}
+
+static void aes_gcm_decrypt_update_helper(u8 *dst, const u8 *src,
+					  unsigned int len,
+					  struct aes_gcm_ctx *ctx)
+{
+	aes_gcm_decrypt_update(ctx, dst, src, len);
+}
+
+static int crypto_aes_gcm_encrypt_common(struct aead_request *req,
+					 const struct aes_gcm_key *key,
+					 u8 iv[12], unsigned int assoclen)
+{
+	struct aes_gcm_ctx ctx;
+	u8 authtag[16];
+
+	aes_gcm_init(&ctx, iv, key);
+	AES_PROCESS_ASSOC_DATA(aes_gcm_auth_update, req->src, assoclen, &ctx);
+	AES_CRYPT_SG(aes_gcm_encrypt_update_helper, req->dst, req->src,
+		     req->cryptlen, req->assoclen, &ctx);
+	aes_gcm_encrypt_final(&ctx, authtag);
+	memcpy_to_sglist(req->dst, req->assoclen + req->cryptlen, authtag,
+			 key->authtag_len);
+	memzero_explicit(authtag, sizeof(authtag));
+	return 0;
+}
+
+static int crypto_aes_gcm_decrypt_common(struct aead_request *req,
+					 const struct aes_gcm_key *key,
+					 u8 iv[12], unsigned int assoclen)
+{
+	struct aes_gcm_ctx ctx;
+	unsigned int data_len;
+	u8 authtag[16];
+	int err;
+
+	/* crypto_aead_decrypt() already checked cryptlen >= authsize. */
+	data_len = req->cryptlen - key->authtag_len;
+
+	aes_gcm_init(&ctx, iv, key);
+	AES_PROCESS_ASSOC_DATA(aes_gcm_auth_update, req->src, assoclen, &ctx);
+	AES_CRYPT_SG(aes_gcm_decrypt_update_helper, req->dst, req->src,
+		     data_len, req->assoclen, &ctx);
+	memcpy_from_sglist(authtag, req->src, req->assoclen + data_len,
+			   key->authtag_len);
+	err = aes_gcm_decrypt_final(&ctx, authtag);
+	memzero_explicit(authtag, sizeof(authtag));
+	return err;
+}
+
+static __maybe_unused int crypto_aes_gcm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aes_gcm_key *key = crypto_aead_ctx(tfm);
+
+	return crypto_aes_gcm_encrypt_common(req, key, req->iv, req->assoclen);
+}
+
+static __maybe_unused int crypto_aes_gcm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aes_gcm_key *key = crypto_aead_ctx(tfm);
+
+	return crypto_aes_gcm_decrypt_common(req, key, req->iv, req->assoclen);
+}
+
+struct aes_rfc4106_key {
+	struct aes_gcm_key gcm;
+	u8 nonce[4];
+};
+
+static __maybe_unused int crypto_aes_rfc4106_setkey(struct crypto_aead *tfm,
+						    const u8 *in_key,
+						    unsigned int key_len)
+{
+	struct aes_rfc4106_key *key = crypto_aead_ctx(tfm);
+
+	if (key_len < 4)
+		return -EINVAL;
+
+	key_len -= 4;
+	memcpy(key->nonce, in_key + key_len, 4);
+
+	return aes_gcm_preparekey(&key->gcm, in_key, key_len,
+				  crypto_aead_authsize(tfm));
+}
+
+static __maybe_unused int
+crypto_aes_rfc4106_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	struct aes_rfc4106_key *key = crypto_aead_ctx(tfm);
+
+	if (crypto_rfc4106_check_authsize(authsize) != 0)
+		return -EINVAL;
+
+	/* Synchronize the tag length to the struct aes_gcm_key. */
+	key->gcm.authtag_len = authsize;
+	return 0;
+}
+
+static __maybe_unused int crypto_aes_rfc4106_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aes_rfc4106_key *key = crypto_aead_ctx(tfm);
+	u8 iv[12];
+
+	if (crypto_ipsec_check_assoclen(req->assoclen) != 0)
+		return -EINVAL;
+	memcpy(iv, key->nonce, 4);
+	memcpy(&iv[4], req->iv, 8);
+
+	return crypto_aes_gcm_encrypt_common(req, &key->gcm, iv,
+					     req->assoclen - 8);
+}
+
+static __maybe_unused int crypto_aes_rfc4106_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aes_rfc4106_key *key = crypto_aead_ctx(tfm);
+	u8 iv[12];
+
+	if (crypto_ipsec_check_assoclen(req->assoclen) != 0)
+		return -EINVAL;
+	memcpy(iv, key->nonce, 4);
+	memcpy(&iv[4], req->iv, 8);
+
+	return crypto_aes_gcm_decrypt_common(req, &key->gcm, iv,
+					     req->assoclen - 8);
+}
+
+static struct aead_alg aead_algs[] = {
+#if IS_ENABLED(CONFIG_CRYPTO_GCM)
+	{
+		.base.cra_name = "gcm(aes)",
+		.base.cra_driver_name = "gcm-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = 1,
+		.base.cra_ctxsize = sizeof(struct aes_gcm_key),
+		.base.cra_module = THIS_MODULE,
+		.setkey = crypto_aes_gcm_setkey,
+		.setauthsize = crypto_aes_gcm_setauthsize,
+		.encrypt = crypto_aes_gcm_encrypt,
+		.decrypt = crypto_aes_gcm_decrypt,
+		.ivsize = GCM_AES_IV_SIZE,
+		.maxauthsize = AES_BLOCK_SIZE,
+		.chunksize = AES_BLOCK_SIZE,
+	},
+	{
+		.base.cra_name = "rfc4106(gcm(aes))",
+		.base.cra_driver_name = "rfc4106-gcm-aes-lib",
+		.base.cra_priority = 110,
+		.base.cra_blocksize = 1,
+		.base.cra_ctxsize = sizeof(struct aes_rfc4106_key),
+		.base.cra_module = THIS_MODULE,
+		.setkey = crypto_aes_rfc4106_setkey,
+		.setauthsize = crypto_aes_rfc4106_setauthsize,
+		.encrypt = crypto_aes_rfc4106_encrypt,
+		.decrypt = crypto_aes_rfc4106_decrypt,
+		.ivsize = GCM_RFC4106_IV_SIZE,
+		.maxauthsize = AES_BLOCK_SIZE,
+		.chunksize = AES_BLOCK_SIZE,
+	},
+#endif /* CONFIG_CRYPTO_GCM */
+};
+
 static int __init crypto_aes_mod_init(void)
 {
 	int err = crypto_register_alg(&alg);
@@ -696,8 +915,18 @@ static int __init crypto_aes_mod_init(void)
 		if (err)
 			goto err_unregister_macs;
 	}
+
+	if (ARRAY_SIZE(aead_algs) > 0) {
+		err = crypto_register_aeads(aead_algs, ARRAY_SIZE(aead_algs));
+		if (err)
+			goto err_unregister_skciphers;
+	} /* Else, CONFIG_CRYPTO_AEAD might not be enabled. */
 	return 0;
 
+err_unregister_skciphers:
+	if (ARRAY_SIZE(skcipher_algs) > 0)
+		crypto_unregister_skciphers(skcipher_algs,
+					    ARRAY_SIZE(skcipher_algs));
 err_unregister_macs:
 	if (ARRAY_SIZE(mac_algs) > 0)
 		crypto_unregister_shashes(mac_algs, ARRAY_SIZE(mac_algs));
@@ -709,6 +938,8 @@ module_init(crypto_aes_mod_init);
 
 static void __exit crypto_aes_mod_exit(void)
 {
+	if (ARRAY_SIZE(aead_algs) > 0)
+		crypto_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
 	if (ARRAY_SIZE(skcipher_algs) > 0)
 		crypto_unregister_skciphers(skcipher_algs,
 					    ARRAY_SIZE(skcipher_algs));
@@ -759,3 +990,9 @@ MODULE_ALIAS_CRYPTO("xctr-aes-lib");
 MODULE_ALIAS_CRYPTO("xts(aes)");
 MODULE_ALIAS_CRYPTO("xts-aes-lib");
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_GCM)
+MODULE_ALIAS_CRYPTO("gcm(aes)");
+MODULE_ALIAS_CRYPTO("gcm-aes-lib");
+MODULE_ALIAS_CRYPTO("rfc4106(gcm(aes))");
+MODULE_ALIAS_CRYPTO("rfc4106-gcm-aes-lib");
+#endif
-- 
2.54.0

