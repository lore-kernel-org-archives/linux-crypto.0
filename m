Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B5638B7BD;
	Mon, 12 Jan 2026 19:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245814; cv=none; b=H7qtm/jlJYb0QYTwnr39sKTAmTIFBzCo48l8baP1XAN0JQNgv4SI3Q387alNVNvPNY3f+XbzGR+KjjLYNiLX+GH/HqMXNh3ggydGv1MmIooBCGtLs+N0dxHYM7mlyhadayfSUBKsGhIhYMtR/8EZ+2DEDquLRm79Zb6GlIEBjSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245814; c=relaxed/simple;
	bh=BBKB65xS0OpZpUhmAej3YWy5tO0vX+fEXhT2Dx9/+hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR5fGGG59JH3P5iEY8EnNwdtNNfUras9x+7o4SO06Kzm+WoExByeFLnzZdsgpFhT85n1n2/vwXJtkCUBmiZQubFvMuK6ugc3UdwAfuJDfT6YB0nFwvjQAid2Spv58RER2tOyv3Y/5ETO3S3Btb8OOUK7ioQtUaZWm1Ey2qYzZnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+MPGuKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+MPGuKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED5EC19425;
	Mon, 12 Jan 2026 19:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245813;
	bh=BBKB65xS0OpZpUhmAej3YWy5tO0vX+fEXhT2Dx9/+hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+MPGuKbhpS7/FgOBDKBzcyb8WMNKxVDlbJDnBswswVQjNTyepUQk3tSVY14vE2zG
	 UX57SThhUr6Rv+zmecFVUL2A4P+qu9QTjUEyKTZav5Gh2dKxYHvAMSCcQhXmTNnuwP
	 tLQMKrNcAajFMfItPOX1wSFsknV6Co/uCfzKLKNTgNifbkU7gxwh/q3sATLoURCx2z
	 gr0Tqh7T9MZCcuPbyEwXmKyevYKB/i8+EKi0FtQ3ug05KV0iq0dR7aeHRx+JyVWpzE
	 sIlhv3742IeqSPA8e9lIewSPkEJz1LGVfF+7jYw296kTbwivG2Ax+nyMLnnTsZwvdg
	 lrCYmNH+jyOcg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 29/35] crypto: drbg - Use new AES library API
Date: Mon, 12 Jan 2026 11:20:27 -0800
Message-ID: <20260112192035.10427-30-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from the old AES library functions (which use struct
crypto_aes_ctx) to the new ones (which use struct aes_enckey).  This
eliminates the unnecessary computation and caching of the decryption
round keys.  The new AES en/decryption functions are also much faster
and use AES instructions when supported by the CPU.

Note that in addition to the change in the key preparation function and
the key struct type itself, the change in the type of the key struct
results in aes_encrypt() (which is temporarily a type-generic macro)
calling the new encryption function rather than the old one.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/df_sp80090a.c                | 30 ++++++++++-------------------
 crypto/drbg.c                       | 12 ++++++------
 drivers/crypto/xilinx/xilinx-trng.c |  8 ++++----
 include/crypto/df_sp80090a.h        |  2 +-
 4 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/crypto/df_sp80090a.c b/crypto/df_sp80090a.c
index dc63b31a93fc..b8134be6f7ad 100644
--- a/crypto/df_sp80090a.c
+++ b/crypto/df_sp80090a.c
@@ -12,31 +12,21 @@
 #include <linux/string.h>
 #include <crypto/aes.h>
 #include <crypto/df_sp80090a.h>
 #include <crypto/internal/drbg.h>
 
