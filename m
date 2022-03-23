Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A1EC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 02:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbiCWCQk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 22:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241134AbiCWCQj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 22:16:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607B170075
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 19:15:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C08BBB81DE3
        for <linux-crypto@vger.kernel.org>; Wed, 23 Mar 2022 02:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462C1C340F3;
        Wed, 23 Mar 2022 02:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648001705;
        bh=TDdno/jQsh4BZoZT9Z/5rf8DDidcaJffNvwJocy8FzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dpvW0nBScJCwkgPD0hJE/QD5nThGWiC2/WGr2D7r0gWc469RiOwGVURsNSotOZCDK
         lVzGAe1buMb5kex9954MGOqU7HHM6xYFvNYmXMImhHuUpyeEx6xT1siytm8jVTcpin
         aLQvjzJcn/URaYQmZQqPvpsMkHDhRSF/ixMcpYB5oUHhTGHzt9dRrgSSNdk9RZ1JX5
         Eif1OyfzRoUS2IbrRshmNcrjVEiTlDNikQ9y7+GH73cyAA7KPsxb0829eXgV/PQLCc
         DYINib4YrYeE5U74QXg+y3k/hRjfK2nY18GhJrFXKHT6Sgtr5CWQHO9FWjTH5q4Kku
         pp0h5EhVym4vA==
Date:   Tue, 22 Mar 2022 19:15:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 6/8] crypto: x86/polyval: Add PCLMULQDQ accelerated
 implementation of POLYVAL
Message-ID: <YjqCpxNiFqefyuFO@sol.localdomain>
References: <20220315230035.3792663-1-nhuck@google.com>
 <20220315230035.3792663-7-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315230035.3792663-7-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 15, 2022 at 11:00:33PM +0000, Nathan Huckleberry wrote:
> diff --git a/arch/x86/crypto/polyval-clmulni_asm.S b/arch/x86/crypto/polyval-clmulni_asm.S
> new file mode 100644
> index 000000000000..ad7126d9f0ff
> --- /dev/null
> +++ b/arch/x86/crypto/polyval-clmulni_asm.S
> @@ -0,0 +1,376 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright 2021 Google LLC
> + */
> +/*
> + * This is an efficient implementation of POLYVAL using intel PCLMULQDQ-NI
> + * instructions. It works on 8 blocks at a time, by precomputing the first 8
> + * keys powers h^8, ..., h^1 in the POLYVAL finite field. This precomputation
> + * allows us to split finite field multiplication into two steps.
> + *
> + * In the first step, we consider h^i, m_i as normal polynomials of degree less
> + * than 128. We then compute p(x) = h^8m_0 + ... + h^1m_7 where multiplication
> + * is simply polynomial multiplication.
> + *
> + * In the second step, we compute the reduction of p(x) modulo the finite field
> + * modulus g(x) = x^128 + x^127 + x^126 + x^121 + 1.
> + *
> + * This two step process is equivalent to computing h^8m_0 + ... + h^1m_7 where
> + * multiplication is finite field multiplication. The advantage is that the
> + * two-step process  only requires 1 finite field reduction for every 8
> + * polynomial multiplications. Further parallelism is gained by interleaving the
> + * multiplications and polynomial reductions.
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/frame.h>
> +
> +#define NUM_PRECOMPUTE_POWERS 8

STRIDE_BLOCKS might be a better name than NUM_PRECOMPUTE_POWERS.  Shorter but
more descriptive, IMO.

> +/*
> + * Performs schoolbook1_iteration on two lists of 128-bit polynomials of length
> + * b pointed to by MSG and KEY_POWERS.
> + */
> +.macro schoolbook1 count
> +	.set i, 0
> +	.rept (\count)
> +		schoolbook1_iteration i 0
> +		.set i, (i +1)
> +	.endr
> +.endm

'count', not 'b'.

