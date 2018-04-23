From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: ccree: limit build to plausible archs
Date: Mon, 23 Apr 2018 16:22:06 +0300
Message-ID: <CAOtvUMd41+5DzHRbViyNZkiL92BYh2YaREvhiAH0UPnPYCzB+w@mail.gmail.com>
References: <1524484097-8315-1-git-send-email-gilad@benyossef.com> <CAMuHMdXNAkCVpyGyQMKRMRGuXyjOHAGgvHT4QGkuYdZetOr-9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdXNAkCVpyGyQMKRMRGuXyjOHAGgvHT4QGkuYdZetOr-9Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 23, 2018 at 3:13 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Gilad,
>
> On Mon, Apr 23, 2018 at 1:48 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>> Limit option to compile ccree to plausible architectures.
>
> Thanks for your patch!
>
>> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> ---
>>  drivers/crypto/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>> index d1ea1a0..7302785 100644
>> --- a/drivers/crypto/Kconfig
>> +++ b/drivers/crypto/Kconfig
>> @@ -726,6 +726,7 @@ config CRYPTO_DEV_ARTPEC6
>>  config CRYPTO_DEV_CCREE
>>         tristate "Support for ARM TrustZone CryptoCell family of security processors"
>>         depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
>> +       depends on (XTENSA || X86 || UNICORE32 || SUPERH || RISCV || PPC32 || OPENRISC || NIOS2 || NDS32 || MIPS || MICROBLAZE || HEXAGON || H8300 || ARM || ARM64 || ARC || COMPILE_TEST)
>
> That list looks a bit excessive to me...

I'm sorry, but as an Arm employee I'm not in liberty to identify which
customer licensed or might license CryptoCell for which platform, now
or in the future.

I'm sure you understand.

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
