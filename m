Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624FEC432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 17:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66DAB20409
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 17:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKMRIT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 12:08:19 -0500
Received: from foss.arm.com ([217.140.110.172]:55786 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbfKMRIT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 12:08:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3005130E;
        Wed, 13 Nov 2019 09:08:18 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CCCA3F534;
        Wed, 13 Nov 2019 09:08:17 -0800 (PST)
Date:   Wed, 13 Nov 2019 17:08:15 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     richard.henderson@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v6 1/1] arm64: Implement archrandom.h for ARMv8.5-RNG
Message-ID: <20191113170814.GB35227@lakrids.cambridge.arm.com>
References: <20191113101151.13389-1-richard.henderson@linaro.org>
 <20191113101151.13389-2-richard.henderson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113101151.13389-2-richard.henderson@linaro.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 13, 2019 at 11:11:51AM +0100, richard.henderson@linaro.org wrote:
> From: Richard Henderson <richard.henderson@linaro.org>
> 
> Expose the ID_AA64ISAR0.RNDR field to userspace, as the
> RNG system registers are always available at EL0.

This patch does more than just that (e.g. implementing
arch_get_random_*()). Please write a more complete commit message.
That's where you should call out any gotchas.

[...]

> +/*
> + * The ALTERNATIVE infrastructure leads GCC to believe that the
> + * inline assembly is quite large, rather than two insns, which
> + * leads to the function being considered not profitable to inline.
> + * Override this decision with __always_inline.
> + */
> +static __always_inline __must_check
> +bool arch_get_random_seed_long(unsigned long *v)
> +{
> +	register unsigned long x0 __asm__("x0");
> +	unsigned long ok;
> +
> +	asm volatile(ALTERNATIVE_CB("bl boot_get_random_seed_long\n",
> +				    arm64_update_get_random_seed_long)
> +		     "cset %1, ne\n"
> +		     : "=r" (x0), "=r" (ok) : : "cc");
> +
> +	*v = x0;
> +	return ok;
> +}

> +/*
> + * Before alternatives are finalized, arch_get_random_seed_long calls
> + * this function.  The abi is as if
> + *
> + *     msr x0, rndr
> + *
> + * Preserve all other call-clobbered regs.
> + */
> +
> +asm(".globl	boot_get_random_seed_long\n"
> +".type	boot_get_random_seed_long, @function\n"
> +"boot_get_random_seed_long:\n"
> +"	stp	x29, x30, [sp, -160]!\n"
> +"	stp	x1, x2, [sp, 16]\n"
> +"	stp	x3, x4, [sp, 32]\n"
> +"	stp	x5, x6, [sp, 48]\n"
> +"	stp	x7, x8, [sp, 64]\n"
> +"	stp	x9, x10, [sp, 80]\n"
> +"	stp	x11, x12, [sp, 96]\n"
> +"	stp	x13, x14, [sp, 112]\n"
> +"	stp	x15, x16, [sp, 128]\n"
> +"	stp	x17, x18, [sp, 144]\n"
> +"	mov	x0, " __stringify(ARM64_HAS_RNG) "\n"
> +"	bl	this_cpu_has_cap\n"
> +"	ldp	x1, x2, [sp, 16]\n"
> +"	ldp	x3, x4, [sp, 32]\n"
> +"	ldp	x5, x6, [sp, 48]\n"
> +"	ldp	x7, x8, [sp, 64]\n"
> +"	ldp	x9, x10, [sp, 80]\n"
> +"	ldp	x11, x12, [sp, 96]\n"
> +"	ldp	x13, x14, [sp, 112]\n"
> +"	ldp	x15, x16, [sp, 128]\n"
> +"	ldp	x17, x18, [sp, 144]\n"
> +"	ldp	x29, x30, [sp], 160\n"
> +/* Test this_cpu_has_cap result, clearing x0 and setting Z if false. */
> +"	ands	w0, w0, #0xff\n"
> +"	beq	1f\n"
> +	__mrs_s("x0", SYS_RNDR_EL0) "\n"
> +"1:	ret\n"
> +".size boot_get_random_seed_long, . - boot_get_random_seed_long\n");
> +
> +
> +void arm64_update_get_random_seed_long(struct alt_instr *alt,
> +				       __le32 *origptr, __le32 *updptr,
> +				       int nr_inst)
> +{
> +	u32 insn;
> +
> +	BUG_ON(nr_inst != 1);
> +
> +	if (cpus_have_cap(ARM64_HAS_RNG))
> +		insn = 0xd53b2400;	/* mrs	x0, rndr */
> +	else
> +		insn = 0xea1f03e0;	/* ands	x0, xzr, xzr */
> +	updptr[0] = cpu_to_le32(insn);
> +}

Sorry if I wasn't sufficiently clear on this before, but I really want
this to be as braindead simple as possible, and so I don't think the
above is the right approach.

Rather than being clever, as above, please let's do this in a simpler
way. If we need to do something early on the boot CPU, we should either:

 * Have the common random init code (running on the boot CPU) use 
   specific early_arch_get_random_*() helpers; and have the arm64
   version of this check this_cpu_has_cap() to determine whether the
   boot CPU has the instruction.

 * Have the arm64 setup_arch() code call something that checks
   this_cpu_has_cap(), and have that explicitly feed entropy to the core
   code somehow.

The common case should just check the system cap, then use the
instruction. In either case the only patching should be for the cap.

Thanks,
Mark.
