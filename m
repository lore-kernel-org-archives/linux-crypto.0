From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] crypto: eseqiv - fix IV generation for sync algorithms
Date: Wed, 15 Apr 2009 14:19:02 +0200
Message-ID: <20090415121902.GO6791@secunet.com>
References: <20090414132351.GN6791@secunet.com> <20090415111549.GA10128@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:53563 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbZDOMRD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Apr 2009 08:17:03 -0400
Content-Disposition: inline
In-Reply-To: <20090415111549.GA10128@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 15, 2009 at 07:15:49PM +0800, Herbert Xu wrote:
> 
> Well caught! Clearly no one has ever tried this before :)
> 

I thought so :)

> 
> So how about doing what seqiv does and check
> 
> 	if (giv != req->giv)
> 

Yes, that's probaply the better check.
An updated patch is below.


crypto: eseqiv - fix IV generation for sync algorithms

If crypto_ablkcipher_encrypt() returns synchronous,
eseqiv_complete2() is called even if req->giv is already the
pointer to the generated IV. The generated IV is overwritten
with some random data in this case. This patch fixes this by
calling eseqiv_complete2() just if the generated IV has to be
copied to req->giv.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/eseqiv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index 2a342c8..3ca3b66 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -153,7 +153,8 @@ static int eseqiv_givencrypt(struct skcipher_givcrypt_request *req)
 	if (err)
 		goto out;
 
-	eseqiv_complete2(req);
+	if (giv != req->giv)
+		eseqiv_complete2(req);
 
 out:
 	return err;
-- 
1.5.4.2

