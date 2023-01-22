Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D2DC25B4E
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Jan 2023 08:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjAVIHm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Jan 2023 03:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAVIHm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Jan 2023 03:07:42 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430B63C08
        for <linux-crypto@vger.kernel.org>; Sun, 22 Jan 2023 00:07:40 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pJVO5-002kCF-Hr; Sun, 22 Jan 2023 16:07:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 22 Jan 2023 16:07:37 +0800
Date:   Sun, 22 Jan 2023 16:07:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [v2 PATCH] crypto: xts - Handle EBUSY correctly
Message-ID: <Y8zuyRTzvwNONaqw@gondor.apana.org.au>
References: <Y8kInrsuWybCTgK0@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8kInrsuWybCTgK0@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v2 fixes a typo in the commit message.

---8<---
As it is xts only handles the special return value of EINPROGRESS,
which means that in all other cases it will free data related to the
request.

However, as the caller of xts may specify MAY_BACKLOG, we also need
to expect EBUSY and treat it in the same way.  Otherwise backlogged
requests will trigger a use-after-free.

Fixes: 8083b1bf8163 ("crypto: xts - add support for ciphertext stealing")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/crypto/xts.c b/crypto/xts.c
index 63c85b9e64e0..de6cbcf69bbd 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -203,12 +203,12 @@ static void xts_encrypt_done(struct crypto_async_request *areq, int err)
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
-		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 		err = xts_xor_tweak_post(req, true);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
 			err = xts_cts_final(req, crypto_skcipher_encrypt);
-			if (err == -EINPROGRESS)
+			if (err == -EINPROGRESS || err == -EBUSY)
 				return;
 		}
 	}
@@ -223,12 +223,12 @@ static void xts_decrypt_done(struct crypto_async_request *areq, int err)
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
-		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 		err = xts_xor_tweak_post(req, false);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
 			err = xts_cts_final(req, crypto_skcipher_decrypt);
-			if (err == -EINPROGRESS)
+			if (err == -EINPROGRESS || err == -EBUSY)
 				return;
 		}
 	}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
