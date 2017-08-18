From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 3/6] crypto: jz4780-rng: Add Ingenic JZ4780 hardware PRNG driver
Date: Fri, 18 Aug 2017 19:36:43 +0530
Message-ID: <CANc+2y5zEg7NeE7a8JK+ALwtPN0FJ6Ajo2PxBGGZ=fBzxtKbjA@mail.gmail.com>
References: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
 <20170817182520.20102-4-prasannatsmkumar@gmail.com> <20325029.4QLNKKN8OS@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Turquette <mturquette@baylibre.com>,
        sboyd@codeaurora.org, "David S . Miller" <davem@davemloft.net>,
        Paul Cercueil <paul@crapouillou.net>,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34759 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdHROGp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2017 10:06:45 -0400
Received: by mail-io0-f193.google.com with SMTP id m88so5738649iod.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Aug 2017 07:06:44 -0700 (PDT)
In-Reply-To: <20325029.4QLNKKN8OS@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On 18 August 2017 at 00:22, Stephan Mueller <smueller@chronox.de> wrote:
> Am Donnerstag, 17. August 2017, 20:25:17 CEST schrieb PrasannaKumar
> Muralidharan:
>
> Hi PrasannaKumar,
>
>> +
>> +static int jz4780_rng_generate(struct crypto_rng *tfm,
>> +                            const u8 *src, unsigned int slen,
>> +                            u8 *dst, unsigned int dlen)
>> +{
>> +     struct jz4780_rng_ctx *ctx = crypto_rng_ctx(tfm);
>> +     struct jz4780_rng *rng = ctx->rng;
>> +     u32 data;
>> +
>> +     /*
>> +      * JZ4780 Programmers manual says the RNG should not run continuously
>> +      * for more than 1s. So enable RNG, read data and disable it.
>> +      * NOTE: No issue was observed with MIPS creator CI20 board even when
>> +      * RNG ran continuously for longer periods. This is just a precaution.
>> +      *
>> +      * A delay is required so that the current RNG data is not bit shifted
>> +      * version of previous RNG data which could happen if random data is
>> +      * read continuously from this device.
>> +      */
>> +     jz4780_rng_writel(rng, 1, REG_RNG_CTRL);
>> +     do {
>> +             data = jz4780_rng_readl(rng, REG_RNG_DATA);
>> +             memcpy((void *)dst, (void *)&data, 4);
>
> How do you know that dst is a multiple of 4 bytes? When dlen is only 3, you
> overflow the buffer.

You are right. I initially used hw_random framework for this driver.
But later realised that PRNG driver should use crypto framework. When
I started using crypto I reused most of the code. This was because of
porting. Will change it and send next version.

>
>> +             dlen -= 4;
>> +             dst += 4;
>> +             udelay(20);
>> +     } while (dlen >= 4);
>> +
>> +     if (dlen > 0) {
>> +             data = jz4780_rng_readl(rng, REG_RNG_DATA);
>> +             memcpy((void *)dst, (void *)&data, dlen);
>> +     }
>> +     jz4780_rng_writel(rng, 0, REG_RNG_CTRL);
>> +
>> +     return 0;
>> +}
>
> Ciao
> Stephan

Thanks,
PrasannaKumar
