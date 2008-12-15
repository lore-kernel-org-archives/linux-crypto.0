From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI
	instructions
Date: Mon, 15 Dec 2008 16:21:06 +1100
Message-ID: <20081215052106.GA29324@gondor.apana.org.au>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com> <20081212195722.GA24489@Chamillionaire.breakpoint.cc> <1229307542.5936.204.camel@yhuang-dev.sh.intel.com> <20081215033842.GA28499@gondor.apana.org.au> <1229318099.5936.224.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
	Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"mingo@elte.hu" <mingo@elte.hu>,
	"tglx@linutronix.de" <tglx@linutronix.de>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53176 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750816AbYLOFVS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Dec 2008 00:21:18 -0500
Content-Disposition: inline
In-Reply-To: <1229318099.5936.224.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 15, 2008 at 01:14:59PM +0800, Huang Ying wrote:
> 
> The PadLock instructions don't use/touch SSE registers, but might cause
> DNA fault when CR0.TS is set. So it is sufficient just to clear CR0.TS
> before executed.
> 
> The AES-NI instructions do use SSE registers. Considering the following

This really sucks as more than half of the kernel AES users are
in softirq context.  Someone hit the guy who designed this with
a clue-bat please!

> To solve the above issue, the following methods can be used:
> 
> a. Do not touch SSE state in soft_irq
> b. Disable/restore soft_irq in kernel_fpu_begin/kernel_fpu_end
> c. Use a per-CPU data structure to save kernel FPU state during
> soft_irq.
> 
> The mothod a is used in patch.

Could you run the tcrypt speed test on this and measure the
difference between the native AES vs. the fallback? Depending
on the difference I think we'd want to consider b) or c).

Of course the best solution would be to fix the hardware.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
