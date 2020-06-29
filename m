Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475DDC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25196206A1
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593466796;
	bh=nt3QmxtH/WE0Vm+VSZ3e8b2CAYUV2JMJFCEzMWvZ0RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=syAFSTOK1VQx/SX3InRBC3nhLqSKoVt0mRMZXlmUafNmFHRO7XMGQO5TcCUGhz/FI
	 vw+0E4DHvfrgNmmg4isfQkAOJKgUeolBxf7SalOjGOeG3dGcail3Xop3cEPJajfvn7
	 dPH4772M85w4k0hpbnJw0d9nkEimoKQDsJXJER/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgF2Vjz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgF2Ska (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:30 -0400
Received: from localhost.localdomain (82-64-249-211.subs.proxad.net [82.64.249.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EB1A2332A;
        Mon, 29 Jun 2020 07:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593416385;
        bh=nt3QmxtH/WE0Vm+VSZ3e8b2CAYUV2JMJFCEzMWvZ0RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIeTxXHGR8YiZr9EssWzSAJpShcbzE9XG3tjIlqHaabI/cApb+Z5i89KYeJYnwS5b
         kpubF8rGrAJnjgo3skHkm7LtkOew2D/QM8R4k6NVsLlIEkuNFQ6YadvZdWENmH8O+k
         Si4j4Y2n5He3bMDIuRMSIy84J3ulC4ONT4dJxd0Y=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/5] crypto: arm64/gcm - use variably sized key struct
Date:   Mon, 29 Jun 2020 09:39:23 +0200
Message-Id: <20200629073925.127538-4-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200629073925.127538-1-ardb@kernel.org>
References: <20200629073925.127538-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that the ghash and gcm drivers are split, we no longer need to allocate
a key struct for the former that carries powers of H that are only used by
the latter. Also, take this opportunity to clean up the code a little bit.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-glue.c | 49 +++++++++-----------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 921fa69b5ded..2ae95dcf648f 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -31,12 +31,8 @@ MODULE_ALIAS_CRYPTO("ghash");
 #define GCM_IV_SIZE		12
 
 struct ghash_key {
-	u64			h[2];
-	u64			h2[2];
-	u64			h3[2];
-	u64			h4[2];
-
 	be128			k;
+	u64			h[][2];
 };
 
 struct ghash_desc_ctx {
@@ -51,22 +47,18 @@ struct gcm_aes_ctx {
 };
 
 asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
-				       struct ghash_key const *k,
-				       const char *head);
+				       u64 const h[][2], const char *head);
 
 asmlinkage void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
-				      struct ghash_key const *k,
-				      const char *head);
+				      u64 const h[][2], const char *head);
 
 asmlinkage void pmull_gcm_encrypt(int bytes, u8 dst[], const u8 src[],
-				  struct ghash_key const *k, u64 dg[],
-				  u8 ctr[], u32 const rk[], int rounds,
-				  u8 tag[]);
+				  u64 const h[][2], u64 dg[], u8 ctr[],
+				  u32 const rk[], int rounds, u8 tag[]);
 
 asmlinkage void pmull_gcm_decrypt(int bytes, u8 dst[], const u8 src[],
-				  struct ghash_key const *k, u64 dg[],
-				  u8 ctr[], u32 const rk[], int rounds,
-				  u8 tag[]);
+				  u64 const h[][2], u64 dg[], u8 ctr[],
+				  u32 const rk[], int rounds, u8 tag[]);
 
 static int ghash_init(struct shash_desc *desc)
 {
@@ -80,12 +72,12 @@ static void ghash_do_update(int blocks, u64 dg[], const char *src,
 			    struct ghash_key *key, const char *head,
 			    void (*simd_update)(int blocks, u64 dg[],
 						const char *src,
-						struct ghash_key const *k,
+						u64 const h[][2],
 						const char *head))
 {
 	if (likely(crypto_simd_usable() && simd_update)) {
 		kernel_neon_begin();
-		simd_update(blocks, dg, src, key, head);
+		simd_update(blocks, dg, src, key->h, head);
 		kernel_neon_end();
 	} else {
 		be128 dst = { cpu_to_be64(dg[1]), cpu_to_be64(dg[0]) };
@@ -195,7 +187,7 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	/* needed for the fallback */
 	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
 
-	ghash_reflect(key->h, &key->k);
+	ghash_reflect(key->h[0], &key->k);
 	return 0;
 }
 
@@ -204,7 +196,7 @@ static struct shash_alg ghash_alg = {
 	.base.cra_driver_name	= "ghash-neon",
 	.base.cra_priority	= 150,
 	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct ghash_key),
+	.base.cra_ctxsize	= sizeof(struct ghash_key) + sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
 
 	.digestsize		= GHASH_DIGEST_SIZE,
@@ -244,17 +236,17 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *inkey,
 	/* needed for the fallback */
 	memcpy(&ctx->ghash_key.k, key, GHASH_BLOCK_SIZE);
 
-	ghash_reflect(ctx->ghash_key.h, &ctx->ghash_key.k);
+	ghash_reflect(ctx->ghash_key.h[0], &ctx->ghash_key.k);
 
 	h = ctx->ghash_key.k;
 	gf128mul_lle(&h, &ctx->ghash_key.k);
-	ghash_reflect(ctx->ghash_key.h2, &h);
+	ghash_reflect(ctx->ghash_key.h[1], &h);
 
 	gf128mul_lle(&h, &ctx->ghash_key.k);
-	ghash_reflect(ctx->ghash_key.h3, &h);
+	ghash_reflect(ctx->ghash_key.h[2], &h);
 
 	gf128mul_lle(&h, &ctx->ghash_key.k);
-	ghash_reflect(ctx->ghash_key.h4, &h);
+	ghash_reflect(ctx->ghash_key.h[3], &h);
 
 	return 0;
 }
@@ -380,8 +372,8 @@ static int gcm_encrypt(struct aead_request *req)
 			}
 
 			kernel_neon_begin();
-			pmull_gcm_encrypt(nbytes, dst, src, &ctx->ghash_key, dg,
-					  iv, ctx->aes_key.key_enc, nrounds,
+			pmull_gcm_encrypt(nbytes, dst, src, ctx->ghash_key.h,
+					  dg, iv, ctx->aes_key.key_enc, nrounds,
 					  tag);
 			kernel_neon_end();
 
@@ -494,8 +486,8 @@ static int gcm_decrypt(struct aead_request *req)
 			}
 
 			kernel_neon_begin();
-			pmull_gcm_decrypt(nbytes, dst, src, &ctx->ghash_key, dg,
-					  iv, ctx->aes_key.key_enc, nrounds,
+			pmull_gcm_decrypt(nbytes, dst, src, ctx->ghash_key.h,
+					  dg, iv, ctx->aes_key.key_enc, nrounds,
 					  tag);
 			kernel_neon_end();
 
@@ -582,7 +574,8 @@ static struct aead_alg gcm_aes_alg = {
 	.base.cra_driver_name	= "gcm-aes-ce",
 	.base.cra_priority	= 300,
 	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct gcm_aes_ctx),
+	.base.cra_ctxsize	= sizeof(struct gcm_aes_ctx) +
+				  4 * sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
 };
 
-- 
2.20.1

