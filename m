From: Dave Watson <davejwatson@fb.com>
Subject: [PATCH v2 09/14] x86/crypto: aesni: Move ghash_mul to GCM_COMPLETE
Date: Wed, 14 Feb 2018 09:39:55 -0800
Message-ID: <20180214173955.GA62088@davejwatson-mba>
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

Prepare to handle partial blocks between scatter/gather calls.
For the last partial block, we only want to calculate the aadhash
in GCM_COMPLETE, and a new partial block macro will handle both
aadhash update and encrypting partial blocks between calls.

Signed-off-by: Dave Watson <davejwatson@fb.com>
---
 arch/x86/crypto/aesni-intel_asm.S | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index aa82493..37b1cee 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -345,7 +345,6 @@ _zero_cipher_left_\@:
 	pxor	%xmm0, %xmm8
 .endif
 
-	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
 	movdqu %xmm8, AadHash(%arg2)
 .ifc \operation, enc
 	# GHASH computation for the last <16 byte block
@@ -378,6 +377,15 @@ _multiple_of_16_bytes_\@:
 .macro GCM_COMPLETE
 	movdqu AadHash(%arg2), %xmm8
 	movdqu HashKey(%rsp), %xmm13
+
+	mov PBlockLen(%arg2), %r12
+
+	cmp $0, %r12
+	je _partial_done\@
+
+	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
+
+_partial_done\@:
 	mov AadLen(%arg2), %r12  # %r13 = aadLen (number of bytes)
 	shl	$3, %r12		  # convert into number of bits
 	movd	%r12d, %xmm15		  # len(A) in %xmm15
-- 
2.9.5
