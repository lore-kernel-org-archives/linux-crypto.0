From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 09/12] x86/crypto: Fix RBP usage in sha256-avx2-asm.S
Date: Tue, 29 Aug 2017 13:05:42 -0500
Message-ID: <8b520aba97ad2c8907c2040210bf9894b850d0ea.1504029132.git.jpoimboe@redhat.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1504029132.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Using RBP as a temporary register breaks frame pointer convention and
breaks stack traces when unwinding from an interrupt in the crypto code.

Use R12 instead of RBP for the TBL register.  Since R12 is also used as
another temporary register (T1), it gets clobbered in each round of
computation.  So the table address needs to be freshly reloaded into R12
each time it's used.

Reported-by: Eric Biggers <ebiggers@google.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha256-avx2-asm.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 89c8f09787d2..cdd647231fa9 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -99,7 +99,7 @@ e       = %edx	# clobbers NUM_BLKS
 y3	= %esi	# clobbers INP
 
 
-TBL	= %rbp
+TBL	= %r12	# clobbered by T1
 SRND	= CTX	# SRND is same register as CTX
 
 a = %eax
@@ -531,7 +531,6 @@ STACK_SIZE	= _RSP      + _RSP_SIZE
 ENTRY(sha256_transform_rorx)
 .align 32
 	pushq	%rbx
-	pushq	%rbp
 	pushq	%r12
 	pushq	%r13
 	pushq	%r14
@@ -568,8 +567,6 @@ ENTRY(sha256_transform_rorx)
 	mov	CTX, _CTX(%rsp)
 
 loop0:
-	lea     K256(%rip), TBL
-
 	## Load first 16 dwords from two blocks
 	VMOVDQ	0*32(INP),XTMP0
 	VMOVDQ	1*32(INP),XTMP1
@@ -597,18 +594,22 @@ last_block_enter:
 
 .align 16
 loop1:
+	lea	K256(%rip), TBL
 	vpaddd	0*32(TBL, SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 0*32
 
+	lea	K256(%rip), TBL
 	vpaddd	1*32(TBL, SRND), X0, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 1*32
 
+	lea	K256(%rip), TBL
 	vpaddd	2*32(TBL, SRND), X0, XFER
 	vmovdqa XFER, 2*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 2*32
 
+	lea	K256(%rip), TBL
 	vpaddd	3*32(TBL, SRND), X0, XFER
 	vmovdqa XFER, 3*32+_XFER(%rsp, SRND)
 	FOUR_ROUNDS_AND_SCHED	_XFER + 3*32
@@ -619,9 +620,12 @@ loop1:
 
 loop2:
 	## Do last 16 rounds with no scheduling
+	lea	K256(%rip), TBL
 	vpaddd	0*32(TBL, SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
 	DO_4ROUNDS	_XFER + 0*32
+
+	lea	K256(%rip), TBL
 	vpaddd	1*32(TBL, SRND), X1, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
 	DO_4ROUNDS	_XFER + 1*32
@@ -676,9 +680,6 @@ loop3:
 	ja	done_hash
 
 do_last_block:
-	#### do last block
-	lea	K256(%rip), TBL
-
 	VMOVDQ	0*16(INP),XWORD0
 	VMOVDQ	1*16(INP),XWORD1
 	VMOVDQ	2*16(INP),XWORD2
@@ -718,7 +719,6 @@ done_hash:
 	popq	%r14
 	popq	%r13
 	popq	%r12
-	popq	%rbp
 	popq	%rbx
 	ret
 ENDPROC(sha256_transform_rorx)
-- 
2.13.5
