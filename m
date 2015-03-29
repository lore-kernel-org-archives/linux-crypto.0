From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: remove instance when test failed
Date: Sun, 29 Mar 2015 16:26:40 +0200
Message-ID: <1636428.jcYq32xsYj@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46794 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbbC2O0p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Mar 2015 10:26:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A cipher instance is added to the list of instances unconditionally
regardless of whether the associated test failed. However, a failed
test implies that during another lookup, the cipher instance will
be added to the list again as it will not be found by the lookup
code.

That means that the list can be filled up with instances whose tests
failed.

Note: tests only fail in reality in FIPS mode when a cipher is not
marked as fips_allowed=1. This can be seen with cmac(des3_ede) that does
not have a fips_allowed=1. When allocating the cipher, the allocation
fails with -ENOENT due to the missing fips_allowed=1 flag (which
causes the testmgr to return EINVAL). Yet, the instance of
cmac(des3_ede) is shown in /proc/crypto. Allocating the cipher again
fails again, but a 2nd instance is listed in /proc/crypto.

The patch simply de-registers the instance when the testing failed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algapi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 83b04e0..c029afe 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -545,6 +545,10 @@ unlock:
 		goto err;
 
 	crypto_wait_for_test(larval);
+
+	/* Remove instance if test failed */
+	if (!(inst->alg.cra_flags & CRYPTO_ALG_TESTED))
+		crypto_unregister_instance((void *)inst);
 	err = 0;
 
 err:
-- 
2.1.0
