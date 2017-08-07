From: Stefan Agner <stefan@agner.ch>
Subject: [PATCH RESEND] lib/mpi: fix build with clang
Date: Mon,  7 Aug 2017 10:31:20 -0700
Message-ID: <20170807173120.15463-1-stefan@agner.ch>
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kmu-office.ch ([178.209.48.109]:38443 "EHLO
        mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbdHGRbe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Aug 2017 13:31:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use just @ to denote comments which works with gcc and clang.
Otherwise clang reports an escape sequence error:
  error: invalid % escape in inline assembly string

Use %0-%3 as operand references, this avoids:
  error: invalid operand in inline asm: 'umull ${1:r}, ${0:r}, ${2:r}, ${3:r}'

Also remove superfluous casts on output operands to avoid warnings
such as:
  warning: invalid use of a cast in an inline asm context requiring an l-value

Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
I checked the output of gcc with -S switch before and after this change,
gcc generated the same assembly.

Resend this time with linux-crypto ML.

--
Stefan

 lib/mpi/longlong.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index 93336502af08..57fd45ab7af1 100644
--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -176,8 +176,8 @@ extern UDItype __udiv_qrnnd(UDItype *, UDItype, UDItype, UDItype);
 #define add_ssaaaa(sh, sl, ah, al, bh, bl) \
 	__asm__ ("adds %1, %4, %5\n" \
 		"adc  %0, %2, %3" \
-	: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+	: "=r" (sh), \
+		"=&r" (sl) \
 	: "%r" ((USItype)(ah)), \
 		"rI" ((USItype)(bh)), \
 		"%r" ((USItype)(al)), \
@@ -185,15 +185,15 @@ extern UDItype __udiv_qrnnd(UDItype *, UDItype, UDItype, UDItype);
 #define sub_ddmmss(sh, sl, ah, al, bh, bl) \
 	__asm__ ("subs %1, %4, %5\n" \
 		"sbc  %0, %2, %3" \
-	: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+	: "=r" (sh), \
+		"=&r" (sl) \
 	: "r" ((USItype)(ah)), \
 		"rI" ((USItype)(bh)), \
 		"r" ((USItype)(al)), \
 		"rI" ((USItype)(bl)))
 #if defined __ARM_ARCH_2__ || defined __ARM_ARCH_3__
 #define umul_ppmm(xh, xl, a, b) \
-	__asm__ ("%@ Inlined umul_ppmm\n" \
+	__asm__ ("@ Inlined umul_ppmm\n" \
 		"mov	%|r0, %2, lsr #16		@ AAAA\n" \
 		"mov	%|r2, %3, lsr #16		@ BBBB\n" \
 		"bic	%|r1, %2, %|r0, lsl #16		@ aaaa\n" \
@@ -206,19 +206,19 @@ extern UDItype __udiv_qrnnd(UDItype *, UDItype, UDItype, UDItype);
 		"addcs	%|r2, %|r2, #65536\n" \
 		"adds	%1, %|r1, %|r0, lsl #16\n" \
 		"adc	%0, %|r2, %|r0, lsr #16" \
-	: "=&r" ((USItype)(xh)), \
-		"=r" ((USItype)(xl)) \
+	: "=&r" (xh), \
+		"=r" (xl) \
 	: "r" ((USItype)(a)), \
 		"r" ((USItype)(b)) \
 	: "r0", "r1", "r2")
 #else
 #define umul_ppmm(xh, xl, a, b) \
-	__asm__ ("%@ Inlined umul_ppmm\n" \
-		"umull %r1, %r0, %r2, %r3" \
-	: "=&r" ((USItype)(xh)), \
-			"=&r" ((USItype)(xl)) \
+	__asm__ ("@ Inlined umul_ppmm\n" \
+		"umull %1, %0, %2, %3" \
+	: "=&r" (xh), \
+		"=&r" (xl) \
 	: "r" ((USItype)(a)), \
-			"r" ((USItype)(b)) \
+		"r" ((USItype)(b)) \
 	: "r0", "r1")
 #endif
 #define UMUL_TIME 20
-- 
2.12.2
