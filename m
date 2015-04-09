From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v4] crypto: remove instance when test failed
Date: Thu, 09 Apr 2015 12:09:55 +0200
Message-ID: <4399727.C1fCR46vxf@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
 crypto/algapi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f1d0307..1907d5b 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -522,7 +522,10 @@ int crypto_register_instance(struct crypto_template *tmpl,
 
 	err = crypto_check_alg(&inst->alg);
 	if (err)
-		goto err;
+		return err;
+
+	if (unlikely(!crypto_mod_get(&inst->alg)))
+		return -EAGAIN;
 
 	inst->alg.cra_module = tmpl->module;
 	inst->alg.cra_flags |= CRYPTO_ALG_INSTANCE;
@@ -544,9 +547,14 @@ unlock:
 		goto err;
 
 	crypto_wait_for_test(larval);
+
+	/* Remove instance if test failed */
+	if (!(inst->alg.cra_flags & CRYPTO_ALG_TESTED))
+		crypto_unregister_instance(inst);
 	err = 0;
 
 err:
+	crypto_mod_put(&inst->alg);
 	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_register_instance);
-- 
2.1.0
