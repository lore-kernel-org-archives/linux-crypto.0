From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [QUESTION] How is the backlog supposed to be used?
Date: Fri, 12 Dec 2014 00:15:51 +1100
Message-ID: <20141211131551.GA13037@gondor.apana.org.au>
References: <20141201131255.GG6184@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40207 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLKNP5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Dec 2014 08:15:57 -0500
Content-Disposition: inline
In-Reply-To: <20141201131255.GG6184@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:
>
> Everything works fine if I do not complete the request from the
> backlog, but instead complete the request when it is due.
> Alternative: make the queue deeper like some drivers have it.
> If the queue is deeper than I have threads, it works, because
> the requests never get onto the backlog.
> So, how is the queue intended to be used? What is a correct max_depth?

The queue depth is up to the driver to determine.

> Do I need to complete the requests from the backlog or not?

Completing the backlog with EINPROGRESS is meant to indicate
to the caller of the crypto API that we're now open to more
requests.

What crypto API user were you using to test this?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
