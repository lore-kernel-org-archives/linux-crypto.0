From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2] lib/mpi: call cond_resched() from mpi_powm() loop
Date: Tue,  7 Nov 2017 14:15:27 -0800
Message-ID: <20171107221527.98433-1-ebiggers3@gmail.com>
Cc: Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:54612 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755829AbdKGWQV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 17:16:21 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

On a non-preemptible kernel, if KEYCTL_DH_COMPUTE is called with the
largest permitted inputs (16384 bits), the kernel spends 10+ seconds
doing modular exponentiation in mpi_powm() without rescheduling.  If all
threads do it, it locks up the system.  Moreover, it can cause
rcu_sched-stall warnings.

Notwithstanding the insanity of doing this calculation in kernel mode
rather than in userspace, fix it by calling cond_resched() as each bit
from the exponent is processed.  It's still noninterruptible, but at
least it's preemptible now.

Do the cond_resched() once per bit rather than once per MPI limb because
each limb might still easily take 100+ milliseconds on slow CPUs.

Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/mpi/mpi-pow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/mpi/mpi-pow.c b/lib/mpi/mpi-pow.c
index e24388a863a7..468fb7cd1221 100644
--- a/lib/mpi/mpi-pow.c
+++ b/lib/mpi/mpi-pow.c
@@ -26,6 +26,7 @@
  *	 however I decided to publish this code under the plain GPL.
  */
 
+#include <linux/sched.h>
 #include <linux/string.h>
 #include "mpi-internal.h"
 #include "longlong.h"
@@ -256,6 +257,7 @@ int mpi_powm(MPI res, MPI base, MPI exp, MPI mod)
 				}
 				e <<= 1;
 				c--;
+				cond_resched();
 			}
 
 			i--;
-- 
2.15.0.403.gc27cc4dac6-goog
