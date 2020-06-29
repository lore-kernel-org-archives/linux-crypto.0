Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2DCC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E577206A1
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593466318;
	bh=dccaYlXmdk9joEu+wP8c89JHxosC0hks/a742yYmYoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Y+ZLAnYj2rAzrZK+ekG5q0CL1VxXAFWMtdlWd4CD4QrosnOVA5pj2Dn8rUQ7nG0B5
	 aY45BRhJHC1goXC9cVYgjEmWa8A7oUy0o5ruj0b6A1djepMCOYodZvQMYI+Mr72BsN
	 mY8+yN8CpjjZfQ84xmY1CTwv1QoTGHOUF1o6yHG8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgF2Vb4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbgF2SlK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:10 -0400
Received: from localhost.localdomain (82-64-249-211.subs.proxad.net [82.64.249.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE6082332B;
        Mon, 29 Jun 2020 07:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593416382;
        bh=dccaYlXmdk9joEu+wP8c89JHxosC0hks/a742yYmYoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8Xk1peDFYKQISqNiK8uyjr931XE7pf9Q7gd4wRTGdqQY4zqbH+40hf+q1LG/Zzmr
         Abjc5PxFj+/V1/BmYqwHJWQUJIPGLZs7TacTHWz7zehT4unItIdw2+Dh9ZZFUwpo3C
         pwek01S1qkVdW7pTHbRa9e/PPQYQLO87EN4hsPNQ=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/5] crypto: arm64/ghash - drop PMULL based shash
Date:   Mon, 29 Jun 2020 09:39:21 +0200
Message-Id: <20200629073925.127538-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200629073925.127538-1-ardb@kernel.org>
References: <20200629073925.127538-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are two ways to implement SIMD accelerated GCM on arm64:
- using the PMULL instructions for carryless 64x64->128 multiplication,
  in which case the architecture guarantees that the AES instructions are
  available as well, and so we can use the AEAD implementation that combines
  both,
- using the PMULL instructions for carryless 8x8->16 bit multiplication,
  which is implemented as a shash, and can be combined with any ctr(aes)
  implementation by the generic GCM AEAD template driver.

So let's drop the 64x64->128 shash driver, which is never needed for GCM,
and not suitable for use anywhere else.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-glue.c | 90 +++-----------------
 1 file changed, 12 insertions(+), 78 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 22831d3b7f62..be63d8b5152c 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -113,12 +113,8 @@ static void ghash_do_update(int blocks, u64 dg[], const char *src,
 /* avoid hogging the CPU for too long */
 #define MAX_BLOCKS	(SZ_64K / GHASH_BLOCK_SIZE)
 
-static int __ghash_update(struct shash_desc *desc, const u8 *src,
-			  unsigned int len,
-			  void (*simd_update)(int blocks, u64 dg[],
-					      const char *src,
-					      struct ghash_key const *k,
-					      const char *head))
+static int ghash_update(struct shash_desc *desc, const u8 *src,
+			unsigned int len)
 {
 	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
 	unsigned int partial = ctx->count % GHASH_BLOCK_SIZE;
@@ -145,7 +141,7 @@ static int __ghash_update(struct shash_desc *desc, const u8 *src,
 
 			ghash_do_update(chunk, ctx->digest, src, key,
 					partial ? ctx->buf : NULL,
-					simd_update);
+					pmull_ghash_update_p8);
 
 			blocks -= chunk;
 			src += chunk * GHASH_BLOCK_SIZE;
@@ -157,19 +153,7 @@ static int __ghash_update(struct shash_desc *desc, const u8 *src,
 	return 0;
 }
 
-static int ghash_update_p8(struct shash_desc *desc, const u8 *src,
-			   unsigned int len)
-{
-	return __ghash_update(desc, src, len, pmull_ghash_update_p8);
-}
-
-static int ghash_update_p64(struct shash_desc *desc, const u8 *src,
-			    unsigned int len)
-{
-	return __ghash_update(desc, src, len, pmull_ghash_update_p64);
-}
-
-static int ghash_final_p8(struct shash_desc *desc, u8 *dst)
+static int ghash_final(struct shash_desc *desc, u8 *dst)
 {
 	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
 	unsigned int partial = ctx->count % GHASH_BLOCK_SIZE;
@@ -189,26 +173,6 @@ static int ghash_final_p8(struct shash_desc *desc, u8 *dst)
 	return 0;
 }
 
-static int ghash_final_p64(struct shash_desc *desc, u8 *dst)
-{
-	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	unsigned int partial = ctx->count % GHASH_BLOCK_SIZE;
-
-	if (partial) {
-		struct ghash_key *key = crypto_shash_ctx(desc->tfm);
-
-		memset(ctx->buf + partial, 0, GHASH_BLOCK_SIZE - partial);
-
-		ghash_do_update(1, ctx->digest, ctx->buf, key, NULL,
-				pmull_ghash_update_p64);
-	}
-	put_unaligned_be64(ctx->digest[1], dst);
-	put_unaligned_be64(ctx->digest[0], dst + 8);
-
-	*ctx = (struct ghash_desc_ctx){};
-	return 0;
-}
-
 static void ghash_reflect(u64 h[], const be128 *k)
 {
 	u64 carry = be64_to_cpu(k->a) & BIT(63) ? 1 : 0;
@@ -254,7 +218,7 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	return __ghash_setkey(key, inkey, keylen);
 }
 
-static struct shash_alg ghash_alg[] = {{
+static struct shash_alg ghash_alg = {
 	.base.cra_name		= "ghash",
 	.base.cra_driver_name	= "ghash-neon",
 	.base.cra_priority	= 150,
@@ -264,25 +228,11 @@ static struct shash_alg ghash_alg[] = {{
 
 	.digestsize		= GHASH_DIGEST_SIZE,
 	.init			= ghash_init,
-	.update			= ghash_update_p8,
-	.final			= ghash_final_p8,
-	.setkey			= ghash_setkey,
-	.descsize		= sizeof(struct ghash_desc_ctx),
-}, {
-	.base.cra_name		= "ghash",
-	.base.cra_driver_name	= "ghash-ce",
-	.base.cra_priority	= 200,
-	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct ghash_key),
-	.base.cra_module	= THIS_MODULE,
-
-	.digestsize		= GHASH_DIGEST_SIZE,
-	.init			= ghash_init,
-	.update			= ghash_update_p64,
-	.final			= ghash_final_p64,
+	.update			= ghash_update,
+	.final			= ghash_final,
 	.setkey			= ghash_setkey,
 	.descsize		= sizeof(struct ghash_desc_ctx),
-}};
+};
 
 static int num_rounds(struct crypto_aes_ctx *ctx)
 {
@@ -641,37 +591,21 @@ static struct aead_alg gcm_aes_alg = {
 
 static int __init ghash_ce_mod_init(void)
 {
-	int ret;
-
 	if (!cpu_have_named_feature(ASIMD))
 		return -ENODEV;
 
 	if (cpu_have_named_feature(PMULL))
-		ret = crypto_register_shashes(ghash_alg,
-					      ARRAY_SIZE(ghash_alg));
-	else
-		/* only register the first array element */
-		ret = crypto_register_shash(ghash_alg);
+		return crypto_register_aead(&gcm_aes_alg);
 
-	if (ret)
-		return ret;
-
-	if (cpu_have_named_feature(PMULL)) {
-		ret = crypto_register_aead(&gcm_aes_alg);
-		if (ret)
-			crypto_unregister_shashes(ghash_alg,
-						  ARRAY_SIZE(ghash_alg));
-	}
-	return ret;
+	return crypto_register_shash(&ghash_alg);
 }
 
 static void __exit ghash_ce_mod_exit(void)
 {
 	if (cpu_have_named_feature(PMULL))
-		crypto_unregister_shashes(ghash_alg, ARRAY_SIZE(ghash_alg));
+		crypto_unregister_aead(&gcm_aes_alg);
 	else
-		crypto_unregister_shash(ghash_alg);
-	crypto_unregister_aead(&gcm_aes_alg);
+		crypto_unregister_shash(&ghash_alg);
 }
 
 static const struct cpu_feature ghash_cpu_feature[] = {
-- 
2.20.1

