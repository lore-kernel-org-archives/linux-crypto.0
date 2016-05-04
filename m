From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2] crypto: hash - Fix page length clamping in hash walk
Date: Wed, 4 May 2016 17:52:56 +0800
Message-ID: <20160504095256.GA27632@gondor.apana.org.au>
References: <20160421071451.GE3347@gauss.secunet.com>
 <20160425100527.GA9521@gondor.apana.org.au>
 <20160428082743.GO3347@gauss.secunet.com>
 <20160503095531.GA18007@gondor.apana.org.au>
 <20160504093420.GB3347@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
	linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44302 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbcEDJxI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 05:53:08 -0400
Content-Disposition: inline
In-Reply-To: <20160504093420.GB3347@gauss.secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 04, 2016 at 11:34:20AM +0200, Steffen Klassert wrote:
> 
> Hmm, the 'sleeping while atomic' because of not unmapping
> the page goes away, but now I see a lot of IPsec ICV fails
> on the receive side. I'll try to find out what's going on.
> 
> Sowmini, could you please doublecheck with your test setup?

Don't bother, my patch was crap.  Here's one that's more likely
to work:

---8<---
The crypto hash walk code is broken when supplied with an offset
greater than or equal to PAGE_SIZE.  This patch fixes it by adjusting
walk->pg and walk->offset when this happens.

Cc: <stable@vger.kernel.org>
Reported-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 5fc1f17..3887a98 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -69,8 +69,9 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 	struct scatterlist *sg;
 
 	sg = walk->sg;
-	walk->pg = sg_page(sg);
 	walk->offset = sg->offset;
+	walk->pg = sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
+	walk->offset = offset_in_page(walk->offset);
 	walk->entrylen = sg->length;
 
 	if (walk->entrylen > walk->total)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
