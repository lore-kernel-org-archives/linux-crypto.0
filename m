From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] lib/mpi: avoid assembler warning
Date: Fri, 26 Feb 2016 13:46:26 +0100
Message-ID: <1456490794-1034544-1-git-send-email-arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:57244 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbcBZMrV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 07:47:21 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A wrapper around the umull assembly instruction might reuse
the input register as an output, which is undefined on
some ARM machines, as pointed out by this assembler warning:

  CC      lib/mpi/generic_mpih-mul1.o
/tmp/ccxJuxIy.s: Assembler messages:
/tmp/ccxJuxIy.s:53: rdhi, rdlo and rm must all be different
  CC      lib/mpi/generic_mpih-mul2.o
/tmp/ccI0scAD.s: Assembler messages:
/tmp/ccI0scAD.s:53: rdhi, rdlo and rm must all be different
  CC      lib/mpi/generic_mpih-mul3.o
/tmp/ccMvVQcp.s: Assembler messages:
/tmp/ccMvVQcp.s:53: rdhi, rdlo and rm must all be different

This changes the constraints to force different registers to
be used as output.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 lib/mpi/longlong.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index b90e255c2a68..93336502af08 100644
--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -216,7 +216,7 @@ extern UDItype __udiv_qrnnd(UDItype *, UDItype, UDItype, UDItype);
 	__asm__ ("%@ Inlined umul_ppmm\n" \
 		"umull %r1, %r0, %r2, %r3" \
 	: "=&r" ((USItype)(xh)), \
-			"=r" ((USItype)(xl)) \
+			"=&r" ((USItype)(xl)) \
 	: "r" ((USItype)(a)), \
 			"r" ((USItype)(b)) \
 	: "r0", "r1")
-- 
2.7.0
