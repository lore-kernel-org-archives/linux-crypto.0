From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4] crypto: arm64/sha2: integrate OpenSSL implementations
 of SHA256/SHA512
Date: Mon, 28 Nov 2016 14:17:34 +0100
Message-ID: <CAKv+Gu-uzqR758CSPZ_sWwbeejgw1cU-zwxpLU11A=3mnvqcNg@mail.gmail.com>
References: <1479642121-17912-1-git-send-email-ard.biesheuvel@linaro.org> <20161128120503.GC1485@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andy Polyakov <appro@openssl.org>
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35068 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754482AbcK1NRf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 08:17:35 -0500
Received: by mail-io0-f180.google.com with SMTP id a124so228343560ioe.2
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 05:17:35 -0800 (PST)
In-Reply-To: <20161128120503.GC1485@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28 November 2016 at 13:05, Will Deacon <will.deacon@arm.com> wrote:
> On Sun, Nov 20, 2016 at 11:42:01AM +0000, Ard Biesheuvel wrote:
>> This integrates both the accelerated scalar and the NEON implementations
>> of SHA-224/256 as well as SHA-384/512 from the OpenSSL project.
>>
>> Relative performance compared to the respective generic C versions:
>>
>>                  |  SHA256-scalar  | SHA256-NEON* |  SHA512  |
>>      ------------+-----------------+--------------+----------+
>>      Cortex-A53  |      1.63x      |     1.63x    |   2.34x  |
>>      Cortex-A57  |      1.43x      |     1.59x    |   1.95x  |
>>      Cortex-A73  |      1.26x      |     1.56x    |     ?    |
>>
>> The core crypto code was authored by Andy Polyakov of the OpenSSL
>> project, in collaboration with whom the upstream code was adapted so
>> that this module can be built from the same version of sha512-armv8.pl.
>>
>> The version in this patch was taken from OpenSSL commit 32bbb62ea634
>> ("sha/asm/sha512-armv8.pl: fix big-endian support in __KERNEL__ case.")
>>
>> * The core SHA algorithm is fundamentally sequential, but there is a
>>   secondary transformation involved, called the schedule update, which
>>   can be performed independently. The NEON version of SHA-224/SHA-256
>>   only implements this part of the algorithm using NEON instructions,
>>   the sequential part is always done using scalar instructions.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm64/crypto/Kconfig               |    8 +
>>  arch/arm64/crypto/Makefile              |   17 +
>>  arch/arm64/crypto/sha256-core.S_shipped | 2061 ++++++++++++++++++++
>>  arch/arm64/crypto/sha256-glue.c         |  185 ++
>>  arch/arm64/crypto/sha512-armv8.pl       |  778 ++++++++
>>  arch/arm64/crypto/sha512-core.S_shipped | 1085 +++++++++++
>>  arch/arm64/crypto/sha512-glue.c         |   94 +
>>  7 files changed, 4228 insertions(+)
>
> If I build a kernel with this applied and CRYPTO_SHA{256,512}_ARM64=y,
> then I end up with untracked .S files according to git:
>
> $ git status
> Untracked files:
>         arch/arm64/crypto/sha256-core.S
>         arch/arm64/crypto/sha512-core.S
>

Ah right, I forgot to add a .gitignore for these: that is required
with .S_shipped files. I didn't spot this myself because I always
build out of tree

Would you mind taking a separate patch for that?
