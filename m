From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 5/5] tcrypt: Test algorithms by name
Date: Fri, 19 Jun 2009 18:56:27 +0800
Message-ID: <20090619105627.GA17781@gondor.apana.org.au>
References: <20090608070749.GR20366@secunet.com> <20090608071246.GW20366@secunet.com> <20090619105325.GA17647@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57208 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752390AbZFSK43 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2009 06:56:29 -0400
Content-Disposition: inline
In-Reply-To: <20090619105325.GA17647@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 19, 2009 at 06:53:25PM +0800, Herbert Xu wrote:
> On Mon, Jun 08, 2009 at 09:12:46AM +0200, Steffen Klassert wrote:
> > This adds the 'alg' module parameter to be able to test an
> > algorithm by name. If the algorithm type is not ad-hoc
> > clear for a algorithm (e.g. pcrypt, cryptd) it is possilbe
> > to set the algorithm type with the 'type' module parameter.
> > 
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> 
> I'll apply this one right now.  Thanks!

Oops it doesn't apply anymore.  Could you rebase this one for me?
Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
