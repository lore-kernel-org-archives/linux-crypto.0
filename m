From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: may_use_simd on aarch64, chacha20
Date: Fri, 26 May 2017 14:28:09 +0100
Message-ID: <20170526132808.GP3559@e103592.cambridge.arm.com>
References: <CAHmME9qH=Wu-=9YUmxi7NPrczHu1UrB7phG0y68ipB+ProQ2TA@mail.gmail.com>
 <4150EFDC-CD3A-4C5C-9EF7-689F63C142C2@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:60456 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761891AbdEZN2N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2017 09:28:13 -0400
Content-Disposition: inline
In-Reply-To: <4150EFDC-CD3A-4C5C-9EF7-689F63C142C2@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 21, 2017 at 10:55:20PM +0200, Ard Biesheuvel wrote:
> (+ Dave)

Apologies for the slow reply -- hopefully this is still useful.

> > On 21 May 2017, at 19:02, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > 
> > Hi folks,
> > 
> > I noticed that the ARM implementation [1] of chacha20 makes a check to
> > may_use_simd(), but the ARM64 implementation [2] does not. Question 1:
> > is this a bug, in which case I'll submit a patch shortly, or is this
> > intentional? In case of the latter, could somebody explain the
> > reasoning?
> 
> This is intentional. arm64 supports kernel mode NEON in any context,
> whereas ARM only supports it in process context. This is due to the way
> lazy FP restore is implemented on ARM. However, we are about to change
> this on arm64 to only allow non-nested kernel mode NEON, similar to
> x86. This is necessary to support SVE.
> 
> > On a similar note, the only ARM64 glue code that uses
> > may_use_simd() is sha256; everything else does not. Shall I submit a
> > substantial patch series to fix this up everywhere?
> > 
> 
> Currently, may_use_simd() is only used as a hint on arm64 whether it
> makes sense to offload crypto to process context. In the sha256 code,
> whose arm64 neon implementation is only marginally faster than scalar
> on some micro-architectures, it is used to prefer the scalar code in
> interrupt context, because the NEON code preserves/restores the NEON
> state of the interrupted context eagerly, which is costly.
> 
> > Secondly, I noticed that may_use_simd() is essentially aliased to
> > !in_interrupt(), since it uses the asm-generic variety. Question 2:
> > Isn't this overkill? Couldn't we make an arm/arm64 variant of this
> > that only checks in_irq()?
> > 
> 
> No. ARM does not support kernel mode NEON in softirq context, and
> arm64 will soon have its own override that only allows non-nested use
> in softirq context.
> 
> > Lastly, APIs like pcrypts and padata execute with bottom halves
> > disabled, even though their actual execution environment is process
> > context, via a workqueue. Thus, here, in_interrupt() will always be
> > true, even though this is likely a place where we want to use simd.
> > Question 3: is there something better that could be done?
> 
> I guess we should switch to in_serving_softirq() instead.

For context, the arm64 kernel-mode NEON refactoring I've been working
on [1] defines may_use_simd() to indicate whether calling
kernel_neon_begin() is safe or not, rather then being a hint about
whether it is desirable to do so.

This changes the definition of may_use_simd() to something that is
probably appropriate for your scenario.  From process context without
any outer kernel_neon_begin()...kernel_neon_end(), it should return
true.

In general, callers in any context should do something like:

	if (may_use_simd()) {
		kernel_neon_begin();
		/* SIMD implementation */
		kernel_neon_end();
	} else {
		/* fallback implementation, or defer to another context */
	}

Even from task context where may_use_simd() should always return true
and thus where the fallback path can be omitted, it may be a good idea
to do something like

	if (!may_use_simd()) {
		WARN_ON(1);
		return -EBUSY;
	}

... or similar.


If the semantics or name don't feel right, I'm happy to change them.

Cheers
---Dave


[1] lists.infradead.org/pipermail/linux-arm-kernel/2017-May/508901.html
(arm64: neon: Remove support for nested or hardirq kernel-mode NEON)
