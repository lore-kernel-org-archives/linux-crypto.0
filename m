Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20675360ED1;
	Fri,  2 Oct 2026 21:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977903; cv=none; b=ZMj9KI2Ar5kewg4xJWkynrezjXUZ9TJb/p6PC67UMbwWGkSysuvHMhzPRkVdyzBrJ822E+CErAhv9w/jqu8qKujPe6vjfQKtb+ItdzjmdAXicKPB3/bPae84WoOizRdr07WXdczvdP7gTFhZeTuLoeP2E8pcgKflXELwnnHycnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977903; c=relaxed/simple;
	bh=sYQLP//6IlDahQBrfHqWJ5TeU1GtarzohWijfkEz/AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rXY4vfTGiz2AUk5NZpc+w09ccafV0DgIFcitYlzHp9502oe3snlT04CRB2OQwXYkpA76tgEsFbqTb1vDk6zeOVJ2AVBhn9aNsJ8BVJgIMl/8vI+wOF1aaZgZJ0iEuBu0CB9aljyeMPOewUwlGArqY6udJBjxK9gfhz39KEztqSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+w5+SYH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+w5+SYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096121F00893;
	Fri,  2 Oct 2026 21:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790977902;
	bh=lhMxFDoiE/N+ZYYSHQ2+O4QKGDRf9yFy3Q5op1ryIwQ=;
	h=From:To:Cc:Subject:Date;
	b=S+w5+SYHC7cua2AmIfWDbqouii1xj45MBhTaubFF+k4Fmv9N7RzV5T4aJGuViW5H7
	 fF9NJiS878hbb2BzoFqBfQtGYMUdREuE06NF8+4TSdaONRKVEKomZRzN6b1bv/ebAh
	 ace9dUl2w62m5Sb3nIYgpeyMu+LrjAzyX8+4CiQyZhdywlQQ3H30R9azWs57n8ya4N
	 FxanBJ74q64oF9OPWPFE0LtEZke+UPGIB28WbVwekRDlz2lf8yQwG8t6+2JtQmF5+N
	 CKaYeX7b+IkpbPX+iqTQs1s1O0CfFJc1iIDaf8dGmaTZ8iv6A7rL+8ZyGE2f0Od4LR
	 7XlDHmH+vQ6Bw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Tero Kristo <t-kristo@ti.com>,
	Keerthy <j-keerthy@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: sa2ul - Remove unused fields
Date: Fri,  2 Oct 2026 14:50:19 -0700
Message-ID: <20261002215019.14822-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the shash, authkey, and auth fields from sa_tfm_ctx since they
have no purpose and create confusion with fields that actually matter.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/sa2ul.c | 9 ---------
 drivers/crypto/sa2ul.h | 3 ---
 2 files changed, 12 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index b014350a3da0..4557eae94164 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1388,7 +1388,6 @@ static int sa_sha_run(struct ahash_request *req)
 
 static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 {
-	int bs = crypto_shash_blocksize(ctx->shash);
 	int cmdl_len;
 	struct sa_cmdl_cfg cfg;
 
@@ -1396,7 +1395,6 @@ static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 	ad->auth_eng.eng_id = SA_ENG_ID_AM1;
 	ad->auth_eng.sc_size = SA_CTX_AUTH_TYPE2_SZ;
 
-	memset(ctx->authkey, 0, bs);
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.aalg = ad->aalg_id;
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
@@ -1439,12 +1437,6 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 		return ret;
 
 	if (alg_base) {
-		ctx->shash = crypto_alloc_shash(alg_base, 0, 0);
-		if (IS_ERR(ctx->shash)) {
-			dev_err(sa_k3_dev, "base driver %s couldn't be loaded\n",
-				alg_base);
-			return PTR_ERR(ctx->shash);
-		}
 		/* for fallback */
 		ctx->fallback.ahash =
 			crypto_alloc_ahash(alg_base, 0, CRYPTO_ALG_ASYNC);
@@ -1599,7 +1591,6 @@ static void sa_sha_cra_exit(struct crypto_tfm *tfm)
 	if (crypto_tfm_alg_type(tfm) == CRYPTO_ALG_TYPE_AHASH)
 		sa_free_ctx_info(&ctx->enc, data);
 
-	crypto_free_shash(ctx->shash);
 	crypto_free_ahash(ctx->fallback.ahash);
 }
 
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 12c17a68d350..211ef4e40f22 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -307,12 +307,9 @@ struct sa_tfm_ctx {
 	struct sa_crypto_data *dev_data;
 	struct sa_ctx_info enc;
 	struct sa_ctx_info dec;
-	struct sa_ctx_info auth;
 	int keylen;
 	int iv_idx;
 	u32 key[AES_KEYSIZE_256 / sizeof(u32)];
-	u8 authkey[SHA512_BLOCK_SIZE];
-	struct crypto_shash	*shash;
 	/* for fallback */
 	union {
 		struct crypto_skcipher		*skcipher;

base-commit: 4c3ca7c8c152278332590bfd3df1b0f086364759
-- 
2.56.0

