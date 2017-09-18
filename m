From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 10/12] x86/crypto: Fix RBP usage in sha256-ssse3-asm.S
Date: Mon, 18 Sep 2017 14:42:09 -0500
Message-ID: <b22b10e48bd5a0132f7918b3ea7a8879bfa9f702.1505763153.git.jpoimboe@redhat.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751488AbdIRTmv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Sep 2017 15:42:51 -0400
In-Reply-To: <cover.1505763153.git.jpoimboe@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
