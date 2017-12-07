From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 11/20] arm64: assembler: add macros to conditionally
 yield the NEON under PREEMPT
Date: Thu, 7 Dec 2017 15:51:48 +0000
Message-ID: <CAKv+Gu8B=53Tz1Twr==ze_qcwdDu+9JA5B2f9JgNn1E3+EnG6g@mail.gmail.com>
References: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
 <20171206194346.24393-12-ard.biesheuvel@linaro.org> <20171207143934.GF22781@e103592.cambridge.arm.com>
 <CAKv+Gu8N6w3+VFpF3kq-qg9Gij=4VbtQqu+yfvfA67p2kWaRLg@mail.gmail.com> <CAKv+Gu-Otcg4UxhJA44PbbYamBJd26Be+YsSUQUaB+qy9owzvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-rt-users@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:37446 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755581AbdLGPvu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Dec 2017 10:51:50 -0500
Received: by mail-it0-f68.google.com with SMTP id d137so15370974itc.2
        for <linux-crypto@vger.kernel.org>; Thu, 07 Dec 2017 07:51:49 -0800 (PST)
In-Reply-To: <CAKv+Gu-Otcg4UxhJA44PbbYamBJd26Be+YsSUQUaB+qy9owzvQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7 December 2017 at 15:47, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 7 December 2017 at 14:50, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> On 7 December 2017 at 14:39, Dave Martin <Dave.Martin@arm.com> wrote:
>>> On Wed, Dec 06, 2017 at 07:43:37PM +0000, Ard Biesheuvel wrote:
>>>> Add support macros to conditionally yield the NEON (and thus the CPU)
>>>> that may be called from the assembler code.
>>>>
>>>> In some cases, yielding the NEON involves saving and restoring a non
>>>> trivial amount of context (especially in the CRC folding algorithms),
>>>> and so the macro is split into three, and the code in between is only
>>>> executed when the yield path is taken, allowing the context to be preserved.
>>>> The third macro takes an optional label argument that marks the resume
>>>> path after a yield has been performed.
>>>>
>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>> ---
>>>>  arch/arm64/include/asm/assembler.h | 51 ++++++++++++++++++++
>>>>  1 file changed, 51 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
>>>> index 5f61487e9f93..c54e408fd5a7 100644
>>>> --- a/arch/arm64/include/asm/assembler.h
>>>> +++ b/arch/arm64/include/asm/assembler.h
>>>> @@ -572,4 +572,55 @@ alternative_else_nop_endif
>>>>  #endif
>>>>       .endm
>>>>
>>>> +/*
>>>> + * Check whether to yield to another runnable task from kernel mode NEON code
>>>> + * (which runs with preemption disabled).
>>>> + *
>>>> + * if_will_cond_yield_neon
>>>> + *        // pre-yield patchup code
>>>> + * do_cond_yield_neon
>>>> + *        // post-yield patchup code
>>>> + * endif_yield_neon
>>>
>>> ^ Mention the lbl argument?
>>>
>>
>> Yep will do
>>
>>>> + *
>>>> + * - Check whether the preempt count is exactly 1, in which case disabling
>>>
>>>                                                            enabling ^
>>>
>>>> + *   preemption once will make the task preemptible. If this is not the case,
>>>> + *   yielding is pointless.
>>>> + * - Check whether TIF_NEED_RESCHED is set, and if so, disable and re-enable
>>>> + *   kernel mode NEON (which will trigger a reschedule), and branch to the
>>>> + *   yield fixup code.
>>>
>>> Mention that neither patchup sequence is allowed to use section-changing
>>> directives?
>>>
>>> For example:
>>>
>>>         if_will_cond_yield_neon
>>>                 // some code
>>>
>>>                 .pushsection .rodata, "a"
>>> foo:                    .quad // some literal data for some reason
>>>                 .popsection
>>>
>>>                 // some code
>>>         do_cond_yield_neon
>>>
>>> is not safe, because .previous is now .rodata.
>>>
>>
>> Are you sure this is true?
>>
>> The gas info page for .previous tells me
>>
>>    In terms of the section stack, this directive swaps the current
>> section with the top section on the section stack.
>>
>> and it seems to me that .rodata is no longer on the section stack
>> after .popsection. In that sense, push/pop should be safe, but
>> section/subsection/previous is not (I think). So yes, let's put a note
>> in to mention that section directives are unsupported.
>>
>>> (You could protect against this with
>>>         .pushsection .text; .previous; .subsection 1; // ...
>>>         .popsection
>>> but it may be overkill.)
>>>
>>>> + *
>>>> + * This macro sequence clobbers x0, x1 and the flags register unconditionally,
>>>> + * and may clobber x2 .. x18 if the yield path is taken.
>>>> + */
>>>> +
>>>> +     .macro          cond_yield_neon, lbl
>>>> +     if_will_cond_yield_neon
>>>> +     do_cond_yield_neon
>>>> +     endif_yield_neon        \lbl
>>>> +     .endm
>>>> +
>>>> +     .macro          if_will_cond_yield_neon
>>>> +#ifdef CONFIG_PREEMPT
>>>> +     get_thread_info x0
>>>> +     ldr             w1, [x0, #TSK_TI_PREEMPT]
>>>> +     ldr             x0, [x0, #TSK_TI_FLAGS]
>>>> +     cmp             w1, #1 // == PREEMPT_OFFSET
>>>
>>> Can we at least drop a BUILD_BUG_ON() somewhere to check this?
>>>
>>> Maybe in kernel_neon_begin() since this is intimately kernel-mode NEON
>>> related.
>>>
>>
>> Sure.
>>
>
> I only just understood your asm-offsets remark earlier. I wasn't aware
> that it allows exposing random constants as well (although it is
> fairly obvious now that I do). So I will expose PREEMPT_OFFSET rather
> than open code it
>

Of course, I mean 'arbitrary' not 'random' (like 6666)
