Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069B6CA9EA0
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 10:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6FA62064B
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 10:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SM4CUnNq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731728AbfJVKE6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 06:04:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37599 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbfJVKE6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 06:04:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id e11so8624879wrv.4
        for <linux-crypto@vger.kernel.org>; Tue, 22 Oct 2019 03:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=muLH3PsnFQxUt5jT6phT88tqkbIUXJVWvD4mMtP38Mg=;
        b=SM4CUnNqIgrMBaut+ToyPWCyxl0wmDc+Rh8HIJJ+9oYKWURikrWsKoLMxj/wcF5HOp
         jlfVYVgqZohkBN1JlRmFW++TsHE976Nknl7PMij7b8kVuWDG60Y7o4f5fuJy4YEM4ubM
         IMk1qbFjJfxulEZ/gILB7rdCNwVPPxRONA3PfUnOur6R4rj+A8tz86Zyj/zWdKZeElhR
         tb1zXThdwzrlpyHMKMVUuiMg8KnPUX0rT2S1oSKv0IL59t5fChR5osrxpCKZlyhOg2Qm
         qI+qJtzfvR+kpkcJ20FG0TmQ9PJ+rF+QbJbO2lOUpLxktawJlaSI9ViArVTAjzOkpnXW
         5JJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=muLH3PsnFQxUt5jT6phT88tqkbIUXJVWvD4mMtP38Mg=;
        b=YIlHqjokGg3TkiYr9dxNx+pVAFMIovNFvHc/cP/+cm7pggevxJVvNi3vNlx71wAhBP
         8+4CP6N6YOJHQSNNtMFVdMwW7ZsJ8i3BVSzthcmENTYlRhb7PNavzWSPwwaJqEt8dgW9
         gvDHDG9721LnlNR4O2gTDIjQmhPDdbMptHhCPhxGJzBXE5rlofzGmEKKoQDngDmCdZGn
         5bbeVDh9Ml3FZWI9W3EA63khdyY4P/fR7vjyDG5s9jQLXyaXZUtK/e/u98stt5X6UltU
         TlBXgWlPrat8bsO98eHNkN/CieHooS/Y4ZHVfdpvwVDEm/6+ZrsnLGzTFirV9EoGEdMJ
         N+eQ==
X-Gm-Message-State: APjAAAVQ2t3gDOsz1Z/fB70XEaQOBOe3oywUF2eifWstYzr1UQzGnic8
        /EWwAjOn4eyHIa+ZBK7DIgFvsCBb
X-Google-Smtp-Source: APXvYqwwOWX1VjRJ3T4nQ5TnbwvEvqP/J8/wutz6z05fLipL5/fdoMwzoKVuI8DHAQUyyy6x7UO2zA==
X-Received: by 2002:adf:fac2:: with SMTP id a2mr2571580wrs.290.1571738694288;
        Tue, 22 Oct 2019 03:04:54 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id q196sm17063378wme.23.2019.10.22.03.04.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 03:04:53 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Fixed warnings on inconsistent byte order handling
Date:   Tue, 22 Oct 2019 11:01:43 +0200
Message-Id: <1571734903-24443-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes a bunch of endianness related sparse warnings reported by the
kbuild test robot as well as Ben Dooks.

Credits for the fix to safexcel.c go to Ben Dooks.

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  5 +-
 drivers/crypto/inside-secure/safexcel.h        |  4 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 88 ++++++++++++--------------
 drivers/crypto/inside-secure/safexcel_hash.c   | 31 +++++----
 4 files changed, 61 insertions(+), 67 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index e5f2bd7..fdd99ef 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -311,13 +311,14 @@ static void eip197_init_firmware(struct safexcel_crypto_priv *priv)
 static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
 				  const struct firmware *fw)
 {
-	const u32 *data = (const u32 *)fw->data;
+	const __be32 *data = (const __be32 *)fw->data;
 	int i;
 
 	/* Write the firmware */
 	for (i = 0; i < fw->size / sizeof(u32); i++)
 		writel(be32_to_cpu(data[i]),
-		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(u32));
+		       priv->base + EIP197_CLASSIFICATION_RAMS +
+		       i * sizeof(__be32));
 
 	/* Exclude final 2 NOPs from size */
 	return i - EIP197_FW_TERMINAL_NOPS;
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 30103d5..ba03e4d 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -360,8 +360,8 @@
 
 /* Context Control */
 struct safexcel_context_record {
-	u32 control0;
-	u32 control1;
+	__le32 control0;
+	__le32 control1;
 
 	__le32 data[40];
 } __packed;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 407ebcd..98f9fc6 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -57,8 +57,8 @@ struct safexcel_cipher_ctx {
 	/* All the below is AEAD specific */
 	u32 hash_alg;
 	u32 state_sz;
-	u32 ipad[SHA512_DIGEST_SIZE / sizeof(u32)];
-	u32 opad[SHA512_DIGEST_SIZE / sizeof(u32)];
+	__be32 ipad[SHA512_DIGEST_SIZE / sizeof(u32)];
+	__be32 opad[SHA512_DIGEST_SIZE / sizeof(u32)];
 
 	struct crypto_cipher *hkaes;
 	struct crypto_aead *fback;
@@ -92,7 +92,8 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 			cdesc->control_data.token[3] = 0;
 		} else {
 			/* 32 bit counter, start at 1 (big endian!) */
-			cdesc->control_data.token[3] = cpu_to_be32(1);
+			cdesc->control_data.token[3] =
+				(__force u32)cpu_to_be32(1);
 		}
 
 		return;
