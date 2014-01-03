From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 1/5] crypto: Fully restore ahash request before completing
Date: Fri, 3 Jan 2014 09:10:30 -0600
Message-ID: <10214668.cztjge9Iie@tlendack-t1>
References: <1386703583-8386-1-git-send-email-marex@denx.de> <201312270121.36578.marex@denx.de> <20131230090112.GA8550@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Marek Vasut <marex@denx.de>,
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:17502
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbaACPKl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jan 2014 10:10:41 -0500
In-Reply-To: <20131230090112.GA8550@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, December 30, 2013 05:01:13 PM Herbert Xu wrote:
> On Fri, Dec 27, 2013 at 01:21:36AM +0100, Marek Vasut wrote:
> >
> > > > -	complete(data, err);
> > > > +	areq->base.complete = complete;
> > > > +	areq->base.data = data;
> > > > +
> > > > +	complete(&areq->base, err);
> > > 
> > > This looks completely bogus.  While restoring areq isn't wrong per
> > > se, calling complete with &areq->base makes no sense.  The original
> > > completion data is in the variable "data".
> > 
> > Is there some documentation for this so I can understand why this is wrong, 
> > please? I really don't quite get it, sorry. Actually, is there some 
> > documentation for writing crypto API drivers at all please ?
> 
> Well it's wrong because the completion function (req->base.complete)
> is meant to take data (req->base.data) as its first argument.  So
> giving it a pointer to req->base makes no sense.
> 

The crypto_completion_t typdef is defined as:

typedef void (*crypto_completion_t)(struct crypto_async_request *req, int err);

so I believe &areq->base is the proper first argument (which is actually just
the req parameter on the ahash_op_unaligned_done function).

If you are going to restore areq, you really should restore all fields that
were changed - result, base.complete, base.data - and set priv to NULL.

Since the ahash_request_priv structure is freed in ahash_op_unaligned_finish
you'll need to save the value of priv->result in order to restore areq->result
(u8 *result = priv->result; or similar).

Additionally, you should probably also fix up ahash_def_finup_done2 and
ahash_def_finup_done1.

Thanks,
Tom

> Cheers,
> 
