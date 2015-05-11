From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] crypto: arm/sha512 - accelerated SHA-512 using ARM
 generic ASM and NEON
Date: Mon, 11 May 2015 09:00:49 +0200
Message-ID: <CAKv+Gu9+xrX2nB43cskOoL63WjZGTDdq9ZTO-maWas5u=ng=JQ@mail.gmail.com>
References: <1431074782-22141-1-git-send-email-ard.biesheuvel@linaro.org>
	<20150511065952.GB2598@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38239 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbbEKHAu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 03:00:50 -0400
Received: by igbhj9 with SMTP id hj9so62650655igb.1
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 00:00:50 -0700 (PDT)
In-Reply-To: <20150511065952.GB2598@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11 May 2015 at 08:59, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, May 08, 2015 at 10:46:21AM +0200, Ard Biesheuvel wrote:
>>
>> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
>> index 8da2207b0072..08b5fb85bff5 100644
>> --- a/arch/arm/crypto/Kconfig
>> +++ b/arch/arm/crypto/Kconfig
>> @@ -53,20 +53,14 @@ config CRYPTO_SHA256_ARM
>>         SHA-256 secure hash standard (DFIPS 180-2) implemented
>>         using optimized ARM assembler and NEON, when available.
>>
>> -config CRYPTO_SHA512_ARM_NEON
>> -     tristate "SHA384 and SHA512 digest algorithm (ARM NEON)"
>> -     depends on KERNEL_MODE_NEON
>> -     select CRYPTO_SHA512
>> +config CRYPTO_SHA512_ARM
>> +     tristate "SHA-384/512 digest algorithm (ARM-asm and NEON)"
>> +     depends on !CPU_V7M
>>       select CRYPTO_HASH
>> +     depends on !CPU_V7M
>
> This looks like a duplicate, no?

Yes, you are right. Let me figure out what's going on and send you a
new version.
