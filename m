Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE653E3C45;
	Mon, 13 Apr 2026 19:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109612; cv=none; b=KP1SjY4FVitBFiVApsZSNZFaChibCYocDVAwXvxRceGsomo/lnpaHWTCaGQ8Kw7K8VEznvQoJYM3hxCRWcJ6TqYkq8pzP6LVxgRgnhYYrc+FP6v/yAoNKExSnVxz72A2OEFDET0IRWwfrqdTGRg28WXah19JNRiPYyE2m3RFRPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109612; c=relaxed/simple;
	bh=F92yqkbWUsJNWwla5E/IA+JwEhDJyPr91dLdxI1UV2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnu/EGtRR09C10NQsAayZVG0plPHd4I1GSwbMXhl7K8qt/ld4dI9DLeLHVAUNR3giEbb3mPvZNCtquy5RJFsSgj4YogKkvsv/0lU5dt2yTlpp5647nqIUu6YkGfAkOQ/w1/DxXHWE2zHwB/qz2+w+lx9/5yw27sAIYmuTV9vV88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id 34BE410606;
	Mon, 13 Apr 2026 21:46:38 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 194AA6151B46; Mon, 13 Apr 2026 21:46:38 +0200 (CEST)
Date: Mon, 13 Apr 2026 21:46:38 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <ad1IHo1rkVxqeMkc@wunner.de>
References: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
 <adY8iUPrnoXDp_-g@ashevche-desk.local>
 <adZZ70lNnhoDnwok@wunner.de>
 <05d3e296-1b61-4ab4-9bec-6c11407e6f89@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WgAw6ZgpYYzlY3nX"
Content-Disposition: inline
In-Reply-To: <05d3e296-1b61-4ab4-9bec-6c11407e6f89@app.fastmail.com>


--WgAw6ZgpYYzlY3nX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 13, 2026 at 05:42:39PM +0200, Arnd Bergmann wrote:
> On Wed, Apr 8, 2026, at 15:36, Lukas Wunner wrote:
> > On Wed, Apr 08, 2026 at 02:31:21PM +0300, Andy Shevchenko wrote:
> > > On Wed, Apr 08, 2026 at 08:15:49AM +0200, Lukas Wunner wrote:
> > > > Prevent gcc from going overboard with inlining to unbreak the build.
> > > > The maximum inline limit to avoid the error is 101.  Use 100 to get a
> > > > nice round number per Andrew's preference.
> 
> Have you checked if the total call chain gets a lower stack usage this
> way? Usually the high stack usage is a sign of absolutely awful
> code generation when the compiler runs into a corner case that
> spills variables onto the stack instead of keeping them in registers.
> 
> The question is whether the lower inline limit causes the compiler
> to not get into this state at all and produce the expected object
> code, or if it just ends up producing multiple functions that
> stay under the limit individually but have the same problems with
> stack usage and performance as before.

Attached please find the Assembler output created by gcc -save-temps,
both the original version and the one with limited inlining.

The former requires a 1360 bytes stack frame, the latter 1232 bytes.
E.g. xycz_initial_double() is not inlined into ecc_point_mult(),
together with all its recursive baggage, so the latter version
contains two branch instructions to that function which the former
(original) version does not contain.

At the beginning of the function, it looks like the same register values
are stored to multiple locations on the stack.  I assume that's what you
mean by awful code generation?  This odd behavior seems more subdued in
the version with limited inlining.

> I think your patch can be merged either way, but it would be
> good to describe what type of problem we are hitting here.

I will respin and I will also take Nathan's suggestion into account.

Thanks,

Lukas

--WgAw6ZgpYYzlY3nX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ecc_point_mult_orig.s"

	.section	.rodata.ecc_point_mult.str1.4,"aMS",%progbits,1
	.align	2
.LC43:
	.ascii	"7 48 72 6 z:1337 160 72 6 z:1208 272 72 7 t1:1196 3"
	.ascii	"84 144 7 rx:1335 592 144 7 ry:1336 800 144 7 sk:133"
	.ascii	"8 1008 144 12 product:1018\000"
	.section	.text.ecc_point_mult,"ax",%progbits
	.align	2
	.syntax unified
	.arm
	.type	ecc_point_mult, %function
