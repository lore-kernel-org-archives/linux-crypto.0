From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: pcrypt - Use the online cpumask as the default
Date: Wed, 28 Mar 2012 08:51:03 +0200
Message-ID: <20120328065103.GH16191@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:49325 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab2C1GvG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Mar 2012 02:51:06 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We use the active cpumask to determine the superset of cpus
to use for parallelization. However, the active cpumask is
for internal usage of the scheduler and therefore not the
appropriate cpumask for these purposes. So use the online
cpumask instead.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 29a89da..b2c99dc 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -280,11 +280,11 @@ static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
 
 	ictx->tfm_count++;
 
-	cpu_index = ictx->tfm_count % cpumask_weight(cpu_active_mask);
+	cpu_index = ictx->tfm_count % cpumask_weight(cpu_online_mask);
 
-	ctx->cb_cpu = cpumask_first(cpu_active_mask);
+	ctx->cb_cpu = cpumask_first(cpu_online_mask);
 	for (cpu = 0; cpu < cpu_index; cpu++)
-		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_active_mask);
+		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_online_mask);
 
 	cipher = crypto_spawn_aead(crypto_instance_ctx(inst));
 
@@ -472,7 +472,7 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
 		goto err_free_padata;
 	}
 
-	cpumask_and(mask->mask, cpu_possible_mask, cpu_active_mask);
+	cpumask_and(mask->mask, cpu_possible_mask, cpu_online_mask);
 	rcu_assign_pointer(pcrypt->cb_cpumask, mask);
 
 	pcrypt->nblock.notifier_call = pcrypt_cpumask_change_notify;
-- 
1.7.0.4
