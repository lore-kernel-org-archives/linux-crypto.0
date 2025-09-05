Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7472628D;
	Fri,  5 Sep 2025 03:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757041430; cv=none; b=aawS8DVLgRwfVg67Kx8ichORkkj2Nx1lC+BBqfeuKh4/0+di8Xx38HPo3cxRM27e48pv+XfstNjv0MdHz4G9wRqj36XySIJCP2sVp0e+gkcXuoKTQN2xVDHt/Ug0FAfJydM/H4ZaeaLEPPORuTTYVt2r8A9bcZr6NS56JjhTXgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757041430; c=relaxed/simple;
	bh=AjJrp8RvVHOfXJ/GebGXhT+LXhkOcwYs8UByks1Eg/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aEu4qGKaYS0THr6GNYLiGgD2tSBlFVgP853Ev4VrKjChevMU3HbrCxKIPbjdZ0ac6x0Z1m96VEMQMVIMI1kfYm4VHK1au1X9mnF8E2pNydDQHF3LxoRUpStWjWJ8CEwlYO3K4+LP6VlE/MgQGC3JEekD/B2NG1TF6M9jooiJO48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2YTisTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2YTisTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AD5C4CEF0;
	Fri,  5 Sep 2025 03:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757041429;
	bh=AjJrp8RvVHOfXJ/GebGXhT+LXhkOcwYs8UByks1Eg/0=;
	h=From:To:Cc:Subject:Date:From;
	b=o2YTisTAqEyqUJZbd4swinp8rq5Ea4t0cwp1pzF/POHKbnttNDJCZ6sjuOq6m5IZ/
	 ZbsPEBRJsp3oWn46WIo7IPHXs9fjc7HMGKJnPp90VJuFf2djvq1BpVQxqdMQSBOsLt
	 v/7zqnodX0x/cmynNGIWXDnl5apUA7/gC4Z4nAUHA3XoTav1S/LmkWH9DIDnsORcyi
	 yeV8Lje8yvuhIAte/dpGThp5BBpHk+R4Zb6lUtPlnvtEI9ttQWY6x/yzn5LatKDd30
	 B1/5F+U6PdQYK+eoyuo/hGDFlmd2Rc3uQPAJJ8uycrmv14b4VQOWz0EaMbKQd3ZDms
	 iEzhIMLX2qfpQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] crypto: qat - Use library to prepare HMAC keys
