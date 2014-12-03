From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v4 0/4] crypto: sahara - SHA support
Date: Wed, 3 Dec 2014 17:03:35 +0100
Message-ID: <20141203160335.GA4652@pengutronix.de>
References: <1417436794-7804-1-git-send-email-s.trumtrar@pengutronix.de>
 <20141203143415.GA11336@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49398 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaLCQDl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2014 11:03:41 -0500
Content-Disposition: inline
In-Reply-To: <20141203143415.GA11336@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 03, 2014 at 10:34:16PM +0800, Herbert Xu wrote:
> On Mon, Dec 01, 2014 at 01:26:30PM +0100, Steffen Trumtrar wrote:
> > Hi!
> > 
> > This series adds support for
> > 	- i.MX53 support
> > 	- SHA1/256
> > to the SAHARA driver.
> > 
> > - Version 4 is a major overhaul of the previous versions.
> >   The tasklet/watchdog implementation of the driver is replaced by a kthread
> >   and completions. This makes sure, that only one request is queued into
> >   the device and makes sure that the requests from user-space processes are
> >   correctly enqueued into the queue. This means, that the queue is responsible
> >   for sequentializing accesses from userspace.
> > 
> > - The request is now saved into the sahara_sha_reqctx
> 
> All applied to cryptodev.  Nice work Steffen, thanks!

\o/

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
