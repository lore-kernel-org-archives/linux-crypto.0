From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC] crypto: Add platform dependencies for CRYPTO_DEV_CCREE
Date: Wed, 18 Apr 2018 09:43:23 +0200
Message-ID: <CAMuHMdWyuo+y6bTv39gwg4VH7NvzHNSDXprNcM_m854g6ZfiPg@mail.gmail.com>
References: <1523988865-26848-1-git-send-email-geert@linux-m68k.org> <CAK8P3a0fRZmumK5zLRgqT1iPtn2HgEjg6qyv-PMEaM1Z1W6aDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0fRZmumK5zLRgqT1iPtn2HgEjg6qyv-PMEaM1Z1W6aDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Arnd,

On Tue, Apr 17, 2018 at 9:53 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Apr 17, 2018 at 8:14 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> The ARM TrustZone CryptoCell is found on ARM SoCs only.  Hence make it
>> depend on ARM or ARM64, unless compile-testing.
>>
>> Drop the dependency on HAS_DMA, as DMA is always available on ARM and
>> ARM64 platforms, and doing so will increase compile coverage.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>> Is ARM || ARM64 OK?
>> Or should this be limited to either ARM or ARM64? Or something else?
>
> ARM || ARM64 seems fine, but don't you need '|| (HAS_DMA && COMPILE_TEST)'?
>
> I assume the HAS_DMA dependency was added to prevent compile
> testing to run into a build error.

Probably it was. But in v4.17-rc1, dummies are present in the NO_DMA case,
so everything compile-tests fine.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
