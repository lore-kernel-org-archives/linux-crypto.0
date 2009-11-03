From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Date: Tue, 3 Nov 2009 09:12:34 -0500
Message-ID: <20091103141234.GA8609@gondor.apana.org.au>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com> <20091019025332.GA26624@gondor.apana.org.au> <20091031173015.69e8e9f8.akpm@linux-foundation.org> <20091101175043.GA25257@gondor.apana.org.au> <20091102075039.GA15942@elte.hu> <20091102142824.GA31981@gondor.apana.org.au> <20091102143258.GA23776@elte.hu> <20091102144621.GA32164@gondor.apana.org.au> <20091102154604.GA26453@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Daniel Walker <dwalker@fifo99.com>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56562 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751426AbZKCOMv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Nov 2009 09:12:51 -0500
Content-Disposition: inline
In-Reply-To: <20091102154604.GA26453@elte.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 02, 2009 at 04:46:04PM +0100, Ingo Molnar wrote:
> 
> Yeah. Or just a single block of:
> 
> 
>   #ifndef __ASSEMBLY__
>   ...
>   #endif /* __ASSEMBLY__ */
> 
> around the C bits - anything outside that is good for assembly as well. 

OK I'll throw this into cryptodev:

commit 3b0d65969b549b796abc6f0230f6142fed365d49
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Nov 3 09:11:15 2009 -0500

    crypto: ghash-intel - Add PSHUFB macros
    
    Add PSHUFB macros instead of repeating byte sequences, suggested
    by Ingo.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index 71768d5..5958498 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -17,6 +17,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/i387.h>
 
 .align 16
 .Lbswap_mask:
@@ -101,7 +102,7 @@ ENTRY(clmul_ghash_mul)
 	movups (%rsi), SHASH
 	movaps .Lbswap_mask, BSWAP
 	# pshufb BSWAP, DATA
-	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
+	PSHUFB_XMM5_XMM0
 	call __clmul_gf128mul_ble
 	# pshufb BSWAP, DATA
 	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
@@ -119,12 +120,12 @@ ENTRY(clmul_ghash_update)
 	movups (%rdi), DATA
 	movups (%rcx), SHASH
 	# pshufb BSWAP, DATA
-	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
+	PSHUFB_XMM5_XMM0
 .align 4
 .Lupdate_loop:
 	movups (%rsi), IN1
 	# pshufb BSWAP, IN1
-	.byte 0x66, 0x0f, 0x38, 0x00, 0xf5
+	PSHUFB_XMM5_XMM6
 	pxor IN1, DATA
 	call __clmul_gf128mul_ble
 	sub $16, %rdx
@@ -132,7 +133,7 @@ ENTRY(clmul_ghash_update)
 	cmp $16, %rdx
 	jge .Lupdate_loop
 	# pshufb BSWAP, DATA
-	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
+	PSHUFB_XMM5_XMM0
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
 	ret
@@ -146,7 +147,7 @@ ENTRY(clmul_ghash_setkey)
 	movaps .Lbswap_mask, BSWAP
 	movups (%rsi), %xmm0
 	# pshufb BSWAP, %xmm0
-	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5
+	PSHUFB_XMM5_XMM0
 	movaps %xmm0, %xmm1
 	psllq $1, %xmm0
 	psrlq $63, %xmm1
diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 0b20bbb..ebfb8a9 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -10,6 +10,8 @@
 #ifndef _ASM_X86_I387_H
 #define _ASM_X86_I387_H
 
+#ifndef __ASSEMBLY__
+
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
 #include <linux/regset.h>
@@ -411,4 +413,9 @@ static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 	}
 }
 
+#endif /* __ASSEMBLY__ */
+
+#define PSHUFB_XMM5_XMM0 .byte 0x66, 0x0f, 0x38, 0x00, 0xc5
+#define PSHUFB_XMM5_XMM6 .byte 0x66, 0x0f, 0x38, 0x00, 0xf5
+
 #endif /* _ASM_X86_I387_H */

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
