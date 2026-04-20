Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF3383C98;
	Mon, 20 Apr 2026 06:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667021; cv=none; b=LMNBau2x9PRyNNsKTbMgs9jrY3uNCIO/TNaiA9Aq1Fv89XeuRdKjsYW8c1vQhEGhDA4UWr/qN8JguzTxn5v9xin6gAg5Gubq4Sev077ZRz8l308u0Rje/nvKDEzEQc7OI0DlY/4CGbk2qPPdwD5I5Gr165Sh3IYkcraAPfCysqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667021; c=relaxed/simple;
	bh=HwRwOcrg2l7pzuavWMlw3hYGvyX28tCgu4/F45/zmOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pag4Co+s125FxzTjvHapHNdcLpmX9x9Fv4AxJFJ/qaZZ53WMz6DBylyxeUqC9zoKUe93qNR5HP0+75axvSjgpo5pws4kvrdhDDR1DbcXOQ2qOa11OFiSOtBU/ikWTev86zzqTd8b1EPVJwuOz/nVVjgTFeAM4nF2+C8o4K619Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tbyiuh+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tbyiuh+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C8FC2BCB3;
	Mon, 20 Apr 2026 06:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667021;
	bh=HwRwOcrg2l7pzuavWMlw3hYGvyX28tCgu4/F45/zmOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbyiuh+nbsomhAUjoQOpNGkTZ16+hzIXw7Jq1g6FnYf+u0yVnbtUV37vmQASAEeN6
	 F3SZbGGDmfxmFLuRCN3U5nUiE019vCehGgn3/6rpPG6BwVb4WRmbCpEv8Ze0bWjFeU
	 lMMkvgwDnMfOsOIeCnv8pn/pHeAlDoFHi243GRqjam93CfL2JVHnZkOg9MvpYpqY/8
	 TB+nPTozcctx2RYrra8jBcOYAKVTgvLttMh3e5tpnbUhPTh9OeKdrgHOkHH2e3T4ZZ
	 8wSdjE34dzPelIZO8QHjBFCOvU4YwO1CRdQ3hIE499ftSYgROAQX2xtKzSs/yHJaDn
	 hfgt6xgMPgdzQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 06/38] crypto: drbg - Remove always-enabled symbol CRYPTO_DRBG_HMAC
Date: Sun, 19 Apr 2026 23:33:50 -0700
Message-ID: <20260420063422.324906-7-ebiggers@kernel.org>
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

The kconfig symbol CRYPTO_DRBG_HMAC is always enabled when
CRYPTO_DRBG_MENU is enabled, and all checks for CRYPTO_DRBG_HMAC are in
code conditional on CRYPTO_DRBG_MENU.  Thus, the only purpose of the
CRYPTO_DRBG_HMAC symbol is to select CRYPTO_HMAC and CRYPTO_SHA512.

Move those two selections to CRYPTO_DRBG_MENU, remove the checks for
CRYPTO_DRBG_HMAC, and remove the CRYPTO_DRBG_HMAC symbol itself.

Note that this also fixes an issue where CRYPTO_HMAC and CRYPTO_SHA512
were unnecessarily being forced to built-in when CRYPTO_DRBG=m.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig | 10 +++-------
 crypto/drbg.c  | 15 ---------------
 2 files changed, 3 insertions(+), 22 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 103d1f58cb7c..34da01c153d6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1120,16 +1120,10 @@ menuconfig CRYPTO_DRBG_MENU
 
 	  In the following submenu, one or more of the DRBG types must be selected.
 
 if CRYPTO_DRBG_MENU
 
-config CRYPTO_DRBG_HMAC
-	bool
-	default y
-	select CRYPTO_HMAC
-	select CRYPTO_SHA512
-
 config CRYPTO_DRBG_HASH
 	bool "Hash_DRBG"
 	select CRYPTO_SHA256
 	help
 	  Hash_DRBG variant as defined in NIST SP800-90A.
@@ -1145,12 +1139,14 @@ config CRYPTO_DRBG_CTR
 	  This uses the AES cipher algorithm with the counter block mode.
 
 config CRYPTO_DRBG
 	tristate
 	default CRYPTO_DRBG_MENU
-	select CRYPTO_RNG
+	select CRYPTO_HMAC
 	select CRYPTO_JITTERENTROPY
+	select CRYPTO_RNG
+	select CRYPTO_SHA512
 
 endif	# if CRYPTO_DRBG_MENU
 
 config CRYPTO_JITTERENTROPY
 	tristate "CPU Jitter Non-Deterministic RNG (Random Number Generator)"
diff --git a/crypto/drbg.c b/crypto/drbg.c
index e3065fb9541b..f6bff275c31b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -159,11 +159,10 @@ static const struct drbg_core drbg_cores[] = {
 		.blocklen_bytes = 32,
 		.cra_name = "sha256",
 		.backend_cra_name = "sha256",
 	},
 #endif /* CONFIG_CRYPTO_DRBG_HASH */
