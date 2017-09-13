From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 00/12] x86/crypto: Fix RBP usage in several crypto .S
 files
Date: Wed, 13 Sep 2017 17:33:03 -0500
Message-ID: <20170913223303.pskmy2v7nto6rvtg@treble>
References: <cover.1504029132.git.jpoimboe@redhat.com>
 <20170902000919.GA139193@gmail.com>
 <20170907071534.ztbxvyfoo7m7esmw@gmail.com>
 <20170907175800.GA92996@gmail.com>
 <20170907212646.q3y5wmhyaaqblg5m@gmail.com>
 <20170908175705.GA623@zzz.localdomain>
 <20170913212428.kibwbqs2f7dkeslb@treble>
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
Received: from mx1.redhat.com ([209.132.183.28]:34950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbdIMWdG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Sep 2017 18:33:06 -0400
Content-Disposition: inline
In-Reply-To: <20170913212428.kibwbqs2f7dkeslb@treble>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 13, 2017 at 04:24:28PM -0500, Josh Poimboeuf wrote:
> On Fri, Sep 08, 2017 at 10:57:05AM -0700, Eric Biggers wrote:
> > On Thu, Sep 07, 2017 at 11:26:47PM +0200, Ingo Molnar wrote:
> > > 
> > > * Eric Biggers <ebiggers3@gmail.com> wrote:
> > > 
> > > > On Thu, Sep 07, 2017 at 09:15:34AM +0200, Ingo Molnar wrote:
> > > > > 
> > > > > * Eric Biggers <ebiggers3@gmail.com> wrote:
> > > > > 
> > > > > > Thanks for fixing these!  I don't have time to review these in detail, but I ran
> > > > > > the crypto self-tests on the affected algorithms, and they all pass.  I also
> > > > > > benchmarked them before and after; the only noticable performance difference was
> > > > > > that sha256-avx2 and sha512-avx2 became a few percent slower.  I don't suppose
> > > > > > there is a way around that?  Otherwise it's probably not a big deal.
> > > > > 
> > > > > Which CPU model did you use for the test?
> > > > > 
> > > > > Thanks,
> > > > > 
> > > > > 	Ingo
> > > > 
> > > > This was on Haswell, "Intel(R) Xeon(R) CPU E5-1650 v3 @ 3.50GHz".
> > > 
> > > Any chance to test this with the latest microarchitecture - any Skylake derivative 
> > > Intel CPU you have access to?
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > 
> > Tested with Skylake, "Intel(R) Core(TM) i5-6200U CPU @ 2.30GHz".  The results
> > were the following which seemed a bit worse than Haswell:
> > 
> > 	sha256-avx2 became 3.5% slower
> > 	sha512-avx2 became 7.5% slower
> > 
> > Note: it's tricky to benchmark this, especially with just a few percent
> > difference, so don't read too much into the exact numbers.
> 
> Here's a v2 for the sha256-avx2 patch, would you mind seeing if this
> closes the performance gap?
> 
> I'm still looking at the other one (sha512-avx2), but so far I haven't
> found a way to speed it back up.

And here's v2 of the sha512-avx2 patch.  It should hopefully gain back
most of the performance lost by v1.

From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] x86/crypto: Fix RBP usage in sha512-avx2-asm.S

Using RBP as a temporary register breaks frame pointer convention and
breaks stack traces when unwinding from an interrupt in the crypto code.

Mix things up a little bit to get rid of the RBP usage, without
destroying performance.  Use RDI instead of RBP for the TBL pointer.
That will clobber CTX, so save CTX on the stack and use RDI as CTX
before it gets clobbered, and R12 as CTX after it gets clobbered.

Also remove the unused y4 variable.

Reported-by: Eric Biggers <ebiggers3@gmail.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha512-avx2-asm.S | 75 ++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 36 deletions(-)

diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index 7f5f6c6ec72e..b16d56005162 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -69,8 +69,9 @@ XFER  = YTMP0
 
 BYTE_FLIP_MASK  = %ymm9
 
-# 1st arg
-CTX         = %rdi
+# 1st arg is %rdi, which is saved to the stack and accessed later via %r12
+CTX1        = %rdi
+CTX2        = %r12
 # 2nd arg
 INP         = %rsi
 # 3rd arg
@@ -81,7 +82,7 @@ d           = %r8
 e           = %rdx
 y3          = %rsi
 
-TBL   = %rbp
+TBL   = %rdi # clobbers CTX1
 
 a     = %rax
 b     = %rbx
@@ -91,26 +92,26 @@ g     = %r10
 h     = %r11
 old_h = %r11
 
-T1    = %r12
+T1    = %r12 # clobbers CTX2
 y0    = %r13
 y1    = %r14
 y2    = %r15
 
-y4    = %r12
-
 # Local variables (stack frame)
 XFER_SIZE = 4*8
 SRND_SIZE = 1*8
 INP_SIZE = 1*8
 INPEND_SIZE = 1*8
