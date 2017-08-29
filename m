From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 10/12] x86/crypto: Fix RBP usage in sha256-ssse3-asm.S
Date: Tue, 29 Aug 2017 13:05:43 -0500
Message-ID: <6818de78fab761c9337063050bdfed699b52b5fa.1504029132.git.jpoimboe@redhat.com>
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

Swap the usages of R12 and RBP.  Use R12 for the TBL register, and use
RBP to store the pre-aligned stack pointer.

Reported-by: Eric Biggers <ebiggers@google.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha256-ssse3-asm.S | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index 39b83c93e7fd..c6c05ed2c16a 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -95,7 +95,7 @@ SRND = %rsi       # clobbers INP
 c = %ecx
 d = %r8d
 e = %edx
-TBL = %rbp
+TBL = %r12
 a = %eax
 b = %ebx
 
@@ -356,13 +356,13 @@ a = TMP_
 ENTRY(sha256_transform_ssse3)
 .align 32
 	pushq   %rbx
-	pushq   %rbp
+	pushq   %r12
 	pushq   %r13
 	pushq   %r14
 	pushq   %r15
-	pushq   %r12
+	pushq   %rbp
+	mov	%rsp, %rbp
 
-	mov	%rsp, %r12
 	subq    $STACK_SIZE, %rsp
 	and	$~15, %rsp
 
@@ -462,13 +462,12 @@ loop2:
 
 done_hash:
 
-	mov	%r12, %rsp
-
-	popq    %r12
+	mov	%rbp, %rsp
+	popq	%rbp
 	popq    %r15
 	popq    %r14
 	popq    %r13
-	popq    %rbp
+	popq    %r12
 	popq    %rbx
 
 	ret
-- 
2.13.5
