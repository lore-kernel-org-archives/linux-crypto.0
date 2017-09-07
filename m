From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] crc32-pclmul: remove useless relative addressing
Date: Wed, 6 Sep 2017 22:41:21 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1709062236370.22191@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alexander Boyko <alexander_boyko@xyratex.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752428AbdIGCl0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Sep 2017 22:41:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In 32-bit mode, the x86 architecture can hold full 32-bit pointers.
Therefore, the code that copies the current address to the %ecx register
and uses %ecx-relative addressing is useless, we could just use absolute
addressing.

The processors have a stack of return addresses for branch prediction. If 
we use a call instruction and pop the return address, it desynchronizes 
the return stack and causes branch prediction misses.

This patch also moves the data to the .rodata section.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 arch/x86/crypto/crc32-pclmul_asm.S |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/crypto/crc32-pclmul_asm.S
===================================================================
--- linux-2.6.orig/arch/x86/crypto/crc32-pclmul_asm.S
+++ linux-2.6/arch/x86/crypto/crc32-pclmul_asm.S
@@ -41,6 +41,7 @@
 #include <asm/inst.h>
 
 
+.section .rodata
 .align 16
 /*
  * [x4*128+32 mod P(x) << 32)]'  << 1   = 0x154442bd4
@@ -111,19 +112,13 @@ ENTRY(crc32_pclmul_le_16) /* buffer and
 	pxor    CONSTANT, %xmm1
 	sub     $0x40, LEN
 	add     $0x40, BUF
-#ifndef __x86_64__
-	/* This is for position independent code(-fPIC) support for 32bit */
-	call    delta
-delta:
-	pop     %ecx
-#endif
 	cmp     $0x40, LEN
 	jb      less_64
 
 #ifdef __x86_64__
 	movdqa .Lconstant_R2R1(%rip), CONSTANT
 #else
-	movdqa .Lconstant_R2R1 - delta(%ecx), CONSTANT
+	movdqa .Lconstant_R2R1, CONSTANT
 #endif
 
 loop_64:/*  64 bytes Full cache line folding */
@@ -172,7 +167,7 @@ less_64:/*  Folding cache line into 128b
 #ifdef __x86_64__
 	movdqa  .Lconstant_R4R3(%rip), CONSTANT
 #else
-	movdqa  .Lconstant_R4R3 - delta(%ecx), CONSTANT
+	movdqa  .Lconstant_R4R3, CONSTANT
 #endif
 	prefetchnta     (BUF)
 
@@ -220,8 +215,8 @@ fold_64:
 	movdqa  .Lconstant_R5(%rip), CONSTANT
 	movdqa  .Lconstant_mask32(%rip), %xmm3
 #else
-	movdqa  .Lconstant_R5 - delta(%ecx), CONSTANT
-	movdqa  .Lconstant_mask32 - delta(%ecx), %xmm3
+	movdqa  .Lconstant_R5, CONSTANT
+	movdqa  .Lconstant_mask32, %xmm3
 #endif
 	psrldq  $0x04, %xmm2
 	pand    %xmm3, %xmm1
@@ -232,7 +227,7 @@ fold_64:
 #ifdef __x86_64__
 	movdqa  .Lconstant_RUpoly(%rip), CONSTANT
 #else
-	movdqa  .Lconstant_RUpoly - delta(%ecx), CONSTANT
+	movdqa  .Lconstant_RUpoly, CONSTANT
 #endif
 	movdqa  %xmm1, %xmm2
 	pand    %xmm3, %xmm1
