From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH v2 02/14] x86/crypto: aesni: Macro-ify func save/restore
Date: Wed, 14 Feb 2018 09:38:35 -0800
Message-ID: <20180214173835.GA61851@davejwatson-mba>
References: <cover.1518628278.git.davejwatson@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        <linux-kernel@vger.kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Junaid Shahid <junaids@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1518628278.git.davejwatson@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Macro-ify function save and restore.  These will be used in new functions
added for scatter/gather update operations.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 53 ++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 48911fe..39b42b1 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -170,6 +170,26 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 #define TKEYP	T1
 #endif
 
+.macro FUNC_SAVE
+	push	%r12
+	push	%r13
+	push	%r14
+	mov	%rsp, %r14
+#
+# states of %xmm registers %xmm6:%xmm15 not saved
+# all %xmm registers are clobbered
+#
+	sub	$VARIABLE_OFFSET, %rsp
+	and	$~63, %rsp
+.endm
+
+
+.macro FUNC_RESTORE
+	mov	%r14, %rsp
+	pop	%r14
+	pop	%r13
+	pop	%r12
+.endm
 
 #ifdef __x86_64__
 /* GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
@@ -1130,16 +1150,7 @@ _esb_loop_\@:
 *
 *****************************************************************************/
 ENTRY(aesni_gcm_dec)
-	push	%r12
-	push	%r13
-	push	%r14
-	mov	%rsp, %r14
-/*
-* states of %xmm registers %xmm6:%xmm15 not saved
-* all %xmm registers are clobbered
-*/
-	sub	$VARIABLE_OFFSET, %rsp
-	and	$~63, %rsp                        # align rsp to 64 bytes
+	FUNC_SAVE
 	mov	%arg6, %r12
 	movdqu	(%r12), %xmm13			  # %xmm13 = HashKey
         movdqa  SHUF_MASK(%rip), %xmm2
@@ -1309,10 +1320,7 @@ _T_1_decrypt:
 _T_16_decrypt:
 	movdqu	%xmm0, (%r10)
 _return_T_done_decrypt:
-	mov	%r14, %rsp
-	pop	%r14
-	pop	%r13
-	pop	%r12
+	FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_dec)
 
@@ -1393,22 +1401,12 @@ ENDPROC(aesni_gcm_dec)
 * poly = x^128 + x^127 + x^126 + x^121 + 1
 ***************************************************************************/
 ENTRY(aesni_gcm_enc)
-	push	%r12
-	push	%r13
-	push	%r14
-	mov	%rsp, %r14
-#
-# states of %xmm registers %xmm6:%xmm15 not saved
-# all %xmm registers are clobbered
-#
-	sub	$VARIABLE_OFFSET, %rsp
-	and	$~63, %rsp
+	FUNC_SAVE
 	mov	%arg6, %r12
 	movdqu	(%r12), %xmm13
         movdqa  SHUF_MASK(%rip), %xmm2
 	PSHUFB_XMM %xmm2, %xmm13
 
-
 # precompute HashKey<<1 mod poly from the HashKey (required for GHASH)
 
 	movdqa	%xmm13, %xmm2
@@ -1576,10 +1574,7 @@ _T_1_encrypt:
 _T_16_encrypt:
 	movdqu	%xmm0, (%r10)
 _return_T_done_encrypt:
-	mov	%r14, %rsp
-	pop	%r14
-	pop	%r13
-	pop	%r12
+	FUNC_RESTORE
 	ret
 ENDPROC(aesni_gcm_enc)
 
-- 
2.9.5