ecc_point_mult:
.LASANPC2762:
	.fnstart
	@ args = 8, pretend = 0, frame = 1360
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	.save {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	.pad #1360
	sub	sp, sp, #1360
	.pad #12
	sub	sp, sp, #12
	push	{lr}
	bl	__gnu_mcount_nc
	str	r3, [sp, #80]
	add	r3, sp, #1360
	add	r3, r3, #8
	bic	r9, r3, #31
	sub	r3, r9, #1248
	ldr	ip, .L2798
	lsr	r3, r3, #3
	add	r7, r3, #-1627389952
	str	r0, [sp, #52]
	str	r1, [sp, #32]
	ldr	r4, [sp, #1408]
	str	r9, [sp, #44]
	str	r7, [sp, #68]
	str	ip, [r9, #-1248]
	ldr	ip, .L2798+4
	ldr	r3, .L2798+8
	str	ip, [r9, #-1244]
	ldr	ip, .L2798+12
	ldr	lr, .L2798+16
	ldr	r0, .L2798+20
	ldr	r1, .L2798+24
	ldr	r5, .L2798+28
	ldr	r6, .L2798+32
	mov	r8, r2
	ldr	r2, .L2798+36
	str	ip, [r9, #-1240]
	mov	ip, #-234881024
	str	r3, [r7, #16]
	str	r3, [r7, #44]
	str	r3, [r7, #68]
	str	r3, [r7, #92]
	str	r3, [r7, #96]
	str	r3, [r7, #120]
	ldr	r3, .L2798+40
	str	lr, [r7, #28]
	str	ip, [r7, #12]
	str	ip, [r7, #40]
	str	r5, [r7, #4]
	str	r2, [r7, #32]
	str	r0, [r7, #64]
	str	r0, [r7, #116]
	str	r2, [r7, #72]
	str	r2, [r7, #124]
	str	r1, [r7, #144]
	str	r1, [r7, #148]
	str	r6, [r7]
	ldr	r3, [r3]
	str	r3, [sp, #1364]
	mov	r3, #0
	bl	__sanitizer_cov_trace_pc
	sub	r3, r9, #864
	mov	r2, #144
	mov	r1, #254
	mov	r0, r3
	sub	r5, r9, #448
	str	r3, [sp, #40]
	bl	memset
	sub	r3, r9, #656
	mov	r2, #144
	mov	r1, #254
	mov	r0, r3
	str	r3, [sp, #24]
	bl	memset
	sub	r3, r9, #1200
	mov	r0, r3
	mov	r2, #72
	mov	r1, #254
	str	r3, [sp, #36]
	bl	memset
	mov	r2, #144
	mov	r1, #254
	mov	r0, r5
	bl	memset
	add	r0, r4, #20
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2534
	bl	__asan_report_load4_noabort
.L2534:
	add	r0, r4, #24
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	ldr	r3, [r4, #20]
	str	r3, [sp, #56]
	beq	.L2535
	bl	__asan_report_load4_noabort
.L2535:
	ldr	r1, [sp, #1412]
	mov	r0, #0
	ldr	r7, [r4, #24]
	bl	__sanitizer_cov_trace_const_cmp4
	ldr	r3, [sp, #1412]
	cmp	r3, #0
	beq	.L2536
	mov	r6, r5
	mov	r1, #0
	mov	r10, r7
	strd	r6, [sp, #16]
	mov	r9, r5
	mov	r7, r1
	str	r1, [sp, #8]
	str	r4, [sp, #28]
	str	r5, [sp, #48]
.L2541:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r8, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2537
	mov	r0, r8
	bl	__asan_report_load8_noabort
.L2537:
	lsr	r3, r10, #3
	add	r3, r3, #-1627389952
	ldm	r8, {r6, fp}
	ldrsb	r3, [r3]
	add	r8, r8, #8
	mov	r5, r10
	cmp	r3, #0
	beq	.L2538
	mov	r0, r10
	bl	__asan_report_load8_noabort
.L2538:
	ldrd	r4, [r5]
	ldr	r3, [sp, #8]
	mov	r0, r6
	adds	r4, r6, r4
	adc	r5, fp, r5
	adds	r4, r4, r3
	adc	r5, r5, #0
	mov	r2, r4
	mov	r3, r5
	mov	r1, fp
	bl	__sanitizer_cov_trace_cmp8
	cmp	fp, r5
	cmpeq	r6, r4
	add	r10, r10, #8
	beq	.L2539
	bl	__sanitizer_cov_trace_pc
	mov	r3, r5
	mov	r1, fp
	mov	r2, r4
	mov	r0, r6
	bl	__sanitizer_cov_trace_cmp8
	cmp	r4, r6
	sbcs	r1, r5, fp
	movcc	r3, #1
	movcs	r3, #0
	str	r3, [sp, #8]
.L2539:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r9, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2540
	mov	r0, r9
	bl	__asan_report_store8_noabort
.L2540:
	add	r7, r7, #1
	strd	r4, [r9]
	ldr	r0, [sp, #1412]
	mov	r1, r7
	bl	__sanitizer_cov_trace_cmp4
	add	r9, r9, #8
	ldr	r3, [sp, #1412]
	cmp	r7, r3
	bne	.L2541
	ldr	r4, [sp, #28]
	ldr	r5, [sp, #48]
	ldrd	r6, [sp, #16]
	bl	__sanitizer_cov_trace_pc
	mov	r10, #0
	str	r10, [sp, #16]
	str	r4, [sp, #20]
	str	r5, [sp, #28]
	b	.L2550
.L2536:
	bl	__sanitizer_cov_trace_pc
	add	r0, r4, #4
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2543
	bl	__asan_report_load4_noabort
.L2543:
	ldr	r8, [r4, #4]
	ldr	r5, .L2798+44
	mov	r1, r8
	mov	r0, r5
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	r8, r5
	ldr	r3, [sp, #44]
	beq	.L2632
	sub	r3, r3, #376
	str	r3, [sp, #28]
	b	.L2545
.L2633:
	mov	r6, r9
.L2550:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2546
	mov	r0, r6
	bl	__asan_report_load8_noabort
.L2546:
	lsr	r3, r7, #3
	add	r3, r3, #-1627389952
	ldm	r6, {r8, fp}
	ldrsb	r3, [r3]
	add	r9, r6, #8
	mov	r5, r7
	cmp	r3, #0
	beq	.L2547
	mov	r0, r7
	bl	__asan_report_load8_noabort
.L2547:
	ldrd	r4, [r5]
	ldr	r3, [sp, #16]
	mov	r0, r8
	adds	r4, r8, r4
	adc	r5, fp, r5
	adds	r4, r4, r3
	adc	r5, r5, #0
	mov	r2, r4
	mov	r3, r5
	mov	r1, fp
	bl	__sanitizer_cov_trace_cmp8
	cmp	fp, r5
	cmpeq	r8, r4
	add	r7, r7, #8
	beq	.L2548
	bl	__sanitizer_cov_trace_pc
	mov	r3, r5
	mov	r1, fp
	mov	r2, r4
	mov	r0, r8
	bl	__sanitizer_cov_trace_cmp8
	cmp	r4, r8
	sbcs	r1, r5, fp
	movcc	r3, #1
	movcs	r3, #0
	str	r3, [sp, #16]
.L2548:
	add	r6, r6, #72
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2549
	mov	r0, r6
	bl	__asan_report_store8_noabort
.L2549:
	add	r10, r10, #1
	ldr	r0, [sp, #1412]
	mov	r1, r10
	strd	r4, [r9, #64]
	bl	__sanitizer_cov_trace_cmp4
	ldr	r3, [sp, #1412]
	cmp	r10, r3
	bne	.L2633
	ldr	r4, [sp, #20]
	ldr	r5, [sp, #28]
	bl	__sanitizer_cov_trace_pc
	add	r0, r4, #4
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	ldrsb	r2, [r2]
	ldr	r3, [sp, #8]
	eor	r3, r3, #1
	rsb	r3, r3, #0
	and	r3, r3, #72
	add	r3, r5, r3
	str	r3, [sp, #28]
	and	r3, r0, #7
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2552
	bl	__asan_report_load4_noabort
.L2552:
	ldr	r6, [r4, #4]
	ldr	r5, .L2798+44
	mov	r1, r6
	mov	r0, r5
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	r6, r5
	beq	.L2553
.L2545:
	bl	__sanitizer_cov_trace_pc
	ldr	r3, [sp, #1412]
	lsl	r8, r3, #6
	bl	__sanitizer_cov_trace_pc
	sub	r8, r8, #1
	ldr	r1, [sp, #32]
	lsr	r3, r1, #3
	str	r3, [sp, #76]
	add	r3, r3, #-1627389952
	ldrsb	r2, [r3]
	and	r3, r1, #7
	str	r3, [sp, #72]
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2554
	mov	r0, r1
	bl	__asan_report_load4_noabort
.L2554:
	ldr	r3, [sp, #32]
	ldr	r1, [sp, #1412]
	mov	r0, #0
	ldr	r5, [r3]
	bl	__sanitizer_cov_trace_const_cmp4
	ldr	r3, [sp, #1412]
	cmp	r3, #0
	bne	.L2630
	ldr	r3, [sp, #44]
	sub	r2, r3, #792
	str	r2, [sp, #48]
	ldr	r2, [sp, #32]
	sub	r3, r3, #584
	add	r2, r2, #4
	str	r2, [sp, #64]
	str	r3, [sp, #60]
	b	.L2559
.L2630:
	ldr	r3, [sp, #44]
	ldr	r9, [sp, #1412]
	sub	r3, r3, #792
	mov	r6, r3
	mov	r7, #0
	str	r3, [sp, #48]
.L2557:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r5, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2555
	mov	r0, r5
	bl	__asan_report_load8_noabort
.L2555:
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrd	r10, [r5], #8
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2556
	mov	r0, r6
	bl	__asan_report_store8_noabort
.L2556:
	add	r7, r7, #1
	mov	r1, r7
	mov	r0, r9
	strd	r10, [r6], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r7, r9
	bne	.L2557
	b	.L2795
.L2632:
	sub	r2, r3, #376
	str	r2, [sp, #28]
	ldr	r2, [sp, #32]
	lsr	r1, r2, #3
	str	r1, [sp, #76]
	and	r1, r2, #7
	str	r1, [sp, #72]
	add	r2, r2, #4
	sub	r1, r3, #792
	sub	r3, r3, #584
	str	r1, [sp, #48]
	str	r2, [sp, #64]
	str	r3, [sp, #60]
	b	.L2559
.L2795:
	bl	__sanitizer_cov_trace_pc
	ldr	r3, [sp, #32]
	add	r2, r3, #4
	and	r3, r2, #7
	str	r2, [sp, #64]
	lsr	r2, r2, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2560
	ldr	r0, [sp, #64]
	bl	__asan_report_load4_noabort
.L2560:
	ldr	r3, [sp, #44]
	ldr	r9, [sp, #1412]
	sub	r5, r3, #584
	ldr	r3, [sp, #32]
	mov	r7, #0
	str	r5, [sp, #60]
	ldr	r6, [r3, #4]
.L2563:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2561
	mov	r0, r6
	bl	__asan_report_load8_noabort
.L2561:
	lsr	r3, r5, #3
	add	r3, r3, #-1627389952
	ldrd	r10, [r6], #8
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2562
	mov	r0, r5
	bl	__asan_report_store8_noabort
.L2562:
	add	r7, r7, #1
	mov	r1, r7
	mov	r0, r9
	strd	r10, [r5], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r7, r9
	bne	.L2563
.L2559:
	bl	__sanitizer_cov_trace_pc
	mov	r2, #72
	mov	r1, #254
	ldr	r3, [sp, #44]
	sub	fp, r3, #1088
	mov	r0, fp
	bl	memset
	add	r1, r4, #16
	and	r3, r1, #7
	lsr	r2, r1, #3
	str	r2, [sp, #20]
	add	r2, r2, #-1627389952
	str	r1, [sp, #84]
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	and	r3, r1, #7
	str	r3, [sp, #16]
	beq	.L2564
	mov	r0, r1
	bl	__asan_report_load1_noabort
.L2564:
	ldrb	r5, [r4, #16]	@ zero_extendqisi2
	mov	r0, #0
	mov	r1, r5
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	r5, #0
	beq	.L2565
	ldr	r7, [sp, #48]
	mov	r6, #0
	mov	r9, fp
.L2568:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r7, #3
	add	r3, r3, #-1627389952
	sub	r2, r7, #72
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2566
	mov	r0, r7
	str	r2, [sp, #8]
	bl	__asan_report_load8_noabort
	ldr	r2, [sp, #8]
.L2566:
	lsr	r3, r2, #3
	add	r3, r3, #-1627389952
	ldrd	r10, [r7], #8
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2567
	mov	r0, r2
	bl	__asan_report_store8_noabort
.L2567:
	add	r6, r6, #1
	mov	r1, r6
	mov	r0, r5
	strd	r10, [r7, #-80]
	bl	__sanitizer_cov_trace_cmp4
	cmp	r6, r5
	bne	.L2568
	ldr	r7, [sp, #60]
	mov	r6, #0
.L2571:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r7, #3
	add	r3, r3, #-1627389952
	sub	r2, r7, #72
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2569
	mov	r0, r7
	str	r2, [sp, #8]
	bl	__asan_report_load8_noabort
	ldr	r2, [sp, #8]
.L2569:
	lsr	r3, r2, #3
	add	r3, r3, #-1627389952
	ldrd	r10, [r7], #8
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2570
	mov	r0, r2
	bl	__asan_report_store8_noabort
.L2570:
	add	r6, r6, #1
	mov	r1, r6
	mov	r0, r5
	strd	r10, [r7, #-80]
	bl	__sanitizer_cov_trace_cmp4
	cmp	r6, r5
	bne	.L2571
	mov	fp, r9
	mov	r10, r9
	mov	r6, #0
.L2573:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r9, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2572
	mov	r0, r9
	bl	__asan_report_store8_noabort
.L2572:
	mov	r2, #0
	mov	r3, #0
	add	r6, r6, #1
	mov	r1, r6
	mov	r0, r5
	strd	r2, [r9], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r6, r5
	bne	.L2573
	b	.L2796
.L2565:
	bl	__sanitizer_cov_trace_pc
	mov	r2, #1
	mov	r3, #0
	strd	r2, [fp]
	b	.L2575
.L2796:
	bl	__sanitizer_cov_trace_pc
	mov	r2, #1
	mov	r3, #0
	strd	r2, [fp]
	ldr	r6, [sp, #80]
	cmp	r6, #0
	beq	.L2575
	mov	r7, #0
.L2579:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2577
	mov	r0, r6
	bl	__asan_report_load8_noabort
.L2577:
	lsr	r3, r10, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	ldrd	r2, [r6], #8
	beq	.L2578
	mov	r0, r10
	strd	r2, [sp, #8]
	bl	__asan_report_store8_noabort
	ldrd	r2, [sp, #8]
.L2578:
	add	r7, r7, #1
	mov	r1, r7
	mov	r0, r5
	strd	r2, [r10], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r7, r5
	bne	.L2579
.L2575:
	bl	__sanitizer_cov_trace_pc
	mov	r2, #72
	mov	r1, #254
	ldr	r5, [sp, #44]
	sub	r9, r5, #976
	mov	r0, r9
	bl	memset
	mov	r2, r4
	mov	r1, fp
	mov	r0, r9
	bl	vli_mod_square_fast
	sub	r3, r5, #240
	mov	r2, #144
	mov	r0, r3
	mov	r1, #254
	str	r3, [sp, #8]
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2581
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2581:
	ldr	r5, [sp, #8]
	ldr	r6, [sp, #48]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, r9
	mov	r1, r6
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, r6
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r5
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2582
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2582:
	ldr	r5, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, fp
	mov	r1, r9
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, r9
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r5
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2583
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2583:
	ldr	r5, [sp, #60]
	ldr	r6, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, r9
	mov	r1, r5
	mov	r0, r6
	bl	vli_mult
	mov	r2, r4
	mov	r1, r6
	mov	r0, r5
	bl	vli_mmod_fast
	mov	r3, r4
	mov	r2, fp
	mov	r1, r5
	ldr	r0, [sp, #48]
	bl	ecc_point_double_jacobian
	mov	r2, #72
	mov	r1, #254
	mov	r0, r9
	bl	memset
	mov	r2, r4
	mov	r1, fp
	mov	r0, r9
	bl	vli_mod_square_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r6
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2584
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2584:
	ldr	r5, [sp, #8]
	ldr	r6, [sp, #40]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, r9
	mov	r1, r6
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, r6
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r5
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2585
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2585:
	ldr	r5, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, fp
	mov	r1, r9
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, r9
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r5
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2586
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2586:
	ldr	r6, [sp, #24]
	ldr	r5, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, r9
	mov	r1, r6
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, r6
	bl	vli_mmod_fast
	mov	r1, r8
	mov	r0, #0
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	r8, #0
	ble	.L2621
	ldr	fp, [sp, #40]
	mov	r7, #1
	str	r9, [sp, #44]
	b	.L2587
.L2799:
	.align	2
.L2798:
	.word	1102416563
	.word	.LC43
	.word	-218959118
	.word	.LASANPC2762
	.word	-218959360
	.word	-219021312
	.word	-202116109
	.word	61937
	.word	-235802127
	.word	62194
	.word	__stack_chk_guard
	.word	521
.L2621:
	bl	__sanitizer_cov_trace_pc
	ldr	r3, [sp, #28]
	lsr	r3, r3, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2588
	ldr	r0, [sp, #28]
	bl	__asan_report_load8_noabort
.L2588:
	ldr	r3, [sp, #28]
	ldr	r5, [sp, #40]
	ldr	r1, [sp, #24]
	ldr	r3, [r3]
	str	r4, [sp]
	and	r3, r3, #1
	eor	r2, r3, #1
	rsb	r2, r2, #0
	rsb	r3, r3, #0
	and	r3, r3, #72
	and	r2, r2, #72
	add	r10, r1, r2
	add	r7, r5, r3
	add	r8, r1, r3
	add	r6, r5, r2
	mov	r3, r10
	mov	r2, r6
	mov	r1, r8
	mov	r0, r7
	bl	xycz_add_c
	mov	r2, r5
	ldr	r3, [sp, #1412]
	ldr	r1, [sp, #48]
	ldr	r0, [sp, #36]
	str	r3, [sp]
	ldr	r3, [sp, #56]
	bl	vli_mod_sub
	mov	r2, #144
	mov	r1, #254
	ldr	r0, [sp, #8]
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2594
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2594:
	ldr	fp, [sp, #36]
	ldr	r5, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, r8
	mov	r1, fp
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, fp
	bl	vli_mmod_fast
	ldr	r3, [sp, #76]
	add	r2, r3, #-1627389952
	ldr	r3, [sp, #72]
	ldrsb	r2, [r2]
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2595
	ldr	r0, [sp, #32]
	bl	__asan_report_load4_noabort
.L2595:
	ldr	r3, [sp, #32]
	mov	r2, #144
	ldr	r0, [sp, #8]
	mov	r1, #254
	ldr	r5, [r3]
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2596
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2596:
	ldr	fp, [sp, #36]
	mov	r2, r5
	ldr	r5, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r1, fp
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, fp
	bl	vli_mmod_fast
	ldr	r3, [sp, #32]
	add	r0, r3, #8
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2597
	bl	__asan_report_load1_noabort
.L2597:
	ldr	r3, [sp, #32]
	ldr	r1, [sp, #36]
	ldr	r2, [sp, #56]
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	mov	r0, r1
	bl	vli_mod_inv
	ldr	r1, [sp, #64]
	lsr	r3, r1, #3
	add	r3, r3, #-1627389952
	ldrsb	r2, [r3]
	and	r3, r1, #7
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2598
	mov	r0, r1
	bl	__asan_report_load4_noabort
.L2598:
	ldr	r3, [sp, #32]
	mov	r2, #144
	ldr	r0, [sp, #8]
	mov	r1, #254
	ldr	r5, [r3, #4]
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2599
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2599:
	ldr	fp, [sp, #36]
	mov	r2, r5
	ldr	r5, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r1, fp
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, fp
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r5
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2601
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2601:
	ldr	r5, [sp, #36]
	ldr	fp, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, r7
	mov	r1, r5
	mov	r0, fp
	bl	vli_mult
	mov	r2, r4
	mov	r1, fp
	mov	r0, r5
	bl	vli_mmod_fast
	mov	r3, r8
	mov	r2, r7
	mov	r1, r10
	mov	r0, r6
	str	r4, [sp]
	bl	xycz_add
	mov	r2, #72
	mov	r1, #254
	mov	r0, r9
	bl	memset
	mov	r2, r4
	mov	r1, r5
	mov	r0, r9
	bl	vli_mod_square_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, fp
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2606
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2606:
	ldr	r5, [sp, #8]
	ldr	r6, [sp, #40]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, r9
	mov	r1, r6
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, r6
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r5
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2607
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2607:
	ldr	r5, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	ldr	r2, [sp, #36]
	mov	r1, r9
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, r9
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r5
	bl	memset
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #16]
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r2, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L2608
	ldr	r0, [sp, #84]
	bl	__asan_report_load1_noabort
.L2608:
	ldr	r6, [sp, #24]
	ldr	r5, [sp, #8]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, r9
	mov	r1, r6
	mov	r0, r5
	bl	vli_mult
	mov	r2, r4
	mov	r1, r5
	mov	r0, r6
	bl	vli_mmod_fast
	ldr	r1, [sp, #52]
	lsr	r3, r1, #3
	add	r3, r3, #-1627389952
	ldrsb	r2, [r3]
	and	r3, r1, #7
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2609
	mov	r0, r1
	bl	__asan_report_load4_noabort
.L2609:
	ldr	r3, [sp, #52]
	ldr	r1, [sp, #1412]
	mov	r0, #0
	ldr	r5, [r3]
	bl	__sanitizer_cov_trace_const_cmp4
	ldr	r3, [sp, #1412]
	cmp	r3, #0
	bne	.L2610
	b	.L2611
.L2587:
	bl	__sanitizer_cov_trace_pc
	lsr	r5, r8, #6
	ldr	r3, [sp, #28]
	add	r5, r3, r5, lsl #3
	lsr	r3, r5, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2612
	mov	r0, r5
	bl	__asan_report_load8_noabort
.L2612:
	and	r3, r8, #63
	sub	r6, r3, #32
	ldr	r9, [r5]
	rsb	r2, r3, #32
	lsl	r6, r7, r6
	and	r9, r9, r7, lsl r3
	orr	r6, r6, r7, lsr r2
	ldr	r3, [r5, #4]
	mov	r2, r9
	and	r6, r6, r3
	mov	r3, r6
	mov	r0, #0
	mov	r1, #0
	bl	__sanitizer_cov_trace_const_cmp8
	orrs	r3, r9, r6
	mov	r2, r9
	mov	r3, r6
	mov	r0, #0
	mov	r1, #0
	moveq	r5, #1
	movne	r5, #0
	bl	__sanitizer_cov_trace_const_cmp8
	orrs	r9, r9, r6
	movne	r3, #1
	moveq	r3, #0
	sub	r8, r8, #1
	cmp	r3, #0
	movne	r6, #72
	ldr	r3, [sp, #24]
	moveq	r6, #0
	cmp	r5, #0
	movne	r5, #72
	moveq	r5, #0
	add	r10, fp, r6
	add	r9, fp, r5
	add	r6, r3, r6
	add	r5, r3, r5
	mov	r3, r5
	mov	r2, r9
	mov	r1, r6
	mov	r0, r10
	str	r4, [sp]
	bl	xycz_add_c
	mov	r3, r6
	mov	r2, r10
	mov	r1, r5
	mov	r0, r9
	str	r4, [sp]
	bl	xycz_add
	mov	r0, #0
	mov	r1, r8
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	r8, #0
	bne	.L2587
	ldr	r9, [sp, #44]
	b	.L2621
.L2611:
	bl	__sanitizer_cov_trace_pc
	mov	r3, #0
	ldr	ip, [sp, #68]
	str	r3, [ip]
	str	r3, [ip, #4]
	str	r3, [ip, #12]
	str	r3, [ip, #16]
	str	r3, [ip, #28]
	str	r3, [ip, #32]
	str	r3, [ip, #40]
	str	r3, [ip, #44]
	str	r3, [ip, #64]
	str	r3, [ip, #68]
	str	r3, [ip, #72]
	str	r3, [ip, #92]
	str	r3, [ip, #96]
	str	r3, [ip, #116]
	str	r3, [ip, #120]
	str	r3, [ip, #124]
	str	r3, [ip, #144]
	str	r3, [ip, #148]
	ldr	r3, .L2798+40
	ldr	r2, [r3]
	ldr	r3, [sp, #1364]
	eors	r2, r3, r2
	mov	r3, #0
	beq	.L2631
	b	.L2797
.L2610:
	ldr	r6, [sp, #40]
	ldr	r7, [sp, #1412]
	mov	r4, #0
.L2624:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2622
	mov	r0, r6
	bl	__asan_report_load8_noabort
.L2622:
	lsr	r3, r5, #3
	add	r3, r3, #-1627389952
	ldrd	r8, [r6], #8
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2623
	mov	r0, r5
	bl	__asan_report_store8_noabort
.L2623:
	add	r4, r4, #1
	mov	r1, r4
	mov	r0, r7
	strd	r8, [r5], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r4, r7
	bne	.L2624
	bl	__sanitizer_cov_trace_pc
	ldr	r3, [sp, #52]
	add	r0, r3, #4
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2625
	bl	__asan_report_load4_noabort
.L2625:
	ldr	r3, [sp, #52]
	ldr	r8, [sp, #24]
	ldr	r9, [sp, #1412]
	ldr	r5, [r3, #4]
	mov	r4, #0
.L2628:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r8, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2626
	mov	r0, r8
	bl	__asan_report_load8_noabort
.L2626:
	lsr	r3, r5, #3
	add	r3, r3, #-1627389952
	ldrd	r6, [r8], #8
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L2627
	mov	r0, r5
	bl	__asan_report_store8_noabort
.L2627:
	add	r4, r4, #1
	mov	r1, r4
	mov	r0, r9
	strd	r6, [r5], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r4, r9
	bne	.L2628
	b	.L2611
.L2553:
	bl	__sanitizer_cov_trace_pc
	ldr	r1, [sp, #32]
	lsr	r3, r1, #3
	str	r3, [sp, #76]
	add	r3, r3, #-1627389952
	ldrsb	r2, [r3]
	and	r3, r1, #7
	str	r3, [sp, #72]
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L2629
	mov	r0, r1
	bl	__asan_report_load4_noabort
.L2629:
	ldr	r3, [sp, #32]
	ldr	r1, [sp, #1412]
	mov	r0, #0
	ldr	r5, [r3]
	ldr	r8, .L2798+44
	bl	__sanitizer_cov_trace_const_cmp4
	b	.L2630
.L2797:
	bl	__stack_chk_fail
.L2631:
	add	sp, sp, #1360
	add	sp, sp, #12
	@ sp needed
	mov	r0, #0
	mov	r1, #0
	mov	r2, #0
	mov	r3, #0
	mov	ip, #0
	mov	lr, #0
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
	.fnend
	.size	ecc_point_mult, .-ecc_point_mult

--WgAw6ZgpYYzlY3nX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="ecc_point_mult_limited_inlining.s"

	.section	.rodata.ecc_point_mult.str1.4,"aMS",%progbits,1
	.align	2
.LC45:
	.ascii	"6 32 72 6 z:1337 144 72 7 t1:1196 256 144 7 rx:1335"
	.ascii	" 464 144 7 ry:1336 672 144 7 sk:1338 880 144 12 pro"
	.ascii	"duct:1028\000"
	.section	.text.ecc_point_mult,"ax",%progbits
	.align	2
	.syntax unified
	.arm
	.type	ecc_point_mult, %function
ecc_point_mult:
.LASANPC2762:
	.fnstart
	@ args = 8, pretend = 0, frame = 1232
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	.save {r4, r5, r6, r7, r8, r9, r10, fp, lr}
	.pad #1232
	sub	sp, sp, #1232
	.pad #12
	sub	sp, sp, #12
	push	{lr}
	bl	__gnu_mcount_nc
	str	r3, [sp, #64]
	add	r3, sp, #1232
	add	r3, r3, #8
	bic	lr, r3, #31
	ldr	ip, .L3548
	str	r0, [sp, #44]
	str	r1, [sp, #32]
	str	lr, [sp, #40]
	ldr	r4, [sp, #1280]
	sub	r3, lr, #1120
	str	ip, [lr, #-1120]
	ldr	ip, .L3548+4
	lsr	r3, r3, #3
	str	ip, [lr, #-1116]
	ldr	ip, .L3548+8
	add	r5, r3, #-1627389952
	ldr	r3, .L3548+12
	str	ip, [lr, #-1112]
	mov	r7, lr
	ldr	r0, .L3548+16
	ldr	lr, .L3548+20
	ldr	r1, .L3548+24
	ldr	r6, .L3548+28
	mov	r8, r2
	ldr	r2, .L3548+32
	ldr	fp, [sp, #1284]
	mov	ip, #-234881024
	str	r3, [r5, #28]
	str	r3, [r5, #52]
	str	r3, [r5, #76]
	str	r3, [r5, #80]
	str	r3, [r5, #104]
	ldr	r3, .L3548+36
	str	lr, [r5, #12]
	str	ip, [r5, #24]
	str	r2, [r5, #16]
	str	r0, [r5, #48]
	str	r0, [r5, #100]
	str	r2, [r5, #56]
	str	r2, [r5, #108]
	str	r1, [r5, #128]
	str	r1, [r5, #132]
	str	r6, [r5]
	ldr	r3, [r3]
	str	r3, [sp, #1236]
	mov	r3, #0
	bl	__sanitizer_cov_trace_pc
	sub	r3, r7, #864
	mov	r2, #144
	mov	r1, #254
	mov	r0, r3
	str	r3, [sp, #24]
	bl	memset
	sub	r3, r7, #656
	mov	r2, #144
	mov	r1, #254
	mov	r0, r3
	str	r3, [sp, #36]
	bl	memset
	sub	r3, r7, #1088
	mov	r2, #72
	mov	r1, #254
	mov	r0, r3
	str	r3, [sp, #28]
	bl	memset
	sub	r3, r7, #448
	mov	r2, #144
	mov	r0, r3
	mov	r1, #254
	str	r3, [sp, #48]
	bl	memset
	add	r0, r4, #20
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3325
	bl	__asan_report_load4_noabort
.L3325:
	add	r0, r4, #24
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	ldr	r3, [r4, #20]
	str	r3, [sp, #56]
	beq	.L3326
	bl	__asan_report_load4_noabort
.L3326:
	mov	r1, fp
	mov	r0, #0
	ldr	r7, [r4, #24]
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	fp, #0
	beq	.L3327
	mov	r1, #0
	ldr	r9, [sp, #48]
	mov	r10, r7
	str	r7, [sp, #52]
	mov	r7, r1
	str	r1, [sp, #8]
	str	r9, [sp, #16]
	str	r4, [sp, #60]
	str	fp, [sp, #1284]
	str	r5, [sp, #68]
.L3332:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r8, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3328
	mov	r0, r8
	bl	__asan_report_load8_noabort
.L3328:
	lsr	r3, r10, #3
	add	r3, r3, #-1627389952
	ldm	r8, {r6, fp}
	ldrsb	r3, [r3]
	add	r8, r8, #8
	mov	r5, r10
	cmp	r3, #0
	beq	.L3329
	mov	r0, r10
	bl	__asan_report_load8_noabort
.L3329:
	ldrd	r4, [r5]
	ldr	r3, [sp, #8]
	mov	r0, r6
	adds	r4, r6, r4
	adc	r5, fp, r5
	adds	r4, r4, r3
	adc	r5, r5, #0
	mov	r2, r4
	mov	r3, r5
	mov	r1, fp
	bl	__sanitizer_cov_trace_cmp8
	cmp	fp, r5
	cmpeq	r6, r4
	add	r10, r10, #8
	beq	.L3330
	bl	__sanitizer_cov_trace_pc
	mov	r3, r5
	mov	r1, fp
	mov	r2, r4
	mov	r0, r6
	bl	__sanitizer_cov_trace_cmp8
	cmp	r4, r6
	sbcs	r1, r5, fp
	movcc	r3, #1
	movcs	r3, #0
	str	r3, [sp, #8]
.L3330:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r9, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3331
	mov	r0, r9
	bl	__asan_report_store8_noabort
.L3331:
	add	r7, r7, #1
	strd	r4, [r9]
	ldr	r0, [sp, #1284]
	mov	r1, r7
	bl	__sanitizer_cov_trace_cmp4
	add	r9, r9, #8
	ldr	r3, [sp, #1284]
	cmp	r7, r3
	bne	.L3332
	ldr	r4, [sp, #60]
	ldr	r5, [sp, #68]
	mov	fp, r3
	ldr	r6, [sp, #16]
	ldr	r7, [sp, #52]
	bl	__sanitizer_cov_trace_pc
	mov	r10, #0
	str	r10, [sp, #16]
	str	r4, [sp, #52]
	str	fp, [sp, #1284]
	str	r5, [sp, #60]
	b	.L3341
.L3327:
	bl	__sanitizer_cov_trace_pc
	add	r0, r4, #4
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3334
	bl	__asan_report_load4_noabort
.L3334:
	ldr	r7, [r4, #4]
	ldr	r6, .L3548+40
	mov	r1, r7
	mov	r0, r6
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	r7, r6
	beq	.L3335
	ldr	r3, [sp, #40]
	sub	r8, r3, #376
	b	.L3336
.L3412:
	mov	r6, r9
.L3341:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3337
	mov	r0, r6
	bl	__asan_report_load8_noabort
.L3337:
	lsr	r3, r7, #3
	add	r3, r3, #-1627389952
	ldm	r6, {r8, fp}
	ldrsb	r3, [r3]
	add	r9, r6, #8
	mov	r5, r7
	cmp	r3, #0
	beq	.L3338
	mov	r0, r7
	bl	__asan_report_load8_noabort
.L3338:
	ldrd	r4, [r5]
	ldr	r3, [sp, #16]
	mov	r0, r8
	adds	r4, r8, r4
	adc	r5, fp, r5
	adds	r4, r4, r3
	adc	r5, r5, #0
	mov	r2, r4
	mov	r3, r5
	mov	r1, fp
	bl	__sanitizer_cov_trace_cmp8
	cmp	fp, r5
	cmpeq	r8, r4
	add	r7, r7, #8
	beq	.L3339
	bl	__sanitizer_cov_trace_pc
	mov	r3, r5
	mov	r1, fp
	mov	r2, r4
	mov	r0, r8
	bl	__sanitizer_cov_trace_cmp8
	cmp	r4, r8
	sbcs	r1, r5, fp
	movcc	r3, #1
	movcs	r3, #0
	str	r3, [sp, #16]
.L3339:
	add	r6, r6, #72
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3340
	mov	r0, r6
	bl	__asan_report_store8_noabort
.L3340:
	add	r10, r10, #1
	ldr	r0, [sp, #1284]
	mov	r1, r10
	strd	r4, [r9, #64]
	bl	__sanitizer_cov_trace_cmp4
	ldr	r3, [sp, #1284]
	cmp	r10, r3
	bne	.L3412
	ldr	r4, [sp, #52]
	mov	fp, r3
	ldr	r5, [sp, #60]
	bl	__sanitizer_cov_trace_pc
	add	r0, r4, #4
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	ldrsb	r2, [r2]
	ldr	r3, [sp, #8]
	eor	r8, r3, #1
	rsb	r8, r8, #0
	ldr	r3, [sp, #48]
	and	r8, r8, #72
	add	r8, r3, r8
	and	r3, r0, #7
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3343
	bl	__asan_report_load4_noabort
.L3343:
	ldr	r7, [r4, #4]
	ldr	r6, .L3548+40
	mov	r1, r7
	mov	r0, r6
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	r7, r6
	beq	.L3344
.L3336:
	bl	__sanitizer_cov_trace_pc
	bl	__sanitizer_cov_trace_pc
	lsl	r7, fp, #6
	sub	r7, r7, #1
	ldr	r1, [sp, #32]
	lsr	r3, r1, #3
	str	r3, [sp, #76]
	add	r3, r3, #-1627389952
	ldrsb	r2, [r3]
	and	r3, r1, #7
	str	r3, [sp, #72]
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3345
	mov	r0, r1
	bl	__asan_report_load4_noabort
.L3345:
	ldr	r3, [sp, #32]
	mov	r1, fp
	mov	r0, #0
	ldr	r6, [r3]
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	fp, #0
	bne	.L3410
	ldr	r3, [sp, #40]
	sub	r2, r3, #792
	str	r2, [sp, #52]
	ldr	r2, [sp, #32]
	sub	r3, r3, #584
	add	r2, r2, #4
	str	r2, [sp, #60]
	str	r3, [sp, #8]
	b	.L3346
.L3410:
	ldr	r3, [sp, #40]
	mov	r10, #0
	sub	r3, r3, #792
	mov	r9, r3
	str	r3, [sp, #52]
.L3349:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3347
	mov	r0, r6
	bl	__asan_report_load8_noabort
.L3347:
	lsr	r3, r9, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	ldrd	r2, [r6], #8
	beq	.L3348
	mov	r0, r9
	strd	r2, [sp, #8]
	bl	__asan_report_store8_noabort
	ldrd	r2, [sp, #8]
.L3348:
	add	r10, r10, #1
	mov	r1, r10
	mov	r0, fp
	strd	r2, [r9], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r10, fp
	bne	.L3349
	bl	__sanitizer_cov_trace_pc
	ldr	r3, [sp, #32]
	add	r2, r3, #4
	and	r3, r2, #7
	str	r2, [sp, #60]
	lsr	r2, r2, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3350
	ldr	r0, [sp, #60]
	bl	__asan_report_load4_noabort
.L3350:
	ldr	r3, [sp, #40]
	mov	r10, #0
	sub	r6, r3, #584
	ldr	r3, [sp, #32]
	str	r6, [sp, #8]
	ldr	r9, [r3, #4]
.L3353:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r9, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3351
	mov	r0, r9
	bl	__asan_report_load8_noabort
.L3351:
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	ldrd	r2, [r9], #8
	beq	.L3352
	mov	r0, r6
	strd	r2, [sp, #16]
	bl	__asan_report_store8_noabort
	ldrd	r2, [sp, #16]
.L3352:
	add	r10, r10, #1
	mov	r1, r10
	mov	r0, fp
	strd	r2, [r6], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r10, fp
	bne	.L3353
.L3346:
	bl	__sanitizer_cov_trace_pc
	ldr	r3, [sp, #64]
	ldr	r1, [sp, #8]
	ldr	r2, [sp, #24]
	ldr	r0, [sp, #52]
	str	r3, [sp]
	str	r4, [sp, #4]
	ldr	r3, [sp, #36]
	bl	xycz_initial_double
	mov	r1, r7
	mov	r0, #0
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	r7, #0
	bgt	.L3354
.L3372:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r8, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3355
	mov	r0, r8
	bl	__asan_report_load8_noabort
.L3355:
	ldr	r3, [r8]
	ldr	ip, [sp, #24]
	and	r3, r3, #1
	eor	r2, r3, #1
	rsb	r2, r2, #0
	rsb	r3, r3, #0
	ldr	lr, [sp, #36]
	and	r3, r3, #72
	and	r2, r2, #72
	add	r0, ip, r3
	add	ip, ip, r2
	add	r1, lr, r3
	str	r4, [sp]
	add	r3, lr, r2
	mov	r2, ip
	str	r0, [sp, #16]
	str	r1, [sp, #48]
	str	ip, [sp, #64]
	str	r3, [sp, #68]
	bl	xycz_add_c
	mov	r1, fp
	mov	r0, #0
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	fp, #0
	bne	.L3360
	b	.L3361
.L3354:
	str	fp, [sp, #1284]
	ldr	fp, [sp, #36]
	mov	r9, #1
	str	r8, [sp, #8]
	str	r5, [sp, #16]
.L3371:
	bl	__sanitizer_cov_trace_pc
	lsr	r5, r7, #6
	ldr	r3, [sp, #8]
	add	r5, r3, r5, lsl #3
	lsr	r3, r5, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3362
	mov	r0, r5
	bl	__asan_report_load8_noabort
.L3362:
	and	r3, r7, #63
	sub	r2, r3, #32
	rsb	r1, r3, #32
	lsl	r2, r9, r2
	ldr	r6, [r5]
	ldr	r8, [r5, #4]
	orr	r2, r2, r9, lsr r1
	and	r6, r6, r9, lsl r3
	and	r8, r8, r2
	mov	r3, r8
	mov	r2, r6
	mov	r0, #0
	mov	r1, #0
	bl	__sanitizer_cov_trace_const_cmp8
	orrs	r3, r6, r8
	mov	r2, r6
	mov	r3, r8
	mov	r0, #0
	mov	r1, #0
	moveq	r5, #1
	movne	r5, #0
	bl	__sanitizer_cov_trace_const_cmp8
	orrs	r8, r6, r8
	movne	r3, #1
	moveq	r3, #0
	sub	r7, r7, #1
	cmp	r3, #0
	movne	r6, #72
	ldr	r3, [sp, #24]
	moveq	r6, #0
	cmp	r5, #0
	movne	r5, #72
	moveq	r5, #0
	add	r10, r3, r6
	add	r8, r3, r5
	add	r6, fp, r6
	add	r5, fp, r5
	mov	r3, r5
	mov	r2, r8
	mov	r1, r6
	mov	r0, r10
	str	r4, [sp]
	bl	xycz_add_c
	mov	r3, r6
	mov	r2, r10
	mov	r1, r5
	mov	r0, r8
	str	r4, [sp]
	bl	xycz_add
	mov	r0, #0
	mov	r1, r7
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	r7, #0
	bne	.L3371
	ldr	r8, [sp, #8]
	ldr	fp, [sp, #1284]
	ldr	r5, [sp, #16]
	b	.L3372
.L3361:
	bl	__sanitizer_cov_trace_pc
	add	r10, r4, #16
	mov	r2, #144
	mov	r1, #254
	lsr	r7, r10, #3
	and	r8, r10, #7
	ldr	r3, [sp, #40]
	sub	r6, r3, #240
	mov	r0, r6
	bl	memset
	add	r2, r7, #-1627389952
	and	r3, r10, #7
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3374
	mov	r0, r10
	bl	__asan_report_load1_noabort
.L3374:
	ldr	r9, [sp, #28]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	ldr	r2, [sp, #48]
	mov	r1, r9
	mov	r0, r6
	bl	vli_mult
	mov	r2, r4
	mov	r1, r6
	mov	r0, r9
	bl	vli_mmod_fast
	ldr	r3, [sp, #76]
	add	r2, r3, #-1627389952
	ldr	r3, [sp, #72]
	ldrsb	r2, [r2]
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3375
	ldr	r0, [sp, #32]
	bl	__asan_report_load4_noabort
.L3375:
	ldr	r3, [sp, #32]
	mov	r2, #144
	mov	r1, #254
	mov	r0, r6
	ldr	r9, [r3]
	bl	memset
	add	r3, r7, #-1627389952
	ldrsb	r3, [r3]
	cmp	r8, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L3376
	mov	r0, r10
	bl	__asan_report_load1_noabort
.L3376:
	mov	r2, r9
	ldr	r9, [sp, #28]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r1, r9
	mov	r0, r6
	bl	vli_mult
	mov	r2, r4
	mov	r1, r6
	mov	r0, r9
	bl	vli_mmod_fast
	ldr	r3, [sp, #32]
	add	r0, r3, #8
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3377
	bl	__asan_report_load1_noabort
.L3377:
	ldr	r3, [sp, #32]
	ldr	r1, [sp, #28]
	ldr	r2, [sp, #56]
	ldrb	r3, [r3, #8]	@ zero_extendqisi2
	mov	r0, r1
	bl	vli_mod_inv
	ldr	r1, [sp, #60]
	lsr	r3, r1, #3
	add	r3, r3, #-1627389952
	ldrsb	r2, [r3]
	and	r3, r1, #7
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3378
	mov	r0, r1
	bl	__asan_report_load4_noabort
.L3378:
	ldr	r3, [sp, #32]
	mov	r2, #144
	mov	r1, #254
	mov	r0, r6
	ldr	r9, [r3, #4]
	bl	memset
	add	r3, r7, #-1627389952
	ldrsb	r3, [r3]
	cmp	r8, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L3379
	mov	r0, r10
	bl	__asan_report_load1_noabort
.L3379:
	mov	r2, r9
	ldr	r9, [sp, #28]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r1, r9
	mov	r0, r6
	bl	vli_mult
	mov	r2, r4
	mov	r1, r6
	mov	r0, r9
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r6
	bl	memset
	add	r3, r7, #-1627389952
	ldrsb	r3, [r3]
	cmp	r8, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L3381
	mov	r0, r10
	bl	__asan_report_load1_noabort
.L3381:
	ldr	r9, [sp, #28]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r1, r9
	ldr	r2, [sp, #16]
	mov	r0, r6
	bl	vli_mult
	mov	r2, r4
	mov	r1, r6
	mov	r0, r9
	bl	vli_mmod_fast
	ldrd	r0, [sp, #64]
	ldr	r3, [sp, #48]
	ldr	r2, [sp, #16]
	str	r4, [sp]
	bl	xycz_add
	mov	r2, #72
	mov	r1, #254
	ldr	r3, [sp, #40]
	sub	r9, r3, #976
	mov	r0, r9
	bl	memset
	mov	r2, #144
	mov	r1, #254
	mov	r0, r6
	bl	memset
	add	r3, r7, #-1627389952
	ldrsb	r3, [r3]
	cmp	r8, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L3386
	mov	r0, r10
	bl	__asan_report_load1_noabort
.L3386:
	ldrb	r2, [r4, #16]	@ zero_extendqisi2
	ldr	r1, [sp, #28]
	mov	r0, r6
	bl	vli_square
	mov	r2, r4
	mov	r1, r6
	mov	r0, r9
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r6
	bl	memset
	add	r3, r7, #-1627389952
	ldrsb	r3, [r3]
	cmp	r8, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L3387
	mov	r0, r10
	bl	__asan_report_load1_noabort
.L3387:
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	ldr	r1, [sp, #24]
	mov	r2, r9
	mov	r0, r6
	bl	vli_mult
	mov	r2, r4
	mov	r1, r6
	ldr	r0, [sp, #24]
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r6
	bl	memset
	add	r3, r7, #-1627389952
	ldrsb	r3, [r3]
	cmp	r8, r3
	movlt	r2, #0
	movge	r2, #1
	cmp	r3, #0
	moveq	r2, #0
	cmp	r2, #0
	beq	.L3388
	mov	r0, r10
	bl	__asan_report_load1_noabort
.L3388:
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	ldr	r2, [sp, #28]
	mov	r1, r9
	mov	r0, r6
	bl	vli_mult
	add	r7, r7, #-1627389952
	mov	r2, r4
	mov	r1, r6
	mov	r0, r9
	bl	vli_mmod_fast
	mov	r2, #144
	mov	r1, #254
	mov	r0, r6
	bl	memset
	ldrsb	r3, [r7]
	cmp	r8, r3
	movlt	r8, #0
	movge	r8, #1
	cmp	r3, #0
	moveq	r8, #0
	cmp	r8, #0
	beq	.L3389
	mov	r0, r10
	bl	__asan_report_load1_noabort
.L3389:
	ldr	r7, [sp, #36]
	ldrb	r3, [r4, #16]	@ zero_extendqisi2
	mov	r2, r9
	mov	r1, r7
	mov	r0, r6
	bl	vli_mult
	mov	r2, r4
	mov	r1, r6
	mov	r0, r7
	bl	vli_mmod_fast
	ldr	r1, [sp, #44]
	lsr	r3, r1, #3
	add	r3, r3, #-1627389952
	ldrsb	r2, [r3]
	and	r3, r1, #7
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3390
	mov	r0, r1
	bl	__asan_report_load4_noabort
.L3390:
	ldr	r3, [sp, #44]
	mov	r1, fp
	mov	r0, #0
	ldr	r6, [r3]
	bl	__sanitizer_cov_trace_const_cmp4
	cmp	fp, #0
	movne	r4, #0
	ldrne	r7, [sp, #24]
	bne	.L3404
	b	.L3392
.L3360:
	ldr	r8, [sp, #28]
	mov	r9, #0
	ldr	r6, [sp, #52]
	str	r9, [sp, #8]
	str	r8, [sp, #52]
	strd	r4, [sp, #80]
.L3397:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3393
	mov	r0, r6
	bl	__asan_report_load8_noabort
.L3393:
	sub	r0, r6, #72
	ldr	r7, [r6]
	lsr	r3, r0, #3
	add	r3, r3, #-1627389952
	ldr	r10, [r6, #4]
	ldrsb	r3, [r3]
	add	r6, r6, #8
	cmp	r3, #0
	beq	.L3394
	bl	__asan_report_load8_noabort
.L3394:
	ldr	r2, [sp, #8]
	ldr	r3, [r6, #-80]
	subs	r4, r7, r2
	ldr	r2, [r6, #-76]
	sbc	r5, r10, #0
	subs	r4, r4, r3
	sbc	r5, r5, r2
	mov	r3, r5
	mov	r2, r4
	mov	r0, r7
	mov	r1, r10
	bl	__sanitizer_cov_trace_cmp8
	cmp	r10, r5
	cmpeq	r7, r4
	beq	.L3395
	bl	__sanitizer_cov_trace_pc
	mov	r3, r5
	mov	r1, r10
	mov	r2, r4
	mov	r0, r7
	bl	__sanitizer_cov_trace_cmp8
	cmp	r7, r4
	sbcs	r1, r10, r5
	movcc	r3, #1
	movcs	r3, #0
	str	r3, [sp, #8]
.L3395:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r8, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3396
	mov	r0, r8
	bl	__asan_report_store8_noabort
.L3396:
	add	r9, r9, #1
	strd	r4, [r8]
	mov	r1, r9
	mov	r0, fp
	bl	__sanitizer_cov_trace_cmp4
	cmp	r9, fp
	add	r8, r8, #8
	bne	.L3397
	ldr	r7, [sp, #52]
	ldrd	r4, [sp, #80]
	bl	__sanitizer_cov_trace_pc
	mov	r3, #0
	mov	r0, #0
	mov	r1, #0
	ldr	r6, [sp, #8]
	mov	r2, r6
	bl	__sanitizer_cov_trace_const_cmp8
	orrs	r9, r6, #0
	beq	.L3361
	ldr	r9, [sp, #56]
	mov	r10, #0
	str	r10, [sp, #8]
	str	r4, [sp, #52]
	str	r5, [sp, #80]
.L3401:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r7, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3398
	mov	r0, r7
	bl	__asan_report_load8_noabort
.L3398:
	lsr	r3, r9, #3
	add	r3, r3, #-1627389952
	ldm	r7, {r6, r8}
	ldrsb	r3, [r3]
	add	r7, r7, #8
	mov	r5, r9
	cmp	r3, #0
	beq	.L3399
	mov	r0, r9
	bl	__asan_report_load8_noabort
.L3399:
	ldrd	r4, [r5]
	ldr	r3, [sp, #8]
	mov	r0, r6
	adds	r4, r6, r4
	adc	r5, r8, r5
	adds	r4, r4, r3
	adc	r5, r5, #0
	mov	r2, r4
	mov	r3, r5
	mov	r1, r8
	bl	__sanitizer_cov_trace_cmp8
	cmp	r8, r5
	cmpeq	r6, r4
	add	r9, r9, #8
	beq	.L3400
	bl	__sanitizer_cov_trace_pc
	mov	r3, r5
	mov	r1, r8
	mov	r2, r4
	mov	r0, r6
	bl	__sanitizer_cov_trace_cmp8
	cmp	r4, r6
	sbcs	r1, r5, r8
	movcc	r3, #1
	movcs	r3, #0
	str	r3, [sp, #8]
.L3400:
	add	r10, r10, #1
	bl	__sanitizer_cov_trace_pc
	mov	r1, r10
	mov	r0, fp
	strd	r4, [r7, #-8]
	bl	__sanitizer_cov_trace_cmp4
	cmp	r10, fp
	bne	.L3401
	ldr	r4, [sp, #52]
	ldr	r5, [sp, #80]
	b	.L3361
.L3392:
	bl	__sanitizer_cov_trace_pc
	mov	r2, r5
	mov	r3, #0
	str	r3, [r2], #12
	str	r3, [r5, #12]
	str	r3, [r2, #4]
	str	r3, [r5, #24]
	str	r3, [r5, #28]
	str	r3, [r5, #48]
	str	r3, [r5, #52]
	str	r3, [r5, #56]
	str	r3, [r5, #76]
	str	r3, [r5, #80]
	str	r3, [r5, #100]
	str	r3, [r5, #104]
	str	r3, [r5, #108]
	str	r3, [r5, #128]
	str	r3, [r5, #132]
	ldr	r3, .L3548+36
	ldr	r2, [r3]
	ldr	r3, [sp, #1236]
	eors	r2, r3, r2
	mov	r3, #0
	beq	.L3411
	b	.L3547
.L3549:
	.align	2
.L3548:
	.word	1102416563
	.word	.LC45
	.word	.LASANPC2762
	.word	-218959118
	.word	-219021312
	.word	-218959360
	.word	-202116109
	.word	-235802127
	.word	62194
	.word	__stack_chk_guard
	.word	521
.L3404:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r7, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3402
	mov	r0, r7
	bl	__asan_report_load8_noabort
.L3402:
	lsr	r3, r6, #3
	add	r3, r3, #-1627389952
	ldrd	r8, [r7], #8
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3403
	mov	r0, r6
	bl	__asan_report_store8_noabort
.L3403:
	add	r4, r4, #1
	mov	r1, r4
	mov	r0, fp
	strd	r8, [r6], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r4, fp
	bne	.L3404
	bl	__sanitizer_cov_trace_pc
	ldr	r3, [sp, #44]
	add	r0, r3, #4
	and	r3, r0, #7
	lsr	r2, r0, #3
	add	r2, r2, #-1627389952
	add	r3, r3, #3
	ldrsb	r2, [r2]
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3405
	bl	__asan_report_load4_noabort
.L3405:
	ldr	r3, [sp, #44]
	ldr	r9, [sp, #36]
	mov	r4, #0
	ldr	r8, [r3, #4]
.L3408:
	bl	__sanitizer_cov_trace_pc
	lsr	r3, r9, #3
	add	r3, r3, #-1627389952
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3406
	mov	r0, r9
	bl	__asan_report_load8_noabort
.L3406:
	lsr	r3, r8, #3
	add	r3, r3, #-1627389952
	ldrd	r6, [r9], #8
	ldrsb	r3, [r3]
	cmp	r3, #0
	beq	.L3407
	mov	r0, r8
	bl	__asan_report_store8_noabort
.L3407:
	add	r4, r4, #1
	mov	r1, r4
	mov	r0, fp
	strd	r6, [r8], #8
	bl	__sanitizer_cov_trace_cmp4
	cmp	r4, fp
	bne	.L3408
	b	.L3392
.L3335:
	bl	__sanitizer_cov_trace_pc
	ldr	r3, [sp, #64]
	ldr	r6, [sp, #40]
	ldr	r2, [sp, #24]
	sub	r0, r6, #792
	sub	r1, r6, #584
	stm	sp, {r3, r4}
	ldr	r3, [sp, #36]
	str	r0, [sp, #52]
	bl	xycz_initial_double
	mov	r1, r7
	mov	r0, #0
	bl	__sanitizer_cov_trace_const_cmp4
	sub	r8, r6, #376
	ldr	r3, [sp, #32]
	lsr	r2, r3, #3
	str	r2, [sp, #76]
	and	r2, r3, #7
	add	r3, r3, #4
	str	r2, [sp, #72]
	str	r3, [sp, #60]
	b	.L3354
.L3344:
	bl	__sanitizer_cov_trace_pc
	ldr	r1, [sp, #32]
	lsr	r3, r1, #3
	str	r3, [sp, #76]
	add	r3, r3, #-1627389952
	ldrsb	r2, [r3]
	and	r3, r1, #7
	str	r3, [sp, #72]
	add	r3, r3, #3
	cmp	r3, r2
	movlt	r3, #0
	movge	r3, #1
	cmp	r2, #0
	moveq	r3, #0
	cmp	r3, #0
	beq	.L3409
	mov	r0, r1
	bl	__asan_report_load4_noabort
.L3409:
	ldr	r3, [sp, #32]
	mov	r1, fp
	mov	r0, #0
	ldr	r6, [r3]
	ldr	r7, .L3548+40
	bl	__sanitizer_cov_trace_const_cmp4
	b	.L3410
.L3547:
	bl	__stack_chk_fail
.L3411:
	add	sp, sp, #1232
	add	sp, sp, #12
	@ sp needed
	mov	r0, #0
	mov	r1, #0
	mov	r2, #0
	mov	r3, #0
	mov	ip, #0
	mov	lr, #0
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, pc}
	.fnend
	.size	ecc_point_mult, .-ecc_point_mult

--WgAw6ZgpYYzlY3nX--
