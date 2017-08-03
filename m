From: Oleksij Rempel <ore@pengutronix.de>
Subject: Re: [PATCH v1] crypto: caam - set hwrng quality level
Date: Thu, 3 Aug 2017 11:26:57 +0200
Message-ID: <8c0a88cd-8ce0-3752-d17a-9e78ff05b640@pengutronix.de>
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
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Dan Douglass <dan.douglass@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
To: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:56545 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751094AbdHCJ1E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 05:27:04 -0400
In-Reply-To: <VI1PR0401MB25919FFF2B07150E1BD02AE298B10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 03.08.2017 09:48, Horia Geantã wrote:
> On 8/3/2017 6:17 AM, Herbert Xu wrote:
>> On Wed, Aug 02, 2017 at 02:03:14PM +0000, Horia Geantã wrote:
>>>
>>> Take CAAM's engine HWRNG: it can work both as a TRNG and as a
>>> TRNG-seeded DRBG (that's how it's currently configured).
>>> IIUC, both setups are fit as source for the entropy pool.
>>
>> So which is it? If it's a DRBG then it should not be exposed through
>> the hwrng interface.  Only TRNG should go through hwrng.  DRBGs
>> can use the crypto rng API.
>
> Right now it's configured as a DRBG.
> If I read correctly, it doesn't matter it's using the internal TRNG for
> (automated) seeding, it still shouldn't use hwrng.
> This means it's broken since the very beginning:
> e24f7c9e87d4 crypto: caam - hwrng support

Hmmm..
- what is the security risk of this issue? For example system which use 
/dev/hwrng directly?
- And who will fix it?
