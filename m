From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Sun, 1 Nov 2009 12:50:43 -0500
Message-ID: <20091101175043.GA25257@gondor.apana.org.au>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com> <20091019025332.GA26624@gondor.apana.org.au> <20091031173015.69e8e9f8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Daniel Walker <dwalker@fifo99.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36618 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752974AbZKARuq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Nov 2009 12:50:46 -0500
Content-Disposition: inline
In-Reply-To: <20091031173015.69e8e9f8.akpm@linux-foundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 31, 2009 at 05:30:15PM -0700, Andrew Morton wrote:
> 
> x86_64 allmodconfig, GNU assembler 2.16.1:
> 
> arch/x86/crypto/ghash-clmulni-intel_asm.S: Assembler messages:
> arch/x86/crypto/ghash-clmulni-intel_asm.S:103: Error: no such instruction: `pshufb %xmm5,%xmm0'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:105: Error: no such instruction: `pshufb %xmm5,%xmm0'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:119: Error: no such instruction: `pshufb %xmm5,%xmm0'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:123: Error: no such instruction: `pshufb %xmm5,%xmm6'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:130: Error: no such instruction: `pshufb %xmm5,%xmm0'
> arch/x86/crypto/ghash-clmulni-intel_asm.S:143: Error: no such instruction: `pshufb %xmm5,%xmm0'

This patch should fix it.

commit 2d06ef7f42ed8c9969c9aa84e95df5d5c6378327
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Nov 1 12:49:44 2009 -0500

    crypto: ghash-intel - Hard-code pshufb
    
    Old gases don't have a clue what pshufb stands for so we have
    to hard-code it for now.
    
    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index b9e787a..71768d5 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -100,9 +100,11 @@ ENTRY(clmul_ghash_mul)
 	movups (%rdi), DATA
 	movups (%rsi), SHASH
 	movaps .Lbswap_mask, BSWAP
-	pshufb BSWAP, DATA
+	# pshufb BSWAP, DATA
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 	call __clmul_gf128mul_ble
-	pshufb BSWAP, DATA
+	# pshufb BSWAP, DATA
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 	movups DATA, (%rdi)
 	ret
 
@@ -116,18 +118,21 @@ ENTRY(clmul_ghash_update)
 	movaps .Lbswap_mask, BSWAP
 	movups (%rdi), DATA
 	movups (%rcx), SHASH
-	pshufb BSWAP, DATA
+	# pshufb BSWAP, DATA
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 .align 4
 .Lupdate_loop:
 	movups (%rsi), IN1
-	pshufb BSWAP, IN1
+	# pshufb BSWAP, IN1
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xf5
 	pxor IN1, DATA
 	call __clmul_gf128mul_ble
 	sub $16, %rdx
 	add $16, %rsi
 	cmp $16, %rdx
 	jge .Lupdate_loop
-	pshufb BSWAP, DATA
+	# pshufb BSWAP, DATA
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
 	ret
@@ -140,7 +145,8 @@ ENTRY(clmul_ghash_update)
 ENTRY(clmul_ghash_setkey)
 	movaps .Lbswap_mask, BSWAP
 	movups (%rsi), %xmm0
-	pshufb BSWAP, %xmm0
+	# pshufb BSWAP, %xmm0
+	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
 	movaps %xmm0, %xmm1
 	psllq $1, %xmm0
 	psrlq $63, %xmm1
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
