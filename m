From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam: add backlogging support
Date: Fri, 13 May 2016 21:50:13 +0800
Message-ID: <20160513135013.GA16190@gondor.apana.org.au>
References: <1462540733-2170-1-git-send-email-cata.vasile@nxp.com>
 <20160510094622.GA15860@gondor.apana.org.au>
 <DB5PR04MB130246563C30EB92CDF5B5A1EE720@DB5PR04MB1302.eurprd04.prod.outlook.com>
 <20160511105411.GB25016@gondor.apana.org.au>
 <DB5PR04MB1302B3363939FD8E0FD6BBB2EE740@DB5PR04MB1302.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-crypto-owner@vger.kernel.org"
	<linux-crypto-owner@vger.kernel.org>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Scott Wood <scott.wood@nxp.com>
To: Catalin Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46206 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbcEMNuS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 May 2016 09:50:18 -0400
Content-Disposition: inline
In-Reply-To: <DB5PR04MB1302B3363939FD8E0FD6BBB2EE740@DB5PR04MB1302.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 13, 2016 at 12:55:09PM +0000, Catalin Vasile wrote:
> 
> We are inclining towards a hardware backlogging solution because on
> low end devices the software queue does not scale very well.
> Regarding your concerns, we are now evaluating adding a software queue based
> fallback solution: if the hardware backlogging fails because no hardware slots
> are available, backlog the job inside a crypto software queue.
> Is this hybrid configurable solution acceptable? Namely, if the hardware queue
> is full, to fallback to the crypto software queue.

It is but you need to be very careful so as to not introduce
reordering.

Essentially if you go to the fallback then you have to wait for
all the outstanding requests to complete before you complete the
fallback request.

A number of existing drivers that make use of fallbacks get this
wrong and we need to fix them.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
