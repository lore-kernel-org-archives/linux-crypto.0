From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v1] crypto: caam - set hwrng quality level
Date: Wed, 2 Aug 2017 14:03:14 +0000
Message-ID: <VI1PR0401MB25914FE46AC61475A45172B198B00@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170719074458.9247-1-o.rempel@pengutronix.de>
 <VI1PR0401MB2591B52EB2EF7B7B900FBCC998A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719163248.sn7mvnq2s3fm2hvh@pengutronix.de>
 <VI1PR0401MB25917848BA4AF6626E8DF1AD98A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719181303.rj4fyjj7qplatrzk@pengutronix.de>
 <4e42d639-9f83-dcbb-9a2a-91686656c7dd@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "Dan Douglass" <dan.douglass@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
To: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Oleksij Rempel <ore@pengutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 7/20/2017 4:08 PM, Harald Freudenberger wrote:=0A=
> On 07/19/2017 08:13 PM, Oleksij Rempel wrote:=0A=
>> On Wed, Jul 19, 2017 at 04:53:21PM +0000, Horia Geant=E3 wrote:=0A=
>>> On 7/19/2017 7:32 PM, Oleksij Rempel wrote:=0A=
>>>> On Wed, Jul 19, 2017 at 12:49:47PM +0000, Horia Geant=E3 wrote:=0A=
>>>>> On 7/19/2017 10:45 AM, Oleksij Rempel wrote:=0A=
>>>>>> According documentation, it is NIST certified TRNG.=0A=
>>>>>> So, set high quality to let the HWRNG framework automatically use it=
.=0A=
>>>>>>=0A=
>>>>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>=0A=
>>>>>> ---=0A=
>>>>>>  drivers/crypto/caam/caamrng.c | 6 ++++++=0A=
>>>>>>  1 file changed, 6 insertions(+)=0A=
>>>>>>=0A=
>>>>>> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caa=
mrng.c=0A=
>>>>>> index 41398da3edf4..684c0bc88dfd 100644=0A=
>>>>>> --- a/drivers/crypto/caam/caamrng.c=0A=
>>>>>> +++ b/drivers/crypto/caam/caamrng.c=0A=
>>>>>> @@ -292,10 +292,16 @@ static int caam_init_rng(struct caam_rng_ctx *=
ctx, struct device *jrdev)=0A=
>>>>>>  	return 0;=0A=
>>>>>>  }=0A=
>>>>>>  =0A=
>>>>>> +/*=0A=
>>>>>> + * hwrng register struct=0A=
>>>>>> + * The trng is suppost to have 100% entropy, and thus=0A=
>>>>>> + * we register with a very high quality value.=0A=
>>>>>> + */=0A=
>>>>>>  static struct hwrng caam_rng =3D {=0A=
>>>>>>  	.name		=3D "rng-caam",=0A=
>>>>>>  	.cleanup	=3D caam_cleanup,=0A=
>>>>>>  	.read		=3D caam_read,=0A=
>>>>>> +	.quality	=3D 999,=0A=
>>>>> Why not 1024, i.e. where is 999 coming from?=0A=
>>>> It comes from s390-trng.c driver.=0A=
>>>> Should I use 1024 instead?=0A=
>>>>=0A=
>>> AFAICT the range for quality is from 0 to 1024 (no entropy -> perfect=
=0A=
>>> entropy).=0A=
>>>=0A=
>>> 1024 should be used since I'd expect a HW TRNG to provide perfect=0A=
>>> entropy unless otherwise stated.=0A=
>> I assume 1024 can be given only on verified HW with accessible verilog=
=0A=
>> files and compared with resulting chip :)=0A=
>> May be this would be a good example https://www.sifive.com/=0A=
>>=0A=
> Well, the header file says:=0A=
> ...=0A=
> /**=0A=
>  * struct hwrng - Hardware Random Number Generator driver=0A=
>  * @name:               Unique RNG name.=0A=
>  * @init:               Initialization callback (can be NULL).=0A=
>  * @cleanup:            Cleanup callback (can be NULL).=0A=
>  * @data_present:       Callback to determine if data is available=0A=
>  *                      on the RNG. If NULL, it is assumed that=0A=
>  *                      there is always data available.  *OBSOLETE*=0A=
>  * @data_read:          Read data from the RNG device.=0A=
>  *                      Returns the number of lower random bytes in "data=
".=0A=
>  *                      Must not be NULL.    *OBSOLETE*=0A=
>  * @read:               New API. drivers can fill up to max bytes of data=
=0A=
>  *                      into the buffer. The buffer is aligned for any ty=
pe=0A=
>  *                      and max is a multiple of 4 and >=3D 32 bytes.=0A=
>  * @priv:               Private data, for use by the RNG driver.=0A=
>  * @quality:            Estimation of true entropy in RNG's bitstream=0A=
>  *                      (per mill).=0A=
>  */=0A=
> ...=0A=
> quality =3D estimation of true entropy per mill.=0A=
"per mill as in https://en.wikipedia.org/wiki/Mill_(currency) ?=0A=
I consider it rather unfortunate, as already noticed here:=0A=
https://lkml.org/lkml/2014/3/27/210=0A=
=0A=
And isn't this inaccurate, since the (de)rating factor is quality/1024,=0A=
not quality/1000?=0A=
=0A=
> I understand this as quality=3D1000 meaning 100% entropy.=0A=
> However, the core code currently does not really check this value.=0A=
> When more than one hwrng sources do register, simple the one with=0A=
> the higher quality value wins :-) The value is not even checked=0A=
> to be in a given range.=0A=
> =0A=
> I searched through some device drivers which do register at=0A=
> the hwrng and it looks like most of the drivers do not even=0A=
> set this value. My feeling is, you should use 999 when your=0A=
=0A=
Maybe this is because it's not clear how to determine quality's value?=0A=
=0A=
Take CAAM's engine HWRNG: it can work both as a TRNG and as a=0A=
TRNG-seeded DRBG (that's how it's currently configured).=0A=
IIUC, both setups are fit as source for the entropy pool.=0A=
=0A=
Do I have to set quality value comparing the two cases?=0A=
(It's a bit like comparing the quality of entropy offered by RDSEED vs.=0A=
RDRAND.)=0A=
Meaning: give full credit - maximum quality - for the TRNG setup, and=0A=
provide a lower value for quality in the case of TRNG-seeded DRBG?=0A=
=0A=
> hardware provides 'perfect' random. So there is a chance for=0A=
> an even 'more perfect' hardware coming up later to overrule=0A=
> your 'perfect' hardware.=0A=
=0A=
I am not sure why the hwrng with the best quality wins, instead of using=0A=
all available resources, as suggested here:=0A=
https://lkml.org/lkml/2014/3/27/210=0A=
=0A=
Thanks,=0A=
Horia=0A=
