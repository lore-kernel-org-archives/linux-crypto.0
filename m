From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] crypto: ccree: limit build to plausible archs
Date: Tue, 24 Apr 2018 10:52:46 +0200
Message-ID: <CAMuHMdWQAss+_fjrj5BGcstojR0Up9-danH3UxC5PWOLkKrpXQ@mail.gmail.com>
References: <1524484097-8315-1-git-send-email-gilad@benyossef.com>
 <CAMuHMdXNAkCVpyGyQMKRMRGuXyjOHAGgvHT4QGkuYdZetOr-9Q@mail.gmail.com>
 <CAOtvUMd41+5DzHRbViyNZkiL92BYh2YaREvhiAH0UPnPYCzB+w@mail.gmail.com>
 <CAMuHMdXZ0vL7Rxg4+CsP1u_Eb95Nj+qHnrahYPhAewmcrxN9HQ@mail.gmail.com> <CAOtvUMe=iOeWAUwDQ-3yy=Ogg0_=4iEwV32ATEn6SrLPEojNGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOtvUMe=iOeWAUwDQ-3yy=Ogg0_=4iEwV32ATEn6SrLPEojNGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

On Tue, Apr 24, 2018 at 10:31 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> On Mon, Apr 23, 2018 at 8:53 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Mon, Apr 23, 2018 at 3:22 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>> On Mon, Apr 23, 2018 at 3:13 PM, Geert Uytterhoeven
>>> <geert@linux-m68k.org> wrote:
>>>> On Mon, Apr 23, 2018 at 1:48 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>>>> Limit option to compile ccree to plausible architectures.
>>>>
>>>> Thanks for your patch!
>>>>
>>>>> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>>>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>>>>> ---
>>>>>  drivers/crypto/Kconfig | 1 +
>>>>>  1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>>>>> index d1ea1a0..7302785 100644
>>>>> --- a/drivers/crypto/Kconfig
>>>>> +++ b/drivers/crypto/Kconfig
>>>>> @@ -726,6 +726,7 @@ config CRYPTO_DEV_ARTPEC6
>>>>>  config CRYPTO_DEV_CCREE
>>>>>         tristate "Support for ARM TrustZone CryptoCell family of security processors"
>>>>>         depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
>>>>> +       depends on (XTENSA || X86 || UNICORE32 || SUPERH || RISCV || PPC32 || OPENRISC || NIOS2 || NDS32 || MIPS || MICROBLAZE || HEXAGON || H8300 || ARM || ARM64 || ARC || COMPILE_TEST)
>>>>
>>>> That list looks a bit excessive to me...
>>>
>>> I'm sorry, but as an Arm employee I'm not in liberty to identify which
>>> customer licensed or might license CryptoCell for which platform, now
>>> or in the future.
>>>
>>> I'm sure you understand.

>> What about using "depends on <list> || COMPILE_TEST", with <list> the
>> platforms for which the DTS (incl. "arm,cryptocell-*") will be submitted
>> for v4.18? The list can easily be extended when needed.

> Seriously though, I think I was not efficient in communicating my
> point through. Let me try again:

Perhaps I also wasn't clear. With "platform dependency", I meant not just
architectures (e.g. ARM64), but also platform families (e.g. ARCH_EXYNOS).

> The boards that came out last year (which I plan to send DT entries
> for)  are using CryptoCell 630p, which we shipped as a design IP a few
> years ago. It takes years for an IP design to ship, be designed into
> SoCs, for these SoCs to ship and be designed into boards and until
> these ship... and when they do, they almost always don't use the
> cutting edge latest kernel.

OK, so the list can be extended when you send the DTS for that...

> That is to say - I don't know which SoC and using which architecture
> the CryptoCell IP was and will be designed into but I want the driver
> and the kernel to be ready when they do - this IS after all the whole
> point o doing stuff Upstream First(tm)!

... and IMHO an initial empty list is fine, as it will still be upstream, and
compile-tested by the bots.

(note: I do love Upstream First(tm)!)

> This is the same of having random PCI devices depend on PCI and not a
> specific architecture even if no one shipped a system with that device
> yet and again the same with I2C devices depending on I2C and not a
> specific architecture even if we don't have a board out with that I2C
> device designed it. It's a generic none architecture dependent
> component.

At least those depend on PCI or I2C, and thus won't show up on machines
without PCI or I2C.

> This is why I initially did not mark the device driver as depending on
> any specific architecture.
>
> In light of your request, and what I believe is the underlying idea to
> cut down as much as possible build time for test code, to which I
> agree, I've decided to cut out architecture that there is very little
> chance to even go into a SoC with CryptoCell, such as s390 or um.

My underlying idea is not to cut down build time for test code (that's what
we have COMPILE_TEST for), but to enhance usability for users and distros,
who need to know if it makes sense to enable an option.

> So, any pointer to an architecture that will not likely to go into a
> SoC in the coming years with some off the shelf HW IP so I can cut off
> more is very welcome, but using currently shipping boards to indicate
> which architecture to support is not appropriate.
>
> I hope this makes things a bit clearer.

IMHO the extensive list of possible architectures is not really an
improvement. So either a dependency on COMPILE_TEST, or no dependency
at all makes the most sense to me.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
