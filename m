From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC PATCH] crypto: Make the page handling of hash walk compatible
 to networking.
Date: Thu, 21 Apr 2016 09:14:51 +0200
Message-ID: <20160421071451.GE3347@gauss.secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:44705 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbcDUHOz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Apr 2016 03:14:55 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The network layer tries to allocate high order pages for skb_buff
fragments, this leads to problems if we pass such a buffer to
crypto because crypto assumes to have always order null pages
in the scatterlists.

This was not a problem so far, because the network stack linearized
all buffers before passing them to crypto. If we try to avoid the
linearization with skb_cow_data in IPsec esp4/esp6 this incompatibility
becomes visible.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---

Herbert, I could not find out why this PAGE_SIZE limit is in place.
So not sure if this is the right fix. Also, would it be ok to merge
this, or whatever is the right fix through the IPsec tree? We need
this before we can change esp to avoid linearization.

The full IPsec patchset can be found here:

https://git.kernel.org/cgit/linux/kernel/git/klassert/linux-stk.git/log/?h=net-next-ipsec-offload-work

 crypto/ahash.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 5fc1f17..ca92783 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -44,8 +44,7 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
 {
 	unsigned int alignmask = walk->alignmask;
 	unsigned int offset = walk->offset;
-	unsigned int nbytes = min(walk->entrylen,
-				  ((unsigned int)(PAGE_SIZE)) - offset);
+	unsigned int nbytes = walk->entrylen;
 
 	if (walk->flags & CRYPTO_ALG_ASYNC)
 		walk->data = kmap(walk->pg);
@@ -91,8 +90,6 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 		walk->offset = ALIGN(walk->offset, alignmask + 1);
 		walk->data += walk->offset;
 
-		nbytes = min(nbytes,
-			     ((unsigned int)(PAGE_SIZE)) - walk->offset);
 		walk->entrylen -= nbytes;
 
 		return nbytes;
-- 
1.9.1