-#ifdef CONFIG_CRYPTO_DRBG_HMAC
 	{
 		.flags = DRBG_HMAC | DRBG_STRENGTH256,
 		.statelen = 48, /* block length of cipher */
 		.blocklen_bytes = 48,
 		.cra_name = "hmac_sha384",
@@ -179,11 +178,10 @@ static const struct drbg_core drbg_cores[] = {
 		.statelen = 64, /* block length of cipher */
 		.blocklen_bytes = 64,
 		.cra_name = "hmac_sha512",
 		.backend_cra_name = "hmac(sha512)",
 	},
-#endif /* CONFIG_CRYPTO_DRBG_HMAC */
 };
 
 static int drbg_uninstantiate(struct drbg_state *drbg);
 
 /******************************************************************
@@ -404,20 +402,17 @@ static const struct drbg_state_ops drbg_ctr_ops = {
 
 /******************************************************************
  * HMAC DRBG callback functions
  ******************************************************************/
 
-#if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
 static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
 			   const struct list_head *in);
 static void drbg_kcapi_hmacsetkey(struct drbg_state *drbg,
 				  const unsigned char *key);
 static int drbg_init_hash_kernel(struct drbg_state *drbg);
 static int drbg_fini_hash_kernel(struct drbg_state *drbg);
-#endif /* (CONFIG_CRYPTO_DRBG_HASH || CONFIG_CRYPTO_DRBG_HMAC) */
 
-#ifdef CONFIG_CRYPTO_DRBG_HMAC
 #define CRYPTO_DRBG_HMAC_STRING "HMAC "
 MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha512");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha512");
 MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha384");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha384");
@@ -525,11 +520,10 @@ static const struct drbg_state_ops drbg_hmac_ops = {
 	.update		= drbg_hmac_update,
 	.generate	= drbg_hmac_generate,
 	.crypto_init	= drbg_init_hash_kernel,
 	.crypto_fini	= drbg_fini_hash_kernel,
 };
-#endif /* CONFIG_CRYPTO_DRBG_HMAC */
 
 /******************************************************************
  * Hash DRBG callback functions
  ******************************************************************/
 
@@ -1044,15 +1038,13 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 {
 	int ret = -ENOMEM;
 	unsigned int sb_size = 0;
 
 	switch (drbg->core->flags & DRBG_TYPE_MASK) {
-#ifdef CONFIG_CRYPTO_DRBG_HMAC
 	case DRBG_HMAC:
 		drbg->d_ops = &drbg_hmac_ops;
 		break;
-#endif /* CONFIG_CRYPTO_DRBG_HMAC */
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 	case DRBG_HASH:
 		drbg->d_ops = &drbg_hash_ops;
 		break;
 #endif /* CONFIG_CRYPTO_DRBG_HASH */
@@ -1429,11 +1421,10 @@ static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
 
 /***************************************************************
  * Kernel crypto API cipher invocations requested by DRBG
  ***************************************************************/
 
-#if defined(CONFIG_CRYPTO_DRBG_HASH) || defined(CONFIG_CRYPTO_DRBG_HMAC)
 struct sdesc {
 	struct shash_desc shash;
 };
 
 static int drbg_init_hash_kernel(struct drbg_state *drbg)
@@ -1489,11 +1480,10 @@ static int drbg_kcapi_hash(struct drbg_state *drbg, unsigned char *outval,
 	crypto_shash_init(&sdesc->shash);
 	list_for_each_entry(input, in, list)
 		crypto_shash_update(&sdesc->shash, input->buf, input->len);
 	return crypto_shash_final(&sdesc->shash, outval);
 }
-#endif /* (CONFIG_CRYPTO_DRBG_HASH || CONFIG_CRYPTO_DRBG_HMAC) */
 
 #ifdef CONFIG_CRYPTO_DRBG_CTR
 static int drbg_fini_sym_kernel(struct drbg_state *drbg)
 {
 	struct aes_enckey *aeskey = drbg->priv_data;
@@ -1755,13 +1745,11 @@ static inline int __init drbg_healthcheck_sanity(void)
 	drbg_convert_tfm_core("drbg_nopr_ctr_aes256", &coreref, &pr);
 #endif
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 	drbg_convert_tfm_core("drbg_nopr_sha256", &coreref, &pr);
 #endif
-#ifdef CONFIG_CRYPTO_DRBG_HMAC
 	drbg_convert_tfm_core("drbg_nopr_hmac_sha512", &coreref, &pr);
-#endif
 
 	drbg = kzalloc_obj(struct drbg_state);
 	if (!drbg)
 		return -ENOMEM;
 
@@ -1885,13 +1873,10 @@ static void __exit drbg_exit(void)
 module_init(drbg_init);
 module_exit(drbg_exit);
 #ifndef CRYPTO_DRBG_HASH_STRING
 #define CRYPTO_DRBG_HASH_STRING ""
 #endif
-#ifndef CRYPTO_DRBG_HMAC_STRING
-#define CRYPTO_DRBG_HMAC_STRING ""
-#endif
 #ifndef CRYPTO_DRBG_CTR_STRING
 #define CRYPTO_DRBG_CTR_STRING ""
 #endif
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
-- 
2.53.0

