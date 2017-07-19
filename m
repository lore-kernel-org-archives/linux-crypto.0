From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v1] crypto: caam - set hwrng quality level
Date: Wed, 19 Jul 2017 16:53:21 +0000
Message-ID: <VI1PR0401MB25917848BA4AF6626E8DF1AD98A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170719074458.9247-1-o.rempel@pengutronix.de>
 <VI1PR0401MB2591B52EB2EF7B7B900FBCC998A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719163248.sn7mvnq2s3fm2hvh@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Dan Douglass <dan.douglass@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Harald Freudenberger" <freude@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleksij Rempel <ore@pengutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/19/2017 7:32 PM, Oleksij Rempel wrote:=0A=
> On Wed, Jul 19, 2017 at 12:49:47PM +0000, Horia Geant=E3 wrote:=0A=
>> On 7/19/2017 10:45 AM, Oleksij Rempel wrote:=0A=
>>> According documentation, it is NIST certified TRNG.=0A=
>>> So, set high quality to let the HWRNG framework automatically use it.=
=0A=
>>>=0A=
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>=0A=
>>> ---=0A=
>>>  drivers/crypto/caam/caamrng.c | 6 ++++++=0A=
>>>  1 file changed, 6 insertions(+)=0A=
>>>=0A=
>>> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrn=
g.c=0A=
>>> index 41398da3edf4..684c0bc88dfd 100644=0A=
>>> --- a/drivers/crypto/caam/caamrng.c=0A=
>>> +++ b/drivers/crypto/caam/caamrng.c=0A=
>>> @@ -292,10 +292,16 @@ static int caam_init_rng(struct caam_rng_ctx *ctx=
, struct device *jrdev)=0A=
>>>  	return 0;=0A=
>>>  }=0A=
>>>  =0A=
>>> +/*=0A=
>>> + * hwrng register struct=0A=
>>> + * The trng is suppost to have 100% entropy, and thus=0A=
>>> + * we register with a very high quality value.=0A=
>>> + */=0A=
>>>  static struct hwrng caam_rng =3D {=0A=
>>>  	.name		=3D "rng-caam",=0A=
>>>  	.cleanup	=3D caam_cleanup,=0A=
>>>  	.read		=3D caam_read,=0A=
>>> +	.quality	=3D 999,=0A=
>>=0A=
>> Why not 1024, i.e. where is 999 coming from?=0A=
> =0A=
> It comes from s390-trng.c driver.=0A=
> Should I use 1024 instead?=0A=
> =0A=
AFAICT the range for quality is from 0 to 1024 (no entropy -> perfect=0A=
entropy).=0A=
=0A=
1024 should be used since I'd expect a HW TRNG to provide perfect=0A=
entropy unless otherwise stated.=0A=
=0A=
[Cc-ing Harald and Martin for awareness wrt. s390/trng.]=0A=
=0A=
Thanks,=0A=
Horia=0A=
