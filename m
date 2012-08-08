From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 5/5] crypto: talitos - add IPsec ESN support
Date: Wed, 8 Aug 2012 18:46:45 +0300
Message-ID: <1344440805-20324-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:22743
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932345Ab2HHPrI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Aug 2012 11:47:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Support for ESNs (extended sequence numbers).
Tested with strongswan on a P2020RDB back-to-back setup.
Extracted from /etc/ipsec.conf:
esp=aes-sha1-esn-modp4096!

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a57fdcd..a6c6168 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -38,6 +38,7 @@
 #include <linux/spinlock.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
@@ -1974,7 +1975,11 @@ struct talitos_alg_template {
 };
 
 static struct talitos_alg_template driver_algs[] = {
-	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
+	/*
+	 * AEAD algorithms. These use a single-pass ipsec_esp descriptor.
+	 * authencesn(*,*) is also registered, although not present
+	 * explicitly here.
+	 */
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.crypto = {
 			.cra_name = "authenc(hmac(sha1),cbc(aes))",
@@ -2968,7 +2973,9 @@ static int talitos_probe(struct platform_device *ofdev)
 		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
 			struct talitos_crypto_alg *t_alg;
 			char *name = NULL;
+			bool authenc = false;
 
+authencesn:
 			t_alg = talitos_alg_alloc(dev, &driver_algs[i]);
 			if (IS_ERR(t_alg)) {
 				err = PTR_ERR(t_alg);
@@ -2983,6 +2990,8 @@ static int talitos_probe(struct platform_device *ofdev)
 				err = crypto_register_alg(
 						&t_alg->algt.alg.crypto);
 				name = t_alg->algt.alg.crypto.cra_driver_name;
+				authenc = authenc ? !authenc :
+					  !(bool)memcmp(name, "authenc", 7);
 				break;
 			case CRYPTO_ALG_TYPE_AHASH:
 				err = crypto_register_ahash(
@@ -2995,8 +3004,25 @@ static int talitos_probe(struct platform_device *ofdev)
 				dev_err(dev, "%s alg registration failed\n",
 					name);
 				kfree(t_alg);
-			} else
+			} else {
 				list_add_tail(&t_alg->entry, &priv->alg_list);
+				if (authenc) {
+					struct crypto_alg *alg =
+						&driver_algs[i].alg.crypto;
+
+					name = alg->cra_name;
+					memmove(name + 10, name + 7,
+						strlen(name) - 7);
+					memcpy(name + 7, "esn", 3);
+
+					name = alg->cra_driver_name;
+					memmove(name + 10, name + 7,
+						strlen(name) - 7);
+					memcpy(name + 7, "esn", 3);
+
+					goto authencesn;
+				}
+			}
 		}
 	}
 	if (!list_empty(&priv->alg_list))
-- 
1.7.3.4
