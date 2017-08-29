From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 11/12] x86/crypto: Fix RBP usage in sha512-avx2-asm.S
Date: Tue, 29 Aug 2017 13:05:44 -0500
Message-ID: <9a0f9d601d4ee24f6896f4764f3e3d08c80fa806.1504029132.git.jpoimboe@redhat.com>
References: <cover.1504029132.git.jpoimboe@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751514AbdH2SGb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2017 14:06:31 -0400
In-Reply-To: <cover.1504029132.git.jpoimboe@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Using RBP as a temporary register breaks frame pointer convention and
breaks stack traces when unwinding from an interrupt in the crypto code.

Use R12 instead of RBP for the TBL register.  Since R12 is also used as
another temporary register (T1), it gets clobbered in each round of
computation.  So the TBL value needs to be freshly reloaded into R12
each time it's used.  Since the value of TBL can change, store its
permanent value on the stack at the frame_TBL offset.

Also remove the unused y4 variable.

Reported-by: Eric Biggers <ebiggers3@gmail.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha512-avx2-asm.S | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index 7f5f6c6ec72e..37cfc2004abd 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -81,7 +81,7 @@ d           = %r8
 e           = %rdx
 y3          = %rsi
 
-TBL   = %rbp
+TBL   = %r12 # clobbered by T1
 
 a     = %rax
 b     = %rbx
@@ -96,11 +96,10 @@ y0    = %r13
 y1    = %r14
 y2    = %r15
 
-y4    = %r12
-
 # Local variables (stack frame)
 XFER_SIZE = 4*8
 SRND_SIZE = 1*8
+TBL_SIZE = 1*8
 INP_SIZE = 1*8
 INPEND_SIZE = 1*8
 RSPSAVE_SIZE = 1*8
@@ -108,7 +107,8 @@ GPRSAVE_SIZE = 6*8
 
 frame_XFER = 0
 frame_SRND = frame_XFER + XFER_SIZE
-frame_INP = frame_SRND + SRND_SIZE
+frame_TBL = frame_SRND + SRND_SIZE
+frame_INP = frame_TBL + TBL_SIZE
 frame_INPEND = frame_INP + INP_SIZE
 frame_RSPSAVE = frame_INPEND + INPEND_SIZE
 frame_GPRSAVE = frame_RSPSAVE + RSPSAVE_SIZE
@@ -601,7 +601,7 @@ ENTRY(sha512_transform_rorx)
 	vmovdqa	PSHUFFLE_BYTE_FLIP_MASK(%rip), BYTE_FLIP_MASK
 
 loop0:
-	lea	K512(%rip), TBL
+	movq	$K512, frame_TBL(%rsp)
 
 	## byte swap first 16 dwords
 	COPY_YMM_AND_BSWAP	Y_0, (INP), BYTE_FLIP_MASK
@@ -616,39 +616,46 @@ loop0:
 
 .align 16
 loop1:
+	mov frame_TBL(%rsp), TBL
 	vpaddq	(TBL), Y_0, XFER
 	vmovdqa XFER, frame_XFER(%rsp)
 	FOUR_ROUNDS_AND_SCHED
 
+	mov frame_TBL(%rsp), TBL
 	vpaddq	1*32(TBL), Y_0, XFER
 	vmovdqa XFER, frame_XFER(%rsp)
 	FOUR_ROUNDS_AND_SCHED
 
+	mov frame_TBL(%rsp), TBL
 	vpaddq	2*32(TBL), Y_0, XFER
 	vmovdqa XFER, frame_XFER(%rsp)
 	FOUR_ROUNDS_AND_SCHED
 
+	mov frame_TBL(%rsp), TBL
 	vpaddq	3*32(TBL), Y_0, XFER
 	vmovdqa XFER, frame_XFER(%rsp)
-	add	$(4*32), TBL
 	FOUR_ROUNDS_AND_SCHED
 
+	addq	$(4*32), frame_TBL(%rsp)
 	subq	$1, frame_SRND(%rsp)
 	jne	loop1
 
 	movq	$2, frame_SRND(%rsp)
 loop2:
+	mov frame_TBL(%rsp), TBL
 	vpaddq	(TBL), Y_0, XFER
 	vmovdqa XFER, frame_XFER(%rsp)
 	DO_4ROUNDS
+
+	mov frame_TBL(%rsp), TBL
 	vpaddq	1*32(TBL), Y_1, XFER
 	vmovdqa XFER, frame_XFER(%rsp)
-	add	$(2*32), TBL
 	DO_4ROUNDS
 
 	vmovdqa	Y_2, Y_0
 	vmovdqa	Y_3, Y_1
 
+	add	$(2*32), frame_TBL(%rsp)
 	subq	$1, frame_SRND(%rsp)
 	jne	loop2
 
-- 
2.13.5
