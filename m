From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HMAC regression
Date: Sat, 30 May 2009 11:12:23 +1000
Message-ID: <20090530011222.GA19425@gondor.apana.org.au>
References: <1243523348.30487.89.camel@martin.hsr.ch> <20090529061931.GA10003@gondor.apana.org.au> <1243591472.7473.169.camel@martin.hsr.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47765 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753400AbZE3BMX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2009 21:12:23 -0400
Content-Disposition: inline
In-Reply-To: <1243591472.7473.169.camel@martin.hsr.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 29, 2009 at 12:04:32PM +0200, Martin Willi wrote:
> 
> After doing further tests, it seems that this is additionally related to
> User-Mode-Linux and/or it's TUN/TAP network driver. I couldn't reproduce
> the issue on a x64 with e1000. 
> I think the bug is actually in the UML network code, but changing the
> scatterwalk logic by using the hash_walk functions triggered the issue.

Ah, I think I see the problem.  You must getting an sg entry that
crosses a page boundary, rather than two sg entries that both stay
within a page.  These things are very rare, and usually occurs as
a result of SLAB debugging causing kmalloc to return memory that
crosses page boundaries.

Can you see if this patch fixes the problem?

diff --git a/crypto/ahash.c b/crypto/ahash.c
index b2d1ee3..f347637 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -82,10 +82,11 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 	if (err)
 		return err;
 
-	walk->offset = 0;
