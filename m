Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8F72066DE;
	Sun, 31 Aug 2025 20:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756673847; cv=none; b=IhHAMbrBNy822OgnxRkbXUUEngNUvfdFGKN/B9rJ7Md5gHSLDUjwgicIQskqwtdrFO9qGI0TA4cGhnnwv/bpZYXQCyUY1cD5rBbwywreeNHkb3yP02X8wVgumpKaItYwYa5/GP9xLO7u6FZNeG6lTt4slEkbL5DZcMelc0qXWY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756673847; c=relaxed/simple;
	bh=vPyvmzUf4s5h/p/bNgG8Mzin8fEQzg+iEgPMmmyNkzM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XKZKYW1j7h/atHJDaqBdXidQBRwrgyi9PrNggNj9rNM5UhHj1gUnqADb12FqrFCvngBm9NtF4mGXgquxCwJLW1Q8RsyhwS3N9E0eAR3HXUN4ucOays+ssZ0DuOFKkZ7zxonFdIeNpGtdBPYF00Fqy+ETSnmyQ67amQIv+wTs5kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r3HNmuau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r3HNmuau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DB7C4CEED;
	Sun, 31 Aug 2025 20:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756673847;
	bh=vPyvmzUf4s5h/p/bNgG8Mzin8fEQzg+iEgPMmmyNkzM=;
	h=From:To:Cc:Subject:Date:From;
	b=r3HNmuau7rcmbgU/toYxRFcREktXIw7M37zl1QKmzyA7hjHARtudLla9H/qaJfA4d
	 TeYVchg3d8+G5A49MHjXgdFZ9Z7kmkYRC/pDmgLe6p0ZGG9+4BGVRcAZaHCz6FFUnD
	 LNGnnHbDWDsDCjqJ6tKAktZ4iwNmSwXkUoyYkKc5/Ep15/bfVzvzeh7X0bJF63H0cc
	 th8/4RF/L/9nM0OYz6beuMRaMH8L8skc9kjil92qV0tbywTNtrKVyw99N/9ZxTXQ1p
	 cX0IA1Dh1wa8/zxVDLNdge9xvR8BfM7gs1i44ctwozYK++XMm6qdL1+a4sh7tCIQbF
	 m5RjoUa3SsHVQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: qat-linux@intel.com,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: qat: Use library to prepare HMAC keys
Date: Sun, 31 Aug 2025 13:54:57 -0700
Message-ID: <20250831205457.36143-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reimplementing the sha1, sha256, and sha512 crypto_shash algorithms on
top of the library APIs caused the recently-added function
crypto_shash_export_core() to no longer be supported.  Meanwhile, the
QAT driver was updated to use crypto_shash_export_core().  But it's not
actually necessary.  Instead, just do the HMAC key preparation using the
library functions instead of crypto_shash.  This fixes the QAT driver
and greatly simplifies the code.  Additional benefits include stronger
typing, and improved performance due to reduced overhead.

Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Closes: https://lore.kernel.org/r/aLSnCc9Ws5L9y+8X@gcabiddu-mobl.ger.corp.intel.com
Fixes: ccafe2821cfa ("crypto: qat - Use crypto_shash_export_core")
Fixes: 8bc79ab67d78 ("crypto: sha1 - Wrap library and add HMAC support")
Fixes: e0cd37169103 ("crypto: sha256 - Wrap library and add HMAC support")
Fixes: 469acaa12502 ("crypto: sha512 - Replace sha512_generic with wrapper around SHA-512 library")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-fixes.

I'll send a similar one for the cheslio driver too.

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

base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
-- 
2.50.1

