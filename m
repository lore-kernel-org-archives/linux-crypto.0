From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH 03/14] x86/crypto: aesni: Add GCM_INIT macro
Date: Mon, 12 Feb 2018 11:48:33 -0800
Message-ID: <20180212194833.GA60642@davejwatson-mba.local>
References: <cover.1518211765.git.davejwatson@fb.com>
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
In-Reply-To: <cover.1518211765.git.davejwatson@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Reduce code duplication by introducting GCM_INIT macro.  This macro
will also be exposed as a function for implementing scatter/gather
support, since INIT only needs to be called once for the full
operation.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 84 +++++++++++++++------------------------
 1 file changed, 33 insertions(+), 51 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 39b42b1..b9fe2ab 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -191,6 +191,37 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	pop	%r12
 .endm
 
+
+# GCM_INIT initializes a gcm_context struct to prepare for encoding/decoding.
+# Clobbers rax, r10-r13 and xmm0-xmm6, %xmm13
+.macro GCM_INIT
+	mov	%arg6, %r12
+	movdqu	(%r12), %xmm13
+	movdqa  SHUF_MASK(%rip), %xmm2
+	PSHUFB_XMM %xmm2, %xmm13
+
+	# precompute HashKey<<1 mod poly from the HashKey (required for GHASH)
+
+	movdqa	%xmm13, %xmm2
+	psllq	$1, %xmm13
+	psrlq	$63, %xmm2
+	movdqa	%xmm2, %xmm1
+	pslldq	$8, %xmm2
+	psrldq	$8, %xmm1
+	por	%xmm2, %xmm13
+
+	# reduce HashKey<<1
+
+	pshufd	$0x24, %xmm1, %xmm2
+	pcmpeqd TWOONE(%rip), %xmm2
+	pand	POLY(%rip), %xmm2
+	pxor	%xmm2, %xmm13
+	movdqa	%xmm13, HashKey(%rsp)
+	mov	%arg4, %r13			# %xmm13 holds HashKey<<1 (mod poly)
+	and	$-16, %r13
+	mov	%r13, %r12
+.endm
+
 #ifdef __x86_64__
 /* GHASH_MUL MACRO to implement: Data*HashKey mod (128,127,126,121,0)
 *
@@ -1151,36 +1182,11 @@ _esb_loop_\@:
 *****************************************************************************/
 ENTRY(aesni_gcm_dec)
 	FUNC_SAVE
-	mov	%arg6, %r12
-	movdqu	(%r12), %xmm13			  # %xmm13 = HashKey
-        movdqa  SHUF_MASK(%rip), %xmm2
-	PSHUFB_XMM %xmm2, %xmm13
-
-
-# Precompute HashKey<<1 (mod poly) from the hash key (required for GHASH)
-
-	movdqa	%xmm13, %xmm2
-	psllq	$1, %xmm13
-	psrlq	$63, %xmm2
-	movdqa	%xmm2, %xmm1
-	pslldq	$8, %xmm2
-	psrldq	$8, %xmm1
-	por	%xmm2, %xmm13
-
-        # Reduction
-
-	pshufd	$0x24, %xmm1, %xmm2
-	pcmpeqd TWOONE(%rip), %xmm2
-	pand	POLY(%rip), %xmm2
-	pxor	%xmm2, %xmm13     # %xmm13 holds the HashKey<<1 (mod poly)
 
+	GCM_INIT
 
         # Decrypt first few blocks
 
-	movdqa %xmm13, HashKey(%rsp)           # store HashKey<<1 (mod poly)
-	mov %arg4, %r13    # save the number of bytes of plaintext/ciphertext
-	and $-16, %r13                      # %r13 = %r13 - (%r13 mod 16)
-	mov %r13, %r12
 	and $(3<<4), %r12
 	jz _initial_num_blocks_is_0_decrypt
 	cmp $(2<<4), %r12
@@ -1402,32 +1408,8 @@ ENDPROC(aesni_gcm_dec)
 ***************************************************************************/
 ENTRY(aesni_gcm_enc)
 	FUNC_SAVE
-	mov	%arg6, %r12
-	movdqu	(%r12), %xmm13
-        movdqa  SHUF_MASK(%rip), %xmm2
-	PSHUFB_XMM %xmm2, %xmm13
-
-# precompute HashKey<<1 mod poly from the HashKey (required for GHASH)
-
-	movdqa	%xmm13, %xmm2
-	psllq	$1, %xmm13
-	psrlq	$63, %xmm2
-	movdqa	%xmm2, %xmm1
-	pslldq	$8, %xmm2
-	psrldq	$8, %xmm1
-	por	%xmm2, %xmm13
-
-        # reduce HashKey<<1
-
-	pshufd	$0x24, %xmm1, %xmm2
-	pcmpeqd TWOONE(%rip), %xmm2
-	pand	POLY(%rip), %xmm2
-	pxor	%xmm2, %xmm13
-	movdqa	%xmm13, HashKey(%rsp)
-	mov	%arg4, %r13            # %xmm13 holds HashKey<<1 (mod poly)
-	and	$-16, %r13
-	mov	%r13, %r12
 
+	GCM_INIT
         # Encrypt first few blocks
 
 	and	$(3<<4), %r12
-- 
2.9.5