> +/*
> + * Computes the product of two 128-bit polynomials at the memory locations
> + * specified by (MSG + 16*i) and (KEY_POWERS + 16*i) and XORs the components of the
> + * 256-bit product into LO, MI, HI.
> + *
> + * The multiplication produces four parts:
> + *   LOW: The polynomial given by performing carryless multiplication of the
> + *   bottom 64-bits of each polynomial
> + *   MID1: The polynomial given by performing carryless multiplication of the
> + *   bottom 64-bits of the first polynomial and the top 64-bits of the second
> + *   MID2: The polynomial given by performing carryless multiplication of the
> + *   bottom 64-bits of the second polynomial and the top 64-bits of the first
> + *   HIGH: The polynomial given by performing carryless multiplication of the
> + *   top 64-bits of each polynomial
> + *
> + * We compute:
> + *  LO ^= LOW
> + *  MI ^= MID1 ^ MID2
> + *  HI ^= HIGH
> + *
> + * Later, the 256-bit result can be extracted as:
> + *   [HI_H : HI_L ^ MI_H : LO_H ^ MI_L : LO_L]
> + * This step is done when computing the polynomial reduction for efficiency
> + * reasons.
> + *
> + * If xor_sum == 1, then also XOR the value of SUM into m_0.  This avoids an
> + * extra multiplication of SUM and h^N.
> + */

h^8 instead of h^N?  The above is one of only two places where "N" is mentioned,
and the other uses to mean something different from here.

> +/*
> + * Performs the same computation as schoolbook1_iteration, except we expect the
> + * arguments to already be loaded into xmm0 and xmm1.
> + */
> +.macro schoolbook1_noload
> +	vpclmulqdq $0x01, %xmm0, %xmm1, %xmm2
> +	vpclmulqdq $0x00, %xmm0, %xmm1, %xmm3
> +	vpclmulqdq $0x11, %xmm0, %xmm1, %xmm4
> +	vpclmulqdq $0x10, %xmm0, %xmm1, %xmm5
> +	vpxor %xmm2, MI, MI
> +	vpxor %xmm3, LO, LO
> +	vpxor %xmm5, MI, MI
> +	vpxor %xmm4, HI, HI
> +.endm

How about making this macro set LO, MI, HI and directly instead of XOR'ing into
them?  That's actually what the two users of it want.  I.e.:

/*
 * Performs the same computation as schoolbook1_iteration, except we expect the
 * arguments to already be loaded into xmm0 and xmm1, and we set the result
 * registers LO, MI, and HI directly rather than XOR'ing into them.
 */
.macro schoolbook1_noload
        vpclmulqdq $0x01, %xmm0, %xmm1, MI
        vpclmulqdq $0x10, %xmm0, %xmm1, %xmm2
        vpclmulqdq $0x00, %xmm0, %xmm1, LO
        vpclmulqdq $0x11, %xmm0, %xmm1, HI
        vpxor %xmm2, MI, MI
.endm

That would save some instructions.

