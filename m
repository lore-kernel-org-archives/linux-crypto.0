From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] padata: generic interface for parallel processing
Date: Sat, 19 Sep 2009 16:19:59 -0700
Message-ID: <20090919231958.GA8097@gondor.apana.org.au>
References: <20090831091145.GB32705@secunet.com> <20090831091249.GC32705@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36341 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752769AbZISXUD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Sep 2009 19:20:03 -0400
Content-Disposition: inline
In-Reply-To: <20090831091249.GC32705@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 31, 2009 at 11:12:49AM +0200, Steffen Klassert wrote:
> This patch introduces an interface to process data objects
> in parallel. On request it is possible to serialize again.
> The parallelized objects return after serialization in the
> same order as they were before the parallelization.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Looks good to me.  Dave, do you want to pick this one up?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
