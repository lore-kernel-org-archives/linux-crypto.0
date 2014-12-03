From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 0/4] crypto: sahara - SHA support
Date: Wed, 3 Dec 2014 22:34:16 +0800
Message-ID: <20141203143415.GA11336@gondor.apana.org.au>
References: <1417436794-7804-1-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36226 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaLCOeU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Dec 2014 09:34:20 -0500
Content-Disposition: inline
In-Reply-To: <1417436794-7804-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 01, 2014 at 01:26:30PM +0100, Steffen Trumtrar wrote:
> Hi!
> 
> This series adds support for
> 	- i.MX53 support
> 	- SHA1/256
> to the SAHARA driver.
> 
> - Version 4 is a major overhaul of the previous versions.
>   The tasklet/watchdog implementation of the driver is replaced by a kthread
>   and completions. This makes sure, that only one request is queued into
>   the device and makes sure that the requests from user-space processes are
>   correctly enqueued into the queue. This means, that the queue is responsible
>   for sequentializing accesses from userspace.
> 
> - The request is now saved into the sahara_sha_reqctx

All applied to cryptodev.  Nice work Steffen, thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