> +/*
> + * Computes the 128-bit reduction of PL, PH. Stores the result in PH.

"PL, PH" => "PH : PL".

Also mention which register this clobbers.

> + *
> + * This macro computes p(x) mod g(x) where p(x) is in montgomery form and g(x) =
> + * x^128 + x^127 + x^126 + x^121 + 1.
> + *
> + * We have a 256-bit polynomial P_3 : P_2 : P_1 : P_0 that is the product of

"P_3 : P_2 : P_1 : P_0" => "PH : PL = P_3 : P_2 : P_1 : P_0", so that it's clear
how P_3 through P_0 relate to PH and PL.

> + * two 128-bit polynomials in Montgomery form.  We need to reduce it mod g(x).
> + * Also, since polynomials in Montgomery form have an "extra" factor of x^128,
> + * this product has two extra factors of x^128.  To get it back into Montgomery
> + * form, we need to remove one of these factors by dividing by x^128.
> + *
> + * To accomplish both of these goals, we add multiples of g(x) that cancel out
> + * the low 128 bits P_1 : P_0, leaving just the high 128 bits. Since the low
> + * bits are zero, the polynomial division by x^128 can be done by right shifting.
> + *
> + * Since the only nonzero term in the low 64 bits of g(x) is the constant term,
> + * the multiple of g(x) needed to cancel out P_0 is P_0 * g(x).  The CPU can
> + * only do 64x64 bit multiplications, so split P_0 * g(x) into x^128 * P_0 +
> + * x^64 g*(x) * P_0 + P_0, where g*(x) is bits 64-127 of g(x).  Adding this to

"x^64 g*(x)" => "x^64 * g*(x)"

> + * the original polynomial gives P_3 : P_2 + P_0 + T_1 : P_1 + T_0 : 0, where T
> + * = T_1 : T_0 = g*(x) * P0.  Thus, bits 0-63 got "folded" into bits 64-191.

"P0" => "P_0"

> + *
> + * Repeating this same process on the next 64 bits "folds" bits 64-127 into bits
> + * 128-255, giving the answer in bits 128-255. This time, we need to cancel P_1
> + * + T_0 in bits 64-127. The multiple of g(x) required is (P_1 + T_0) * g(x) *
> + * x^64. Adding this to our previous computation gives P_3 + P_1 + T_0 + V_1 :
> + * P_2 + P_0 + T_1 + V_0 : 0 : 0, where V = V_1 : V_0 = g*(x) * (P_1 + T_0).
> + *
> + * So our final computation is:
> + *   T = T_1 : T_0 = g*(x) * P_0
> + *   V = V_1 : V_0 = g*(x) * (T_0 ^ P_1)
> + *   p(x) / x^{128} mod g(x) = P_3 ^ P_1 ^ V_1 ^ T_0 : P_2 ^ P_0 ^ V_0 ^ T_1

The notation suddenly changes from + to ^.  How about consistently using +?
Or ^, either one as long as it's consistent...

Also, for the final line, the order "P_3 + P_1 + T_0 + V_1 : P_2 + P_0 + T_1 +
V_0" would make more sense, as it would match the logic of the code.

> + *
> + * The implementation below saves a XOR instruction by computing P_1 ^ T_0 : P_0
> + * ^ T_1 and XORing into PH, rather than directly XORing P_1 : P_0, T_0 : T1
> + * into PH.  This allows us to reuse P_1 ^ T_0 when computing V.
> + */
> +.macro montgomery_reduction
> +	movdqa PL, T
> +	pclmulqdq $0x00, GSTAR, T # T = [P_0 * g*(x)]
> +	pshufd $0b01001110, T, V # V = [T_0 : T_1]
> +	pxor V, PL # PL = [P_1 ^ T_0 : P_0 ^ T_1]
> +	pxor PL, PH # PH = [P_1 ^ T_0 ^ P_3 : P_0 ^ T_1 ^ P_2]
> +	pclmulqdq $0x11, GSTAR, PL # PL = [(P_1 ^ T_0) * g*(x)]
> +	pxor PL, PH
> +.endm

Several comments here:

- Aligning the comments would make them much easier to read.

- Only one temporary register is needed, since T isn't used after it's used to
  compute V.

- The thing called V isn't actually the same as the V described in the long
  comment above.  Maybe just call the temporary variable 'TMP_XMM' or something?
  Or even just hard-code %xmm6, similar to %xmm0-%xmm5.

- It's not necessary to modify PL.

- Since this file is relying on AVX anyway, the three-operand instructions are
  available, and can be used to avoid the 'movdqa' at the beginning.

- None of the users of this macro really want the result in register PH.  How
  about passing the destination register as an argument and using vpxor to put
  it in the appropriate place?

So in summary, this is what I'd suggest:

.macro montgomery_reduction dest
	vpclmulqdq $0x00, GSTAR, PL, TMP_XMM	# TMP_XMM = T_1 : T_0 = P_0 * g*(x)
	pshufd $0b01001110, TMP_XMM, TMP_XMM	# TMP_XMM = T_0 : T_1
	pxor PL, TMP_XMM			# TMP_XMM = P_1 + T_0 : P_0 + T_1
	pxor TMP_XMM, PH			# PH = P_3 + P_1 + T_0 : P_2 + P_0 + T_1
	pclmulqdq $0x11, GSTAR, TMP_XMM		# TMP_XMM = V_1 : V_0 = V = [(P_1 + T_0) * g*(x)]
	vpxor TMP_XMM, PH, \dest
.endm

