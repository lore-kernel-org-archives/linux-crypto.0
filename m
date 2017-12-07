From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3 11/20] arm64: assembler: add macros to conditionally
 yield the NEON under PREEMPT
Date: Thu, 7 Dec 2017 15:47:43 +0000
Message-ID: <CAKv+Gu-Otcg4UxhJA44PbbYamBJd26Be+YsSUQUaB+qy9owzvQ@mail.gmail.com>
References: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
 <20171206194346.24393-12-ard.biesheuvel@linaro.org>
 <20171207143934.GF22781@e103592.cambridge.arm.com>
 <CAKv+Gu8N6w3+VFpF3kq-qg9Gij=4VbtQqu+yfvfA67p2kWaRLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will.deacon@arm.com>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 Steven Rostedt <rostedt@goodmis.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 linux-rt-users@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu8N6w3+VFpF3kq-qg9Gij=4VbtQqu+yfvfA67p2kWaRLg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 7 December 2017 at 14:50, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 7 December 2017 at 14:39, Dave Martin <Dave.Martin@arm.com> wrote:
>> On Wed, Dec 06, 2017 at 07:43:37PM +0000, Ard Biesheuvel wrote:
>>> Add support macros to conditionally yield the NEON (and thus the CPU)
>>> that may be called from the assembler code.
>>>
>>> In some cases, yielding the NEON involves saving and restoring a non
>>> trivial amount of context (especially in the CRC folding algorithms),
>>> and so the macro is split into three, and the code in between is only
>>> executed when the yield path is taken, allowing the context to be preserved.
>>> The third macro takes an optional label argument that marks the resume
>>> path after a yield has been performed.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
>>>  arch/arm64/include/asm/assembler.h | 51 ++++++++++++++++++++
>>>  1 file changed, 51 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
>>> index 5f61487e9f93..c54e408fd5a7 100644
>>> --- a/arch/arm64/include/asm/assembler.h
>>> +++ b/arch/arm64/include/asm/assembler.h
>>> @@ -572,4 +572,55 @@ alternative_else_nop_endif
>>>  #endif
>>>       .endm
>>>
>>> +/*
>>> + * Check whether to yield to another runnable task from kernel mode NEON code
>>> + * (which runs with preemption disabled).
>>> + *
>>> + * if_will_cond_yield_neon
>>> + *        // pre-yield patchup code
>>> + * do_cond_yield_neon
>>> + *        // post-yield patchup code
>>> + * endif_yield_neon
>>
>> ^ Mention the lbl argument?
>>
>
> Yep will do
>
>>> + *
>>> + * - Check whether the preempt count is exactly 1, in which case disabling
>>
>>                                                            enabling ^
>>
>>> + *   preemption once will make the task preemptible. If this is not the case,
>>> + *   yielding is pointless.
>>> + * - Check whether TIF_NEED_RESCHED is set, and if so, disable and re-enable
>>> + *   kernel mode NEON (which will trigger a reschedule), and branch to the
>>> + *   yield fixup code.
>>
>> Mention that neither patchup sequence is allowed to use section-changing
>> directives?
>>
>> For example:
>>
>>         if_will_cond_yield_neon
>>                 // some code
>>
>>                 .pushsection .rodata, "a"
>> foo:                    .quad // some literal data for some reason
>>                 .popsection
>>
>>                 // some code
>>         do_cond_yield_neon
>>
>> is not safe, because .previous is now .rodata.
>>
>
> Are you sure this is true?
>
> The gas info page for .previous tells me
>
>    In terms of the section stack, this directive swaps the current
> section with the top section on the section stack.
>
> and it seems to me that .rodata is no longer on the section stack
> after .popsection. In that sense, push/pop should be safe, but
> section/subsection/previous is not (I think). So yes, let's put a note
> in to mention that section directives are unsupported.
>
>> (You could protect against this with
>>         .pushsection .text; .previous; .subsection 1; // ...
>>         .popsection
>> but it may be overkill.)
>>
>>> + *
>>> + * This macro sequence clobbers x0, x1 and the flags register unconditionally,
>>> + * and may clobber x2 .. x18 if the yield path is taken.
>>> + */
>>> +
>>> +     .macro          cond_yield_neon, lbl
>>> +     if_will_cond_yield_neon
>>> +     do_cond_yield_neon
>>> +     endif_yield_neon        \lbl
>>> +     .endm
>>> +
>>> +     .macro          if_will_cond_yield_neon
>>> +#ifdef CONFIG_PREEMPT
>>> +     get_thread_info x0
>>> +     ldr             w1, [x0, #TSK_TI_PREEMPT]
>>> +     ldr             x0, [x0, #TSK_TI_FLAGS]
>>> +     cmp             w1, #1 // == PREEMPT_OFFSET
>>
>> Can we at least drop a BUILD_BUG_ON() somewhere to check this?
>>
>> Maybe in kernel_neon_begin() since this is intimately kernel-mode NEON
>> related.
>>
>
> Sure.
>

I only just understood your asm-offsets remark earlier. I wasn't aware
that it allows exposing random constants as well (although it is
fairly obvious now that I do). So I will expose PREEMPT_OFFSET rather
than open code it

>>> +     csel            x0, x0, xzr, eq
>>> +     tbnz            x0, #TIF_NEED_RESCHED, 5555f    // needs rescheduling?
>>> +#endif
>>
>> A comment that we will fall through to 6666f here may be helpful.
>>
>
> Indeed. Will add that.
>
>>> +     .subsection     1
>>> +5555:
>>> +     .endm
>>> +
>>> +     .macro          do_cond_yield_neon
>>> +     bl              kernel_neon_end
>>> +     bl              kernel_neon_begin
>>> +     .endm
>>> +
>>> +     .macro          endif_yield_neon, lbl=6666f
>>> +     b               \lbl
>>> +     .previous
>>> +6666:
>>
>> Could have slightly more random "random" labels here, but otherwise
>> it looks ok to me.
>>
>
> Which number did you have in mind that is more random than 6666? :-)
>
>> I might go through and replace all the random labels with something
>> more robust sometime, but I've never been sure it was worth the
>> effort...
>>
>
> I guess we could invent all kinds of elaborate schemes but as you say,
> having 4 digit numbers and grep'ing the source before you add a new
> one has been working fine so far, so I don't think it should be a
> priority.
