From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 12/12] x86/crypto: Fix RBP usage in twofish-avx-x86_64-asm_64.S
Date: Tue, 29 Aug 2017 13:05:45 -0500
Message-ID: <168e19f1ba77d5bdec3be71f04de01c9e97f27b1.1504029132.git.jpoimboe@redhat.com>
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

Use R13 instead of RBP.  Both are callee-saved registers, so the
substitution is straightforward.

Reported-by: Eric Biggers <ebiggers@google.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
index b3f49d286348..73b471da3622 100644
--- a/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-avx-x86_64-asm_64.S
@@ -76,8 +76,8 @@
 #define RT %xmm14
 #define RR %xmm15
 
-#define RID1  %rbp
-#define RID1d %ebp
+#define RID1  %r13
+#define RID1d %r13d
 #define RID2  %rsi
 #define RID2d %esi
 
@@ -259,7 +259,7 @@ __twofish_enc_blk8:
 
 	vmovdqu w(CTX), RK1;
 
-	pushq %rbp;
+	pushq %r13;
 	pushq %rbx;
 	pushq %rcx;
 
@@ -282,7 +282,7 @@ __twofish_enc_blk8:
 
 	popq %rcx;
 	popq %rbx;
-	popq %rbp;
+	popq %r13;
 
 	outunpack_blocks(RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
 	outunpack_blocks(RC2, RD2, RA2, RB2, RK1, RX0, RY0, RK2);
@@ -301,7 +301,7 @@ __twofish_dec_blk8:
 
 	vmovdqu (w+4*4)(CTX), RK1;
 
-	pushq %rbp;
+	pushq %r13;
 	pushq %rbx;
 
 	inpack_blocks(RC1, RD1, RA1, RB1, RK1, RX0, RY0, RK2);
@@ -322,7 +322,7 @@ __twofish_dec_blk8:
 	vmovdqu (w)(CTX), RK1;
 
 	popq %rbx;
-	popq %rbp;
+	popq %r13;
 
 	outunpack_blocks(RA1, RB1, RC1, RD1, RK1, RX0, RY0, RK2);
 	outunpack_blocks(RA2, RB2, RC2, RD2, RK1, RX0, RY0, RK2);
-- 
2.13.5