@@ -108,7 +109,8 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 			cdesc->control_data.token[3] = 0;
 		} else {
 			/* 32 bit counter, start at 1 (big endian!) */
-			cdesc->control_data.token[3] = cpu_to_be32(1);
+			*(__be32 *)&cdesc->control_data.token[3] =
+				cpu_to_be32(1);
 		}
 
 		return;
@@ -267,7 +269,7 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	if (ctx->xcm != EIP197_XCM_MODE_GCM) {
 		u8 *final_iv = (u8 *)cdesc->control_data.token;
 		u8 *cbcmaciv = (u8 *)&token[1];
-		u32 *aadlen = (u32 *)&token[5];
+		__le32 *aadlen = (__le32 *)&token[5];
 
 		/* Construct IV block B0 for the CBC-MAC */
 		token[0].opcode = EIP197_TOKEN_OPCODE_INSERT;
@@ -286,7 +288,8 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		cbcmaciv[15] = cryptlen & 255;
 
 		if (assoclen) {
-			*aadlen = cpu_to_le32(cpu_to_be16(assoclen));
+			*aadlen = cpu_to_le32((assoclen >> 8) |
+					      ((assoclen & 0xff) << 8));
 			assoclen += 2;
 		}
 
@@ -333,7 +336,7 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < len / sizeof(u32); i++) {
-			if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
+			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
 				ctx->base.needs_inv = true;
 				break;
 			}
@@ -358,7 +361,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct crypto_authenc_keys keys;
 	struct crypto_aes_ctx aes;
-	int err = -EINVAL;
+	int err = -EINVAL, i;
 
 	if (unlikely(crypto_authenc_extractkeys(&keys, key, len)))
 		goto badkey;
@@ -400,9 +403,14 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 		goto badkey;
 	}
 
-	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma &&
-	    memcmp(ctx->key, keys.enckey, keys.enckeylen))
-		ctx->base.needs_inv = true;
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
+		for (i = 0; i < keys.enckeylen / sizeof(u32); i++) {
+			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
+				ctx->base.needs_inv = true;
+				break;
+			}
+		}
+	}
 
 	/* Auth key */
 	switch (ctx->hash_alg) {
@@ -450,7 +458,8 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 		ctx->base.needs_inv = true;
 
 	/* Now copy the keys into the context */
-	memcpy(ctx->key, keys.enckey, keys.enckeylen);
+	for (i = 0; i < keys.enckeylen / sizeof(u32); i++)
+		ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
 	ctx->key_len = keys.enckeylen;
 
 	memcpy(ctx->ipad, &istate.state, ctx->state_sz);
@@ -1378,7 +1387,7 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < keylen / sizeof(u32); i++) {
-			if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
+			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
 				ctx->base.needs_inv = true;
 				break;
 			}
@@ -1534,13 +1543,11 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
 		return err;
 
 	/* if context exits and key changed, need to invalidate it */
-	if (ctx->base.ctxr_dma) {
+	if (ctx->base.ctxr_dma)
 		if (memcmp(ctx->key, key, len))
 			ctx->base.needs_inv = true;
-	}
 
 	memcpy(ctx->key, key, len);
-
 	ctx->key_len = len;
 
 	return 0;
@@ -2361,7 +2368,7 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < keylen / sizeof(u32); i++) {
-			if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
+			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
 				ctx->base.needs_inv = true;
 				break;
 			}
