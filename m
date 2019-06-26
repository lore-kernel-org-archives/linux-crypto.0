Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50613C48BD3
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 20:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19177208E3
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 20:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GScmWhmT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfFZUlD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jun 2019 16:41:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52383 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfFZUlD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jun 2019 16:41:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so3467328wms.2
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jun 2019 13:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yO2dqQ4f2XXgbvC5iZQKPFNlYr8NCwruImNQuvOoii8=;
        b=GScmWhmTBq066DEGk0o8rO/pffUh6QsZx3suexwCza9UMRMMQKHK9wOk69aw3L7iaR
         y5yMFGIhhDtSeVlgb6sObmg6sRMGbjXnPo0c3gRaXccely1BwA6ce6+b+RKDgd4BKS5d
         AzuSrZLF8S1RS6UMHiWzoP63jiU6jY8KBSjZ3D8naV8hotWnzY2/SakXs0Ed1Aybigoa
         92EHp/hJo8xKsmVRctMb7AFcagwUzQCYxRPYvdyk9I2IDj/bneUigoH1jMkP9+3ggHMt
         qheubFqIXsEegGl0R7ZxA7GGC9k6GUP9FXQeSuYym2J2QXQijFj33lrwcyAIFiWPsHuQ
         lclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yO2dqQ4f2XXgbvC5iZQKPFNlYr8NCwruImNQuvOoii8=;
        b=nzK5zhawJlLkpI9953xGJeCOCRhAsAhT/q/nMZ3cemsXJ6ITXdt6eundR9St8i0/Hk
         40JnEDlltabqD+RwUcDEOJHXg2oxE7EuPb+0BJ+iI5+HS2c0y0UQUS4xFnZhHTG/2KfD
         7MFaPBPpIB/IcXs6/PPc+U4pwxNJqB+gsdfpIUslEKCkMOK3axEPugfAhhbo2VVPMoth
         zk/3U3T56IoWYOXFggbwnnr4X8P9LzcRaZD5b9GqzlQq/GliF6zIYF5dGaFWMsQiq3Oe
         4xX+Qe12umWZLtCPVwM4MdOkQUOo8hcUqAXGMS3EBBgUfcA6fDlFTHm93MvVfbZwD1kw
         UslQ==
X-Gm-Message-State: APjAAAUGXuvfpfWY0rI9qtws15MqY0IHwgWF73dtCF0Cdp1pmNByrYND
        +qxWrk6uDWT9CrIUEQZO8Yk995L1NowkOA==
X-Google-Smtp-Source: APXvYqyzuPUPQ9siU9XbeW0KeEfmGTuXGODjg/4G0nLBD0g9FXbSi+EFwrt0ZTBAKl/EuvFNJhz0EQ==
X-Received: by 2002:a1c:6a06:: with SMTP id f6mr495077wmc.159.1561581660135;
        Wed, 26 Jun 2019 13:41:00 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:9c7f:f574:ee94:7dec])
        by smtp.gmail.com with ESMTPSA id 32sm35164587wra.35.2019.06.26.13.40.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 13:40:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v5 7/7] crypto: arm64/aes - implement accelerated ESSIV/CBC mode
Date:   Wed, 26 Jun 2019 22:40:47 +0200
Message-Id: <20190626204047.32131-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
References: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add an accelerated version of the 'essiv(cbc(aes),aes,sha256'
skcipher, which is used by fscrypt, and in some cases, by dm-crypt.
This avoids a separate call into the AES cipher for every invocation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c  | 123 ++++++++++++++++++++
 arch/arm64/crypto/aes-modes.S |  29 ++++-
 2 files changed, 151 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 11b85ce02d7a..7097739e7cd9 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -12,6 +12,7 @@
 #include <asm/hwcap.h>
 #include <asm/simd.h>
 #include <crypto/aes.h>
+#include <crypto/sha.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
@@ -34,6 +35,8 @@
 #define aes_cbc_decrypt		ce_aes_cbc_decrypt
 #define aes_cbc_cts_encrypt	ce_aes_cbc_cts_encrypt
 #define aes_cbc_cts_decrypt	ce_aes_cbc_cts_decrypt
+#define aes_essiv_cbc_encrypt	ce_aes_essiv_cbc_encrypt
+#define aes_essiv_cbc_decrypt	ce_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		ce_aes_ctr_encrypt
 #define aes_xts_encrypt		ce_aes_xts_encrypt
 #define aes_xts_decrypt		ce_aes_xts_decrypt
