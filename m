From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Thu, 14 Sep 2017 08:28:05 -0500
Message-ID: <20170914132805.l6yfpyinw7lgruee@treble>
References: <cover.1504029132.git.jpoimboe@redhat.com>
 <20170902000919.GA139193@gmail.com>
 <20170907071534.ztbxvyfoo7m7esmw@gmail.com>
 <20170907175800.GA92996@gmail.com>
 <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
 <20170908175705.GA623@zzz.localdomain>
 <20170913212428.kibwbqs2f7dkeslb@treble>
 <20170914091612.ck33coyubzevru2i@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Eric Biggers <ebiggers3@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Ingo Molnar <mingo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbdINN2J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2017 09:28:09 -0400
Content-Disposition: inline
In-Reply-To: <20170914091612.ck33coyubzevru2i@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 14, 2017 at 11:16:12AM +0200, Ingo Molnar wrote:
> 
> * Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > I'm still looking at the other one (sha512-avx2), but so far I haven't
> > found a way to speed it back up.
> 
> Here's a couple of very quick observations with possible optimizations:
> 
> AFAICS the main effect of the RBP fixes is the introduction of a memory load into 
> the critical path, into the body unrolled loop:
> 
> +       mov frame_TBL(%rsp), TBL
>         vpaddq  (TBL), Y_0, XFER
>         vmovdqa XFER, frame_XFER(%rsp)
>         FOUR_ROUNDS_AND_SCHED
> 
> Both 'TLB' and 'T1' are mapped to R12, which is why TBL has to be spilled to be 
> reloaded from the stack.
> 
> 1)
> 
> Note how R12 is used immediately, right in the next instruction:
> 
>         vpaddq  (TBL), Y_0, XFER
> 
> I.e. the RBP fixes lengthen the program order data dependencies - that's a new 
> constraint and a few extra cycles per loop iteration if the workload is 
> address-generator bandwidth limited on that.
> 
> A simple way to ease that constraint would be to move the 'TLB' load up into the 
> loop, body, to the point where 'T1' is used for the last time - which is:
> 
> 
>         mov     a, T1           # T1 = a                                # MAJB
>         and     c, T1           # T1 = a&c                              # MAJB
> 
>         add     y0, y2          # y2 = S1 + CH                          # --
>         or      T1, y3          # y3 = MAJ = (a|c)&b)|(a&c)             # MAJ
> 
> +       mov frame_TBL(%rsp), TBL
> 
>         add     y1, h           # h = k + w + h + S0                    # --
> 
>         add     y2, d           # d = k + w + h + d + S1 + CH = d + t1  # --
> 
>         add     y2, h           # h = k + w + h + S0 + S1 + CH = t1 + S0# --
>         add     y3, h           # h = t1 + S0 + MAJ                     # --
> 
> Note how this moves up the 'TLB' reload by 4 instructions.
> 
> 2)
> 
> If this does not get back performance, then maybe another reason is that it's 
> cache access latency limited, in which case a more involved optimization would be 
> to look at the register patterns and usages:
> 
> 
> 			first-use	last-use		use-length
> 	a:		#10		#29			20
> 	b:		#24		#24			 1
> 	c:		#14		#30			17
> 	d:		#23		#34			12
> 	e:		#11		#20			10
> 	f:		#15		#15			 1
> 	g:		#18		#27			10
> 	h:		#13		#36			24
> 
> 	y0:		#11		#31			21
> 	y1:		#12		#33			22
> 	y2:		#15		#35			21
> 	y3:		#10		#36			27
> 
> 	T1:		#16		#32			17
> 
> The 'first-use' colums shows the number of the instruction within the loop body 
> that the register gets used - with '#1' denoting the first instruction ad #36 the 
> last instruction, the 'last-use' column is showing the last instruction, and the 
> 'use-length' colum shows the 'window' in which a register is used.
> 
> What we want are the registers that are used the most tightly, i.e. these two:
> 
> 	b:		#24		#24			 1
> 	f:		#15		#15			 1
> 
> Of these two 'f' is the best one, because it has an earlier use and longer 
> cooldown.
> 
> If alias 'TBL' with 'f' then we could reload 'TLB' for the next iteration very 
> early on:
> 
>         mov     f, y2           # y2 = f                                # CH
> +       mov frame_TBL(%rsp), TBL
>         rorx    $34, a, T1      # T1 = a >> 34                          # S0B
> 
> And there will be 21 instructions that don't depend on TLB after this, plenty of 
> time for the load to be generated and propagated.
> 
> NOTE: my pseudo-patch is naive, due to the complication caused by the RotateState 
> macro name rotation. It's still fundamentally possible I believe, it's just that 
> 'TBL' has to be rotated too, together with the other varibles.
> 
> 3)
> 
> If even this does not help, because the workload is ucode-cache limited, and the 
> extra reloads pushed the critical path just beyond some cache limit, then another 
> experiment to try would be to roll _back_ the loop some more: instead of 4x 
> FOUR_ROUNDS_AND_SCHED unrolled loops, try just having 2.
> 
> The CPU should still be smart enough with 2x interleaving of the loop body, and 
> the extra branches should be relatively small and we could get back some 
> performance.
> 
> In theory ...
> 
> 4)
> 
> If the workload is fundamentally cache-port bandwidth limited, then the extra 
> loads from memory to reload 'TLB' take away valuable bandwidth. There's no easy 
> fix for that, but to find an unused register.
> 
> Here's the (initial, pre-rotation) integer register mappings:
> 
> 	a:	RAX
> 	b:	RBX
> 	c:	RCX
> 	d:	R8
> 	e:	RDX
> 	f:	R9
> 	g:	R10
> 	h:	R11
> 
> 	y0:	R13
> 	y1:	R14
> 	y2:	R15
> 	y3:	RSI
> 
> 	T1:	R12
> 
> 	TLB:	R12 # aliased to T1
> 
> Look what's missing: I don't see RDI being used in the loop.
> 
> RDI is allocated to 'CTX', but that's only used in higher level glue code, it does 
> not appear to be used in the inner loops (explicitly at least).
> 
> So if this observation of mine is true we could go back to the old code for the 
> hotpath, but use RDI for TBL and not reload it in the hotpath.

Thanks for the excellent breakdown.

When I looked at the patch again, I came to the same conclusion as your
#4, which is that RDI isn't being used in the inner loops.  It *is* used
in the outermost loop, however.

So v2 of my sha512-avx2-asm.S patch spilled CTX onto the stack, instead
of TBL:

  https://lkml.kernel.org/r/20170913223303.pskmy2v7nto6rvtg@treble

That should result in fewer stack accesses, since it's only loaded from
the stack once in the outer loop.

If we still need more performance after that, then we can attempt
something similar to your other suggestions, except with CTX instead of
TBL.

-- 
Josh
