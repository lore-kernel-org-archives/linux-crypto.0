From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: jitterentropy - remove timekeeping_valid_for_hres
Date: Wed, 27 May 2015 13:50:12 +0200
Message-ID: <5175461.r5Ln1vVEmU@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58331 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbbE0LuT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 07:50:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patch removes the use of timekeeping_valid_for_hres which is now
marked as internal for the time keeping subsystem. The jitterentropy
does not really require this verification as a coarse timer (when
random_get_entropy is absent) is discovered by the initialization test
of jent_entropy_init, which would cause the jitter rng to not load in
that case.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 1ebe58a..a60147e 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -131,9 +131,6 @@ static inline void jent_get_nstime(__u64 *out)
 	 * and are registered with clocksource_register()
 	 */
 	if ((0 == tmp) &&
-#ifndef MODULE
-	   (0 == timekeeping_valid_for_hres()) &&
-#endif
 	   (0 == __getnstimeofday(&ts))) {
 		tmp = ts.tv_sec;
 		tmp = tmp << 32;
-- 
2.1.0
