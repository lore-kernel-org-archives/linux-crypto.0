Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C05CC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Nov 2022 09:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiKKJ7c (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Nov 2022 04:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiKKJ70 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2022 04:59:26 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1E3B872
        for <linux-crypto@vger.kernel.org>; Fri, 11 Nov 2022 01:59:24 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1otQof-00CyUS-Hz; Fri, 11 Nov 2022 17:59:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Nov 2022 17:59:17 +0800
Date:   Fri, 11 Nov 2022 17:59:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi,
        Kees Cook <keescook@chromium.org>
Subject: crypto: cryptd - Use request context instead of stack for sub-request
Message-ID: <Y24c9WcEpvibbRqo@gondor.apana.org.au>
References: <20221106143627.30920-1-ap420073@gmail.com>
 <20221106143627.30920-2-ap420073@gmail.com>
 <Y2jGTvgHnu4QZV+D@gondor.apana.org.au>
 <51ed3735-24f0-eef0-0ca6-908c4581d143@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ed3735-24f0-eef0-0ca6-908c4581d143@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 09, 2022 at 10:16:58PM +0900, Taehee Yoo wrote:
>
> I have encountered kernel panic(stack-out-of-bounds) while using the reqctx
> instead of the tfm.
> 
> cryptd is used when simd drivers are used.
> cryptd_skcipher_encrypt() internally doesn't allocate a request ctx of a
> child, instead, it uses stack memory with SYNC_SKCIPHER_REQUEST_ON_STACK.
> It retains only 384 bytes for child request ctx even if a child set a large
> reqsize value with crypto_skcipher_set_reqsize().
> aria-avx2 needs 512 bytes and aria-avx512 needs 1024 bytes.
> So, stack-out-of-bounds occurs.

OK this is not supposed to happen.

---8<---
cryptd is buggy as it tries to use sync_skcipher without going
through the proper sync_skcipher interface.  In fact it doesn't
even need sync_skcipher since it's already a proper skcipher and
can easily access the request context instead of using something
off the stack.

Fixes: 36b3875a97b8 ("crypto: cryptd - Remove VLA usage of skcipher")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 668095eca0fa..ca3a40fc7da9 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -68,11 +68,12 @@ struct aead_instance_ctx {
 
 struct cryptd_skcipher_ctx {
 	refcount_t refcnt;
-	struct crypto_sync_skcipher *child;
+	struct crypto_skcipher *child;
 };
 
 struct cryptd_skcipher_request_ctx {
 	crypto_completion_t complete;
+	struct skcipher_request req;
 };
 
 struct cryptd_hash_ctx {
@@ -227,13 +228,13 @@ static int cryptd_skcipher_setkey(struct crypto_skcipher *parent,
 				  const u8 *key, unsigned int keylen)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(parent);
-	struct crypto_sync_skcipher *child = ctx->child;
+	struct crypto_skcipher *child = ctx->child;
 
-	crypto_sync_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(child,
-				       crypto_skcipher_get_flags(parent) &
-					 CRYPTO_TFM_REQ_MASK);
-	return crypto_sync_skcipher_setkey(child, key, keylen);
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child,
+				  crypto_skcipher_get_flags(parent) &
+				  CRYPTO_TFM_REQ_MASK);
+	return crypto_skcipher_setkey(child, key, keylen);
 }
 
 static void cryptd_skcipher_complete(struct skcipher_request *req, int err)
@@ -258,13 +259,13 @@ static void cryptd_skcipher_encrypt(struct crypto_async_request *base,
 	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_sync_skcipher *child = ctx->child;
-	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	struct skcipher_request *subreq = &rctx->req;
+	struct crypto_skcipher *child = ctx->child;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	skcipher_request_set_sync_tfm(subreq, child);
+	skcipher_request_set_tfm(subreq, child);
 	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
@@ -286,13 +287,13 @@ static void cryptd_skcipher_decrypt(struct crypto_async_request *base,
 	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_sync_skcipher *child = ctx->child;
-	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
+	struct skcipher_request *subreq = &rctx->req;
+	struct crypto_skcipher *child = ctx->child;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 
-	skcipher_request_set_sync_tfm(subreq, child);
+	skcipher_request_set_tfm(subreq, child);
 	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      NULL, NULL);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
@@ -343,9 +344,10 @@ static int cryptd_skcipher_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(cipher))
 		return PTR_ERR(cipher);
 
-	ctx->child = (struct crypto_sync_skcipher *)cipher;
+	ctx->child = cipher;
 	crypto_skcipher_set_reqsize(
-		tfm, sizeof(struct cryptd_skcipher_request_ctx));
+		tfm, sizeof(struct cryptd_skcipher_request_ctx) +
+		     crypto_skcipher_reqsize(cipher));
 	return 0;
 }
 
@@ -353,7 +355,7 @@ static void cryptd_skcipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_sync_skcipher(ctx->child);
+	crypto_free_skcipher(ctx->child);
 }
 
 static void cryptd_skcipher_free(struct skcipher_instance *inst)
@@ -931,7 +933,7 @@ struct crypto_skcipher *cryptd_skcipher_child(struct cryptd_skcipher *tfm)
 {
 	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
 
-	return &ctx->child->base;
+	return ctx->child;
 }
 EXPORT_SYMBOL_GPL(cryptd_skcipher_child);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
