From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] crypto: arm64 - disable NEON across scatterwalk API calls
Date: Mon, 4 Dec 2017 09:08:22 +0000
Message-ID: <CAKv+Gu9e+JWKeHPpgudsJbNPh1sczPBr5SX1jm7h_wmqQ6NPVw@mail.gmail.com>
References: <20171201211927.24653-1-ard.biesheuvel@linaro.org>
 <20171202090107.GT3326@worktop> <CAKv+Gu-dG0Zc35NZZ85U36K2TXCpN+wJTYOyjkhxRjXbdiJTAQ@mail.gmail.com>
 <CAKv+Gu_DMVYX8y-8JJwyxy2rF0+6ofSWyjwpvwuF042ievBb7w@mail.gmail.com> <20171202135952.GX3326@worktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-rt-users@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:42963 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753707AbdLDJIX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Dec 2017 04:08:23 -0500
Received: by mail-it0-f66.google.com with SMTP id p139so11037623itb.1
        for <linux-crypto@vger.kernel.org>; Mon, 04 Dec 2017 01:08:23 -0800 (PST)
In-Reply-To: <20171202135952.GX3326@worktop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 December 2017 at 13:59, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, Dec 02, 2017 at 11:15:14AM +0000, Ard Biesheuvel wrote:
>> On 2 December 2017 at 09:11, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
>> > They consume the entire input in a single go, yes. But making it more
>> > granular than that is going to hurt performance, unless we introduce
>> > some kind of kernel_neon_yield(), which does a end+begin but only if
>> > the task is being scheduled out.
>> >
>> > For example, the SHA256 keeps 256 bytes of round constants in NEON
>> > registers, and reloading those from memory for each 64 byte block of
>> > input is going to be noticeable. The same applies to the AES code
>> > (although the numbers are slightly different)
>>
>> Something like below should do the trick I think (apologies for the
>> patch soup). I.e., check TIF_NEED_RESCHED at a point where only very
>> few NEON registers are live, and preserve/restore the live registers
>> across calls to kernel_neon_end + kernel_neon_begin. Would that work
>> for RT?
>
> Probably yes. The important point is that preempt latencies (and thus by
> extension NEON regions) are bounded and preferably small.
>
> Unbounded stuff (like depends on the amount of data fed) are a complete
> no-no for RT since then you cannot make predictions on how long things
> will take.
>

OK, that makes sense. But I do wonder what the parameters should be here.

For instance, the AES instructions on ARMv8 operate at <1 cycle per
byte, and so checking the TIF_NEED_RESCHED flag for every iteration of
the inner loop (i.e., every 64 bytes ~ 64 cycles) is clearly going to
be noticeable, and is probably overkill. The pure NEON version (which
is instantiated from the same block mode wrappers) uses ~25 cycles per
byte, and the bit sliced NEON version runs at ~20 cycles per byte but
can only operate at 8 blocks (128 bytes) at a time.

So rather than simply polling the bit at each iteration of the inner
loop in each algorithm, I'd prefer to aim for a ballpark number of
cycles to execute, in the order 1000 - 2000. Would that be OK or too
coarse?
