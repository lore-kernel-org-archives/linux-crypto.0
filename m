From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm64: crypto: increase AES interleave to 4x
Date: Fri, 20 Feb 2015 16:16:30 +0000
Message-ID: <CAKv+Gu90z48LBr+ehYaRqxLtAnwsKEkwZrrtR6njhmX2nthHzg@mail.gmail.com>
References: <1424366716-30439-1-git-send-email-ard.biesheuvel@linaro.org>
	<20150220155555.GM31692@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"steve.capper@linaro.org" <steve.capper@linaro.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:64194 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbbBTQQb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Feb 2015 11:16:31 -0500
Received: by mail-ig0-f176.google.com with SMTP id hl2so4167927igb.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2015 08:16:30 -0800 (PST)
In-Reply-To: <20150220155555.GM31692@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 20 February 2015 at 15:55, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Feb 19, 2015 at 05:25:16PM +0000, Ard Biesheuvel wrote:
>> This patch increases the interleave factor for parallel AES modes
>> to 4x. This improves performance on Cortex-A57 by ~35%. This is
>> due to the 3-cycle latency of AES instructions on the A57's
>> relatively deep pipeline (compared to Cortex-A53 where the AES
>> instruction latency is only 2 cycles).
>>
>> At the same time, disable inline expansion of the core AES functions,
>> as the performance benefit of this feature is negligible.
>>
>>   Measured on AMD Seattle (using tcrypt.ko mode=500 sec=1):
>>
>>   Baseline (2x interleave, inline expansion)
>>   ------------------------------------------
>>   testing speed of async cbc(aes) (cbc-aes-ce) decryption
>>   test 4 (128 bit key, 8192 byte blocks): 95545 operations in 1 seconds
>>   test 14 (256 bit key, 8192 byte blocks): 68496 operations in 1 seconds
>>
>>   This patch (4x interleave, no inline expansion)
>>   -----------------------------------------------
>>   testing speed of async cbc(aes) (cbc-aes-ce) decryption
>>   test 4 (128 bit key, 8192 byte blocks): 124735 operations in 1 seconds
>>   test 14 (256 bit key, 8192 byte blocks): 92328 operations in 1 seconds
>
> Fine by me. Shall I queue this via the arm64 tree?
>

Yes, please.



>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm64/crypto/Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
>> index 5720608c50b1..abb79b3cfcfe 100644
>> --- a/arch/arm64/crypto/Makefile
>> +++ b/arch/arm64/crypto/Makefile
>> @@ -29,7 +29,7 @@ aes-ce-blk-y := aes-glue-ce.o aes-ce.o
>>  obj-$(CONFIG_CRYPTO_AES_ARM64_NEON_BLK) += aes-neon-blk.o
>>  aes-neon-blk-y := aes-glue-neon.o aes-neon.o
>>
>> -AFLAGS_aes-ce.o              := -DINTERLEAVE=2 -DINTERLEAVE_INLINE
>> +AFLAGS_aes-ce.o              := -DINTERLEAVE=4
>>  AFLAGS_aes-neon.o    := -DINTERLEAVE=4
>>
>>  CFLAGS_aes-glue-ce.o := -DUSE_V8_CRYPTO_EXTENSIONS
>> --
>> 1.8.3.2
>>
>>
