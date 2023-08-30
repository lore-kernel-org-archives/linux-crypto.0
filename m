Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80871C83F18
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239942AbjH3SoI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243046AbjH3KJN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 06:09:13 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71F71B0;
        Wed, 30 Aug 2023 03:09:09 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qbI7z-009Bvz-Kh; Wed, 30 Aug 2023 18:08:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Aug 2023 18:08:49 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Wed, 30 Aug 2023 18:08:49 +0800
Subject: [PATCH 3/4] crypto: deflate - Remove zlib-deflate
References: <ZO8ULhlJSrJ0Mcsx@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>, ardb@kernel.org,
        kees@kernel.org, linux-kernel@vger.kernel.org, enlin.mu@unisoc.com,
        ebiggers@google.com, gpiccoli@igalia.com, willy@infradead.org,
        yunlong.xing@unisoc.com, yuxiaozhang@google.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Message-Id: <E1qbI7z-009Bvz-Kh@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the implementation of zlib-deflate because it is completely
unused in the kernel.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/deflate.c |   61 +++++++++++++++----------------------------------------
 1 file changed, 17 insertions(+), 44 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index b2a46f6dc961..6e31e0db0e86 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -39,24 +39,20 @@ struct deflate_ctx {
 	struct z_stream_s decomp_stream;
 };
 
-static int deflate_comp_init(struct deflate_ctx *ctx, int format)
+static int deflate_comp_init(struct deflate_ctx *ctx)
 {
 	int ret = 0;
 	struct z_stream_s *stream = &ctx->comp_stream;
 
 	stream->workspace = vzalloc(zlib_deflate_workspacesize(
-				    MAX_WBITS, MAX_MEM_LEVEL));
+				    -DEFLATE_DEF_WINBITS, MAX_MEM_LEVEL));
 	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	if (format)
-		ret = zlib_deflateInit(stream, 3);
-	else
-		ret = zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
-					-DEFLATE_DEF_WINBITS,
-					DEFLATE_DEF_MEMLEVEL,
-					Z_DEFAULT_STRATEGY);
+	ret = zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
+				-DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
+				Z_DEFAULT_STRATEGY);
 	if (ret != Z_OK) {
 		ret = -EINVAL;
 		goto out_free;
@@ -68,7 +64,7 @@ static int deflate_comp_init(struct deflate_ctx *ctx, int format)
 	goto out;
 }
 
-static int deflate_decomp_init(struct deflate_ctx *ctx, int format)
+static int deflate_decomp_init(struct deflate_ctx *ctx)
 {
 	int ret = 0;
 	struct z_stream_s *stream = &ctx->decomp_stream;
@@ -78,10 +74,7 @@ static int deflate_decomp_init(struct deflate_ctx *ctx, int format)
 		ret = -ENOMEM;
 		goto out;
 	}
-	if (format)
-		ret = zlib_inflateInit(stream);
-	else
-		ret = zlib_inflateInit2(stream, -DEFLATE_DEF_WINBITS);
+	ret = zlib_inflateInit2(stream, -DEFLATE_DEF_WINBITS);
 	if (ret != Z_OK) {
 		ret = -EINVAL;
 		goto out_free;
@@ -105,21 +98,21 @@ static void deflate_decomp_exit(struct deflate_ctx *ctx)
 	vfree(ctx->decomp_stream.workspace);
 }
 
-static int __deflate_init(void *ctx, int format)
+static int __deflate_init(void *ctx)
 {
 	int ret;
 
-	ret = deflate_comp_init(ctx, format);
+	ret = deflate_comp_init(ctx);
 	if (ret)
 		goto out;
-	ret = deflate_decomp_init(ctx, format);
+	ret = deflate_decomp_init(ctx);
 	if (ret)
 		deflate_comp_exit(ctx);
 out:
 	return ret;
 }
 
-static void *gen_deflate_alloc_ctx(struct crypto_scomp *tfm, int format)
+static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
 {
 	struct deflate_ctx *ctx;
 	int ret;
@@ -128,7 +121,7 @@ static void *gen_deflate_alloc_ctx(struct crypto_scomp *tfm, int format)
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	ret = __deflate_init(ctx, format);
+	ret = __deflate_init(ctx);
 	if (ret) {
 		kfree(ctx);
 		return ERR_PTR(ret);
@@ -137,21 +130,11 @@ static void *gen_deflate_alloc_ctx(struct crypto_scomp *tfm, int format)
 	return ctx;
 }
 
-static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
-{
-	return gen_deflate_alloc_ctx(tfm, 0);
-}
-
-static void *zlib_deflate_alloc_ctx(struct crypto_scomp *tfm)
-{
-	return gen_deflate_alloc_ctx(tfm, 1);
-}
-
 static int deflate_init(struct crypto_tfm *tfm)
 {
 	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	return __deflate_init(ctx, 0);
+	return __deflate_init(ctx);
 }
 
 static void __deflate_exit(void *ctx)
@@ -286,7 +269,7 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= deflate_decompress } }
 };
 
-static struct scomp_alg scomp[] = { {
+static struct scomp_alg scomp = {
 	.alloc_ctx		= deflate_alloc_ctx,
 	.free_ctx		= deflate_free_ctx,
 	.compress		= deflate_scompress,
@@ -296,17 +279,7 @@ static struct scomp_alg scomp[] = { {
 		.cra_driver_name = "deflate-scomp",
 		.cra_module	 = THIS_MODULE,
 	}
-}, {
-	.alloc_ctx		= zlib_deflate_alloc_ctx,
-	.free_ctx		= deflate_free_ctx,
-	.compress		= deflate_scompress,
-	.decompress		= deflate_sdecompress,
-	.base			= {
-		.cra_name	= "zlib-deflate",
-		.cra_driver_name = "zlib-deflate-scomp",
-		.cra_module	 = THIS_MODULE,
-	}
-} };
+};
 
 static int __init deflate_mod_init(void)
 {
@@ -316,7 +289,7 @@ static int __init deflate_mod_init(void)
 	if (ret)
 		return ret;
 
-	ret = crypto_register_scomps(scomp, ARRAY_SIZE(scomp));
+	ret = crypto_register_scomp(&scomp);
 	if (ret) {
 		crypto_unregister_alg(&alg);
 		return ret;
@@ -328,7 +301,7 @@ static int __init deflate_mod_init(void)
 static void __exit deflate_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
-	crypto_unregister_scomps(scomp, ARRAY_SIZE(scomp));
+	crypto_unregister_scomp(&scomp);
 }
 
 subsys_initcall(deflate_mod_init);
