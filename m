From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: pcrypt - Make tfm_count an atomic_t
Date: Fri, 22 May 2015 20:34:22 +0800
Message-ID: <20150522123422.GA6000@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59728 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbbEVMe1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 08:34:27 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The variable tfm_count is accessed by multiple threads without
locking.  This patch converts it to an atomic_t.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 3942a9f..ff174b6 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -20,6 +20,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/aead.h>
+#include <linux/atomic.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -61,7 +62,7 @@ static struct kset           *pcrypt_kset;
 
 struct pcrypt_instance_ctx {
 	struct crypto_aead_spawn spawn;
-	unsigned int tfm_count;
+	atomic_t tfm_count;
 };
 
 struct pcrypt_aead_ctx {
@@ -278,9 +279,8 @@ static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
 	struct pcrypt_aead_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_aead *cipher;
 
-	ictx->tfm_count++;
-
-	cpu_index = ictx->tfm_count % cpumask_weight(cpu_online_mask);
+	cpu_index = (unsigned int)atomic_inc_return(&ictx->tfm_count) %
+		    cpumask_weight(cpu_online_mask);
 
 	ctx->cb_cpu = cpumask_first(cpu_online_mask);
 	for (cpu = 0; cpu < cpu_index; cpu++)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
