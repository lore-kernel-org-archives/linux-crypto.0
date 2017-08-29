From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 06/12] x86/crypto: Fix RBP usage in sha1_avx2_x86_64_asm.S
Date: Tue, 29 Aug 2017 13:05:39 -0500
Message-ID: <12db8df183584a6c605d233c22b1ca0a19e08c56.1504029132.git.jpoimboe@redhat.com>
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

Use R11 instead of RBP.  Since R11 isn't a callee-saved register, it
doesn't need to be saved and restored on the stack.

Reported-by: Eric Biggers <ebiggers@google.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/sha1_avx2_x86_64_asm.S | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
index 1eab79c9ac48..9f712a7dfd79 100644
--- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
+++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
@@ -89,7 +89,7 @@
 #define	REG_RE	%rdx
 #define	REG_RTA	%r12
 #define	REG_RTB	%rbx
-#define	REG_T1	%ebp
+#define	REG_T1	%r11d
 #define	xmm_mov	vmovups
 #define	avx2_zeroupper	vzeroupper
 #define	RND_F1	1
@@ -637,7 +637,6 @@ _loop3:
 	ENTRY(\name)
 
 	push	%rbx
-	push	%rbp
 	push	%r12
 	push	%r13
 	push	%r14
@@ -673,7 +672,6 @@ _loop3:
 	pop	%r14
 	pop	%r13
 	pop	%r12
-	pop	%rbp
 	pop	%rbx
 
 	ret
-- 
2.13.5
