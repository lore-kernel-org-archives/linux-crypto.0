From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto/arm: accelerated SHA-512 using ARM generic ASM and NEON
Date: Sat, 11 Apr 2015 12:27:18 +0200
Message-ID: <F30C78C6-9DED-47DE-BB9F-D88F1716B4D1@linaro.org>
References: <1428676148-28210-1-git-send-email-ard.biesheuvel@linaro.org> <F695F357-2A5C-4DFC-9F0E-188CDBBE7C01@linaro.org> <CAKv+Gu-6mZwrVSCvS+ZWWwwM-294nWAqX4_J3r5Z8NM7KKC0=Q@mail.gmail.com> <2845656.4sNJ3XBxnz@wuerfel>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"samitolvanen@google.com" <samitolvanen@google.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35298 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbbDKK1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Apr 2015 06:27:25 -0400
Received: by widdi4 with SMTP id di4so21874683wid.0
        for <linux-crypto@vger.kernel.org>; Sat, 11 Apr 2015 03:27:23 -0700 (PDT)
In-Reply-To: <2845656.4sNJ3XBxnz@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> On 11 apr. 2015, at 10:48, Arnd Bergmann <arnd@arndb.de> wrote:
> 
>> On Saturday 11 April 2015 09:35:15 Ard Biesheuvel wrote:
>>> On 10 April 2015 at 22:23, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>> 
>>>>> On 10 apr. 2015, at 22:08, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> 
>>>>> On Friday 10 April 2015 16:29:08 Ard Biesheuvel wrote:
>>>>> +#if __ARM_MAX_ARCH__>=7
>>>>> +.arch  armv7-a
>>>>> +.fpu   neon
>>>>> +
>>>> 
>>>> This will cause a build failure on an ARMv7-M build, which is incompatible
>>>> with .arch  armv7-a and .fpu   neon.
>>> 
>>> The neon part depends on CONFIG_KERNEL_MODE_NEON, which would never be set for that platform, I suppose
>> 
>> On second thought, that is not entirely true, but I still don't think
>> there is problem here:
>> the .arch/.fpu declarations are understood perfectly fine by GAS when
>> targeting ARMv7-M. Only, it will emit code that is incompatible with
>> it. However, this code is invoked at runtime only if a NEON unit has
>> been detected, so it will just be ignored on ARMv7-M
> 
> Sorry, I should have collected my findings better when replying to your
> patch. What I remembered was that I saw a problem in this area in linux-next
> with randconfig builds, but I did not notice that it was for a different
> file, and I had not double-checked that patch yet in order to send it
> out.
> 
> See below for the patch I'm currently using for my randconfig builder.
> Before you apply this, please check again which files are affected, as
> it's possible that there are other modules that suffer from the same
> problem.
> 

Ah i see it now. The new Sha256 module as well as the Sha512 i am proposing here both use a single .o containing the !neon and neon implementations, and only expose the latter if KERNEL_MODE_NEON. This way, we can use the exact same .S file ad OpenSSL, which should mean less maintenance burden.

So your fix seems the most appropriate, even if it means v7m won't be able to use the !neon part either.


>    Arnd
> 
> 8<-----------
> Subject: [PATCH] ARM: crypto: avoid sha256 code on ARMv7-M
> 
> The sha256 assembly implementation can deal with all architecture levels
> from ARMv4 to ARMv7-A, but not with ARMv7-M. Enabling it in an
> ARMv7-M kernel results in this build failure:
> 
> arm-linux-gnueabi-ld: error: arch/arm/crypto/sha256_glue.o: Conflicting architecture profiles M/A
> arm-linux-gnueabi-ld: failed to merge target specific data of file arch/arm/crypto/sha256_glue.o
> 
> This adds a Kconfig dependency to prevent the code from being disabled
> for ARMv7-M.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index 458729d2ce22..76463da22f81 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -49,6 +49,7 @@ config CRYPTO_SHA2_ARM_CE
> config CRYPTO_SHA256_ARM
>    tristate "SHA-224/256 digest algorithm (ARM-asm and NEON)"
>    select CRYPTO_HASH
> +    depends on !CPU_V7M
>    help
>      SHA-256 secure hash standard (DFIPS 180-2) implemented
>      using optimized ARM assembler and NEON, when available.
> 
