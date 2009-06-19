From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] tcrypt: Test algorithms by name
Date: Fri, 19 Jun 2009 19:47:37 +0800
Message-ID: <20090619114737.GC17647@gondor.apana.org.au>
References: <20090608070749.GR20366@secunet.com> <20090608071246.GW20366@secunet.com> <20090619105325.GA17647@gondor.apana.org.au> <20090619105627.GA17781@gondor.apana.org.au> <20090619114058.GY20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38271 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751724AbZFSLrk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2009 07:47:40 -0400
Content-Disposition: inline
In-Reply-To: <20090619114058.GY20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2009 at 01:40:58PM +0200, Steffen Klassert wrote:
> This adds the 'alg' module parameter to be able to test an
> algorithm by name. If the algorithm type is not ad-hoc
> clear for a algorithm (e.g. pcrypt, cryptd) it is possilbe
> to set the algorithm type with the 'type' module parameter.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

That was quick :)

Patch applied.  Thanks a lot Steffen!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
