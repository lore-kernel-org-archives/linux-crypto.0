From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 0/7] crypto: ARM/arm64 - AES and ChaCha20 updates for v4.11
Date: Thu, 12 Jan 2017 16:48:08 +0000
Message-ID: <CAKv+Gu9a5ZsWtT0XYczPBf54L7d5Whu5gG1eUOt8T-wms0orbg@mail.gmail.com>
References: <1484152915-26517-1-git-send-email-ard.biesheuvel@linaro.org> <20170112164504.GD20313@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38809 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdALQsK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 11:48:10 -0500
Received: by mail-it0-f44.google.com with SMTP id x2so17546892itf.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 08:48:10 -0800 (PST)
In-Reply-To: <20170112164504.GD20313@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 January 2017 at 16:45, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jan 11, 2017 at 04:41:48PM +0000, Ard Biesheuvel wrote:
>> This adds ARM and arm64 implementations of ChaCha20, scalar AES and SIMD
>> AES (using bit slicing). The SIMD algorithms in this series take advantage
>> of the new skcipher walksize attribute to iterate over the input in the most
>> efficient manner possible.
>>
>> Patch #1 adds a NEON implementation of ChaCha20 for ARM.
>>
>> Patch #2 adds a NEON implementation of ChaCha20 for arm64.
>>
>> Patch #3 modifies the existing NEON and ARMv8 Crypto Extensions implementations
>> of AES-CTR to be available as a synchronous skcipher as well. This is intended
>> for the mac80211 code, which uses synchronous encapsulations of ctr(aes)
>> [ccm, gcm] in softirq context, during which arm64 supports use of SIMD code.
>>
>> Patch #4 adds a scalar implementation of AES for arm64, using the key schedule
>> generation routines and lookup tables of the generic code in crypto/aes_generic.
>>
>> Patch #5 does the same for ARM, replacing existing scalar code that originated
>> in the OpenSSL project, and contains redundant key schedule generation routines
>> and lookup tables (and is slightly slower on modern cores)
>>
>> Patch #6 replaces the ARM bit sliced NEON code with a new implementation that
>> has a number of advantages over the original code (which also originated in the
>> OpenSSL project.) The performance should be identical.
>>
>> Patch #7 adds a port of the ARM bit-sliced AES code to arm64, in ECB, CBC, CTR
>> and XTS modes.
>>
>> Due to the size of patch #7, it may be difficult to apply these patches from
>> patchwork, so I pushed them here as well:
>
> It seems to have made it.
>
> All applied.  Thanks.

Actually, patch #6 was the huge one not #7, and I don't see it in your tree yet.

https://git.kernel.org/cgit/linux/kernel/git/ardb/linux.git/commit/?h=crypto-arm-v4.11&id=cbf03b255f7c

The order does not matter, though, so could you please put it on top? Thanks.

-- 
Ard.
