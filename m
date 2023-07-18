Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7282EB64DC
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jul 2023 13:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjGRNB4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbjGRNBD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2023 09:01:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BF61FE4;
        Tue, 18 Jul 2023 06:00:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D727161587;
        Tue, 18 Jul 2023 13:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB974C433C8;
        Tue, 18 Jul 2023 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689685225;
        bh=re+UehvkeQHBK1wHhGnLcp2yWUgDT1GsozNrkQ2XFcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2jq/7vFH+5SdEhwac2XpIYEi4F+E5PgxK5t3cUMlQUQCqTe1YvjyexPjPu11dL2c
         yA+xClzV0scHRHYaigqmMwGwO524EVduViwfjGbx5JZ/Md/8EykRqPS2KCqv+fjAg+
         OVZipEnxTXLcwE41PRm9YCd5p3Sy4LxJSOmeX0DCqvN/sCP1Y3ysHaCTT4H9xGNyTG
         PR81t1YkbjBc+0e4kc7x34mAlunxZCrAiJwbGXsiBYgfuNisFYP6+PTLhgYB2otZbr
         MPfNvkjFsrvou9y5c77Q3VziexDLzAOAt6FRUzMHZ8XXO2LdWHKBOClxYEHpj6XmGa
         3QKnSjw0+UlCw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Haren Myneni <haren@us.ibm.com>,
        Nick Terrell <terrelln@fb.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Richard Weinberger <richard@nod.at>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        qat-linux@intel.com, linuxppc-dev@lists.ozlabs.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org
Subject: [RFC PATCH 12/21] crypto: lz4 - drop obsolete 'comp' implementation
Date:   Tue, 18 Jul 2023 14:58:38 +0200
Message-Id: <20230718125847.3869700-13-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230718125847.3869700-1-ardb@kernel.org>
References: <20230718125847.3869700-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2947; i=ardb@kernel.org; h=from:subject; bh=re+UehvkeQHBK1wHhGnLcp2yWUgDT1GsozNrkQ2XFcw=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIWVbT7X8homhprm68cwLX+9c9Fvx644lvpYK0uyVHXczL lbqRHF3lLIwiHEwyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIkI7GFk2Cf5/H/hil+rRD0Y V1qVzlx8uzDmVsz8teat3v8K3ANncjIybI19KFrZfilr2byAGx94Wn2OsHp9Uz7yMyRa5daj4F4 hbgA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The 'comp' API is obsolete and will be removed, so remove this comp
implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/lz4.c | 61 +-------------------
 1 file changed, 1 insertion(+), 60 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index 0606f8862e7872ad..c46b6cbd91ce10c0 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -27,29 +27,11 @@ static void *lz4_alloc_ctx(struct crypto_scomp *tfm)
 	return ctx;
 }
 
-static int lz4_init(struct crypto_tfm *tfm)
-{
-	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	ctx->lz4_comp_mem = lz4_alloc_ctx(NULL);
-	if (IS_ERR(ctx->lz4_comp_mem))
-		return -ENOMEM;
-
-	return 0;
-}
-
 static void lz4_free_ctx(struct crypto_scomp *tfm, void *ctx)
 {
 	vfree(ctx);
 }
 
-static void lz4_exit(struct crypto_tfm *tfm)
-{
-	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	lz4_free_ctx(NULL, ctx->lz4_comp_mem);
-}
-
 static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
 				 u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -70,14 +52,6 @@ static int lz4_scompress(struct crypto_scomp *tfm, const u8 *src,
 	return __lz4_compress_crypto(src, slen, dst, dlen, ctx);
 }
 
-static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
-			       unsigned int slen, u8 *dst, unsigned int *dlen)
-{
-	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	return __lz4_compress_crypto(src, slen, dst, dlen, ctx->lz4_comp_mem);
-}
-
 static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
@@ -97,26 +71,6 @@ static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
 }
 
-static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
-				 unsigned int slen, u8 *dst,
-				 unsigned int *dlen)
-{
-	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
-}
-
-static struct crypto_alg alg_lz4 = {
-	.cra_name		= "lz4",
-	.cra_driver_name	= "lz4-generic",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct lz4_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= lz4_init,
-	.cra_exit		= lz4_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= lz4_compress_crypto,
-	.coa_decompress		= lz4_decompress_crypto } }
-};
-
 static struct scomp_alg scomp = {
 	.alloc_ctx		= lz4_alloc_ctx,
 	.free_ctx		= lz4_free_ctx,
@@ -131,24 +85,11 @@ static struct scomp_alg scomp = {
 
 static int __init lz4_mod_init(void)
 {
-	int ret;
-
-	ret = crypto_register_alg(&alg_lz4);
-	if (ret)
-		return ret;
-
-	ret = crypto_register_scomp(&scomp);
-	if (ret) {
-		crypto_unregister_alg(&alg_lz4);
-		return ret;
-	}
-
-	return ret;
+	return crypto_register_scomp(&scomp);
 }
 
 static void __exit lz4_mod_fini(void)
 {
-	crypto_unregister_alg(&alg_lz4);
 	crypto_unregister_scomp(&scomp);
 }
 
-- 
2.39.2

