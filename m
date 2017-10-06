From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 09/18] crypto: talitos - use devm_kmalloc()
Date: Fri,  6 Oct 2017 15:04:49 +0200 (CEST)
Message-ID: <f86d81a0f791cf8b5696c6fe0f084f76aaec5a8d.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Replace kmalloc() by devm_kmalloc()

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index dd6b1fc90020..2a53d0f2a869 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2993,17 +2993,11 @@ static int talitos_remove(struct platform_device *ofdev)
 			break;
 		}
 		list_del(&t_alg->entry);
-		kfree(t_alg);
 	}
 
 	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
 		talitos_unregister_rng(dev);
 
-	for (i = 0; priv->chan && i < priv->num_channels; i++)
-		kfree(priv->chan[i].fifo);
-
-	kfree(priv->chan);
-
 	for (i = 0; i < 2; i++)
 		if (priv->irq[i]) {
 			free_irq(priv->irq[i], dev);
@@ -3016,8 +3010,6 @@ static int talitos_remove(struct platform_device *ofdev)
 
 	iounmap(priv->reg);
 
-	kfree(priv);
-
 	return 0;
 }
 
@@ -3029,7 +3021,8 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	struct talitos_crypto_alg *t_alg;
 	struct crypto_alg *alg;
 
-	t_alg = kzalloc(sizeof(struct talitos_crypto_alg), GFP_KERNEL);
+	t_alg = devm_kzalloc(dev, sizeof(struct talitos_crypto_alg),
+			     GFP_KERNEL);
 	if (!t_alg)
 		return ERR_PTR(-ENOMEM);
 
@@ -3053,7 +3046,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		t_alg->algt.alg.aead.decrypt = aead_decrypt;
 		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
 		    !strncmp(alg->cra_name, "authenc(hmac(sha224)", 20)) {
-			kfree(t_alg);
+			devm_kfree(dev, t_alg);
 			return ERR_PTR(-ENOTSUPP);
 		}
 		break;
@@ -3073,7 +3066,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 
 		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
 		    !strncmp(alg->cra_name, "hmac", 4)) {
-			kfree(t_alg);
+			devm_kfree(dev, t_alg);
 			return ERR_PTR(-ENOTSUPP);
 		}
 		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
@@ -3088,7 +3081,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		break;
 	default:
 		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
-		kfree(t_alg);
+		devm_kfree(dev, t_alg);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -3169,7 +3162,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	int i, err;
 	int stride;
 
-	priv = kzalloc(sizeof(struct talitos_private), GFP_KERNEL);
+	priv = devm_kzalloc(dev, sizeof(struct talitos_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -3267,8 +3260,8 @@ static int talitos_probe(struct platform_device *ofdev)
 		}
 	}
 
-	priv->chan = kzalloc(sizeof(struct talitos_channel) *
-			     priv->num_channels, GFP_KERNEL);
+	priv->chan = devm_kzalloc(dev, sizeof(struct talitos_channel) *
+				       priv->num_channels, GFP_KERNEL);
 	if (!priv->chan) {
 		dev_err(dev, "failed to allocate channel management space\n");
 		err = -ENOMEM;
@@ -3285,8 +3278,9 @@ static int talitos_probe(struct platform_device *ofdev)
 		spin_lock_init(&priv->chan[i].head_lock);
 		spin_lock_init(&priv->chan[i].tail_lock);
 
-		priv->chan[i].fifo = kzalloc(sizeof(struct talitos_request) *
-					     priv->fifo_len, GFP_KERNEL);
+		priv->chan[i].fifo = devm_kzalloc(dev,
+						sizeof(struct talitos_request) *
+						priv->fifo_len, GFP_KERNEL);
 		if (!priv->chan[i].fifo) {
 			dev_err(dev, "failed to allocate request fifo %d\n", i);
 			err = -ENOMEM;
@@ -3352,7 +3346,7 @@ static int talitos_probe(struct platform_device *ofdev)
 			if (err) {
 				dev_err(dev, "%s alg registration failed\n",
 					alg->cra_driver_name);
-				kfree(t_alg);
+				devm_kfree(dev, t_alg);
 			} else
 				list_add_tail(&t_alg->entry, &priv->alg_list);
 		}
-- 
2.13.3
