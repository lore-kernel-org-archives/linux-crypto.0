Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386D6C636D7
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Feb 2023 03:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBMDKT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Feb 2023 22:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjBMDKS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Feb 2023 22:10:18 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0309EFC
        for <linux-crypto@vger.kernel.org>; Sun, 12 Feb 2023 19:10:12 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pRPED-00ARdr-2s; Mon, 13 Feb 2023 11:10:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Feb 2023 11:10:05 +0800
Date:   Mon, 13 Feb 2023 11:10:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: acomp - Be more careful with request flags
Message-ID: <Y+mqDZBCjnVjRKUk@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The request flags for acompress is split into two parts.  Part of
it may be set by the user while the other part (ALLOC_OUTPUT) is
managed by the API.

This patch makes the split more explicit by not touching the other
bits at all in the two "set" functions that let the user modify the
flags.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e4bc96528902..c14cfc9a3b79 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -219,7 +219,8 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 {
 	req->base.complete = cmpl;
 	req->base.data = data;
-	req->base.flags = flgs;
+	req->base.flags &= CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags |= flgs & ~CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
 /**
@@ -246,6 +247,7 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 	req->slen = slen;
 	req->dlen = dlen;
 
+	req->flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
 	if (!req->dst)
 		req->flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
