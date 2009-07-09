From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 3/3] crypto: hmac - convert to ahash
Date: Thu, 9 Jul 2009 12:48:14 +0800
Message-ID: <20090709044814.GA20890@gondor.apana.org.au>
References: <20090707072343.GC20288@secunet.com> <20090707072658.GF20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47635 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908AbZGIEsS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:48:18 -0400
Content-Disposition: inline
In-Reply-To: <20090707072658.GF20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 07, 2009 at 09:26:58AM +0200, Steffen Klassert wrote:
> This converts hmac to the new ahash frontend.
> Also the hashing of the ipaded and opaded key is done now with the
> setkey function, this saves some bytes of hashing on each request.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

This looks pretty good!

I'll come back to it once we start the ahash conversion.

For now I've cherry-picked the import/export bit (although not
in its exact form).

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
