From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5] crypto: Fully restore ahash request before completing
Date: Mon, 30 Dec 2013 17:01:13 +0800
Message-ID: <20131230090112.GA8550@gondor.apana.org.au>
References: <1386703583-8386-1-git-send-email-marex@denx.de>
 <20131220120408.GA31738@gondor.apana.org.au>
 <201312270121.36578.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>, linux-crypto@vger.kernel.org
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:60617 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3L3JBo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Dec 2013 04:01:44 -0500
Content-Disposition: inline
In-Reply-To: <201312270121.36578.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 27, 2013 at 01:21:36AM +0100, Marek Vasut wrote:
>
> > > -	complete(data, err);
> > > +	areq->base.complete = complete;
> > > +	areq->base.data = data;
> > > +
> > > +	complete(&areq->base, err);
> > 
> > This looks completely bogus.  While restoring areq isn't wrong per
> > se, calling complete with &areq->base makes no sense.  The original
> > completion data is in the variable "data".
> 
> Is there some documentation for this so I can understand why this is wrong, 
> please? I really don't quite get it, sorry. Actually, is there some 
> documentation for writing crypto API drivers at all please ?

Well it's wrong because the completion function (req->base.complete)
is meant to take data (req->base.data) as its first argument.  So
giving it a pointer to req->base makes no sense.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
