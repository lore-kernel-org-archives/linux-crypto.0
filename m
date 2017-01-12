From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: x86-64: Maintain 16-byte stack alignment
Date: Thu, 12 Jan 2017 08:01:51 +0000
Message-ID: <CAKv+Gu8=zhpZF_Y39L+DtxHysnAEATGP1ZzY1tSMdd+pG=k+jA@mail.gmail.com>
References: <20170110143340.GA3787@gondor.apana.org.au> <CAKv+Gu8xVrfR=J5b2pGK7R5Tv-M3xZhL_dnTvvM7nTZLLtC-EQ@mail.gmail.com>
 <20170112061211.GA10247@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:32800 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdALICA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 03:02:00 -0500
Received: by mail-io0-f172.google.com with SMTP id v96so12682029ioi.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 00:01:53 -0800 (PST)
In-Reply-To: <20170112061211.GA10247@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 January 2017 at 06:12, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jan 10, 2017 at 05:30:48PM +0000, Ard Biesheuvel wrote:
>>
>> Apologies for introducing this breakage. It seemed like an obvious and
>> simple cleanup, so I didn't even bother to mention it in the commit
>> log, but if the kernel does not guarantee 16 byte alignment, I guess
>> we should revert to the old method. If SSE instructions are the only
>> ones that require this alignment, then I suppose not having a ABI
>> conforming stack pointer should not be an issue in general.
>
> BTW Ard, what is the stack alignment on ARM64?
>

[From memory] the arm64 ELF psABI mandates a 16 byte stack alignment
at function entry, and 8 byte alignment at all other times. This means
compiled code will typically preserve 16 byte alignment, and
__aligned(16) on a stack variable will likely not result in an
explicit alignment of the stack pointer *. But the arm64 ISA does not
have any load/store instructions that would trigger a misalignment
fault on an address that is 8 byte aligned but not 16 byte aligned, so
the situation is very different from x86 (assuming I am correct in
asserting that there are no failure modes resulting from a misaligned
stack other than this one and a potential performance hit)

* I didn't check whether the exception handling realigns the stack
pointer on nested exceptions (arm64 has separate IRQ stacks)