@@ -2380,8 +2387,8 @@ static int safexcel_skcipher_aesxts_setkey(struct crypto_skcipher *ctfm,
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < keylen / sizeof(u32); i++) {
-			if (ctx->key[i + keylen / sizeof(u32)] !=
-			    cpu_to_le32(aes.key_enc[i])) {
+			if (le32_to_cpu(ctx->key[i + keylen / sizeof(u32)]) !=
+			    aes.key_enc[i]) {
 				ctx->base.needs_inv = true;
 				break;
 			}
@@ -2471,7 +2478,7 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < len / sizeof(u32); i++) {
-			if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
+			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
 				ctx->base.needs_inv = true;
 				break;
 			}
@@ -2498,7 +2505,7 @@ static int safexcel_aead_gcm_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++) {
-			if (ctx->ipad[i] != cpu_to_be32(hashkey[i])) {
+			if (be32_to_cpu(ctx->ipad[i]) != hashkey[i]) {
 				ctx->base.needs_inv = true;
 				break;
 			}
@@ -2588,7 +2595,7 @@ static int safexcel_aead_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
 
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
 		for (i = 0; i < len / sizeof(u32); i++) {
-			if (ctx->key[i] != cpu_to_le32(aes.key_enc[i])) {
+			if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
 				ctx->base.needs_inv = true;
 				break;
 			}
@@ -2697,20 +2704,12 @@ static void safexcel_chacha20_setkey(struct safexcel_cipher_ctx *ctx,
 				     const u8 *key)
 {
 	struct safexcel_crypto_priv *priv = ctx->priv;
-	int i;
 
-	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
-		for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++) {
-			if (ctx->key[i] !=
-			    get_unaligned_le32(key + i * sizeof(u32))) {
-				ctx->base.needs_inv = true;
-				break;
-			}
-		}
-	}
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma)
+		if (memcmp(ctx->key, key, CHACHA_KEY_SIZE))
+			ctx->base.needs_inv = true;
 
-	for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++)
-		ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
+	memcpy(ctx->key, key, CHACHA_KEY_SIZE);
 	ctx->key_len = CHACHA_KEY_SIZE;
 }
 
@@ -2801,7 +2800,7 @@ static int safexcel_aead_chachapoly_crypt(struct aead_request *req,
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct aead_request *subreq = aead_request_ctx(req);
 	u32 key[CHACHA_KEY_SIZE / sizeof(u32) + 1];
-	int i, ret = 0;
+	int ret = 0;
 
 	/*
 	 * Instead of wasting time detecting umpteen silly corner cases,
@@ -2815,8 +2814,7 @@ static int safexcel_aead_chachapoly_crypt(struct aead_request *req,
 	}
 
 	/* HW cannot do full (AAD+payload) zero length, use fallback */
-	for (i = 0; i < CHACHA_KEY_SIZE / sizeof(u32); i++)
-		key[i] = cpu_to_le32(ctx->key[i]);
+	memcpy(key, ctx->key, CHACHA_KEY_SIZE);
 	if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
 		/* ESP variant has nonce appended to the key */
 		key[CHACHA_KEY_SIZE / sizeof(u32)] = ctx->nonce;
@@ -2971,25 +2969,17 @@ static int safexcel_skcipher_sm4_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
-	int i;
 
 	if (len != SM4_KEY_SIZE) {
 		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
 
-	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
-		for (i = 0; i < SM4_KEY_SIZE / sizeof(u32); i++) {
-			if (ctx->key[i] !=
-			    get_unaligned_le32(key + i * sizeof(u32))) {
-				ctx->base.needs_inv = true;
-				break;
-			}
-		}
-	}
+	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma)
+		if (memcmp(ctx->key, key, SM4_KEY_SIZE))
+			ctx->base.needs_inv = true;
 
