From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 08/12] x86/crypto: Fix RBP usage in sha256-avx-asm.S
Date: Mon, 18 Sep 2017 14:42:07 -0500
Message-ID: <a95a7b819d884ef938be2438191824e8335edffe.1505763153.git.jpoimboe@redhat.com>
References: <cover.1505763153.git.jpoimboe@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Mathias Krause <minipli@googlemail.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>, Jiri Slaby <jslaby@suse.cz>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1505763153.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Using RBP as a temporary register breaks frame pointer convention and
breaks stack traces when unwinding from an interrupt in the crypto code.

Swap the usages of R12 and RBP.  Use R12 for the TBL register, and use
RBP to store the pre-aligned stack pointer.

Reported-by: Eric Biggers <ebiggers@google.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Eric Biggers <ebiggers@google.com>
Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha256-avx-asm.S | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index e08888a1a5f2..001bbcf93c79 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -103,7 +103,7 @@ SRND = %rsi       # clobbers INP
 c = %ecx
 d = %r8d
 e = %edx
-TBL = %rbp
+TBL = %r12
 a = %eax
 b = %ebx
 
@@ -350,13 +350,13 @@ a = TMP_
 ENTRY(sha256_transform_avx)
 .align 32
 	pushq   %rbx
-	pushq   %rbp
+	pushq   %r12
 	pushq   %r13
 	pushq   %r14
 	pushq   %r15
-	pushq   %r12
+	pushq	%rbp
+	movq	%rsp, %rbp
 
-	mov	%rsp, %r12
 	subq    $STACK_SIZE, %rsp	# allocate stack space
 	and	$~15, %rsp		# align stack pointer
 
@@ -452,13 +452,12 @@ loop2:
 
 done_hash:
 
-	mov	%r12, %rsp
-
-	popq	%r12
+	mov	%rbp, %rsp
+	popq	%rbp
 	popq    %r15
 	popq    %r14
 	popq    %r13
-	popq    %rbp
+	popq	%r12
 	popq    %rbx
 	ret
 ENDPROC(sha256_transform_avx)
-- 
2.13.5
