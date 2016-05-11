From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam: add backlogging support
Date: Wed, 11 May 2016 18:54:11 +0800
Message-ID: <20160511105411.GB25016@gondor.apana.org.au>
References: <1462540733-2170-1-git-send-email-cata.vasile@nxp.com>
 <20160510094622.GA15860@gondor.apana.org.au>
 <DB5PR04MB130246563C30EB92CDF5B5A1EE720@DB5PR04MB1302.eurprd04.prod.outlook.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:45870 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbcEKKyQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 06:54:16 -0400
Content-Disposition: inline
In-Reply-To: <DB5PR04MB130246563C30EB92CDF5B5A1EE720@DB5PR04MB1302.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 11, 2016 at 07:53:19AM +0000, Catalin Vasile wrote:
>
> Every request will be queued and eventually done.
> The hardware equipment has a constraint on the number of tfms it can have.
> Is there a requirement to support an infinite number of tfms on a device?
> 
> > You should use a software queue instead.> 

As I said you drivers are always supposed to have a software queue
in addition to any hardware queues.  There is no reason why your
driver should be special in this regard.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