-	for (i = 0; i < SM4_KEY_SIZE / sizeof(u32); i++)
-		ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
+	memcpy(ctx->key, key, SM4_KEY_SIZE);
 	ctx->key_len = SM4_KEY_SIZE;
 
 	return 0;
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index b60f9fb..2134dae 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -29,8 +29,8 @@ struct safexcel_ahash_ctx {
 	bool fb_init_done;
 	bool fb_do_setkey;
 
-	u32 ipad[SHA3_512_BLOCK_SIZE / sizeof(u32)];
-	u32 opad[SHA3_512_BLOCK_SIZE / sizeof(u32)];
+	__le32 ipad[SHA3_512_BLOCK_SIZE / sizeof(__le32)];
+	__le32 opad[SHA3_512_BLOCK_SIZE / sizeof(__le32)];
 
 	struct crypto_cipher *kaes;
 	struct crypto_ahash *fback;
@@ -56,7 +56,8 @@ struct safexcel_ahash_req {
 	u8 state_sz;    /* expected state size, only set once */
 	u8 block_sz;    /* block size, only set once */
 	u8 digest_sz;   /* output digest size, only set once */
-	u32 state[SHA3_512_BLOCK_SIZE / sizeof(u32)] __aligned(sizeof(u32));
+	__le32 state[SHA3_512_BLOCK_SIZE /
+		     sizeof(__le32)] __aligned(sizeof(__le32));
 
 	u64 len;
 	u64 processed;
@@ -287,7 +288,7 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
 		if (unlikely(sreq->digest == CONTEXT_CONTROL_DIGEST_XCM &&
 			     ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_CRC32)) {
 			/* Undo final XOR with 0xffffffff ...*/
-			*(u32 *)areq->result = ~sreq->state[0];
+			*(__le32 *)areq->result = ~sreq->state[0];
 		} else {
 			memcpy(areq->result, sreq->state,
 			       crypto_ahash_digestsize(ahash));
@@ -372,9 +373,9 @@ static int safexcel_ahash_send_req(struct crypto_async_request *async, int ring,
 				req->cache[cache_len + skip] = 0x80;
 				// HW will use K2 iso K3 - compensate!
 				for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++)
-					((u32 *)req->cache)[i] ^=
-						cpu_to_be32(ctx->ipad[i]) ^
-						cpu_to_be32(ctx->ipad[i + 4]);
+					((__be32 *)req->cache)[i] ^=
+					  cpu_to_be32(le32_to_cpu(
+					    ctx->ipad[i] ^ ctx->ipad[i + 4]));
 			}
 			cache_len = AES_BLOCK_SIZE;
 			queued = queued + extra;
@@ -807,8 +808,8 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 		int i;
 
 		for (i = 0; i < AES_BLOCK_SIZE / sizeof(u32); i++)
-			((u32 *)areq->result)[i] =
-				cpu_to_be32(ctx->ipad[i + 4]);	// K3
+			((__be32 *)areq->result)[i] =
+				cpu_to_be32(le32_to_cpu(ctx->ipad[i + 4]));//K3
 		areq->result[0] ^= 0x80;			// 10- padding
 		crypto_cipher_encrypt_one(ctx->kaes, areq->result, areq->result);
 		return 0;
@@ -1891,7 +1892,7 @@ static int safexcel_crc32_init(struct ahash_request *areq)
 	memset(req, 0, sizeof(*req));
 
 	/* Start from loaded key */
-	req->state[0]	= cpu_to_le32(~ctx->ipad[0]);
+	req->state[0]	= (__force __le32)le32_to_cpu(~ctx->ipad[0]);
 	/* Set processed to non-zero to enable invalidation detection */
 	req->len	= sizeof(u32);
 	req->processed	= sizeof(u32);
@@ -1993,7 +1994,7 @@ static int safexcel_cbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 	memset(ctx->ipad, 0, 2 * AES_BLOCK_SIZE);
 	for (i = 0; i < len / sizeof(u32); i++)
-		ctx->ipad[i + 8] = cpu_to_be32(aes.key_enc[i]);
+		ctx->ipad[i + 8] = (__force __le32)cpu_to_be32(aes.key_enc[i]);
 
 	if (len == AES_KEYSIZE_192) {
 		ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC192;
@@ -2078,7 +2079,8 @@ static int safexcel_xcbcmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	crypto_cipher_encrypt_one(ctx->kaes, (u8 *)key_tmp + AES_BLOCK_SIZE,
 		"\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
 	for (i = 0; i < 3 * AES_BLOCK_SIZE / sizeof(u32); i++)
-		ctx->ipad[i] = cpu_to_be32(key_tmp[i]);
+		ctx->ipad[i] =
+			cpu_to_le32((__force u32)cpu_to_be32(key_tmp[i]));
 
 	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
 	crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
@@ -2164,7 +2166,8 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	}
 
 	for (i = 0; i < len / sizeof(u32); i++)
-		ctx->ipad[i + 8] = cpu_to_be32(aes.key_enc[i]);
+		ctx->ipad[i + 8] =
+			cpu_to_le32((__force u32)cpu_to_be32(aes.key_enc[i]));
 
 	/* precompute the CMAC key material */
 	crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
@@ -2197,7 +2200,7 @@ static int safexcel_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	/* end of code borrowed from crypto/cmac.c */
 
 	for (i = 0; i < 2 * AES_BLOCK_SIZE / sizeof(u32); i++)
-		ctx->ipad[i] = cpu_to_be32(((u32 *)consts)[i]);
+		ctx->ipad[i] = (__force __le32)cpu_to_be32(((u32 *)consts)[i]);
 
 	if (len == AES_KEYSIZE_192) {
 		ctx->alg    = CONTEXT_CONTROL_CRYPTO_ALG_XCBC192;
-- 
1.8.3.1

