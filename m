From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] MPILIB: avoid assembler warning
Date: Wed, 28 Jan 2015 17:24:36 +0100
Message-ID: <16372019.BFlLRod3Eu@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
 David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

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

Signed-off-by: Arnd Bergmann <arnd@arnd.de>
---
Not sure who would be the best person to pick this patch up.

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index aac511417ad1..c4dbdb506174 100644
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
