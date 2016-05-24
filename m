From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH] hwrng: stm32 - fix build warning
Date: Tue, 24 May 2016 12:57:56 +0200
Message-ID: <CALszF6AmE3yzJL_Wn8nVa3hmTb8eHOoNbvyAh5GiiB2r4PHiyA@mail.gmail.com>
References: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com>
	<6297051.TAxtzW5OIB@wuerfel>
	<CALszF6AxXY0LK5fToFg3095+gz6xcZz8KHaYqc=o39vjpBYDmA@mail.gmail.com>
	<12548318.auB4PSA3KC@wuerfel>
	<CALszF6BPPA=tezMLhmdC4YFwmH1tGhDxCNDZNwGp1cTDWP7Fmg@mail.gmail.com>
	<56bb8ec4-fe7e-ec09-adc3-ec7eea2d7ddd@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Daniel Thompson <daniel.thompson@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36073 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbcEXK56 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 06:57:58 -0400
In-Reply-To: <56bb8ec4-fe7e-ec09-adc3-ec7eea2d7ddd@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2016-05-24 12:09 GMT+02:00 Daniel Thompson <daniel.thompson@linaro.org>:
> On 24/05/16 09:50, Maxime Coquelin wrote:
>>
>> diff --git a/drivers/char/hw_random/stm32-rng.c
>> b/drivers/char/hw_random/stm32-rng.c
>> index 92a810648bd0..2a0fc90e4dc3 100644
>> --- a/drivers/char/hw_random/stm32-rng.c
>> +++ b/drivers/char/hw_random/stm32-rng.c
>> @@ -68,6 +68,10 @@ static int stm32_rng_read(struct hwrng *rng, void
>> *data, size_t max, bool wait)
>>                         } while (!sr && --timeout);
>>                 }
>>
>> +               if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
>> +                               "bad RNG status - %x\n", sr))
>> +                       writel_relaxed(0, priv->base + RNG_SR);
>> +
>>                 /* If error detected or data not ready... */
>>                 if (sr != RNG_SR_DRDY)
>>                         break;
>
>
> Minor quibble but I might prefer that the error handling/recovery actually
> be put on the error path itself (included in the if (sr != RNG_SR_DRDY) ).
Yes, it would be better.

Regards,
Maxime
