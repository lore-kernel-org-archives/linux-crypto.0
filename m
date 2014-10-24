From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 2/2] crypto: sahara - add support for SHA1/256
Date: Fri, 24 Oct 2014 16:13:58 +0200
Message-ID: <20141024141358.GP10262@pengutronix.de>
References: <1412606625-828-1-git-send-email-s.trumtrar@pengutronix.de>
 <1412606625-828-3-git-send-email-s.trumtrar@pengutronix.de>
 <20141007020201.GA27094@gondor.apana.org.au>
 <20141007064705.GB16666@pengutronix.de>
 <20141024134127.GA19583@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48785 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJXOOH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 10:14:07 -0400
Content-Disposition: inline
In-Reply-To: <20141024134127.GA19583@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

On Fri, Oct 24, 2014 at 09:41:27PM +0800, Herbert Xu wrote:
> On Tue, Oct 07, 2014 at 08:47:05AM +0200, Steffen Trumtrar wrote:
> >
> > > This is still wrong since the context needs to be stored in the
> > > request.  Otherwise multiple requests will corrupt each other's
> > > state.
> > > 
> > 
> > :-( Okay.
> > 
> > What would I have to do to test if it works correctly?
> > 
> > I tested this with AF_ALG from userspace and opened two file descriptors
> > and wrote to them in turns. Wouldn't that produce multiple requests?
> 
> It should if you're not finalising the result.  Can you show me
> your test program?
> 

In the mean time I worked on the code a bit more and will send out a v3 in
a second. And I think I now understand your concern and have already
changed the code accordingly.

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
