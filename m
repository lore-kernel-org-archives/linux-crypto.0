From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 0/6] crypto: aes - allow generic AES to be omitted
Date: Mon, 19 Jun 2017 16:04:43 +0200
Message-ID: <CAKv+Gu-RS27GME6E=SRVfZt4vVTbArn1x_6W2n0qapfzBo0Vtg@mail.gmail.com>
References: <1497611869-6126-1-git-send-email-ard.biesheuvel@linaro.org> <20170619031511.GA16855@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "nico@linaro.org" <nico@linaro.org>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:33800 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdFSOEo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 10:04:44 -0400
Received: by mail-it0-f48.google.com with SMTP id m47so12273109iti.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Jun 2017 07:04:44 -0700 (PDT)
In-Reply-To: <20170619031511.GA16855@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 19 June 2017 at 05:15, Eric Biggers <ebiggers3@gmail.com> wrote:
> Hi Ard,
>
> On Fri, Jun 16, 2017 at 01:17:43PM +0200, Ard Biesheuvel wrote:
>> The generic AES driver uses 16 lookup tables of 1 KB each, and has
>> encryption and decryption routines that are fully unrolled. Given how
>> the dependencies between this code and other drivers are declared in
>> Kconfig files, this code is always pulled into the core kernel, even
>> if it is usually superseded at runtime by accelerated drivers that
>> exist for many architectures.
>>
>> This leaves us with 25 KB of dead code in the kernel, which is negligible
>> in typical environments, but which is actually a big deal for the IoT
>> domain, where every kilobyte counts.
>>
>> Also, the scalar, table based AES routines that exist for ARM, arm64, i586
>> and x86_64 share the lookup tables with AES generic, and may be invoked
>> occasionally when the time-invariant AES-NI or other special instruction
>> drivers are called in interrupt context, at which time the SIMD register
>> file cannot be used. Pulling 16 KB of code and 9 KB of instructions into
>> the L1s (and evicting what was already there) when a softirq happens to
>> be handled in the context of an interrupt taken from kernel mode (which
>> means no SIMD on x86) is also something that we may like to avoid, by
>> falling back to a much smaller and moderately less performant driver.
>> (Note that arm64 will be updated shortly to supply fallbacks for all
>> SIMD based AES implementations, which will be based on the core routines
>> [if they are accepted].)
>>
>> For the reasons above, this series refactors the way the various AES
>> implementations are wired up, to allow the generic version in
>> crypto/aes_generic.c to be omitted from the build entirely.
>>
>
> This looks better now.  I think the help text and prompts could still use some
> improvement.  For the prompts, on x86_64 now I see:
>
>         -*- AES cipher algorithms
>         [*] Fixed time AES cipher
>         [*] AES cipher algorithms (x86_64)
>         [*] AES cipher algorithms (AES-NI)
>
> The first is actually the generic table-based implementation now, and it can be
> deselected if the generic fixed-time implementation is selected and the x86_64
> table-based implementation is deselected.  How about making the prompts be:
>
>         AES cipher algorithm (generic, table-based)
>         AES cipher algorithm (generic, time-invariant)
>         AES cipher algorithm (x86_64, table-based)
>         AES cipher algorithm (AES-NI)
>
> For the help text, removing the Wikipedia-style boilerplate is good, but IMO the
> help text should at least spell out "AES (Advanced Encryption Standard)".  It's
> "obvious" to people familiar with crypto algorithms, but I always find it
> annoying when Kconfig options elsewhere in the kernel use unfamiliar acronyms
> which the developers didn't bother to spell out because it was "obvious" to
> them.
>
> The help text could also give a bit more information to help people decide which
> options to enable.  For example, the help for CRYPTO_AES_X86_64 could say that
> it's only useful on older processors that do not have AES-NI instructions, and
> that the AES-NI implementation, if enabled, will take priority on newer
> processors.  Similarly for the generic implementations, though note that the
> user may still be required to enable at least one of them as a fallback.  Also,
> the AES-NI and ARMv8-CE implementations are not only time-invariant but also the
> fastest --- and therefore strongly recommended to enable.
>

Thanks Eric, all good feedback. I will incorporate it into the next respin.

-- 
Ard.