@@ -50,6 +53,8 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
 #define aes_cbc_decrypt		neon_aes_cbc_decrypt
 #define aes_cbc_cts_encrypt	neon_aes_cbc_cts_encrypt
 #define aes_cbc_cts_decrypt	neon_aes_cbc_cts_decrypt
+#define aes_essiv_cbc_encrypt	neon_aes_essiv_cbc_encrypt
+#define aes_essiv_cbc_decrypt	neon_aes_essiv_cbc_decrypt
 #define aes_ctr_encrypt		neon_aes_ctr_encrypt
 #define aes_xts_encrypt		neon_aes_xts_encrypt
 #define aes_xts_decrypt		neon_aes_xts_decrypt
@@ -93,6 +98,13 @@ asmlinkage void aes_xts_decrypt(u8 out[], u8 const in[], u32 const rk1[],
 				int rounds, int blocks, u32 const rk2[], u8 iv[],
 				int first);
 
+asmlinkage void aes_essiv_cbc_encrypt(u8 out[], u8 const in[], u32 const rk1[],
+				      int rounds, int blocks, u8 iv[],
+				      u32 const rk2[]);
+asmlinkage void aes_essiv_cbc_decrypt(u8 out[], u8 const in[], u32 const rk1[],
+				      int rounds, int blocks, u8 iv[],
+				      u32 const rk2[]);
+
 asmlinkage void aes_mac_update(u8 const in[], u32 const rk[], int rounds,
 			       int blocks, u8 dg[], int enc_before,
 			       int enc_after);
@@ -108,6 +120,12 @@ struct crypto_aes_xts_ctx {
 	struct crypto_aes_ctx __aligned(8) key2;
 };
 
+struct crypto_aes_essiv_cbc_ctx {
+	struct crypto_aes_ctx key1;
+	struct crypto_aes_ctx __aligned(8) key2;
+	struct crypto_shash *hash;
+};
+
 struct mac_tfm_ctx {
 	struct crypto_aes_ctx key;
 	u8 __aligned(8) consts[];
@@ -145,6 +163,31 @@ static int xts_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	return -EINVAL;
 }
 
+static int essiv_cbc_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
+			     unsigned int key_len)
+{
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	SHASH_DESC_ON_STACK(desc, ctx->hash);
+	u8 digest[SHA256_DIGEST_SIZE];
+	int ret;
+
+	ret = aes_expandkey(&ctx->key1, in_key, key_len);
+	if (ret)
+		goto out;
+
+	desc->tfm = ctx->hash;
+	crypto_shash_digest(desc, in_key, key_len, digest);
+
+	ret = aes_expandkey(&ctx->key2, digest, sizeof(digest));
+	if (ret)
+		goto out;
+
+	return 0;
+out:
+	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
 static int ecb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -359,6 +402,68 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	return skcipher_walk_done(&walk, 0);
 }
 
