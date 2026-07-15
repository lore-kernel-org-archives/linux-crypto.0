Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6373D3D3CFD;
	Wed, 15 Jul 2026 22:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153568; cv=none; b=L2zOVu1W0Mb8IcS+0U7gXL1NH8hW5mXpQTgselqNu8LSoLnhho3xZZADV5GNt0alIQCOVXBvxciWYH72mIc2EsuJAd6heT335Uktk5Oo30ohATyHGcdrrfSAAlJqfy0xC6z2c5X0TxDo/zHUWPX9hkZmgrAEuDHB+sgwm9HH3hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153568; c=relaxed/simple;
	bh=LXRYEjEzCMaqVvQ4aQujapjQiDkKpoeTjbjaY8NFUBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUYH2qqi1G9cPKOwVx/oIubZZeU3v16Wkt13ore9UFB3nri2WLjw6b2LpUZU05Nyk+ueJhCrfM+C5sx4YPS5GuxUxMQl5IPUhCmzEIAwzMQHNcpyQYCrfFJexLDMWWM+Q+YA08mtkrr1KzU09k9O/03z7RHS1brq8Y5/DQ4dAnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=emgVijv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="emgVijv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53C31F00ADB;
	Wed, 15 Jul 2026 22:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153566;
	bh=lDP4bJTGEiLkb+s3fAkSj4o0g5a8olZiVFLBdfwFwQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emgVijv+lG4GjOk8aghzyjzivsazFcML4TZsAymItywM0kkbK21o27QD7YUrJzMqh
	 axruznZo+f56+c7j5n8YvYdwWbQxPqK/5Z0hyO/h4eYqquHc8u9/6E8kqn9nZBD+Cg
	 GZVO98tSz4ciEVa3auGum60788A5ucdbqlfdU2UARdamkRA9K2N/EUid0LxgOcOBKn
	 c1HPGyXP03QgjYGUhM6N8IdxxRwKJ/aFWnfHm6vWOOBolWRmAaLRiEQv6n0xYuppx0
	 nvbcjFkL04VGOgVMsb9q/S7oDseMIEsf0PlI6bAuXubrGXcvG2jdbMWw3NNuHqNo7a
	 Asa1N4xqI6MqQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 13/13] crypto: aes - Add CCM support using library
Date: Wed, 15 Jul 2026 15:11:53 -0700
Message-ID: <20260715221153.246410-14-ebiggers@kernel.org>
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
 crypto/aes.c   | 129 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index bbd314c07fd7..981d5dc422d4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -360,11 +360,12 @@ config CRYPTO_AES
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_AES_CBC if CRYPTO_CBC != n || CRYPTO_CTS != n
 	select CRYPTO_LIB_AES_CBC_MACS if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
+	select CRYPTO_LIB_AES_CCM if CRYPTO_CCM != n
 	select CRYPTO_LIB_AES_CTR if CRYPTO_CTR != n || CRYPTO_XCTR != n
 	select CRYPTO_LIB_AES_ECB if CRYPTO_ECB != n
 	select CRYPTO_LIB_AES_GCM if CRYPTO_GCM != n
 	select CRYPTO_LIB_AES_XTS if CRYPTO_XTS != n
-	select CRYPTO_AEAD if CRYPTO_GCM != n
+	select CRYPTO_AEAD if CRYPTO_GCM != n || CRYPTO_CCM != n
 	select CRYPTO_HASH if CRYPTO_CMAC != n || CRYPTO_XCBC != n || CRYPTO_CCM != n
 	# CRYPTO_SKCIPHER should be selected only if a mode that needs it is
 	# enabled, but that doesn't work due to a recursive dependency caused by
diff --git a/crypto/aes.c b/crypto/aes.c
index 9fe106c9eed2..94791f481e98 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -7,6 +7,7 @@
 
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/aes-cbc.h>
+#include <crypto/aes-ccm.h>
 #include <crypto/aes-ctr.h>
 #include <crypto/aes-ecb.h>
 #include <crypto/aes-gcm.h>
@@ -871,6 +872,113 @@ static __maybe_unused int crypto_aes_rfc4106_decrypt(struct aead_request *req)
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
+static int crypto_aes_ccm_init(struct aes_ccm_ctx *ctx,
+			       struct aead_request *req, unsigned int data_len,
+			       const struct aes_ccm_key *key)
+{
+	int nonce_len;
+	const u8 *nonce;
+	int err;
+
+	/*
+	 * CCM accepts a variable-length nonce between 7 and 13 bytes
+	 * inclusively, while crypto_aead assumes a fixed-length IV.  This is
+	 * worked around by requiring that iv[0] contain '14 - nonce_len' and
+	 * iv[1..] contain the actual nonce.  Extra bytes at the end are unused.
+	 */
+	nonce_len = 14 - (int)req->iv[0];
+	if (unlikely(nonce_len < 7 || nonce_len > 13))
+		return -EINVAL;
+	nonce = &req->iv[1];
+	err = aes_ccm_init(ctx, data_len, req->assoclen, nonce, nonce_len, key);
+	if (unlikely(err))
+		return err;
+	AES_PROCESS_ASSOC_DATA(aes_ccm_auth_update, req->src, req->assoclen,
+			       ctx);
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
+static __maybe_unused int crypto_aes_ccm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	const struct aes_ccm_key *key = crypto_aead_ctx(tfm);
+	struct aes_ccm_ctx ctx;
+	u8 authtag[16];
+	int err;
+
+	err = crypto_aes_ccm_init(&ctx, req, req->cryptlen, key);
+	if (unlikely(err))
+		return err;
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
+	unsigned int data_len;
+	struct aes_ccm_ctx ctx;
+	u8 authtag[16];
+	int err;
+
+	/* crypto_aead_decrypt() already checked cryptlen >= authtag_len. */
+	data_len = req->cryptlen - key->authtag_len;
+	err = crypto_aes_ccm_init(&ctx, req, data_len, key);
+	if (unlikely(err))
+		return err;
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
@@ -904,6 +1012,23 @@ static struct aead_alg aead_algs[] = {
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
@@ -1006,3 +1131,7 @@ MODULE_ALIAS_CRYPTO("gcm-aes-lib");
 MODULE_ALIAS_CRYPTO("rfc4106(gcm(aes))");
 MODULE_ALIAS_CRYPTO("rfc4106-gcm-aes-lib");
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_CCM)
+MODULE_ALIAS_CRYPTO("ccm(aes)");
+MODULE_ALIAS_CRYPTO("ccm-aes-lib");
+#endif
-- 
2.55.0

