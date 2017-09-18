From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 07/12] x86/crypto: Fix RBP usage in sha1_ssse3_asm.S
Date: Mon, 18 Sep 2017 14:42:06 -0500
Message-ID: <8b3301f8ec3f8c0e4144d6e5ccafbc006762b4e0.1505763153.git.jpoimboe@redhat.com>
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

Swap the usages of R12 and RBP.  Use R12 for the REG_D register, and use
RBP to store the pre-aligned stack pointer.

Reported-by: Eric Biggers <ebiggers@google.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Eric Biggers <ebiggers@google.com>
Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha1_ssse3_asm.S | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
index a4109506a5e8..6204bd53528c 100644
--- a/arch/x86/crypto/sha1_ssse3_asm.S
+++ b/arch/x86/crypto/sha1_ssse3_asm.S
@@ -37,7 +37,7 @@
 #define REG_A	%ecx
 #define REG_B	%esi
 #define REG_C	%edi
-#define REG_D	%ebp
+#define REG_D	%r12d
 #define REG_E	%edx
 
 #define REG_T1	%eax
@@ -74,10 +74,10 @@
 	ENTRY(\name)
 
 	push	%rbx
-	push	%rbp
 	push	%r12
+	push	%rbp
+	mov	%rsp, %rbp
 
-	mov	%rsp, %r12
 	sub	$64, %rsp		# allocate workspace
 	and	$~15, %rsp		# align stack
 
@@ -99,10 +99,9 @@
 	xor	%rax, %rax
 	rep stosq
 
-	mov	%r12, %rsp		# deallocate workspace
-
-	pop	%r12
+	mov	%rbp, %rsp		# deallocate workspace
 	pop	%rbp
+	pop	%r12
 	pop	%rbx
 	ret
 
-- 
2.13.5