> +
> +/*
> + * Compute schoolbook multiplication for 8 blocks
> + * m_0h^8 + ... + m_7h^1
> + *
> + * If reduce is set, also computes the montgomery reduction of the
> + * previous full_stride call and XORs with the first message block.
> + * (m_0 + REDUCE(PL, PH))h^8 + ... + m_7h^1.
> + * I.e., the first multiplication uses m_0 + REDUCE(PL, PH) instead of m_0.
> + *
> + * Sets PL, PH
> + * Clobbers LO, HI, MI
> + *
> + */
> +.macro full_stride reduce
> +	mov %rsi, KEY_POWERS

I don't see why KEY_POWERS and %rsi are different registers.  Why not just
define KEY_POWERS to %rsi?  It stays the same during any full_strides, and then
will be incremented by partial_stride.  That's fine.

[...]
> +	addq $(8*16), KEY_POWERS

As per the above, there's no need to increment KEY_POWERS here.

> +	schoolbook2
> +.endm
> +
> +/*
> + * Compute poly on window size of %rdx blocks
> + * 0 < %rdx < NUM_PRECOMPUTE_POWERS
> + */

The code doesn't actually use %rdx directly.  It should be BLOCKS_LEFT.

> +.macro partial_stride
> +	pxor LO, LO
> +	pxor HI, HI
> +	pxor MI, MI
> +	mov BLOCKS_LEFT, TMP
> +	shlq $4, TMP
> +	mov %rsi, KEY_POWERS
> +	addq $(16*NUM_PRECOMPUTE_POWERS), KEY_POWERS
> +	subq TMP, KEY_POWERS
> +	# Multiply sum by h^N
> +	movups (KEY_POWERS), %xmm0
> +	movdqa SUM, %xmm1
> +	schoolbook1_noload
> +	schoolbook2
> +	montgomery_reduction
> +	movdqa PH, SUM
> +	pxor LO, LO
> +	pxor HI, HI
> +	pxor MI, MI
> +	xor IDX, IDX
> +.LloopPartial:
> +	cmpq BLOCKS_LEFT, IDX # IDX < rdx
> +	jae .LloopExitPartial
> +
> +	movq BLOCKS_LEFT, TMP
> +	subq IDX, TMP # TMP = rdx - IDX
> +
> +	cmp $4, TMP # TMP < 4 ?
> +	jl .Llt4Partial
> +	schoolbook1 4
> +	addq $4, IDX
> +	addq $(4*16), MSG
> +	addq $(4*16), KEY_POWERS
> +	jmp .LoutPartial
> +.Llt4Partial:
> +	cmp $3, TMP # TMP < 3 ?
> +	jl .Llt3Partial
> +	schoolbook1 3
> +	addq $3, IDX
> +	addq $(3*16), MSG
> +	addq $(3*16), KEY_POWERS
> +	jmp .LoutPartial
> +.Llt3Partial:
> +	cmp $2, TMP # TMP < 2 ?
> +	jl .Llt2Partial
> +	schoolbook1 2
> +	addq $2, IDX
> +	addq $(2*16), MSG
> +	addq $(2*16), KEY_POWERS
> +	jmp .LoutPartial
> +.Llt2Partial:
> +	schoolbook1 1 # TMP < 1 ?
> +	addq $1, IDX
> +	addq $(1*16), MSG
> +	addq $(1*16), KEY_POWERS
> +.LoutPartial:
> +	jmp .LloopPartial
> +.LloopExitPartial:
> +	schoolbook2
> +	montgomery_reduction
> +	pxor PH, SUM
> +.endm

This can be simplified and optimized quite a bit:

- The first schoolbook2 and montgomery_reduction are unnecessary.
- The IDX variable is unnecessary.
- There's no need for a loop if there are going to be separate cases for 4, 2,
  and 1 blocks anyway.  We can just always jump forward.
- There's no need to increment MSG and KEY_POWERS after the last block.

Can you consider the following?

/*
 * Process BLOCKS_LEFT blocks, where 0 < BLOCKS_LEFT < STRIDE_BLOCKS
 */
