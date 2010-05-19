From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] crypto: Fix scatterwalk_done() test.
Date: Wed, 19 May 2010 14:05:13 +1000
Message-ID: <20100519040513.GC20887@gondor.apana.org.au>
References: <20100517.222237.232897853.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:43181 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738Ab0ESEFQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 00:05:16 -0400
Content-Disposition: inline
In-Reply-To: <20100517.222237.232897853.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 17, 2010 at 10:22:37PM -0700, David Miller wrote:
> 
> We are done with the scattergather entry when the walk offset goes
> past sg->offset + sg->length, not when it crosses a page boundary.

Thanks for catching this!

> There is a similarly queer test in the second half of
> scatterwalk_pagedone() that probably needs some scrutiny.

I double-checked that one but can't see any problems yet.
 
> diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
> index 3de89a4..b3acf4f 100644
> --- a/crypto/scatterwalk.c
> +++ b/crypto/scatterwalk.c
> @@ -68,7 +68,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
>  
>  void scatterwalk_done(struct scatter_walk *walk, int out, int more)
>  {
> -	if (!offset_in_page(walk->offset) || !more)
> +	if (walk->offset >= walk->sg->offset + walk->sg->length || !more)
>  		scatterwalk_pagedone(walk, out, more);

I think we need to keep the original test as well as otherwise
if we hit a page boundary while the sg spans over a page (that
can happen with a linearised jumbo skb->head for example) then
we'd be screwed.

So I'm going to commit this patch instead.  Let me know if you
see any other issues with it.

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 3de89a4..41e529a 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -68,7 +68,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 
 void scatterwalk_done(struct scatter_walk *walk, int out, int more)
 {
-	if (!offset_in_page(walk->offset) || !more)
+	if (!(scatterwalk_pagelen(walk) & (PAGE_SIZE - 1)) || !more)
 		scatterwalk_pagedone(walk, out, more);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_done);

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
