From: Catalin Vasile <cata.vasile@nxp.com>
Subject: Re: [PATCH] crypto: caam: add backlogging support
Date: Wed, 11 May 2016 07:53:19 +0000
Message-ID: <DB5PR04MB130246563C30EB92CDF5B5A1EE720@DB5PR04MB1302.eurprd04.prod.outlook.com>
References: <1462540733-2170-1-git-send-email-cata.vasile@nxp.com>,<20160510094622.GA15860@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-crypto-owner@vger.kernel.org"
	<linux-crypto-owner@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Scott Wood <scott.wood@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0096.outbound.protection.outlook.com ([157.55.234.96]:36218
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751308AbcEKIJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 04:09:24 -0400
In-Reply-To: <20160510094622.GA15860@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> 

> ________________________________________
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Tuesday, May 10, 2016 12:46 PM
> To: Catalin Vasile
> Cc: linux-crypto@vger.kernel.org; linux-crypto-owner@vger.kernel.org; Horia Ioan Geanta Neag; Alexandru Porosanu; Scott Wood; Catalin Vasile
> Subject: Re: [PATCH] crypto: caam: add backlogging support> 

> Catalin Vasile <cata.vasile@nxp.com> wrote:
> > caam_jr_enqueue() function returns -EBUSY once there are no more slots
> > available in the JR, but it doesn't actually save the current request.
> > This breaks the functionality of users that expect that even if there is
> > no more space for the request, it is at least queued for later
> > execution. In other words, all crypto transformations that request
> > backlogging (i.e. have CRYPTO_TFM_REQ_MAY_BACKLOG set), will hang. Such
> > an example is dm-crypt. The current patch solves this issue by setting a
> > threshold after which caam_jr_enqueue() returns -EBUSY, but since the HW
> > job ring isn't actually full, the job is enqueued.
> >
> > Signed-off-by: Alexandru Porosanu <alexandru.porosanu@nxp.com>
> > Tested-by: Catalin Vasile <cata.vasile@nxp.com>> 

> This is not acceptable.  The request that triggers EBUSY must
> be allowed to queue.  As the number of tfms is unlimited you
> can't just put them onto the hardware queue and hope that it
> works out.>
Every request will be queued and eventually done.
The hardware equipment has a constraint on the number of tfms it can have.
Is there a requirement to support an infinite number of tfms on a device?

> You should use a software queue instead.> 

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
