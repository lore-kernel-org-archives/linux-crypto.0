From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: ccree: limit build to plausible archs
Date: Tue, 24 Apr 2018 11:31:34 +0300
Message-ID: <CAOtvUMe=iOeWAUwDQ-3yy=Ogg0_=4iEwV32ATEn6SrLPEojNGQ@mail.gmail.com>
References: <1524484097-8315-1-git-send-email-gilad@benyossef.com>
 <CAMuHMdXNAkCVpyGyQMKRMRGuXyjOHAGgvHT4QGkuYdZetOr-9Q@mail.gmail.com>
 <CAOtvUMd41+5DzHRbViyNZkiL92BYh2YaREvhiAH0UPnPYCzB+w@mail.gmail.com> <CAMuHMdXZ0vL7Rxg4+CsP1u_Eb95Nj+qHnrahYPhAewmcrxN9HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdXZ0vL7Rxg4+CsP1u_Eb95Nj+qHnrahYPhAewmcrxN9HQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 23, 2018 at 8:53 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Gilad,
>
> On Mon, Apr 23, 2018 at 3:22 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>> On Mon, Apr 23, 2018 at 3:13 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> On Mon, Apr 23, 2018 at 1:48 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>>> Limit option to compile ccree to plausible architectures.
>>>
>>> Thanks for your patch!
>>>
>>>> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>>>> ---
>>>>  drivers/crypto/Kconfig | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>>>> index d1ea1a0..7302785 100644
>>>> --- a/drivers/crypto/Kconfig
>>>> +++ b/drivers/crypto/Kconfig
>>>> @@ -726,6 +726,7 @@ config CRYPTO_DEV_ARTPEC6
>>>>  config CRYPTO_DEV_CCREE
>>>>         tristate "Support for ARM TrustZone CryptoCell family of security processors"
>>>>         depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
>>>> +       depends on (XTENSA || X86 || UNICORE32 || SUPERH || RISCV || PPC32 || OPENRISC || NIOS2 || NDS32 || MIPS || MICROBLAZE || HEXAGON || H8300 || ARM || ARM64 || ARC || COMPILE_TEST)
>>>
>>> That list looks a bit excessive to me...
>>
>> I'm sorry, but as an Arm employee I'm not in liberty to identify which
>> customer licensed or might license CryptoCell for which platform, now
>> or in the future.
>>
>> I'm sure you understand.
>
> IC, a clever marketing scheme to make everyone think that everybody else
> is already a licensee ;-)

I think you are placing too much importance on Kconfig dependencies
marketing power, otherwise I would have long ago rented Kconfig space
to Saatchi & Saatchi - e.g. "This Kconfig entry is brought to you
by...
"  :-)

>
> What about using "depends on <list> || COMPILE_TEST", with <list> the
> platforms for which the DTS (incl. "arm,cryptocell-*") will be submitted
> for v4.18? The list can easily be extended when needed.
>

Seriously though, I think I was not efficient in communicating my
point through. Let me try again:

The CryptoCell 712 doesn't exists as silicon anywhere. It's just been
released to our design partners not too long ago.
I am guessing there are a few SoCs which include CryptoCell 710 which
taped out, but probably no publicly available boards yet.
By the standard you set above, we shouldn't be enabling the driver
build on ANY platform...

The boards that came out last year (which I plan to send DT entries
for)  are using CryptoCell 630p, which we shipped as a design IP a few
years ago. It takes years for an IP design to ship, be designed into
SoCs, for these SoCs to ship and be designed into boards and until
these ship... and when they do, they almost always don't use the
cutting edge latest kernel.

That is to say - I don't know which SoC and using which architecture
the CryptoCell IP was and will be designed into but I want the driver
and the kernel to be ready when they do - this IS after all the whole
point o doing stuff Upstream First(tm)!

This is the same of having random PCI devices depend on PCI and not a
specific architecture even if no one shipped a system with that device
yet and again the same with I2C devices depending on I2C and not a
specific architecture even if we don't have a board out with that I2C
device designed it. It's a generic none architecture dependent
component.

This is why I initially did not mark the device driver as depending on
any specific architecture.
In light of your request, and what I believe is the underlying idea to
cut down as much as possible build time for test code, to which I
agree, I've decided to cut out architecture that there is very little
chance to even go into a SoC with CryptoCell, such as s390 or um.

So, any pointer to an architecture that will not likely to go into a
SoC in the coming years with some off the shelf HW IP so I can cut off
more is very welcome, but using currently shipping boards to indicate
which architecture to support is not appropriate.

I hope this makes things a bit clearer.

Thanks,
Gilad




-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