+CTX_SIZE = 1*8
 RSPSAVE_SIZE = 1*8
-GPRSAVE_SIZE = 6*8
+GPRSAVE_SIZE = 5*8
 
 frame_XFER = 0
 frame_SRND = frame_XFER + XFER_SIZE
 frame_INP = frame_SRND + SRND_SIZE
 frame_INPEND = frame_INP + INP_SIZE
-frame_RSPSAVE = frame_INPEND + INPEND_SIZE
+frame_CTX = frame_INPEND + INPEND_SIZE
+frame_RSPSAVE = frame_CTX + CTX_SIZE
 frame_GPRSAVE = frame_RSPSAVE + RSPSAVE_SIZE
 frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 
@@ -576,12 +577,11 @@ ENTRY(sha512_transform_rorx)
 	mov	%rax, frame_RSPSAVE(%rsp)
 
 	# Save GPRs
-	mov	%rbp, frame_GPRSAVE(%rsp)
-	mov	%rbx, 8*1+frame_GPRSAVE(%rsp)
-	mov	%r12, 8*2+frame_GPRSAVE(%rsp)
-	mov	%r13, 8*3+frame_GPRSAVE(%rsp)
-	mov	%r14, 8*4+frame_GPRSAVE(%rsp)
-	mov	%r15, 8*5+frame_GPRSAVE(%rsp)
+	mov	%rbx, 8*0+frame_GPRSAVE(%rsp)
+	mov	%r12, 8*1+frame_GPRSAVE(%rsp)
+	mov	%r13, 8*2+frame_GPRSAVE(%rsp)
+	mov	%r14, 8*3+frame_GPRSAVE(%rsp)
+	mov	%r15, 8*4+frame_GPRSAVE(%rsp)
 
 	shl	$7, NUM_BLKS	# convert to bytes
 	jz	done_hash
@@ -589,14 +589,17 @@ ENTRY(sha512_transform_rorx)
 	mov	NUM_BLKS, frame_INPEND(%rsp)
 
 	## load initial digest
-	mov	8*0(CTX),a
-	mov	8*1(CTX),b
-	mov	8*2(CTX),c
-	mov	8*3(CTX),d
-	mov	8*4(CTX),e
-	mov	8*5(CTX),f
-	mov	8*6(CTX),g
-	mov	8*7(CTX),h
+	mov	8*0(CTX1), a
+	mov	8*1(CTX1), b
+	mov	8*2(CTX1), c
+	mov	8*3(CTX1), d
+	mov	8*4(CTX1), e
+	mov	8*5(CTX1), f
+	mov	8*6(CTX1), g
+	mov	8*7(CTX1), h
+
+	# save %rdi (CTX) before it gets clobbered
+	mov	%rdi, frame_CTX(%rsp)
 
 	vmovdqa	PSHUFFLE_BYTE_FLIP_MASK(%rip), BYTE_FLIP_MASK
 
@@ -652,14 +655,15 @@ loop2:
 	subq	$1, frame_SRND(%rsp)
 	jne	loop2
 
-	addm	8*0(CTX),a
-	addm	8*1(CTX),b
-	addm	8*2(CTX),c
-	addm	8*3(CTX),d
-	addm	8*4(CTX),e
-	addm	8*5(CTX),f
-	addm	8*6(CTX),g
-	addm	8*7(CTX),h
+	mov	frame_CTX(%rsp), CTX2
+	addm	8*0(CTX2), a
+	addm	8*1(CTX2), b
+	addm	8*2(CTX2), c
+	addm	8*3(CTX2), d
+	addm	8*4(CTX2), e
+	addm	8*5(CTX2), f
+	addm	8*6(CTX2), g
+	addm	8*7(CTX2), h
 
 	mov	frame_INP(%rsp), INP
 	add	$128, INP
@@ -669,12 +673,11 @@ loop2:
 done_hash:
 
 # Restore GPRs
-	mov	frame_GPRSAVE(%rsp)     ,%rbp
-	mov	8*1+frame_GPRSAVE(%rsp) ,%rbx
-	mov	8*2+frame_GPRSAVE(%rsp) ,%r12
-	mov	8*3+frame_GPRSAVE(%rsp) ,%r13
-	mov	8*4+frame_GPRSAVE(%rsp) ,%r14
-	mov	8*5+frame_GPRSAVE(%rsp) ,%r15
+	mov	8*0+frame_GPRSAVE(%rsp), %rbx
+	mov	8*1+frame_GPRSAVE(%rsp), %r12
+	mov	8*2+frame_GPRSAVE(%rsp), %r13
+	mov	8*3+frame_GPRSAVE(%rsp), %r14
+	mov	8*4+frame_GPRSAVE(%rsp), %r15
 
 	# Restore Stack Pointer
 	mov	frame_RSPSAVE(%rsp), %rsp
-- 
2.13.5
