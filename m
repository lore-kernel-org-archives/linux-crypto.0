From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/5] crypto: Fully restore ahash request before completing
Date: Fri, 27 Dec 2013 01:21:36 +0100
Message-ID: <201312270121.36578.marex@denx.de>
References: <1386703583-8386-1-git-send-email-marex@denx.de> <20131220120408.GA31738@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:44159 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3L0Cmf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Dec 2013 21:42:35 -0500
In-Reply-To: <20131220120408.GA31738@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, December 20, 2013 at 01:04:08 PM, Herbert Xu wrote:
> On Tue, Dec 10, 2013 at 08:26:19PM +0100, Marek Vasut wrote:
> > When finishing the ahash request, the ahash_op_unaligned_done() will
> > call complete() on the request. Yet, this will not call the correct
> > complete callback. The correct complete callback was previously stored
> > in the requests' private data, as seen in ahash_op_unaligned(). This
> > patch restores the correct complete callback and .data field of the
> > request before calling complete() on it.
> > 
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Fabio Estevam <fabio.estevam@freescale.com>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: linux-crypto@vger.kernel.org
> > ---
> > 
> >  crypto/ahash.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/crypto/ahash.c b/crypto/ahash.c
> > index 793a27f..a92dc38 100644
> > --- a/crypto/ahash.c
> > +++ b/crypto/ahash.c
> > @@ -213,7 +213,10 @@ static void ahash_op_unaligned_done(struct
> > crypto_async_request *req, int err)
> > 
> >  	ahash_op_unaligned_finish(areq, err);
> > 
> > -	complete(data, err);
> > +	areq->base.complete = complete;
> > +	areq->base.data = data;
> > +
> > +	complete(&areq->base, err);
> 
> This looks completely bogus.  While restoring areq isn't wrong per
> se, calling complete with &areq->base makes no sense.  The original
> completion data is in the variable "data".

Is there some documentation for this so I can understand why this is wrong, 
please? I really don't quite get it, sorry. Actually, is there some 
documentation for writing crypto API drivers at all please ?

> Which driver relies on this behaviour?

This one.

> Also, does your subsequent patches rely on this?

Yes

> Cheers,

Best regards,
Marek Vasut