.macro partial_stride
	mov BLOCKS_LEFT, TMP
	shlq $4, TMP
	addq $(16*STRIDE_BLOCKS), KEY_POWERS
	subq TMP, KEY_POWERS

	movups (MSG), %xmm0
	pxor SUM, %xmm0
	movaps (KEY_POWERS), %xmm1
	schoolbook1_noload
	dec BLOCKS_LEFT
	addq $16, MSG
	addq $16, KEY_POWERS

	test $4, BLOCKS_LEFT
	jz .Lpartial4BlocksDone
	schoolbook1 4
	addq $(4*16), MSG
	addq $(4*16), KEY_POWERS
.Lpartial4BlocksDone:
	test $2, BLOCKS_LEFT
	jz .Lpartial2BlocksDone
	schoolbook1 2
	addq $(2*16), MSG
	addq $(2*16), KEY_POWERS
.Lpartial2BlocksDone:
	test $1, BLOCKS_LEFT
	jz .LpartialDone
	schoolbook1 1
.LpartialDone:
	schoolbook2
	montgomery_reduction SUM
.endm

> +	FRAME_END
> +	ret
> +SYM_FUNC_END(clmul_polyval_mul)

It needs to be RET, not ret.  See https://git.kernel.org/linus/f94909ceb1ed4bfd

> +
> +/*
> + * Perform polynomial evaluation as specified by POLYVAL.  This computes:
> + * 	h^n * accumulator + h^n * m_0 + ... + h^1 * m_{n-1}
> + * where n=nblocks, h is the hash key, and m_i are the message blocks.
> + *
> + * rdi - pointer to message blocks
> + * rsi - pointer to precomputed key powers h^8 ... h^1
> + * rdx - number of blocks to hash
> + * rcx - pointer to the accumulator
> + *
> + * void clmul_polyval_update(const u8 *in, const struct polyval_ctx *ctx,
> + *			     size_t nblocks, u8 *accumulator);
> + */
> +SYM_FUNC_START(clmul_polyval_update)
> +	FRAME_BEGIN
> +	vmovdqa .Lgstar(%rip), GSTAR
> +	movups (%rcx), SUM
> +	cmpq $NUM_PRECOMPUTE_POWERS, BLOCKS_LEFT
> +	jb .LstrideLoopExit
> +	full_stride 0
> +	subq $NUM_PRECOMPUTE_POWERS, BLOCKS_LEFT
> +.LstrideLoop:
> +	cmpq $NUM_PRECOMPUTE_POWERS, BLOCKS_LEFT
> +	jb .LstrideLoopExitReduce
> +	full_stride 1
> +	subq $NUM_PRECOMPUTE_POWERS, BLOCKS_LEFT
> +	jmp .LstrideLoop
> +.LstrideLoopExitReduce:
> +	montgomery_reduction
> +	movdqa PH, SUM
> +.LstrideLoopExit:
> +	test BLOCKS_LEFT, BLOCKS_LEFT
> +	je .LskipPartial
> +	partial_stride
> +.LskipPartial:
> +	movups SUM, (%rcx)
> +	FRAME_END
> +	ret
> +SYM_FUNC_END(clmul_polyval_update)

There are several unneeded instructions above.  Unconditional jumps can be
avoided, as can comparisons if they are already paired with subtractions using
the same amounts (since on x86, subtractions set the flags too).

Consider the following:

SYM_FUNC_START(clmul_polyval_update)
	FRAME_BEGIN
	vmovdqa .Lgstar(%rip), GSTAR
	movups (%rcx), SUM
	subq $STRIDE_BLOCKS, BLOCKS_LEFT
	js .LstrideLoopExit
	full_stride 0
	subq $STRIDE_BLOCKS, BLOCKS_LEFT
	js .LstrideLoopExitReduce
.LstrideLoop:
	full_stride 1
	subq $STRIDE_BLOCKS, BLOCKS_LEFT
	jns .LstrideLoop
.LstrideLoopExitReduce:
	montgomery_reduction SUM
.LstrideLoopExit:
	add $STRIDE_BLOCKS, BLOCKS_LEFT
	jz .LskipPartial
	partial_stride
.LskipPartial:
	movups SUM, (%rcx)
	FRAME_END
	RET
SYM_FUNC_END(clmul_polyval_update)


- Eric
