From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI
	instructions
Date: Wed, 17 Dec 2008 10:31:28 +1100
Message-ID: <20081216233128.GA13942@gondor.apana.org.au>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com> <20081212195722.GA24489@Chamillionaire.breakpoint.cc> <1229307542.5936.204.camel@yhuang-dev.sh.intel.com> <20081215033842.GA28499@gondor.apana.org.au> <1229318099.5936.224.camel@yhuang-dev.sh.intel.com> <20081215052106.GA29324@gondor.apana.org.au> <20081215123801.GA32485@gondor.apana.org.au>
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
Received: from rhun.apana.org.au ([64.62.148.172]:51493 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753691AbYLPXbn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Dec 2008 18:31:43 -0500
Content-Disposition: inline
In-Reply-To: <20081215123801.GA32485@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 15, 2008 at 11:38:01PM +1100, Herbert Xu wrote:
> On Mon, Dec 15, 2008 at 04:21:06PM +1100, Herbert Xu wrote:
> >
> > > a. Do not touch SSE state in soft_irq
> > > b. Disable/restore soft_irq in kernel_fpu_begin/kernel_fpu_end
> > > c. Use a per-CPU data structure to save kernel FPU state during
> > > soft_irq.
 
> Here's another option
> 
> d. When we're in interrupt context, schedule a task to perform
> the encryption asynchronously.

We can also hybridise b. and d.:

e. When we're in interrupt context, if TS is clear, then we defer
the operation to a thread.  Otherwise if user-space has touched
the FPU we save the state, if not then we simply clear TS.  In
either case we perform the operation immediately and then reset
TS if user-space didn't touch the FPU.

This is based on the fact that it should be fairly rare for us
to interrupt a kernel FPU/SSE operation.  The common case would
be interrupting a user process or a kernel context which is not
engaging in any kernel FPU operations.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
