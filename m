From: Catalin Vasile <cata.vasile@nxp.com>
Subject: Re: [PATCH] crypto: caam: add backlogging support
Date: Fri, 13 May 2016 12:55:09 +0000
Message-ID: <DB5PR04MB1302B3363939FD8E0FD6BBB2EE740@DB5PR04MB1302.eurprd04.prod.outlook.com>
References: <1462540733-2170-1-git-send-email-cata.vasile@nxp.com>
 <20160510094622.GA15860@gondor.apana.org.au>
 <DB5PR04MB130246563C30EB92CDF5B5A1EE720@DB5PR04MB1302.eurprd04.prod.outlook.com>,<20160511105411.GB25016@gondor.apana.org.au>
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
Received: from mail-db3on0066.outbound.protection.outlook.com ([157.55.234.66]:1281
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932127AbcEMNK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 May 2016 09:10:59 -0400
In-Reply-To: <20160511105411.GB25016@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> ________________________________________
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Wednesday, May 11, 2016 1:54 PM
> To: Catalin Vasile
> Cc: linux-crypto@vger.kernel.org; linux-crypto-owner@vger.kernel.org; Horia Ioan Geanta Neag; Alexandru Porosanu; Scott Wood
> Subject: Re: [PATCH] crypto: caam: add backlogging support> 

> On Wed, May 11, 2016 at 07:53:19AM +0000, Catalin Vasile wrote:
> >
> > Every request will be queued and eventually done.
> > The hardware equipment has a constraint on the number of tfms it can have.
> > Is there a requirement to support an infinite number of tfms on a device?
> >
> > > You should use a software queue instead.>> 

> As I said you drivers are always supposed to have a software queue
> in addition to any hardware queues.  There is no reason why your
> driver should be special in this regard.>

Hi Herbert,

We are inclining towards a hardware backlogging solution because on
low end devices the software queue does not scale very well.
Regarding your concerns, we are now evaluating adding a software queue based
fallback solution: if the hardware backlogging fails because no hardware slots
are available, backlog the job inside a crypto software queue.
Is this hybrid configurable solution acceptable? Namely, if the hardware queue
is full, to fallback to the crypto software queue.

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
