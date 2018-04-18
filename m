From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC] crypto: Add platform dependencies for CRYPTO_DEV_CCREE
Date: Wed, 18 Apr 2018 09:47:26 +0200
Message-ID: <CAMuHMdUh4MxSoVb5x_FjTgCzrK0Pb_EV-G8npZB6m24d+UJ4Wg@mail.gmail.com>
References: <1523988865-26848-1-git-send-email-geert@linux-m68k.org> <CAOtvUMeJLXxB3v2wr8EQFKxXpMo3Oi64Ac8aGA5vLDo37dQWjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOtvUMeJLXxB3v2wr8EQFKxXpMo3Oi64Ac8aGA5vLDo37dQWjw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

On Wed, Apr 18, 2018 at 6:32 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> On Tue, Apr 17, 2018 at 9:14 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> The ARM TrustZone CryptoCell is found on ARM SoCs only.  Hence make it
>> depend on ARM or ARM64, unless compile-testing.
>
> Actually it is not. Despite what the name suggest, CryptoCell is
> designed by Arm but is
> not in fact limited to Arm cores. I think the only requirement is
> ability to provide an AMBA bus
> interface. Kudos to our marketing department to make that so clear and
> so on... :-)

Good to know, I couldn't find any users of the compatible value in DT sources,
so I had to guess... and missed ;-)

Do you have a good suggestion for a platform dependency?
Based on the above, I'd say "depends on ARM_AMBA || COMPILE_TEST",
but (currently) ARM_AMBA is selected on ARM or ARM64 only?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
