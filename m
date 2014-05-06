From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH resend 04/15] arm64: add support for kernel mode NEON in
 interrupt context
Date: Tue, 6 May 2014 19:09:23 +0200
Message-ID: <CAKv+Gu89KOcBnUgktw-vCogqn5VTcOSsZCer6Qty3rXf4-9zyw@mail.gmail.com>
References: <1398959381-8126-1-git-send-email-ard.biesheuvel@linaro.org>
 <1398959381-8126-5-git-send-email-ard.biesheuvel@linaro.org>
 <20140506164918.GK23957@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "steve.capper@linaro.org" <steve.capper@linaro.org>,
 Will Deacon <Will.Deacon@arm.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20140506164918.GK23957@arm.com>
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

On 6 May 2014 18:49, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Thu, May 01, 2014 at 04:49:36PM +0100, Ard Biesheuvel wrote:
>> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
>> index 7a900142dbc8..05e1b24aca4c 100644
>> --- a/arch/arm64/include/asm/fpsimd.h
>> +++ b/arch/arm64/include/asm/fpsimd.h
>> @@ -41,6 +41,17 @@ struct fpsimd_state {
>>       unsigned int cpu;
>>  };
>>
>> +/*
>> + * Struct for stacking the bottom 'n' FP/SIMD registers.
>> + */
>> +struct fpsimd_partial_state {
>> +     u32             num_regs;
>> +     u32             fpsr;
>> +     u32             fpcr;
>> +     __uint128_t     vregs[32] __aligned(16);
>> +} __aligned(16);
>
> Do we need this explicit alignment here?
>

Without it, the implied alignment is 8 bytes, I suppose, but I haven't
checked carefully.
I will check and remove this if 8 bytes is the default.

>> diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
>> index bbec599c96bd..69e75134689d 100644
>> --- a/arch/arm64/include/asm/fpsimdmacros.h
>> +++ b/arch/arm64/include/asm/fpsimdmacros.h
>> @@ -62,3 +62,38 @@
>>       ldr     w\tmpnr, [\state, #16 * 2 + 4]
>>       msr     fpcr, x\tmpnr
>>  .endm
>> +
>> +.altmacro
>> +.macro fpsimd_save_partial state, numnr, tmpnr1, tmpnr2
>> +     mrs     x\tmpnr1, fpsr
>> +     str     w\numnr, [\state]
>> +     mrs     x\tmpnr2, fpcr
>> +     stp     w\tmpnr1, w\tmpnr2, [\state, #4]
>> +     adr     x\tmpnr1, 0f
>> +     add     \state, \state, x\numnr, lsl #4
>> +     sub     x\tmpnr1, x\tmpnr1, x\numnr, lsl #1
>> +     br      x\tmpnr1
>> +     .irp    qa, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2, 0
>> +     .irp    qb, %(qa + 1)
>> +     stp     q\qa, q\qb, [\state, # -16 * \qa - 16]
>> +     .endr
>> +     .endr
>> +0:
>> +.endm
>> +
>> +.macro fpsimd_restore_partial state, tmpnr1, tmpnr2
>> +     ldp     w\tmpnr1, w\tmpnr2, [\state, #4]
>> +     msr     fpsr, x\tmpnr1
>> +     msr     fpcr, x\tmpnr2
>> +     adr     x\tmpnr1, 0f
>> +     ldr     w\tmpnr2, [\state]
>> +     add     \state, \state, x\tmpnr2, lsl #4
>> +     sub     x\tmpnr1, x\tmpnr1, x\tmpnr2, lsl #1
>> +     br      x\tmpnr1
>> +     .irp    qa, 30, 28, 26, 24, 22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2, 0
>> +     .irp    qb, %(qa + 1)
>> +     ldp     q\qa, q\qb, [\state, # -16 * \qa - 16]
>> +     .endr
>> +     .endr
>> +0:
>> +.endm
>
> BTW, it may be better if num_regs is placed at the end of the structure,
> especially since you use stp to store both fpsr and fpcr (though I
> haven't rewritten the above to see how they look).
>

I suppose you mean in the middle, i.e., after fpsr and fpcr?
Yes that makes sense, I will change that.

-- 
Ard.
