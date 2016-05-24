From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH] hwrng: stm32 - fix build warning
Date: Tue, 24 May 2016 11:09:42 +0100
Message-ID: <56bb8ec4-fe7e-ec09-adc3-ec7eea2d7ddd@linaro.org>
References: <1464007448-25395-1-git-send-email-sudipm.mukherjee@gmail.com>
 <6297051.TAxtzW5OIB@wuerfel>
 <CALszF6AxXY0LK5fToFg3095+gz6xcZz8KHaYqc=o39vjpBYDmA@mail.gmail.com>
 <12548318.auB4PSA3KC@wuerfel>
 <CALszF6BPPA=tezMLhmdC4YFwmH1tGhDxCNDZNwGp1cTDWP7Fmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35850 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbcEXKJp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 06:09:45 -0400
Received: by mail-wm0-f47.google.com with SMTP id n129so121247533wmn.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 May 2016 03:09:45 -0700 (PDT)
In-Reply-To: <CALszF6BPPA=tezMLhmdC4YFwmH1tGhDxCNDZNwGp1cTDWP7Fmg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24/05/16 09:50, Maxime Coquelin wrote:
> diff --git a/drivers/char/hw_random/stm32-rng.c
> b/drivers/char/hw_random/stm32-rng.c
> index 92a810648bd0..2a0fc90e4dc3 100644
> --- a/drivers/char/hw_random/stm32-rng.c
> +++ b/drivers/char/hw_random/stm32-rng.c
> @@ -68,6 +68,10 @@ static int stm32_rng_read(struct hwrng *rng, void
> *data, size_t max, bool wait)
>                         } while (!sr && --timeout);
>                 }
>
> +               if (WARN_ONCE(sr & (RNG_SR_SEIS | RNG_SR_CEIS),
> +                               "bad RNG status - %x\n", sr))
> +                       writel_relaxed(0, priv->base + RNG_SR);
> +
>                 /* If error detected or data not ready... */
>                 if (sr != RNG_SR_DRDY)
>                         break;

Minor quibble but I might prefer that the error handling/recovery 
actually be put on the error path itself (included in the if (sr != 
RNG_SR_DRDY) ).


Daniel.
