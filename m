From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] crypto: sahara - add support for SHA1/256
Date: Fri, 24 Oct 2014 21:41:27 +0800
Message-ID: <20141024134127.GA19583@gondor.apana.org.au>
References: <1412606625-828-1-git-send-email-s.trumtrar@pengutronix.de>
 <1412606625-828-3-git-send-email-s.trumtrar@pengutronix.de>
 <20141007020201.GA27094@gondor.apana.org.au>
 <20141007064705.GB16666@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56343 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbaJXNle (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 09:41:34 -0400
Content-Disposition: inline
In-Reply-To: <20141007064705.GB16666@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 07, 2014 at 08:47:05AM +0200, Steffen Trumtrar wrote:
>
> > This is still wrong since the context needs to be stored in the
> > request.  Otherwise multiple requests will corrupt each other's
> > state.
> > 
> 
> :-( Okay.
> 
> What would I have to do to test if it works correctly?
> 
> I tested this with AF_ALG from userspace and opened two file descriptors
> and wrote to them in turns. Wouldn't that produce multiple requests?

It should if you're not finalising the result.  Can you show me
your test program?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