+static int essiv_cbc_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	ctx->hash = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(ctx->hash))
+		return PTR_ERR(ctx->hash);
+
+	return 0;
+}
+
+static void essiv_cbc_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_shash(ctx->hash);
+}
+
+static int essiv_cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err, rounds = 6 + ctx->key1.key_length / 4;
+	struct skcipher_walk walk;
+	unsigned int blocks;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	blocks = walk.nbytes / AES_BLOCK_SIZE;
+	if (blocks) {
+		kernel_neon_begin();
+		aes_essiv_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				      ctx->key1.key_enc, rounds, blocks,
+				      req->iv, ctx->key2.key_enc);
+		kernel_neon_end();
+		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+	}
+	return err ?: cbc_encrypt_walk(req, &walk);
+}
+
+static int essiv_cbc_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_essiv_cbc_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int err, rounds = 6 + ctx->key1.key_length / 4;
+	struct skcipher_walk walk;
+	unsigned int blocks;
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	blocks = walk.nbytes / AES_BLOCK_SIZE;
+	if (blocks) {
+		kernel_neon_begin();
+		aes_essiv_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
+				      ctx->key1.key_dec, rounds, blocks,
+				      req->iv, ctx->key2.key_enc);
+		kernel_neon_end();
+		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
+	}
+	return err ?: cbc_decrypt_walk(req, &walk);
+}
+
 static int ctr_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -502,6 +607,24 @@ static struct skcipher_alg aes_algs[] = { {
 	.encrypt	= cts_cbc_encrypt,
 	.decrypt	= cts_cbc_decrypt,
 	.init		= cts_cbc_init_tfm,
+}, {
+	.base = {
+		.cra_name		= "__essiv(cbc(aes),aes,sha256)",
+		.cra_driver_name	= "__essiv-cbc-aes-sha256-" MODE,
+		.cra_priority		= PRIO + 1,
+		.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.cra_blocksize		= AES_BLOCK_SIZE,
+		.cra_ctxsize		= sizeof(struct crypto_aes_essiv_cbc_ctx),
+		.cra_module		= THIS_MODULE,
+	},
+	.min_keysize	= AES_MIN_KEY_SIZE,
+	.max_keysize	= AES_MAX_KEY_SIZE,
+	.ivsize		= AES_BLOCK_SIZE,
+	.setkey		= essiv_cbc_set_key,
+	.encrypt	= essiv_cbc_encrypt,
+	.decrypt	= essiv_cbc_decrypt,
+	.init		= essiv_cbc_init_tfm,
+	.exit		= essiv_cbc_exit_tfm,
 }, {
 	.base = {
 		.cra_name		= "__ctr(aes)",
diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 4c7ce231963c..2ef3d7244ea8 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -91,10 +91,25 @@ AES_ENDPROC(aes_ecb_decrypt)
 	 *		   int blocks, u8 iv[])
 	 * aes_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		   int blocks, u8 iv[])
+	 * aes_essiv_cbc_encrypt(u8 out[], u8 const in[], u32 const rk1[],
+	 *			 int rounds, int blocks, u8 iv[],
+	 *			 u32 const rk2[]);
+	 * aes_essiv_cbc_decrypt(u8 out[], u8 const in[], u32 const rk1[],
+	 *			 int rounds, int blocks, u8 iv[],
+	 *			 u32 const rk2[]);
 	 */
 
+AES_ENTRY(aes_essiv_cbc_encrypt)
+	ld1		{v4.16b}, [x5]			/* get iv */
+
+	mov		w8, #14				/* AES-256: 14 rounds */
+	enc_prepare	w8, x6, x7
+	encrypt_block	v4, w8, x6, x7, w9
+	b		.Lessivcbcencstart
+
 AES_ENTRY(aes_cbc_encrypt)
 	ld1		{v4.16b}, [x5]			/* get iv */
+.Lessivcbcencstart:
 	enc_prepare	w3, x2, x6
 
 .Lcbcencloop4x:
@@ -126,13 +141,25 @@ AES_ENTRY(aes_cbc_encrypt)
 	st1		{v4.16b}, [x5]			/* return iv */
 	ret
 AES_ENDPROC(aes_cbc_encrypt)
+AES_ENDPROC(aes_essiv_cbc_encrypt)
 
+AES_ENTRY(aes_essiv_cbc_decrypt)
+	stp		x29, x30, [sp, #-16]!
+	mov		x29, sp
+
+	ld1		{v7.16b}, [x5]			/* get iv */
+
+	mov		w8, #14				/* AES-256: 14 rounds */
+	enc_prepare	w8, x6, x7
+	encrypt_block	v7, w8, x6, x7, w9
+	b		.Lessivcbcdecstart
 
 AES_ENTRY(aes_cbc_decrypt)
 	stp		x29, x30, [sp, #-16]!
 	mov		x29, sp
 
 	ld1		{v7.16b}, [x5]			/* get iv */
+.Lessivcbcdecstart:
 	dec_prepare	w3, x2, x6
 
 .LcbcdecloopNx:
@@ -168,6 +195,7 @@ AES_ENTRY(aes_cbc_decrypt)
 	ldp		x29, x30, [sp], #16
 	ret
 AES_ENDPROC(aes_cbc_decrypt)
+AES_ENDPROC(aes_essiv_cbc_decrypt)
 
 
 	/*
@@ -247,7 +275,6 @@ AES_ENDPROC(aes_cbc_cts_decrypt)
 	.byte		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
 	.previous
 
-
 	/*
 	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
 	 *		   int blocks, u8 ctr[])
-- 
2.20.1

