From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 2/2] crypto: sahara - add support for SHA1/256
Date: Tue, 7 Oct 2014 08:47:05 +0200
Message-ID: <20141007064705.GB16666@pengutronix.de>
References: <1412606625-828-1-git-send-email-s.trumtrar@pengutronix.de>
 <1412606625-828-3-git-send-email-s.trumtrar@pengutronix.de>
 <20141007020201.GA27094@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38501 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJGGrO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Oct 2014 02:47:14 -0400
Content-Disposition: inline
In-Reply-To: <20141007020201.GA27094@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

On Tue, Oct 07, 2014 at 10:02:01AM +0800, Herbert Xu wrote:
> On Mon, Oct 06, 2014 at 04:43:45PM +0200, Steffen Trumtrar wrote:
> > Add support for the MDHA unit in the SAHARA core.
> > The MDHA can generate hash digests for MD5 and SHA1 in version 3 and
> > additionally SHA224 and SHA256 in version 4.
> > 
> > Add the SHA1 and SHA256 algorithms to the driver.
> > 
> > The implementation was tested with the in-kernel testmgr on i.MX27 and
> > i.MX53.
> > 
> > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > ---
> > Changes since v1:
> > 	- save context in the sahara_ctx struct
> 
> This is still wrong since the context needs to be stored in the
> request.  Otherwise multiple requests will corrupt each other's
> state.
> 

:-( Okay.

What would I have to do to test if it works correctly?

I tested this with AF_ALG from userspace and opened two file descriptors
and wrote to them in turns. Wouldn't that produce multiple requests?

> Also please implement export/import.
> 

I will have to look into that.

Thank you for you review.
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
