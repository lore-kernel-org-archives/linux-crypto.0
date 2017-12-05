From: James Hogan <james.hogan@mips.com>
Subject: [PATCH] lib/mpi: Fix umul_ppmm() for MIPS64r6
Date: Tue, 5 Dec 2017 23:31:35 +0000
Message-ID: <20171205233135.1763-1-james.hogan@mips.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: James Hogan <jhogan@kernel.org>, <linux-mips@linux-mips.org>,
        <linux-crypto@vger.kernel.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.154.211]:32773 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752894AbdLEXqr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 18:46:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: James Hogan <jhogan@kernel.org>

Current MIPS64r6 toolchains aren't able to generate efficient
DMULU/DMUHU based code for the C implementation of umul_ppmm(), which
performs an unsigned 64 x 64 bit multiply and returns the upper and
lower 64-bit halves of the 128-bit result. Instead it widens the 64-bit
inputs to 128-bits and emits a __multi3 intrinsic call to perform a 128
x 128 multiply. This is both inefficient, and it results in a link error
since we don't include __multi3 in MIPS linux.

For example commit 90a53e4432b1 ("cfg80211: implement regdb signature
checking") merged in v4.15-rc1 recently broke the 64r6_defconfig and
64r6el_defconfig builds by indirectly selecting MPILIB. The same build
errors can be reproduced on older kernels by enabling e.g. CRYPTO_RSA:

lib/mpi/generic_mpih-mul1.o: In function `mpihelp_mul_1':
lib/mpi/generic_mpih-mul1.c:50: undefined reference to `__multi3'
lib/mpi/generic_mpih-mul2.o: In function `mpihelp_addmul_1':
lib/mpi/generic_mpih-mul2.c:49: undefined reference to `__multi3'
lib/mpi/generic_mpih-mul3.o: In function `mpihelp_submul_1':
lib/mpi/generic_mpih-mul3.c:49: undefined reference to `__multi3'
lib/mpi/mpih-div.o In function `mpihelp_divrem':
lib/mpi/mpih-div.c:205: undefined reference to `__multi3'
lib/mpi/mpih-div.c:142: undefined reference to `__multi3'

Therefore add an efficient MIPS64r6 implementation of umul_ppmm() using
inline assembly and the DMULU/DMUHU instructions, to prevent __multi3
calls being emitted.

Fixes: 7fd08ca58ae6 ("MIPS: Add build support for the MIPS R6 ISA")
Signed-off-by: James Hogan <jhogan@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-mips@linux-mips.org
Cc: linux-crypto@vger.kernel.org
---
Please can somebody apply this fix for v4.15, as the MIPS 64r6_defconfig
and 64r6el_defconfig builds are broken without it.
---
 lib/mpi/longlong.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index 57fd45ab7af1..08c60d10747f 100644
--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -671,7 +671,23 @@ do {						\
 	**************  MIPS/64  **************
 	***************************************/
 #if (defined(__mips) && __mips >= 3) && W_TYPE_SIZE == 64
-#if (__GNUC__ >= 5) || (__GNUC__ >= 4 && __GNUC_MINOR__ >= 4)
+#if defined(__mips_isa_rev) && __mips_isa_rev >= 6
+/*
+ * GCC ends up emitting a __multi3 intrinsic call for MIPS64r6 with the plain C
+ * code below, so we special case MIPS64r6 until the compiler can do better.
+ */
+#define umul_ppmm(w1, w0, u, v)						\
+do {									\
+	__asm__ ("dmulu %0,%1,%2"					\
+		 : "=d" ((UDItype)(w0))					\
+		 : "d" ((UDItype)(u)),					\
+		   "d" ((UDItype)(v)));					\
+	__asm__ ("dmuhu %0,%1,%2"					\
+		 : "=d" ((UDItype)(w1))					\
+		 : "d" ((UDItype)(u)),					\
+		   "d" ((UDItype)(v)));					\
+} while (0)
+#elif (__GNUC__ >= 5) || (__GNUC__ >= 4 && __GNUC_MINOR__ >= 4)
 #define umul_ppmm(w1, w0, u, v) \
 do {									\
 	typedef unsigned int __ll_UTItype __attribute__((mode(TI)));	\
-- 
2.14.1
