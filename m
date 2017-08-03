From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v1] crypto: caam - set hwrng quality level
Date: Thu, 3 Aug 2017 07:48:51 +0000
Message-ID: <VI1PR0401MB25919FFF2B07150E1BD02AE298B10@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170719074458.9247-1-o.rempel@pengutronix.de>
 <VI1PR0401MB2591B52EB2EF7B7B900FBCC998A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719163248.sn7mvnq2s3fm2hvh@pengutronix.de>
 <VI1PR0401MB25917848BA4AF6626E8DF1AD98A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719181303.rj4fyjj7qplatrzk@pengutronix.de>
 <4e42d639-9f83-dcbb-9a2a-91686656c7dd@linux.vnet.ibm.com>
 <VI1PR0401MB25914FE46AC61475A45172B198B00@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170803031652.GA10515@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Oleksij Rempel <ore@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "Dan Douglass" <dan.douglass@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 8/3/2017 6:17 AM, Herbert Xu wrote:=0A=
> On Wed, Aug 02, 2017 at 02:03:14PM +0000, Horia Geant=E3 wrote:=0A=
>>=0A=
>> Take CAAM's engine HWRNG: it can work both as a TRNG and as a=0A=
>> TRNG-seeded DRBG (that's how it's currently configured).=0A=
>> IIUC, both setups are fit as source for the entropy pool.=0A=
> =0A=
> So which is it? If it's a DRBG then it should not be exposed through=0A=
> the hwrng interface.  Only TRNG should go through hwrng.  DRBGs=0A=
> can use the crypto rng API.=0A=
=0A=
Right now it's configured as a DRBG.=0A=
If I read correctly, it doesn't matter it's using the internal TRNG for=0A=
(automated) seeding, it still shouldn't use hwrng.=0A=
This means it's broken since the very beginning:=0A=
e24f7c9e87d4 crypto: caam - hwrng support=0A=
=0A=
Thanks,=0A=
Horia=0A=
