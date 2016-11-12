From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm64/sha2: integrate OpenSSL implementations of SHA256/SHA512
Date: Sat, 12 Nov 2016 13:26:32 +0100
Message-ID: <CAKv+Gu_Ni6xOqDLfC4Qf2wzP-3ByhkEGkpt8M91F01kTCmctsQ@mail.gmail.com>
References: <1478872273-16382-1-git-send-email-ard.biesheuvel@linaro.org> <20161111195607.GB4457@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andy Polyakov <appro@openssl.org>,
        Victor Chong <victor.chong@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37045 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936990AbcKLM0d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Nov 2016 07:26:33 -0500
Received: by mail-it0-f41.google.com with SMTP id u205so27289280itc.0
        for <linux-crypto@vger.kernel.org>; Sat, 12 Nov 2016 04:26:33 -0800 (PST)
In-Reply-To: <20161111195607.GB4457@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11 November 2016 at 20:56, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Nov 11, 2016 at 09:51:13PM +0800, Ard Biesheuvel wrote:
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
>> The version in this patch was taken from OpenSSL commit
>>
>>    866e505e0d66 sha/asm/sha512-armv8.pl: add NEON version of SHA256.
>>
>> * The core SHA algorithm is fundamentally sequential, but there is a
>>   secondary transformation involved, called the schedule update, which
>>   can be performed independently. The NEON version of SHA-224/SHA-256
>>   only implements this part of the algorithm using NEON instructions,
>>   the sequential part is always done using scalar instructions.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>
>> This supersedes the SHA-256-NEON-only patch I sent out about 6 weeks ago.
>>
>> Will, Catalin: note that this pulls in a .pl script, and adds a build rule
>> locally in arch/arm64/crypto to generate .S files on the fly from Perl
>> scripts. I will leave it to you to decide whether you are ok with this as
>> is, or whether you prefer .S_shipped files, in which case the Perl script
>> is only included as a reference (this is how we did it for arch/arm in the
>> past, but given that it adds about 3000 lines of generated code to the patch,
>> I think we may want to simply keep it as below)
>
> I think we should include the shipped files too. 3000 lines isn't that much
> in the grand scheme of things, and there will be people who complain about
> the unconditional perl dependency.
>

OK, fair enough. I will repost with the generated files included.