-static void drbg_kcapi_symsetkey(struct crypto_aes_ctx *aesctx,
-				 const unsigned char *key,
-				 u8 keylen);
-static void drbg_kcapi_symsetkey(struct crypto_aes_ctx *aesctx,
-				 const unsigned char *key, u8 keylen)
-{
-	aes_expandkey(aesctx, key, keylen);
-}
-
-static void drbg_kcapi_sym(struct crypto_aes_ctx *aesctx,
-			   unsigned char *outval,
+static void drbg_kcapi_sym(struct aes_enckey *aeskey, unsigned char *outval,
 			   const struct drbg_string *in, u8 blocklen_bytes)
 {
 	/* there is only component in *in */
 	BUG_ON(in->len < blocklen_bytes);
-	aes_encrypt(aesctx, outval, in->buf);
+	aes_encrypt(aeskey, outval, in->buf);
 }
 
 /* BCC function for CTR DRBG as defined in 10.4.3 */
 
-static void drbg_ctr_bcc(struct crypto_aes_ctx *aesctx,
+static void drbg_ctr_bcc(struct aes_enckey *aeskey,
 			 unsigned char *out, const unsigned char *key,
 			 struct list_head *in,
 			 u8 blocklen_bytes,
 			 u8 keylen)
 {
@@ -45,30 +35,30 @@ static void drbg_ctr_bcc(struct crypto_aes_ctx *aesctx,
 	short cnt = 0;
 
 	drbg_string_fill(&data, out, blocklen_bytes);
 
 	/* 10.4.3 step 2 / 4 */
-	drbg_kcapi_symsetkey(aesctx, key, keylen);
+	aes_prepareenckey(aeskey, key, keylen);
 	list_for_each_entry(curr, in, list) {
 		const unsigned char *pos = curr->buf;
 		size_t len = curr->len;
 		/* 10.4.3 step 4.1 */
 		while (len) {
 			/* 10.4.3 step 4.2 */
 			if (blocklen_bytes == cnt) {
 				cnt = 0;
-				drbg_kcapi_sym(aesctx, out, &data, blocklen_bytes);
+				drbg_kcapi_sym(aeskey, out, &data, blocklen_bytes);
 			}
 			out[cnt] ^= *pos;
 			pos++;
 			cnt++;
 			len--;
 		}
 	}
 	/* 10.4.3 step 4.2 for last block */
 	if (cnt)
-		drbg_kcapi_sym(aesctx, out, &data, blocklen_bytes);
+		drbg_kcapi_sym(aeskey, out, &data, blocklen_bytes);
 }
 
 /*
  * scratchpad usage: drbg_ctr_update is interlinked with crypto_drbg_ctr_df
  * (and drbg_ctr_bcc, but this function does not need any temporary buffers),
@@ -108,11 +98,11 @@ static void drbg_ctr_bcc(struct crypto_aes_ctx *aesctx,
  *			possibilities.
  * refer to crypto_drbg_ctr_df_datalen() to get required length
  */
 
 /* Derivation Function for CTR DRBG as defined in 10.4.2 */
-int crypto_drbg_ctr_df(struct crypto_aes_ctx *aesctx,
+int crypto_drbg_ctr_df(struct aes_enckey *aeskey,
 		       unsigned char *df_data, size_t bytes_to_return,
 		       struct list_head *seedlist,
 		       u8 blocklen_bytes,
 		       u8 statelen)
 {
@@ -185,11 +175,11 @@ int crypto_drbg_ctr_df(struct crypto_aes_ctx *aesctx,
 		 * holds zeros after allocation -- even the increment of i
 		 * is irrelevant as the increment remains within length of i
 		 */
 		drbg_cpu_to_be32(i, iv);
 		/* 10.4.2 step 9.2 -- BCC and concatenation with temp */
-		drbg_ctr_bcc(aesctx, temp + templen, K, &bcc_list,
+		drbg_ctr_bcc(aeskey, temp + templen, K, &bcc_list,
 			     blocklen_bytes, keylen);
 		/* 10.4.2 step 9.3 */
 		i++;
 		templen += blocklen_bytes;
 	}
@@ -199,19 +189,19 @@ int crypto_drbg_ctr_df(struct crypto_aes_ctx *aesctx,
 	drbg_string_fill(&cipherin, X, blocklen_bytes);
 
 	/* 10.4.2 step 12: overwriting of outval is implemented in next step */
 
 	/* 10.4.2 step 13 */
-	drbg_kcapi_symsetkey(aesctx, temp, keylen);
+	aes_prepareenckey(aeskey, temp, keylen);
 	while (generated_len < bytes_to_return) {
 		short blocklen = 0;
 		/*
 		 * 10.4.2 step 13.1: the truncation of the key length is
 		 * implicit as the key is only drbg_blocklen in size based on
 		 * the implementation of the cipher function callback
 		 */
-		drbg_kcapi_sym(aesctx, X, &cipherin, blocklen_bytes);
+		drbg_kcapi_sym(aeskey, X, &cipherin, blocklen_bytes);
 		blocklen = (blocklen_bytes <
 				(bytes_to_return - generated_len)) ?
 			    blocklen_bytes :
 				(bytes_to_return - generated_len);
 		/* 10.4.2 step 13.2 and 14 */
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1d433dae9955..85cc4549bd58 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1503,13 +1503,13 @@ static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
 #endif /* (CONFIG_CRYPTO_DRBG_HASH || CONFIG_CRYPTO_DRBG_HMAC) */
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 static int drbg_fini_sym_kernel(struct drbg_state *drbg)
 {
-	struct crypto_aes_ctx *aesctx =	(struct crypto_aes_ctx *)drbg->priv_data;
+	struct aes_enckey *aeskey = drbg->priv_data;
 
-	kfree(aesctx);
+	kfree(aeskey);
 	drbg->priv_data = NULL;
 
 	if (drbg->ctr_handle)
 		crypto_free_skcipher(drbg->ctr_handle);
 	drbg->ctr_handle = NULL;
@@ -1524,20 +1524,20 @@ static int drbg_fini_sym_kernel(struct drbg_state *drbg)
 	return 0;
 }
 
 static int drbg_init_sym_kernel(struct drbg_state *drbg)
 {
-	struct crypto_aes_ctx *aesctx;
+	struct aes_enckey *aeskey;
 	struct crypto_skcipher *sk_tfm;
 	struct skcipher_request *req;
 	unsigned int alignmask;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
 
-	aesctx = kzalloc(sizeof(*aesctx), GFP_KERNEL);
-	if (!aesctx)
+	aeskey = kzalloc(sizeof(*aeskey), GFP_KERNEL);
+	if (!aeskey)
 		return -ENOMEM;
-	drbg->priv_data = aesctx;
+	drbg->priv_data = aeskey;
 
 	if (snprintf(ctr_name, CRYPTO_MAX_ALG_NAME, "ctr(%s)",
 	    drbg->core->backend_cra_name) >= CRYPTO_MAX_ALG_NAME) {
 		drbg_fini_sym_kernel(drbg);
 		return -EINVAL;
diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index db0fbb28ff32..5276ac2d82bb 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -58,11 +58,11 @@
 
 struct xilinx_rng {
 	void __iomem *rng_base;
 	struct device *dev;
 	unsigned char *scratchpadbuf;
-	struct crypto_aes_ctx *aesctx;
+	struct aes_enckey *aeskey;
 	struct mutex lock;	/* Protect access to TRNG device */
 	struct hwrng trng;
 };
 
 struct xilinx_rng_ctx {
@@ -196,11 +196,11 @@ static int xtrng_reseed_internal(struct xilinx_rng *rng)
 
 	/* collect random data to use it as entropy (input for DF) */
 	ret = xtrng_collect_random_data(rng, entropy, TRNG_SEED_LEN_BYTES, true);
 	if (ret != TRNG_SEED_LEN_BYTES)
 		return -EINVAL;
-	ret = crypto_drbg_ctr_df(rng->aesctx, rng->scratchpadbuf,
+	ret = crypto_drbg_ctr_df(rng->aeskey, rng->scratchpadbuf,
 				 TRNG_SEED_LEN_BYTES, &seedlist, AES_BLOCK_SIZE,
 				 TRNG_SEED_LEN_BYTES);
 	if (ret)
 		return ret;
 
@@ -347,12 +347,12 @@ static int xtrng_probe(struct platform_device *pdev)
 	if (IS_ERR(rng->rng_base)) {
 		dev_err(&pdev->dev, "Failed to map resource %pe\n", rng->rng_base);
 		return PTR_ERR(rng->rng_base);
 	}
 
-	rng->aesctx = devm_kzalloc(&pdev->dev, sizeof(*rng->aesctx), GFP_KERNEL);
-	if (!rng->aesctx)
+	rng->aeskey = devm_kzalloc(&pdev->dev, sizeof(*rng->aeskey), GFP_KERNEL);
+	if (!rng->aeskey)
 		return -ENOMEM;
 
 	sb_size = crypto_drbg_ctr_df_datalen(TRNG_SEED_LEN_BYTES, AES_BLOCK_SIZE);
 	rng->scratchpadbuf = devm_kzalloc(&pdev->dev, sb_size, GFP_KERNEL);
 	if (!rng->scratchpadbuf) {
diff --git a/include/crypto/df_sp80090a.h b/include/crypto/df_sp80090a.h
index 6b25305fe611..cb5d6fe15d40 100644
--- a/include/crypto/df_sp80090a.h
+++ b/include/crypto/df_sp80090a.h
@@ -16,11 +16,11 @@ static inline int crypto_drbg_ctr_df_datalen(u8 statelen, u8 blocklen)
 		blocklen +      /* pad */
 		blocklen +      /* iv */
 		statelen + blocklen;  /* temp */
 }
 
-int crypto_drbg_ctr_df(struct crypto_aes_ctx *aes,
+int crypto_drbg_ctr_df(struct aes_enckey *aes,
 		       unsigned char *df_data,
 		       size_t bytes_to_return,
 		       struct list_head *seedlist,
 		       u8 blocklen_bytes,
 		       u8 statelen);
-- 
2.52.0

