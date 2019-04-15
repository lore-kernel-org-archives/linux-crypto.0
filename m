Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602CCC10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 06:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3693C20825
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 06:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbfDOGhg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 02:37:36 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:59616 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfDOGhg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 02:37:36 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hFvFG-0003ZZ-BO; Mon, 15 Apr 2019 14:37:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hFvFG-00042Y-46; Mon, 15 Apr 2019 14:37:34 +0800
Date:   Mon, 15 Apr 2019 14:37:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     linux-crypto@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>
Subject: [v2 PATCH] crypto: lrw - Fix atomic sleep when walking skcipher
Message-ID: <20190415063733.ayphuy72sasongdr@gondor.apana.org.au>
References: <20190414120743.7fy2jckdytdscj72@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190414120743.7fy2jckdytdscj72@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When we perform a walk in the completion function, we need to ensure
that it is atomic.

Fixes: ac3c8f36c31d ("crypto: lrw - Do not use auxiliary buffer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 0430ccd08728..08a0e458bc3e 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -212,8 +212,12 @@ static void crypt_done(struct crypto_async_request *areq, int err)
 {
 	struct skcipher_request *req = areq->data;
 
-	if (!err)
+	if (!err) {
+		struct rctx *rctx = skcipher_request_ctx(req);
+
+		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 		err = xor_tweak_post(req);
+	}
 
 	skcipher_request_complete(req, err);
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
