From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI
	instructions
Date: Mon, 15 Dec 2008 23:38:01 +1100
Message-ID: <20081215123801.GA32485@gondor.apana.org.au>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com> <20081212195722.GA24489@Chamillionaire.breakpoint.cc> <1229307542.5936.204.camel@yhuang-dev.sh.intel.com> <20081215033842.GA28499@gondor.apana.org.au> <1229318099.5936.224.camel@yhuang-dev.sh.intel.com> <20081215052106.GA29324@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751968AbYLOMi0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081215052106.GA29324@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 15, 2008 at 04:21:06PM +1100, Herbert Xu wrote:
>
> > a. Do not touch SSE state in soft_irq
> > b. Disable/restore soft_irq in kernel_fpu_begin/kernel_fpu_end
> > c. Use a per-CPU data structure to save kernel FPU state during
> > soft_irq.
> > 
> > The mothod a is used in patch.
> 
> Could you run the tcrypt speed test on this and measure the
> difference between the native AES vs. the fallback? Depending
> on the difference I think we'd want to consider b) or c).

Here's another option

d. When we're in interrupt context, schedule a task to perform
the encryption asynchronously.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
