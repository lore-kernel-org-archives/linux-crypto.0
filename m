Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64656C54E94
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Jan 2023 07:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjAVHcK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Jan 2023 02:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVHcJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Jan 2023 02:32:09 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323FC13530
        for <linux-crypto@vger.kernel.org>; Sat, 21 Jan 2023 23:32:07 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pJUpf-002juu-Ts; Sun, 22 Jan 2023 15:32:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 22 Jan 2023 15:32:03 +0800
Date:   Sun, 22 Jan 2023 15:32:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>
Subject: [PATCH] crypto: caam - Use ahash_request_complete
Message-ID: <Y8zmcwnwZOIoj8Vs@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of calling the base completion function directly, use the
correct ahash helper which is ahash_request_complete.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 0ddef9a033a1..5c8d35edaa1c 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3419,7 +3419,7 @@ static void ahash_done(void *cbk_ctx, u32 status)
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 			     ctx->ctx_len, 1);
 
-	req->base.complete(&req->base, ecode);
+	ahash_request_complete(req, ecode);
 }
 
 static void ahash_done_bi(void *cbk_ctx, u32 status)
@@ -3457,7 +3457,7 @@ static void ahash_done_bi(void *cbk_ctx, u32 status)
 				     DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 				     crypto_ahash_digestsize(ahash), 1);
 
-	req->base.complete(&req->base, ecode);
+	ahash_request_complete(req, ecode);
 }
 
 static void ahash_done_ctx_src(void *cbk_ctx, u32 status)
@@ -3484,7 +3484,7 @@ static void ahash_done_ctx_src(void *cbk_ctx, u32 status)
 			     DUMP_PREFIX_ADDRESS, 16, 4, state->caam_ctx,
 			     ctx->ctx_len, 1);
 
-	req->base.complete(&req->base, ecode);
+	ahash_request_complete(req, ecode);
 }
 
 static void ahash_done_ctx_dst(void *cbk_ctx, u32 status)
@@ -3522,7 +3522,7 @@ static void ahash_done_ctx_dst(void *cbk_ctx, u32 status)
 				     DUMP_PREFIX_ADDRESS, 16, 4, req->result,
 				     crypto_ahash_digestsize(ahash), 1);
 
-	req->base.complete(&req->base, ecode);
+	ahash_request_complete(req, ecode);
 }
 
 static int ahash_update_ctx(struct ahash_request *req)
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 1f357f48c473..82d3c730a502 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -614,7 +614,7 @@ static inline void ahash_done_cpy(struct device *jrdev, u32 *desc, u32 err,
 	 * by CAAM, not crypto engine.
 	 */
 	if (!has_bklog)
-		req->base.complete(&req->base, ecode);
+		ahash_request_complete(req, ecode);
 	else
 		crypto_finalize_hash_request(jrp->engine, req, ecode);
 }
@@ -676,7 +676,7 @@ static inline void ahash_done_switch(struct device *jrdev, u32 *desc, u32 err,
 	 * by CAAM, not crypto engine.
 	 */
 	if (!has_bklog)
-		req->base.complete(&req->base, ecode);
+		ahash_request_complete(req, ecode);
 	else
 		crypto_finalize_hash_request(jrp->engine, req, ecode);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
