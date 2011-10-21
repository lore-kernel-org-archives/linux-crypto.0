From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 00/17] crypto user configuration api
Date: Fri, 21 Oct 2011 14:38:37 +0200
Message-ID: <20111021123837.GC17486@gondor.apana.org.au>
References: <20110927052050.GB1808@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:50064 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab1JUMil (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Oct 2011 08:38:41 -0400
Content-Disposition: inline
In-Reply-To: <20110927052050.GB1808@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 27, 2011 at 07:20:50AM +0200, Steffen Klassert wrote:
> This patchset adds a netlink based user configuration API for the crypto
> layer, similar to the configuration API of xfrm.

All applied to cryptodev.  Thanks!

I added this little fix on top:

commit e6ea64ece7f4c14294b2fce5403b1e71eab87f1e
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Oct 21 14:37:10 2011 +0200

    crypto: user - Initialise match in crypto_alg_match
    
    We need to default match to 0 as otherwise it may lead to a false
    positive.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 748990f..2abca78 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -40,7 +40,6 @@ struct crypto_dump_info {
 
 static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 {
-	int match;
 	struct crypto_alg *q, *alg = NULL;
 
 	down_read(&crypto_alg_sem);
@@ -49,6 +48,7 @@ static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact)
 		return NULL;
 
 	list_for_each_entry(q, &crypto_alg_list, cra_list) {
+		int match = 0;
 
 		if ((q->cra_flags ^ p->cru_type) & p->cru_mask)
 			continue;

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
