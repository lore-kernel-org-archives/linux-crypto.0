From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 22/25] crypto: ansi_cprng - Tweak comments
Date: Sun,  7 Dec 2014 07:26:30 -0500
Message-ID: <7d3afdf56eb85b9e06586a97bad963f4f24c3030.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:16236 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753201AbaLGM1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:07 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's not based on the NIST-recommended algorithm, it *is* the
NIST-recommended algorithm, and has even passed their validation
tests.

Also make clear that it's intended to be a determinsitic generator,
despite the confusing name of the DT vector.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index f3e280c4..9c8475a2 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -1,7 +1,9 @@
 /*
- * PRNG: Pseudo Random Number Generator
- *       Based on NIST Recommended PRNG From ANSI X9.31 Appendix A.2.4 using
- *       AES 128 cipher
+ * PRNG: This is the "NIST-Recommended Random Number Generator Based
+ *	 on ANSI X9.31 Appendix A.2.4" using the AES 128 cipher.
+ *	 Many specific kernel snapshots have collected validations from
+ *	 the NIST RNG Validation System; results are available at
+ *	 http://csrc.nist.gov/groups/STM/cavp/documents/rng/rngval.html
  *
  *  (C) Neil Horman <nhorman@tuxdriver.com>
  *
@@ -9,8 +11,6 @@
  *  under the terms of the GNU General Public License as published by the
  *  Free Software Foundation; either version 2 of the License, or (at your
  *  any later version.
- *
- *
  */
 
 #include <crypto/internal/rng.h>
@@ -36,7 +36,12 @@
  * Note: DT is our counter value
  *	 V is our seed vector
  * See http://csrc.nist.gov/groups/STM/cavp/documents/rng/931rngext.pdf
- * for implementation details
+ * for implementation details.
+ *
+ * Note that even though DT stands for "date/time", since this is a
+ * deterministic pseudo-random generator, it is a determinsitic counter,
+ * not a timestamp.  Its function is not to inject seed entropy, but to
+ * ensure a long period in the output.
  */
 struct prng_context {
 	spinlock_t prng_lock;
-- 
2.1.3
