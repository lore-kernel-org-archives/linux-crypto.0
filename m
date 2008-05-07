From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] cryptd: Fix EINPROGRESS notification context
Date: Wed, 7 May 2008 21:40:43 +0800
Message-ID: <20080507134043.GA27580@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44953 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751904AbYEGNkq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 09:40:46 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1Jtjsy-00058M-5C
	for <linux-crypto@vger.kernel.org>; Wed, 07 May 2008 23:40:44 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1Jtjsx-0007BB-00
	for <linux-crypto@vger.kernel.org>; Wed, 07 May 2008 21:40:43 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

While merging the ahash patch I found this buglet in cryptd.

commit 34fe02eec1cf26f67070588a63252ca7a38c55c2
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed May 7 21:10:13 2008 +0800

    [CRYPTO] cryptd: Fix EINPROGRESS notification context
    
    The EINPROGRESS notifications should be done just like the final
    call-backs, i.e., with BH off.  This patch fixes the call in cryptd
    since previously it was called with BH on.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index b150de5..f38e147 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -82,10 +82,8 @@ static void cryptd_blkcipher_crypt(struct ablkcipher_request *req,
 
 	rctx = ablkcipher_request_ctx(req);
 
-	if (unlikely(err == -EINPROGRESS)) {
-		rctx->complete(&req->base, err);
-		return;
-	}
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
 
 	desc.tfm = child;
 	desc.info = req->info;
@@ -95,8 +93,9 @@ static void cryptd_blkcipher_crypt(struct ablkcipher_request *req,
 
 	req->base.complete = rctx->complete;
 
+out:
 	local_bh_disable();
-	req->base.complete(&req->base, err);
+	rctx->complete(&req->base, err);
 	local_bh_enable();
 }

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
