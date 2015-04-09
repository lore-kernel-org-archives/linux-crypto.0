From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3] crypto: remove instance when test failed
Date: Thu, 09 Apr 2015 09:36:03 +0200
Message-ID: <1461449.htSjBpksos@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58134 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbbDIHgH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 03:36:07 -0400
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
 crypto/algapi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f1d0307..cfca1de 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -533,6 +533,13 @@ int crypto_register_instance(struct crypto_template *tmpl,
 	if (IS_ERR(larval))
 		goto unlock;
 
+	err = -EAGAIN;
+	if (unlikely(!crypto_mod_get(&inst->alg))) {
+		up_write(&crypto_alg_sem);
+		crypto_unregister_instance(inst);
+		goto err;
+	}
+
 	hlist_add_head(&inst->list, &tmpl->instances);
 	inst->tmpl = tmpl;
 
@@ -544,8 +551,13 @@ unlock:
 		goto err;
 
 	crypto_wait_for_test(larval);
+
+	/* Remove instance if test failed */
+	if (!(inst->alg.cra_flags & CRYPTO_ALG_TESTED))
+		crypto_unregister_instance(inst);
 	err = 0;
 
+	crypto_mod_put(&inst->alg);
 err:
 	return err;
 }
-- 
2.1.0
