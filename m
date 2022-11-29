Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED541C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 09:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiK2JxL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Nov 2022 04:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiK2Jwu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2022 04:52:50 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4009962FB
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 01:52:40 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ozxI3-001ul4-Tz; Tue, 29 Nov 2022 17:52:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Nov 2022 17:52:35 +0800
Date:   Tue, 29 Nov 2022 17:52:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH] crypto: chelsio - Fix flexible struct array warning
Message-ID: <Y4XWY3/uhuRWheUv@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes the sparse warning about arrays of flexible
structures by removing an unnecessary use of them in struct
__crypto_ctx.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 6933546f87b1..9fac1e758406 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -98,17 +98,17 @@ static int chcr_handle_cipher_resp(struct skcipher_request *req,
 
 static inline  struct chcr_aead_ctx *AEAD_CTX(struct chcr_context *ctx)
 {
-	return ctx->crypto_ctx->aeadctx;
+	return &ctx->crypto_ctx->aeadctx;
 }
 
 static inline struct ablk_ctx *ABLK_CTX(struct chcr_context *ctx)
 {
-	return ctx->crypto_ctx->ablkctx;
+	return &ctx->crypto_ctx->ablkctx;
 }
 
 static inline struct hmac_ctx *HMAC_CTX(struct chcr_context *ctx)
 {
-	return ctx->crypto_ctx->hmacctx;
+	return &ctx->crypto_ctx->hmacctx;
 }
 
 static inline struct chcr_gcm_ctx *GCM_CTX(struct chcr_aead_ctx *gctx)
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index c7816c83e324..7f88ddb08631 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -248,9 +248,9 @@ struct hmac_ctx {
 
 struct __crypto_ctx {
 	union {
-		DECLARE_FLEX_ARRAY(struct hmac_ctx, hmacctx);
-		DECLARE_FLEX_ARRAY(struct ablk_ctx, ablkctx);
-		DECLARE_FLEX_ARRAY(struct chcr_aead_ctx, aeadctx);
+		struct hmac_ctx hmacctx;
+		struct ablk_ctx ablkctx;
+		struct chcr_aead_ctx aeadctx;
 	};
 };
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
