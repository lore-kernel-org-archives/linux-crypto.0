From: Harald Freudenberger <freude@linux.vnet.ibm.com>
Subject: Re: [PATCH v1] crypto: caam - set hwrng quality level
Date: Thu, 20 Jul 2017 15:08:43 +0200
Message-ID: <4e42d639-9f83-dcbb-9a2a-91686656c7dd@linux.vnet.ibm.com>
References: <20170719074458.9247-1-o.rempel@pengutronix.de>
 <VI1PR0401MB2591B52EB2EF7B7B900FBCC998A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719163248.sn7mvnq2s3fm2hvh@pengutronix.de>
 <VI1PR0401MB25917848BA4AF6626E8DF1AD98A60@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <20170719181303.rj4fyjj7qplatrzk@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Dan Douglass <dan.douglass@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
To: Oleksij Rempel <ore@pengutronix.de>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170719181303.rj4fyjj7qplatrzk@pengutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 07/19/2017 08:13 PM, Oleksij Rempel wrote:
> On Wed, Jul 19, 2017 at 04:53:21PM +0000, Horia Geantă wrote:
>> On 7/19/2017 7:32 PM, Oleksij Rempel wrote:
>>> On Wed, Jul 19, 2017 at 12:49:47PM +0000, Horia Geantă wrote:
>>>> On 7/19/2017 10:45 AM, Oleksij Rempel wrote:
>>>>> According documentation, it is NIST certified TRNG.
>>>>> So, set high quality to let the HWRNG framework automatically use it.
>>>>>
>>>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>>>> ---
>>>>>  drivers/crypto/caam/caamrng.c | 6 ++++++
>>>>>  1 file changed, 6 insertions(+)
>>>>>
>>>>> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
>>>>> index 41398da3edf4..684c0bc88dfd 100644
>>>>> --- a/drivers/crypto/caam/caamrng.c
>>>>> +++ b/drivers/crypto/caam/caamrng.c
>>>>> @@ -292,10 +292,16 @@ static int caam_init_rng(struct caam_rng_ctx *ctx, struct device *jrdev)
>>>>>  	return 0;
>>>>>  }
>>>>>  
>>>>> +/*
>>>>> + * hwrng register struct
>>>>> + * The trng is suppost to have 100% entropy, and thus
>>>>> + * we register with a very high quality value.
>>>>> + */
>>>>>  static struct hwrng caam_rng = {
>>>>>  	.name		= "rng-caam",
>>>>>  	.cleanup	= caam_cleanup,
>>>>>  	.read		= caam_read,
>>>>> +	.quality	= 999,
>>>> Why not 1024, i.e. where is 999 coming from?
>>> It comes from s390-trng.c driver.
>>> Should I use 1024 instead?
>>>
>> AFAICT the range for quality is from 0 to 1024 (no entropy -> perfect
>> entropy).
>>
>> 1024 should be used since I'd expect a HW TRNG to provide perfect
>> entropy unless otherwise stated.
> I assume 1024 can be given only on verified HW with accessible verilog
> files and compared with resulting chip :)
> May be this would be a good example https://www.sifive.com/
>
Well, the header file says:
...
/**
 * struct hwrng - Hardware Random Number Generator driver
 * @name:               Unique RNG name.
 * @init:               Initialization callback (can be NULL).
 * @cleanup:            Cleanup callback (can be NULL).
 * @data_present:       Callback to determine if data is available
 *                      on the RNG. If NULL, it is assumed that
 *                      there is always data available.  *OBSOLETE*
 * @data_read:          Read data from the RNG device.
 *                      Returns the number of lower random bytes in "data".
 *                      Must not be NULL.    *OBSOLETE*
 * @read:               New API. drivers can fill up to max bytes of data
 *                      into the buffer. The buffer is aligned for any type
 *                      and max is a multiple of 4 and >= 32 bytes.
 * @priv:               Private data, for use by the RNG driver.
 * @quality:            Estimation of true entropy in RNG's bitstream
 *                      (per mill).
 */
...
quality = estimation of true entropy per mill.
I understand this as quality=1000 meaning 100% entropy.
However, the core code currently does not really check this value.
When more than one hwrng sources do register, simple the one with
the higher quality value wins :-) The value is not even checked
to be in a given range.

I searched through some device drivers which do register at
the hwrng and it looks like most of the drivers do not even
set this value. My feeling is, you should use 999 when your
hardware provides 'perfect' random. So there is a chance for
an even 'more perfect' hardware coming up later to overrule
your 'perfect' hardware.

regards
Harald Freudenberger
