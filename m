From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 02/16] crypto: Add a flag to identify crypto instances
Date: Thu, 11 Aug 2011 13:27:16 +0200
Message-ID: <20110811112716.GF16877@secunet.com>
References: <20110811112603.GD16877@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:44048 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab1HKL0p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2011 07:26:45 -0400
Content-Disposition: inline
In-Reply-To: <20110811112603.GD16877@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The upcomming crypto user configuration api needs to identify
crypto instances. This patch adds a flag that is set if the
algorithm is an instance that is build from templates.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/algapi.c        |    1 +
 include/linux/crypto.h |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index c3cf1a6..6fd9bcf 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -493,6 +493,7 @@ int crypto_register_instance(struct crypto_template *tmpl,
 		goto err;
 
 	inst->alg.cra_module = tmpl->module;
+	inst->alg.cra_flags |= CRYPTO_ALG_INSTANCE;
 
 	down_write(&crypto_alg_sem);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e5e468e..cba4d63 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -72,6 +72,11 @@
 #define CRYPTO_ALG_TESTED		0x00000400
 
 /*
+ * Set if the algorithm is an instance that is build from telplates.
+ */
+#define CRYPTO_ALG_INSTANCE		0x00000800
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
-- 
1.7.0.4
