From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/5] crypto: arm64 - disable NEON across scatterwalk API calls
Date: Sat, 2 Dec 2017 11:15:14 +0000
Message-ID: <CAKv+Gu_DMVYX8y-8JJwyxy2rF0+6ofSWyjwpvwuF042ievBb7w@mail.gmail.com>
References: <20171201211927.24653-1-ard.biesheuvel@linaro.org>
 <20171202090107.GT3326@worktop> <CAKv+Gu-dG0Zc35NZZ85U36K2TXCpN+wJTYOyjkhxRjXbdiJTAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rt-users@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:43382 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdLBLPQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Dec 2017 06:15:16 -0500
Received: by mail-it0-f68.google.com with SMTP id u62so5228767ita.2
        for <linux-crypto@vger.kernel.org>; Sat, 02 Dec 2017 03:15:15 -0800 (PST)
In-Reply-To: <CAKv+Gu-dG0Zc35NZZ85U36K2TXCpN+wJTYOyjkhxRjXbdiJTAQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 December 2017 at 09:11, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 2 December 2017 at 09:01, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, Dec 01, 2017 at 09:19:22PM +0000, Ard Biesheuvel wrote:
>>> Note that the remaining crypto drivers simply operate on fixed buffers, so
>>> while the RT crowd may still feel the need to disable those (and the ones
>>> below as well, perhaps), they don't call back into the crypto layer like
>>> the ones updated by this series, and so there's no room for improvement
>>> there AFAICT.
>>
>> Do these other drivers process all the blocks fed to them in one go
>> under a single NEON section, or do they do a single fixed block per
>> NEON invocation?
>
> They consume the entire input in a single go, yes. But making it more
> granular than that is going to hurt performance, unless we introduce
> some kind of kernel_neon_yield(), which does a end+begin but only if
> the task is being scheduled out.
>
> For example, the SHA256 keeps 256 bytes of round constants in NEON
> registers, and reloading those from memory for each 64 byte block of
> input is going to be noticeable. The same applies to the AES code
> (although the numbers are slightly different)

Something like below should do the trick I think (apologies for the
patch soup). I.e., check TIF_NEED_RESCHED at a point where only very
few NEON registers are live, and preserve/restore the live registers
across calls to kernel_neon_end + kernel_neon_begin. Would that work
for RT?


diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 679c6c002f4f..4f12038574f3 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -77,6 +77,10 @@
  *   int blocks)
  */
 ENTRY(sha2_ce_transform)
+ stp x29, x30, [sp, #-48]!
+ mov x29, sp
+
+restart:
  /* load round constants */
  adr x8, .Lsha2_rcon
  ld1 { v0.4s- v3.4s}, [x8], #64
@@ -129,14 +133,17 @@ CPU_LE( rev32 v19.16b, v19.16b )
  add dgbv.4s, dgbv.4s, dg1v.4s

  /* handled all input blocks? */
- cbnz w2, 0b
+ cbz w2, 2f
+
+ tif_need_resched 4f, 5
+ b 0b

  /*
  * Final block: add padding and total bit count.
  * Skip if the input size was not a round multiple of the block size,
  * the padding is handled by the C code in that case.
  */
- cbz x4, 3f
+2: cbz x4, 3f
  ldr_l w4, sha256_ce_offsetof_count, x4
  ldr x4, [x0, x4]
  movi v17.2d, #0
@@ -151,5 +158,15 @@ CPU_LE( rev32 v19.16b, v19.16b )

  /* store new state */
 3: st1 {dgav.4s, dgbv.4s}, [x0]
+ ldp x29, x30, [sp], #48
  ret
+
+4: st1 {dgav.4s, dgbv.4s}, [x0]
+ stp x0, x1, [sp, #16]
+ stp x2, x4, [sp, #32]
+ bl kernel_neon_end
+ bl kernel_neon_begin
+ ldp x0, x1, [sp, #16]
+ ldp x2, x4, [sp, #32]
+ b restart
 ENDPROC(sha2_ce_transform)
diff --git a/arch/arm64/include/asm/assembler.h
b/arch/arm64/include/asm/assembler.h
index aef72d886677..e3e7e15ebefd 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -512,4 +512,15 @@ alternative_else_nop_endif
 #endif
  .endm

+/*
+ * Check TIF_NEED_RESCHED flag from assembler (for kernel mode NEON)
+ */
+ .macro tif_need_resched, lbl:req, regnum:req
+#ifdef CONFIG_PREEMPT
+ get_thread_info x\regnum
+ ldr w\regnum, [x\regnum, #TSK_TI_FLAGS] // get flags
+ tbnz w\regnum, #TIF_NEED_RESCHED, \lbl // needs rescheduling?
+#endif
+ .endm
+
 #endif /* __ASM_ASSEMBLER_H */
