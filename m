From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 3/3] arm64: dts: renesas: r8a7795: add ccree binding
Date: Thu, 17 May 2018 16:41:11 +0300
Message-ID: <CAOtvUMee+cn+=bEuB5iBiU9yeSsCiDPDwej8Uw-_3wVP4fagpA@mail.gmail.com>
References: <1526387370-17142-1-git-send-email-gilad@benyossef.com>
 <1526387370-17142-4-git-send-email-gilad@benyossef.com> <CAMuHMdWzeNqsho1V6ezZb81T3_HcRzrtuQpmGXsjtFgt9BtZDQ@mail.gmail.com>
 <20180516074333.i2672u435ymwffk3@verge.net.au> <CAOtvUMfFjokOLCg6aHNQESJ_q4Jiok3izrPtae5wR+cND=XL6g@mail.gmail.com>
 <CAMuHMdVM55S7+PdnKusX-qkTxioc=0kQ6EGSbwv+kbLk5RCUYw@mail.gmail.com>
 <CAOtvUMdVNX_vBRofpc5rNiVL-a1NvWMDyWSOaXKYPkm57wkR_A@mail.gmail.com> <CAMuHMdX5quhZzaPkcrtB4CuHWeaKsyF1SustjB9V0SWw_SzXVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        L
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdX5quhZzaPkcrtB4CuHWeaKsyF1SustjB9V0SWw_SzXVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 17, 2018 at 4:35 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Gilad,
>
> On Thu, May 17, 2018 at 3:09 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>> On Thu, May 17, 2018 at 1:16 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> However, even with your clock patch, the signature checking fails for me,
>>> on both R-Car H3 ES1.0 and ES2.0.
>>> Does this need changes to the ARM Trusted Firmware, to allow Linux to
>>> access the public SCEG module?
>>
>> Well, this is actually something different. If you look you will
>> notice that my patch was part of a 3 part patch series,
>> the first of which disabled this test.
>
> Sorry, I had completely forgotten about the first patch from the series.
> With that applied, it continues:
>
>         ccree e6601000.crypto: ARM CryptoCell 630P Driver: HW version
> 0x00000000, Driver version 4.0
>         ccree e6601000.crypto: Cache params previous: 0x00000777
>         ccree e6601000.crypto: Cache params current: 0x00000000
> (expect: 0x00000000)
>         alg: No test for cts1(cbc(aes)) (cts1-cbc-aes-ccree)
>         alg: No test for authenc(xcbc(aes),cbc(aes))
> (authenc-xcbc-aes-cbc-aes-ccree)
>         alg: No test for authenc(xcbc(aes),rfc3686(ctr(aes)))
> (authenc-xcbc-aes-rfc3686-ctr-aes-ccree)
>         ccree e6601000.crypto: ARM ccree device initialized
>
> Is HW version 0x00000000 expected?

It's related to the problem with reading the wrong register I've
mentioned before.

>
>> If you take all the 3 patches, it will work.
>
> is there an easy way to test proper operation?

The lines of the form "  alg: No test for cts1(cbc(aes))
(cts1-cbc-aes-ccree)" indicates
you have the Crypto API testmgr enable (or rather not disabled would
be more accurate) so every
cryptographic algorithm except those specified in these messages was
tested with test
vectors from crypto/testmgr.c upon registration. If you don't seen
failure warnings, it works.

You can also check /proc/crypto for all the algorithm with ccree
listed as their driver and check
that their test passed.


> I enabled CONFIG_CRYPT_TEST, and did insmod tcrypt.ko, but I mostly see
> "Failed to load transform" messages.
>

tcrypt.ko is a rather crude developer tool. It has hard coded lists of
test for different algorithms that does
not take into account if some crypto algs are enagled in the build or
not. It's more of a stress test.


Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
