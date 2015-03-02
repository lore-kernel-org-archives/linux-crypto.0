From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] ARM: crypto: update NEON AES module to latest OpenSSL version
Date: Mon, 2 Mar 2015 08:26:26 +0000
Message-ID: <CAKv+Gu8rLm+imbhzcPxcHO9v7FZpU3q28sJk9Cg_eFr5_EbaLA@mail.gmail.com>
References: <1424935325-14437-1-git-send-email-ard.biesheuvel@linaro.org>
	<54F241A1.1060104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Nicolas Pitre <nico@linaro.org>, dm-crypt <dm-crypt@saout.de>,
	Johannes Ernst <johannes.ernst@gmail.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38419 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbbCBI02 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Mar 2015 03:26:28 -0500
Received: by iecrd18 with SMTP id rd18so45888450iec.5
        for <linux-crypto@vger.kernel.org>; Mon, 02 Mar 2015 00:26:27 -0800 (PST)
In-Reply-To: <54F241A1.1060104@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28 February 2015 at 22:30, Milan Broz <gmazyland@gmail.com> wrote:
> On 02/26/2015 08:22 AM, Ard Biesheuvel wrote:
>> This updates the bit sliced AES module to the latest version in the
>> upstream OpenSSL repository (e620e5ae37bc). This is needed to fix a
>> bug in the XTS decryption path, where data chunked in a certain way
>> could trigger the ciphertext stealing code, which is not supposed to
>> be active in the kernel build (The kernel implementation of XTS only
>> supports round multiples of the AES block size of 16 bytes, whereas
>> the conformant OpenSSL implementation of XTS supports inputs of
>> arbitrary size by applying ciphertext stealing). This is fixed in
>> the upstream version by adding the missing #ifndef XTS_CHAIN_TWEAK
>> around the offending instructions.
>>
>> The upstream code also contains the change applied by Russell to
>> build the code unconditionally, i.e., even if __LINUX_ARM_ARCH__ < 7,
>> but implemented slightly differently.
>>
>> Fixes: e4e7f10bfc40 ("ARM: add support for bit sliced AES using NEON instructions")
>> Reported-by: Adrian Kotelba <adrian.kotelba@gmail.com>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>
>> This was found using the tcrypt test code, to which I recently added additional
>> chunking modes. However, XTS typically operates on pages or at least on sectors,
>> so this bug is unlikely to affect anyone in real life.
>>
>> Still, please add cc stable when applying,
>
> Please apply it for stable.
>
> For me, this patch fixed bug reported here
>   http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/7966
>   http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg13102.html
>
> Cryptsetup uses AF_ALG userspace crypto SKCIPHER interface and on
> Raspberry Pi2 with Neon AES implementation it fails to unlock LUKS device
> (if XTS and aes-arm-bs module is used).
>
> After applying this patch it works as expected.
>
> I did not have time to check it more in detail (we are always encrypting
> the whole sector so this should not happen... but apparently it does.)
>
> Tested-by: Milan Broz <gmazyland@gmail.com>
>

OK, thanks for pointing that out, and for confirming that this fixes the issue.

Actually, I did not consider the userspace use case, but it is not
surprising that the data ends up being pushed into the crypto layer in
odd size chunks.

@Herbert: are you ok to take this as a bug fix for stable?

Thanks,
Ard.


>>  arch/arm/crypto/aesbs-core.S_shipped | 12 ++++++++----
>>  arch/arm/crypto/bsaes-armv7.pl       | 12 ++++++++----
>>  2 files changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm/crypto/aesbs-core.S_shipped b/arch/arm/crypto/aesbs-core.S_shipped
>> index 71e5fc7cfb18..1d1800f71c5b 100644
>> --- a/arch/arm/crypto/aesbs-core.S_shipped
>> +++ b/arch/arm/crypto/aesbs-core.S_shipped
>> @@ -58,14 +58,18 @@
>>  # define VFP_ABI_FRAME       0
>>  # define BSAES_ASM_EXTENDED_KEY
>>  # define XTS_CHAIN_TWEAK
>> -# define __ARM_ARCH__        7
>> +# define __ARM_ARCH__ __LINUX_ARM_ARCH__
>> +# define __ARM_MAX_ARCH__ 7
>>  #endif
>>
>>  #ifdef __thumb__
>>  # define adrl adr
>>  #endif
>>
>> -#if __ARM_ARCH__>=7
>> +#if __ARM_MAX_ARCH__>=7
>> +.arch        armv7-a
>> +.fpu neon
>> +
>>  .text
>>  .syntax      unified         @ ARMv7-capable assembler is expected to handle this
>>  #ifdef __thumb2__
>> @@ -74,8 +78,6 @@
>>  .code   32
>>  #endif
>>
>> -.fpu neon
>> -
>>  .type        _bsaes_decrypt8,%function
>>  .align       4
>>  _bsaes_decrypt8:
>> @@ -2095,9 +2097,11 @@ bsaes_xts_decrypt:
>>       vld1.8  {q8}, [r0]                      @ initial tweak
>>       adr     r2, .Lxts_magic
>>
>> +#ifndef      XTS_CHAIN_TWEAK
>>       tst     r9, #0xf                        @ if not multiple of 16
>>       it      ne                              @ Thumb2 thing, sanity check in ARM
>>       subne   r9, #0x10                       @ subtract another 16 bytes
>> +#endif
>>       subs    r9, #0x80
>>
>>       blo     .Lxts_dec_short
>> diff --git a/arch/arm/crypto/bsaes-armv7.pl b/arch/arm/crypto/bsaes-armv7.pl
>> index be068db960ee..a4d3856e7d24 100644
>> --- a/arch/arm/crypto/bsaes-armv7.pl
>> +++ b/arch/arm/crypto/bsaes-armv7.pl
>> @@ -701,14 +701,18 @@ $code.=<<___;
>>  # define VFP_ABI_FRAME       0
>>  # define BSAES_ASM_EXTENDED_KEY
>>  # define XTS_CHAIN_TWEAK
>> -# define __ARM_ARCH__        7
>> +# define __ARM_ARCH__ __LINUX_ARM_ARCH__
>> +# define __ARM_MAX_ARCH__ 7
>>  #endif
>>
>>  #ifdef __thumb__
>>  # define adrl adr
>>  #endif
>>
>> -#if __ARM_ARCH__>=7
>> +#if __ARM_MAX_ARCH__>=7
>> +.arch        armv7-a
>> +.fpu neon
>> +
>>  .text
>>  .syntax      unified         @ ARMv7-capable assembler is expected to handle this
>>  #ifdef __thumb2__
>> @@ -717,8 +721,6 @@ $code.=<<___;
>>  .code   32
>>  #endif
>>
>> -.fpu neon
>> -
>>  .type        _bsaes_decrypt8,%function
>>  .align       4
>>  _bsaes_decrypt8:
>> @@ -2076,9 +2078,11 @@ bsaes_xts_decrypt:
>>       vld1.8  {@XMM[8]}, [r0]                 @ initial tweak
>>       adr     $magic, .Lxts_magic
>>
>> +#ifndef      XTS_CHAIN_TWEAK
>>       tst     $len, #0xf                      @ if not multiple of 16
>>       it      ne                              @ Thumb2 thing, sanity check in ARM
>>       subne   $len, #0x10                     @ subtract another 16 bytes
>> +#endif
>>       subs    $len, #0x80
>>
>>       blo     .Lxts_dec_short
>>
>
