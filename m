From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH] hwrng: stm32 - fix build warning
Date: Tue, 24 May 2016 11:20:11 +0200
Message-ID: <CALszF6BAFgoccC6fmkdnwQxwHmQ35oLcor6v9yOLyVeXrt-KGA@mail.gmail.com>
References: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com>
	<12548318.auB4PSA3KC@wuerfel>
	<CALszF6BPPA=tezMLhmdC4YFwmH1tGhDxCNDZNwGp1cTDWP7Fmg@mail.gmail.com>
	<6044541.yeLQbYg2Jv@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:36608 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbcEXJUN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 05:20:13 -0400
In-Reply-To: <6044541.yeLQbYg2Jv@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2016-05-24 10:58 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> On Tuesday, May 24, 2016 10:50:17 AM CEST Maxime Coquelin wrote:
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
>> @@ -79,10 +83,6 @@ static int stm32_rng_read(struct hwrng *rng, void
>> *data, size_t max, bool wait)
>>                 max -= sizeof(u32);
>>         }
>>
>> -       if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
>> -                     "bad RNG status - %x\n", sr))
>> -               writel_relaxed(0, priv->base + RNG_SR);
>> -
>>         pm_runtime_mark_last_busy((struct device *) priv->rng.priv);
>>         pm_runtime_put_sync_autosuspend((struct device *) priv->rng.priv);
>>
>> Thanks,
>>
>
> Yes, that looks good to me.

Thanks!
Sudip, do you want to send the patch, or I manage to do it?

Maxime
