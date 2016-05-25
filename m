From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] hwrng: stm32 - fix build warning
Date: Wed, 25 May 2016 07:30:09 +0530
Message-ID: <57450729.3000609@gmail.com>
References: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com>	<12548318.auB4PSA3KC@wuerfel>	<CALszF6BPPA=tezMLhmdC4YFwmH1tGhDxCNDZNwGp1cTDWP7Fmg@mail.gmail.com>	<6044541.yeLQbYg2Jv@wuerfel> <CALszF6BAFgoccC6fmkdnwQxwHmQ35oLcor6v9yOLyVeXrt-KGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALszF6BAFgoccC6fmkdnwQxwHmQ35oLcor6v9yOLyVeXrt-KGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday 24 May 2016 02:50 PM, Maxime Coquelin wrote:
> 2016-05-24 10:58 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
>> On Tuesday, May 24, 2016 10:50:17 AM CEST Maxime Coquelin wrote:
>>> diff --git a/drivers/char/hw_random/stm32-rng.c
>>> b/drivers/char/hw_random/stm32-rng.c
>>> index 92a810648bd0..2a0fc90e4dc3 100644
>>> --- a/drivers/char/hw_random/stm32-rng.c
>>> +++ b/drivers/char/hw_random/stm32-rng.c
>>> @@ -68,6 +68,10 @@ static int stm32_rng_read(struct hwrng *rng, void
>>> *data, size_t max, bool wait)
>>>                          } while (!sr && --timeout);
>>>                  }
>>>
>>> +               if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
>>> +                               "bad RNG status - %x\n", sr))
>>> +                       writel_relaxed(0, priv->base + RNG_SR);
>>> +
>>>                  /* If error detected or data not ready... */
>>>                  if (sr != RNG_SR_DRDY)
>>>                          break;
>>> @@ -79,10 +83,6 @@ static int stm32_rng_read(struct hwrng *rng, void
>>> *data, size_t max, bool wait)
>>>                  max -= sizeof(u32);
>>>          }
>>>
>>> -       if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
>>> -                     "bad RNG status - %x\n", sr))
>>> -               writel_relaxed(0, priv->base + RNG_SR);
>>> -
>>>          pm_runtime_mark_last_busy((struct device *) priv->rng.priv);
>>>          pm_runtime_put_sync_autosuspend((struct device *) priv->rng.priv);
>>>
>>> Thanks,
>>>
>>
>> Yes, that looks good to me.
>
> Thanks!
> Sudip, do you want to send the patch, or I manage to do it?

Maybe you should send it, i have not done anything in reaching its final 
form.

Regards
Sudip
