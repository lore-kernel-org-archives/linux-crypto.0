From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto/des.c cleanups for review
Date: Fri, 17 Nov 2006 16:20:23 +1100
Message-ID: <20061117052023.GB18592@gondor.apana.org.au>
References: <20061116070516.31107.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:29956 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1162116AbWKQFUb
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Nov 2006 00:20:31 -0500
To: linux@horizon.com
Content-Disposition: inline
In-Reply-To: <20061116070516.31107.qmail@science.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 16, 2006 at 02:05:16AM -0500, linux@horizon.com wrote:
> I sent this to <da@osvik.no> on Nov. 1, but have received no response.
> Is anyone interested?  The changes are all mixed up together, but I can
> break them apart into a patch series if desired.

Yes breaking them into more related chunks would be good (although
it is also good to not go overboard with too many one-liners :)
 
> (All placed in the public domain if you want to use them.)

I'm sorry but I'm going to need a sign-off here (as per
Documentation/SubmittingPatches).

> -	memcpy(dctx->expkey, tmp, sizeof(dctx->expkey));
> +	memcpy(dctx->expkey, tmp, sizeof dctx->expkey);

Please keep the brackets as that is the predominant kernel style.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
