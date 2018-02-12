From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH 12/14] x86/crypto: aesni: Add fast path for > 16 byte update
Date: Mon, 12 Feb 2018 11:50:58 -0800
Message-ID: <20180212195058.GA61017@davejwatson-mba.local>
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

We can fast-path any < 16 byte read if the full message is > 16 bytes,
and shift over by the appropriate amount.  Usually we are
reading > 16 bytes, so this should be faster than the READ_PARTIAL
macro introduced in b20209c91e2 for the average case.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 398bd2237f..b941952 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -355,12 +355,37 @@ _zero_cipher_left_\@:
 	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
 	movdqu %xmm0, PBlockEncKey(%arg2)
 
+	cmp	$16, %arg5
+	jge _large_enough_update_\@
+
 	lea (%arg4,%r11,1), %r10
 	mov %r13, %r12
 	READ_PARTIAL_BLOCK %r10 %r12 %xmm2 %xmm1
+	jmp _data_read_\@
+
+_large_enough_update_\@:
+	sub	$16, %r11
+	add	%r13, %r11
+
+	# receive the last <16 Byte block
+	movdqu	(%arg4, %r11, 1), %xmm1
 
+	sub	%r13, %r11
+	add	$16, %r11
+
+	lea	SHIFT_MASK+16(%rip), %r12
+	# adjust the shuffle mask pointer to be able to shift 16-r13 bytes
+	# (r13 is the number of bytes in plaintext mod 16)
+	sub	%r13, %r12
+	# get the appropriate shuffle mask
+	movdqu	(%r12), %xmm2
+	# shift right 16-r13 bytes
+	PSHUFB_XMM  %xmm2, %xmm1
+
+_data_read_\@:
 	lea ALL_F+16(%rip), %r12
 	sub %r13, %r12
+
 .ifc \operation, dec
 	movdqa  %xmm1, %xmm2
 .endif
-- 
2.9.5
