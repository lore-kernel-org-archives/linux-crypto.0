From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Wed, 13 Sep 2017 16:24:28 -0500
Message-ID: <20170913212428.kibwbqs2f7dkeslb@treble>
References: <cover.1504029132.git.jpoimboe@redhat.com>
 <20170902000919.GA139193@gmail.com>
 <20170907071534.ztbxvyfoo7m7esmw@gmail.com>
 <20170907175800.GA92996@gmail.com>
 <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
 <20170908175705.GA623@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
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
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59774 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751117AbdIMVYb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Sep 2017 17:24:31 -0400
Content-Disposition: inline
In-Reply-To: <20170908175705.GA623@zzz.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 08, 2017 at 10:57:05AM -0700, Eric Biggers wrote:
> On Thu, Sep 07, 2017 at 11:26:47PM +0200, Ingo Molnar wrote:
> > 
> > * Eric Biggers <ebiggers3@gmail.com> wrote:
> > 
> > > On Thu, Sep 07, 2017 at 09:15:34AM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Eric Biggers <ebiggers3@gmail.com> wrote:
> > > > 
> > > > > Thanks for fixing these!  I don't have time to review these in detail, but I ran
> > > > > the crypto self-tests on the affected algorithms, and they all pass.  I also
> > > > > benchmarked them before and after; the only noticable performance difference was
> > > > > that sha256-avx2 and sha512-avx2 became a few percent slower.  I don't suppose
> > > > > there is a way around that?  Otherwise it's probably not a big deal.
> > > > 
> > > > Which CPU model did you use for the test?
> > > > 
> > > > Thanks,
> > > > 
> > > > 	Ingo
> > > 
> > > This was on Haswell, "Intel(R) Xeon(R) CPU E5-1650 v3 @ 3.50GHz".
> > 
> > Any chance to test this with the latest microarchitecture - any Skylake derivative 
> > Intel CPU you have access to?
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Tested with Skylake, "Intel(R) Core(TM) i5-6200U CPU @ 2.30GHz".  The results
> were the following which seemed a bit worse than Haswell:
> 
> 	sha256-avx2 became 3.5% slower
> 	sha512-avx2 became 7.5% slower
> 
> Note: it's tricky to benchmark this, especially with just a few percent
> difference, so don't read too much into the exact numbers.

Here's a v2 for the sha256-avx2 patch, would you mind seeing if this
closes the performance gap?

I'm still looking at the other one (sha512-avx2), but so far I haven't
found a way to speed it back up.

From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] x86/crypto: Fix RBP usage in sha256-avx2-asm.S

Using RBP as a temporary register breaks frame pointer convention and
breaks stack traces when unwinding from an interrupt in the crypto code.

There's no need to use RBP as a temporary register for the TBL value,
because it always stores the same value: the address of the K256 table.
Instead just reference the address of K256 directly.

Reported-by: Eric Biggers <ebiggers@google.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha256-avx2-asm.S | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 89c8f09787d2..1420db15dcdd 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -98,8 +98,6 @@ d	= %r8d
 e       = %edx	# clobbers NUM_BLKS
 y3	= %esi	# clobbers INP
 
-
-TBL	= %rbp
 SRND	= CTX	# SRND is same register as CTX
 
 a = %eax
@@ -531,7 +529,6 @@ STACK_SIZE	= _RSP      + _RSP_SIZE
 ENTRY(sha256_transform_rorx)
 .align 32
 	pushq	%rbx
-	pushq	%rbp
 	pushq	%r12
 	pushq	%r13
 	pushq	%r14
@@ -568,8 +565,6 @@ ENTRY(sha256_transform_rorx)
 	mov	CTX, _CTX(%rsp)
 
 loop0:
-	lea     K256(%rip), TBL
-
 	## Load first 16 dwords from two blocks
 	VMOVDQ	0*32(INP),XTMP0
 	VMOVDQ	1*32(INP),XTMP1
@@ -597,19 +592,19 @@ last_block_enter:
 
 .align 16
 loop1:
-	vpaddd	0*32(TBL, SRND), X0, XFER
+	vpaddd	K256+0*32(SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 0*32
 
-	vpaddd	1*32(TBL, SRND), X0, XFER
+	vpaddd	K256+1*32(SRND), X0, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 1*32
 
-	vpaddd	2*32(TBL, SRND), X0, XFER
+	vpaddd	K256+2*32(SRND), X0, XFER
 	vmovdqa XFER, 2*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 2*32
 
-	vpaddd	3*32(TBL, SRND), X0, XFER
+	vpaddd	K256+3*32(SRND), X0, XFER
 	vmovdqa XFER, 3*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 3*32
 
@@ -619,10 +614,11 @@ loop1:
 
 loop2:
 	## Do last 16 rounds with no scheduling
-	vpaddd	0*32(TBL, SRND), X0, XFER
+	vpaddd	K256+0*32(SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
 	DO_4ROUNDS	_XFER + 0*32
-	vpaddd	1*32(TBL, SRND), X1, XFER
+
+	vpaddd	K256+1*32(SRND), X1, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
 	DO_4ROUNDS	_XFER + 1*32
 	add	$2*32, SRND
@@ -676,9 +672,6 @@ loop3:
 	ja	done_hash
 
 do_last_block:
-	#### do last block
-	lea	K256(%rip), TBL
-
 	VMOVDQ	0*16(INP),XWORD0
 	VMOVDQ	1*16(INP),XWORD1
 	VMOVDQ	2*16(INP),XWORD2
@@ -718,7 +711,6 @@ done_hash:
 	popq	%r14
 	popq	%r13
 	popq	%r12
-	popq	%rbp
 	popq	%rbx
 	ret
 ENDPROC(sha256_transform_rorx)
-- 
2.13.5
