From: Huang Ying <ying.huang@intel.com>
Subject: [PATCH 2/2] x86, crypto, Use gas macro for PCLMULQDQ-NI and PSHUFB
Date: Tue, 10 Nov 2009 15:44:01 +0800
Message-ID: <1257839041.22519.2523.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29342 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZKJHoD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Nov 2009 02:44:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Old binutils do not support PCLMULQDQ-NI and PSHUFB, to make kernel
can be compiled by them, .byte code is used instead of assembly
instructions. But the readability and flexibility of raw .byte code is
not good.

So corresponding assembly instruction like gas macro is used instead.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/crypto/ghash-clmulni-intel_asm.S |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -17,7 +17,7 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/i387.h>
+#include <asm/inst.h>
 
 .align 16
 .Lbswap_mask:
@@ -56,12 +56,9 @@ __clmul_gf128mul_ble:
 	pxor DATA, T2
 	pxor SHASH, T3
 
-	# pclmulqdq $0x00, SHASH, DATA	# DATA = a0 * b0
-	.byte 0x66, 0x0f, 0x3a, 0x44, 0xc1, 0x00
-	# pclmulqdq $0x11, SHASH, T1	# T1 = a1 * b1
-	.byte 0x66, 0x0f, 0x3a, 0x44, 0xd1, 0x11
-	# pclmulqdq $0x00, T3, T2	# T2 = (a1 + a0) * (b1 + b0)
-	.byte 0x66, 0x0f, 0x3a, 0x44, 0xdc, 0x00
+	PCLMULQDQ 0x00 SHASH DATA	# DATA = a0 * b0
+	PCLMULQDQ 0x11 SHASH T1		# T1 = a1 * b1
+	PCLMULQDQ 0x00 T3 T2		# T2 = (a1 + a0) * (b1 + b0)
 	pxor DATA, T2
 	pxor T1, T2			# T2 = a0 * b1 + a1 * b0
 
@@ -101,11 +98,9 @@ ENTRY(clmul_ghash_mul)
 	movups (%rdi), DATA
 	movups (%rsi), SHASH
 	movaps .Lbswap_mask, BSWAP
-	# pshufb BSWAP, DATA
-	PSHUFB_XMM5_XMM0
+	PSHUFB_XMM BSWAP DATA
 	call __clmul_gf128mul_ble
-	# pshufb BSWAP, DATA
-	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
+	PSHUFB_XMM BSWAP DATA
 	movups DATA, (%rdi)
 	ret
 
@@ -119,21 +114,18 @@ ENTRY(clmul_ghash_update)
 	movaps .Lbswap_mask, BSWAP
 	movups (%rdi), DATA
 	movups (%rcx), SHASH
-	# pshufb BSWAP, DATA
-	PSHUFB_XMM5_XMM0
+	PSHUFB_XMM BSWAP DATA
 .align 4
 .Lupdate_loop:
 	movups (%rsi), IN1
-	# pshufb BSWAP, IN1
-	PSHUFB_XMM5_XMM6
+	PSHUFB_XMM BSWAP IN1
 	pxor IN1, DATA
 	call __clmul_gf128mul_ble
 	sub $16, %rdx
 	add $16, %rsi
 	cmp $16, %rdx
 	jge .Lupdate_loop
-	# pshufb BSWAP, DATA
-	PSHUFB_XMM5_XMM0
+	PSHUFB_XMM BSWAP DATA
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
 	ret
@@ -146,8 +138,7 @@ ENTRY(clmul_ghash_update)
 ENTRY(clmul_ghash_setkey)
 	movaps .Lbswap_mask, BSWAP
 	movups (%rsi), %xmm0
-	# pshufb BSWAP, %xmm0
-	PSHUFB_XMM5_XMM0
+	PSHUFB_XMM BSWAP %xmm0
 	movaps %xmm0, %xmm1
 	psllq $1, %xmm0
 	psrlq $63, %xmm1


