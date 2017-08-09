From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v1] crypto: caam - set hwrng quality level
Date: Wed, 9 Aug 2017 12:56:45 +0800
Message-ID: <20170809045645.GA30804@gondor.apana.org.au>
References: <20170719074458.9247-1-o.rempel@pengutronix.de>
 <VI1PR0401MB2591B52EB2EF7B7B900FBCC998A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719163248.sn7mvnq2s3fm2hvh@pengutronix.de>
 <VI1PR0401MB25917848BA4AF6626E8DF1AD98A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719181303.rj4fyjj7qplatrzk@pengutronix.de>
 <4e42d639-9f83-dcbb-9a2a-91686656c7dd@linux.vnet.ibm.com>
 <VI1PR0401MB25914FE46AC61475A45172B198B00@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170803031652.GA10515@gondor.apana.org.au>
 <VI1PR0401MB25919FFF2B07150E1BD02AE298B10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Oleksij Rempel <ore@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Dan Douglass <dan.douglass@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:35816 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdHIE5F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 00:57:05 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB25919FFF2B07150E1BD02AE298B10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 03, 2017 at 07:48:51AM +0000, Horia Geantă wrote:
>
> Right now it's configured as a DRBG.
> If I read correctly, it doesn't matter it's using the internal TRNG for
> (automated) seeding, it still shouldn't use hwrng.
> This means it's broken since the very beginning:
> e24f7c9e87d4 crypto: caam - hwrng support

Right.  If it can be switched over to a TRNG then we should do that.
Otherwise it should be converted over to use the crypto rng API.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
