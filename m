From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 11/19] arm64: assembler: add macro to conditionally yield the NEON under PREEMPT
Date: Tue, 5 Dec 2017 12:45:01 +0000
Message-ID: <DD92A22D-E5EF-4C97-8C76-4797892518A4@linaro.org>
References: <20171204122645.31535-1-ard.biesheuvel@linaro.org> <20171204122645.31535-12-ard.biesheuvel@linaro.org> <20171205122757.GW22781@e103592.cambridge.arm.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        herbert@gondor.apana.org.au, Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rt-users@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20171205122757.GW22781@e103592.cambridge.arm.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On 5 Dec 2017, at 12:28, Dave Martin <Dave.Martin@arm.com> wrote:
>=20
>> On Mon, Dec 04, 2017 at 12:26:37PM +0000, Ard Biesheuvel wrote:
>> Add a support macro to conditionally yield the NEON (and thus the CPU)
>> that may be called from the assembler code. Given that especially the
>> instruction based accelerated crypto code may use very tight loops, add
>> some parametrization so that the TIF_NEED_RESCHED flag test is only
>> executed every so many loop iterations.
>>=20
>> In some cases, yielding the NEON involves saving and restoring a non
>> trivial amount of context (especially in the CRC folding algorithms),
>> and so the macro is split into two, and the code in between is only
>> executed when the yield path is taken, allowing the contex to be preserve=
d.
>> The second macro takes a label argument that marks the resume-from-yield
>> path, which should restore the preserved context again.
>>=20
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> arch/arm64/include/asm/assembler.h | 50 ++++++++++++++++++++
>> 1 file changed, 50 insertions(+)
>>=20
>> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/=
assembler.h
>> index aef72d886677..917b026d3e00 100644
>> --- a/arch/arm64/include/asm/assembler.h
>> +++ b/arch/arm64/include/asm/assembler.h
>> @@ -512,4 +512,54 @@ alternative_else_nop_endif
>> #endif
>>    .endm
>>=20
>> +/*
>> + * yield_neon - check whether to yield to another runnable task from
>> + *        kernel mode NEON code (running with preemption disabled)
>> + *
>> + * - Check whether the preempt count is exactly 1, in which case disabli=
ng
>> + *   preemption once will make the task preemptible. If this is not the c=
ase,
>> + *   yielding is pointless.
>> + * - Check whether TIF_NEED_RESCHED is set, and if so, disable and re-en=
able
>> + *   kernel mode NEON (which will trigger a reschedule), and branch to t=
he
>> + *   yield fixup code at @lbl.
>> + */
>> +    .macro        yield_neon, lbl:req, ctr, order, stride, loop
>> +    yield_neon_pre    \ctr, \order, \stride, \loop
>> +    yield_neon_post    \lbl
>> +    .endm
>> +
>> +    .macro        yield_neon_pre, ctr, order=3D0, stride, loop=3D4444f
>> +#ifdef CONFIG_PREEMPT
>> +    /*
>> +     * With some algorithms, it makes little sense to poll the
>> +     * TIF_NEED_RESCHED flag after every iteration, so only perform
>> +     * the check every 2^order strides.
>> +     */
>> +    .if        \order > 1
>> +    .if        (\stride & (\stride - 1)) !=3D 0
>> +    .error        "stride should be a power of 2"
>> +    .endif
>> +    tst        \ctr, #((1 << \order) * \stride - 1) & ~(\stride - 1)
>> +    b.ne        \loop
>> +    .endif
>=20
> I'm not sure what baking in this check gives us, and this seems to
> conflate two rather different things: yielding and defining a
> "heartbeat" frequency for the calling code.
>=20
> Can we separate out the crypto-loop-helper semantics from the yield-
> neon stuff?
>=20

Fair enough. I incorporated the check here so it disappears from the code en=
tirely when !CONFIG_PREEMPT, because otherwise, you end up with a sequence t=
hat is mispredicted every # iterations without any benefit.
I guess i could macroise that separately though.

> If we had
>=20
>    if_cond_yield_neon
>    // patchup code
>    endif_yield_neon
>=20
> then the caller is free to conditionally branch over that as appropriate
> like
>=20
> loop:
>    // crypto stuff
>    tst x0, #0xf
>    b.ne    loop
>=20
>    if_cond_yield_neon
>    // patchup code
>    endif_cond_yield_neon
>=20
>    b    loop
>=20
> I think this is clearer than burying checks and branches in a macro that
> is trying to be generic.
>=20

Agreed.

> Label arguments can be added to elide some branches of course, at a
> corresponding cost to clarity...  in the common case the cache will
> be hot and the branches won't be mispredicted though.  Is it really
> worth it?
>=20

Perhaps not. And i have not made any attempts yet to benchmark at great deta=
il, given that i need some feedback from the rt crowd first whether this is l=
ikely to work as desired.

>> +
>> +    get_thread_info    x0
>> +    ldr        w1, [x0, #TSK_TI_PREEMPT]
>> +    ldr        x0, [x0, #TSK_TI_FLAGS]
>> +    cmp        w1, #1 // =3D=3D PREEMPT_OFFSET
>=20
> asm-offsets?
>=20

This is not an offset in that regard, but the header that defines it is not a=
sm safe

> [...]
>=20
> Cheers
> ---Dave
