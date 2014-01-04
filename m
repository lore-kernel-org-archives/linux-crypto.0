From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/5] crypto: Fully restore ahash request before completing
Date: Sat, 4 Jan 2014 08:20:09 +0100
Message-ID: <201401040820.09129.marex@denx.de>
References: <1386703583-8386-1-git-send-email-marex@denx.de> <10214668.cztjge9Iie@tlendack-t1> <20140103223344.GA15394@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:41166 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaADKOD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 4 Jan 2014 05:14:03 -0500
In-Reply-To: <20140103223344.GA15394@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, January 03, 2014 at 11:33:44 PM, Herbert Xu wrote:
> On Fri, Jan 03, 2014 at 09:10:30AM -0600, Tom Lendacky wrote:
> > On Monday, December 30, 2013 05:01:13 PM Herbert Xu wrote:
> > > On Fri, Dec 27, 2013 at 01:21:36AM +0100, Marek Vasut wrote:
> > > > > > -	complete(data, err);
> > > > > > +	areq->base.complete = complete;
> > > > > > +	areq->base.data = data;
> > > > > > +
> > > > > > +	complete(&areq->base, err);
> > > > > 
> > > > > This looks completely bogus.  While restoring areq isn't wrong per
> > > > > se, calling complete with &areq->base makes no sense.  The original
> > > > > completion data is in the variable "data".
> > > > 
> > > > Is there some documentation for this so I can understand why this is
> > > > wrong, please? I really don't quite get it, sorry. Actually, is
> > > > there some documentation for writing crypto API drivers at all
> > > > please ?
> > > 
> > > Well it's wrong because the completion function (req->base.complete)
> > > is meant to take data (req->base.data) as its first argument.  So
> > > giving it a pointer to req->base makes no sense.
> > 
> > The crypto_completion_t typdef is defined as:
> > 
> > typedef void (*crypto_completion_t)(struct crypto_async_request *req, int
> > err);
> > 
> > so I believe &areq->base is the proper first argument (which is actually
> > just the req parameter on the ahash_op_unaligned_done function).
> 
> You are right.  This unaligned code obviously has never worked.
> I will apply Marek's patch to fix this up.
> 
> > Additionally, you should probably also fix up ahash_def_finup_done2 and
> > ahash_def_finup_done1.
> 
> Yep I'll fix them up too.

I'll try to cook some patches shortly, I will probably also cook some 
documentation for writing drivers using the crypto API, what do you say ?

Best regards,
Marek Vasut