Date: Thu,  4 Sep 2025 20:01:53 -0700
Message-ID: <20250905030153.11892-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To prepare HMAC keys, just use the library functions instead of
crypto_shash.  This is much simpler, avoids depending on the fragile
export_core and import_core methods, and is faster too.

Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This is the same diff as v1, but with an updated commit message and now
targeting cryptodev/master instead of libcrypto-fixes.  Since I'm going
with
https://lore.kernel.org/r/20250901165013.48649-1-ebiggers@kernel.org/ to
fix the reported regression instead, this patch is now "just" a library
conversion and not a fix per se.  If needed I'd be glad to take this
through libcrypto-next instead, but usually these conversions have been
going through subsystem trees (which is Herbert's in this case).

 drivers/crypto/intel/qat/Kconfig              |   7 +-
 .../crypto/intel/qat/qat_common/qat_algs.c    | 191 ++++++------------
 2 files changed, 61 insertions(+), 137 deletions(-)

diff --git a/drivers/crypto/intel/qat/Kconfig b/drivers/crypto/intel/qat/Kconfig
index 359c61f0c8a13..4b4861460dd4e 100644
--- a/drivers/crypto/intel/qat/Kconfig
+++ b/drivers/crypto/intel/qat/Kconfig
@@ -4,16 +4,15 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AKCIPHER
 	select CRYPTO_DH
-	select CRYPTO_HMAC
 	select CRYPTO_RSA
-	select CRYPTO_SHA1
-	select CRYPTO_SHA256
-	select CRYPTO_SHA512
 	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_SHA1
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
 	select FW_LOADER
 	select CRC8
 
 config CRYPTO_DEV_QAT_DH895xCC
 	tristate "Support for Intel(R) DH895xCC"
diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs.c b/drivers/crypto/intel/qat/qat_common/qat_algs.c
index 43e6dd9b77b7d..7f638a62e3ade 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs.c
@@ -3,16 +3,14 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/crypto.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/cipher.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
-#include <crypto/hmac.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/xts.h>
 #include <linux/dma-mapping.h>
@@ -66,20 +64,14 @@ struct qat_alg_aead_ctx {
 	struct qat_alg_cd *dec_cd;
 	dma_addr_t enc_cd_paddr;
 	dma_addr_t dec_cd_paddr;
 	struct icp_qat_fw_la_bulk_req enc_fw_req;
 	struct icp_qat_fw_la_bulk_req dec_fw_req;
-	struct crypto_shash *hash_tfm;
 	enum icp_qat_hw_auth_algo qat_hash_alg;
+	unsigned int hash_digestsize;
+	unsigned int hash_blocksize;
 	struct qat_crypto_instance *inst;
-	union {
-		struct sha1_state sha1;
-		struct sha256_state sha256;
-		struct sha512_state sha512;
-	};
-	char ipad[SHA512_BLOCK_SIZE]; /* sufficient for SHA-1/SHA-256 as well */
-	char opad[SHA512_BLOCK_SIZE];
 };
 
 struct qat_alg_skcipher_ctx {
 	struct icp_qat_hw_cipher_algo_blk *enc_cd;
 	struct icp_qat_hw_cipher_algo_blk *dec_cd;
@@ -92,129 +84,61 @@ struct qat_alg_skcipher_ctx {
 	struct crypto_cipher *tweak;
 	bool fallback;
 	int mode;
 };
 
-static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
-{
-	switch (qat_hash_alg) {
-	case ICP_QAT_HW_AUTH_ALGO_SHA1:
-		return ICP_QAT_HW_SHA1_STATE1_SZ;
-	case ICP_QAT_HW_AUTH_ALGO_SHA256:
-		return ICP_QAT_HW_SHA256_STATE1_SZ;
-	case ICP_QAT_HW_AUTH_ALGO_SHA512:
-		return ICP_QAT_HW_SHA512_STATE1_SZ;
-	default:
-		return -EFAULT;
-	}
-}
-
 static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 				  struct qat_alg_aead_ctx *ctx,
 				  const u8 *auth_key,
 				  unsigned int auth_keylen)
 {
-	SHASH_DESC_ON_STACK(shash, ctx->hash_tfm);
-	int block_size = crypto_shash_blocksize(ctx->hash_tfm);
-	int digest_size = crypto_shash_digestsize(ctx->hash_tfm);
-	__be32 *hash_state_out;
-	__be64 *hash512_state_out;
-	int i, offset;
-
-	memset(ctx->ipad, 0, block_size);
-	memset(ctx->opad, 0, block_size);
-	shash->tfm = ctx->hash_tfm;
-
-	if (auth_keylen > block_size) {
-		int ret = crypto_shash_digest(shash, auth_key,
-					      auth_keylen, ctx->ipad);
-		if (ret)
-			return ret;
-
-		memcpy(ctx->opad, ctx->ipad, digest_size);
-	} else {
-		memcpy(ctx->ipad, auth_key, auth_keylen);
-		memcpy(ctx->opad, auth_key, auth_keylen);
+	switch (ctx->qat_hash_alg) {
+	case ICP_QAT_HW_AUTH_ALGO_SHA1: {
+		struct hmac_sha1_key key;
+		__be32 *istate = (__be32 *)hash->sha.state1;
+		__be32 *ostate = (__be32 *)(hash->sha.state1 +
+					    round_up(sizeof(key.istate.h), 8));
+
+		hmac_sha1_preparekey(&key, auth_key, auth_keylen);
+		for (int i = 0; i < ARRAY_SIZE(key.istate.h); i++) {
+			istate[i] = cpu_to_be32(key.istate.h[i]);
+			ostate[i] = cpu_to_be32(key.ostate.h[i]);
+		}
+		memzero_explicit(&key, sizeof(key));
+		return 0;
 	}
-
-	for (i = 0; i < block_size; i++) {
-		char *ipad_ptr = ctx->ipad + i;
-		char *opad_ptr = ctx->opad + i;
-		*ipad_ptr ^= HMAC_IPAD_VALUE;
-		*opad_ptr ^= HMAC_OPAD_VALUE;
+	case ICP_QAT_HW_AUTH_ALGO_SHA256: {
+		struct hmac_sha256_key key;
+		__be32 *istate = (__be32 *)hash->sha.state1;
+		__be32 *ostate = (__be32 *)(hash->sha.state1 +
+					    sizeof(key.key.istate.h));
+
+		hmac_sha256_preparekey(&key, auth_key, auth_keylen);
+		for (int i = 0; i < ARRAY_SIZE(key.key.istate.h); i++) {
+			istate[i] = cpu_to_be32(key.key.istate.h[i]);
+			ostate[i] = cpu_to_be32(key.key.ostate.h[i]);
+		}
+		memzero_explicit(&key, sizeof(key));
+		return 0;
 	}
-
-	if (crypto_shash_init(shash))
-		return -EFAULT;
-
-	if (crypto_shash_update(shash, ctx->ipad, block_size))
-		return -EFAULT;
-
-	hash_state_out = (__be32 *)hash->sha.state1;
-	hash512_state_out = (__be64 *)hash_state_out;
-
-	switch (ctx->qat_hash_alg) {
-	case ICP_QAT_HW_AUTH_ALGO_SHA1:
-		if (crypto_shash_export_core(shash, &ctx->sha1))
-			return -EFAULT;
-		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
-			*hash_state_out = cpu_to_be32(ctx->sha1.state[i]);
-		break;
-	case ICP_QAT_HW_AUTH_ALGO_SHA256:
-		if (crypto_shash_export_core(shash, &ctx->sha256))
-			return -EFAULT;
-		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
-			*hash_state_out = cpu_to_be32(ctx->sha256.state[i]);
-		break;
-	case ICP_QAT_HW_AUTH_ALGO_SHA512:
-		if (crypto_shash_export_core(shash, &ctx->sha512))
-			return -EFAULT;
-		for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
-			*hash512_state_out = cpu_to_be64(ctx->sha512.state[i]);
-		break;
-	default:
-		return -EFAULT;
+	case ICP_QAT_HW_AUTH_ALGO_SHA512: {
+		struct hmac_sha512_key key;
+		__be64 *istate = (__be64 *)hash->sha.state1;
+		__be64 *ostate = (__be64 *)(hash->sha.state1 +
+					    sizeof(key.key.istate.h));
+
+		hmac_sha512_preparekey(&key, auth_key, auth_keylen);
+		for (int i = 0; i < ARRAY_SIZE(key.key.istate.h); i++) {
+			istate[i] = cpu_to_be64(key.key.istate.h[i]);
+			ostate[i] = cpu_to_be64(key.key.ostate.h[i]);
+		}
+		memzero_explicit(&key, sizeof(key));
+		return 0;
 	}
-
-	if (crypto_shash_init(shash))
-		return -EFAULT;
-
-	if (crypto_shash_update(shash, ctx->opad, block_size))
-		return -EFAULT;
-
-	offset = round_up(qat_get_inter_state_size(ctx->qat_hash_alg), 8);
-	if (offset < 0)
-		return -EFAULT;
-
-	hash_state_out = (__be32 *)(hash->sha.state1 + offset);
-	hash512_state_out = (__be64 *)hash_state_out;
-
-	switch (ctx->qat_hash_alg) {
-	case ICP_QAT_HW_AUTH_ALGO_SHA1:
-		if (crypto_shash_export_core(shash, &ctx->sha1))
-			return -EFAULT;
-		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
-			*hash_state_out = cpu_to_be32(ctx->sha1.state[i]);
-		break;
-	case ICP_QAT_HW_AUTH_ALGO_SHA256:
-		if (crypto_shash_export_core(shash, &ctx->sha256))
-			return -EFAULT;
-		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
-			*hash_state_out = cpu_to_be32(ctx->sha256.state[i]);
-		break;
-	case ICP_QAT_HW_AUTH_ALGO_SHA512:
-		if (crypto_shash_export_core(shash, &ctx->sha512))
-			return -EFAULT;
-		for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
-			*hash512_state_out = cpu_to_be64(ctx->sha512.state[i]);
-		break;
 	default:
 		return -EFAULT;
 	}
-	memzero_explicit(ctx->ipad, block_size);
-	memzero_explicit(ctx->opad, block_size);
-	return 0;
 }
 
 static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header)
 {
 	header->hdr_flags =
@@ -257,11 +181,11 @@ static int qat_alg_aead_init_enc_session(struct crypto_aead *aead_tfm,
 	memcpy(cipher->aes.key, keys->enckey, keys->enckeylen);
 	hash->sha.inner_setup.auth_config.config =
 		ICP_QAT_HW_AUTH_CONFIG_BUILD(ICP_QAT_HW_AUTH_MODE1,
 					     ctx->qat_hash_alg, digestsize);
 	hash->sha.inner_setup.auth_counter.counter =
-		cpu_to_be32(crypto_shash_blocksize(ctx->hash_tfm));
+		cpu_to_be32(ctx->hash_blocksize);
 
 	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen))
 		return -EFAULT;
 
 	/* Request setup */
@@ -324,11 +248,11 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 	struct qat_dec *dec_ctx = &ctx->dec_cd->qat_dec_cd;
 	struct icp_qat_hw_auth_algo_blk *hash = &dec_ctx->hash;
 	struct icp_qat_hw_cipher_algo_blk *cipher =
 		(struct icp_qat_hw_cipher_algo_blk *)((char *)dec_ctx +
 		sizeof(struct icp_qat_hw_auth_setup) +
-		roundup(crypto_shash_digestsize(ctx->hash_tfm), 8) * 2);
+		roundup(ctx->hash_digestsize, 8) * 2);
 	struct icp_qat_fw_la_bulk_req *req_tmpl = &ctx->dec_fw_req;
 	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req_tmpl->cd_pars;
 	struct icp_qat_fw_comn_req_hdr *header = &req_tmpl->comn_hdr;
 	void *ptr = &req_tmpl->cd_ctrl;
 	struct icp_qat_fw_cipher_cd_ctrl_hdr *cipher_cd_ctrl = ptr;
@@ -344,11 +268,11 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 	hash->sha.inner_setup.auth_config.config =
 		ICP_QAT_HW_AUTH_CONFIG_BUILD(ICP_QAT_HW_AUTH_MODE1,
 					     ctx->qat_hash_alg,
 					     digestsize);
 	hash->sha.inner_setup.auth_counter.counter =
-		cpu_to_be32(crypto_shash_blocksize(ctx->hash_tfm));
+		cpu_to_be32(ctx->hash_blocksize);
 
 	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen))
 		return -EFAULT;
 
 	/* Request setup */
@@ -366,11 +290,11 @@ static int qat_alg_aead_init_dec_session(struct crypto_aead *aead_tfm,
 	/* Cipher CD config setup */
 	cipher_cd_ctrl->cipher_key_sz = keys->enckeylen >> 3;
 	cipher_cd_ctrl->cipher_state_sz = AES_BLOCK_SIZE >> 3;
 	cipher_cd_ctrl->cipher_cfg_offset =
 		(sizeof(struct icp_qat_hw_auth_setup) +
-		 roundup(crypto_shash_digestsize(ctx->hash_tfm), 8) * 2) >> 3;
+		 roundup(ctx->hash_digestsize, 8) * 2) >> 3;
 	ICP_QAT_FW_COMN_CURR_ID_SET(cipher_cd_ctrl, ICP_QAT_FW_SLICE_CIPHER);
 	ICP_QAT_FW_COMN_NEXT_ID_SET(cipher_cd_ctrl, ICP_QAT_FW_SLICE_DRAM_WR);
 
 	/* Auth CD config setup */
 	hash_cd_ctrl->hash_cfg_offset = 0;
@@ -1148,46 +1072,47 @@ static int qat_alg_skcipher_xts_decrypt(struct skcipher_request *req)
 
 	return qat_alg_skcipher_decrypt(req);
 }
 
 static int qat_alg_aead_init(struct crypto_aead *tfm,
-			     enum icp_qat_hw_auth_algo hash,
-			     const char *hash_name)
+			     enum icp_qat_hw_auth_algo hash_alg,
+			     unsigned int hash_digestsize,
+			     unsigned int hash_blocksize)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
-	ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
-	if (IS_ERR(ctx->hash_tfm))
-		return PTR_ERR(ctx->hash_tfm);
-	ctx->qat_hash_alg = hash;
+	ctx->qat_hash_alg = hash_alg;
+	ctx->hash_digestsize = hash_digestsize;
+	ctx->hash_blocksize = hash_blocksize;
 	crypto_aead_set_reqsize(tfm, sizeof(struct qat_crypto_request));
 	return 0;
 }
 
 static int qat_alg_aead_sha1_init(struct crypto_aead *tfm)
 {
-	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA1, "sha1");
+	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA1,
+				 SHA1_DIGEST_SIZE, SHA1_BLOCK_SIZE);
 }
 
 static int qat_alg_aead_sha256_init(struct crypto_aead *tfm)
 {
-	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA256, "sha256");
+	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA256,
+				 SHA256_DIGEST_SIZE, SHA256_BLOCK_SIZE);
 }
 
 static int qat_alg_aead_sha512_init(struct crypto_aead *tfm)
 {
-	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA512, "sha512");
+	return qat_alg_aead_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA512,
+				 SHA512_DIGEST_SIZE, SHA512_BLOCK_SIZE);
 }
 
 static void qat_alg_aead_exit(struct crypto_aead *tfm)
 {
 	struct qat_alg_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev;
 
-	crypto_free_shash(ctx->hash_tfm);
-
 	if (!inst)
 		return;
 
 	dev = &GET_DEV(inst->accel_dev);
 	if (ctx->enc_cd) {

base-commit: 41eab2a95950682cdc9c5e60cb3457e29f186540
-- 
2.50.1

