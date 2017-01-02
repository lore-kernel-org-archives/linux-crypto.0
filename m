From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 3/3] crypto: picoxcell - Remove spacc_is_compatible() wrapper
 function
Date: Mon,  2 Jan 2017 14:06:59 -0300
Message-ID: <1483376819-26726-4-git-send-email-javier@osg.samsung.com>
References: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 linux-crypto@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

The function is used to check either the platform device ID name or the OF
node's compatible (depending how the device was registered) to know which
device type was registered.

But the driver is for a DT-only platform and so there's no need for this
level of indirection since the devices can only be registered via OF.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/crypto/picoxcell_crypto.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 539effbbfc7a..b6f14844702e 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1616,32 +1616,17 @@ static const struct of_device_id spacc_of_id_table[] = {
 MODULE_DEVICE_TABLE(of, spacc_of_id_table);
 #endif /* CONFIG_OF */
 
-static bool spacc_is_compatible(struct platform_device *pdev,
-				const char *spacc_type)
-{
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
-
-	if (platid && !strcmp(platid->name, spacc_type))
-		return true;
-
-#ifdef CONFIG_OF
-	if (of_device_is_compatible(pdev->dev.of_node, spacc_type))
-		return true;
-#endif /* CONFIG_OF */
-
-	return false;
-}
-
 static int spacc_probe(struct platform_device *pdev)
 {
 	int i, err, ret = -EINVAL;
 	struct resource *mem, *irq;
+	struct device_node *np = pdev->dev.of_node;
 	struct spacc_engine *engine = devm_kzalloc(&pdev->dev, sizeof(*engine),
 						   GFP_KERNEL);
 	if (!engine)
 		return -ENOMEM;
 
-	if (spacc_is_compatible(pdev, "picochip,spacc-ipsec")) {
+	if (of_device_is_compatible(np, "picochip,spacc-ipsec")) {
 		engine->max_ctxs	= SPACC_CRYPTO_IPSEC_MAX_CTXS;
 		engine->cipher_pg_sz	= SPACC_CRYPTO_IPSEC_CIPHER_PG_SZ;
 		engine->hash_pg_sz	= SPACC_CRYPTO_IPSEC_HASH_PG_SZ;
@@ -1650,7 +1635,7 @@ static int spacc_probe(struct platform_device *pdev)
 		engine->num_algs	= ARRAY_SIZE(ipsec_engine_algs);
 		engine->aeads		= ipsec_engine_aeads;
 		engine->num_aeads	= ARRAY_SIZE(ipsec_engine_aeads);
-	} else if (spacc_is_compatible(pdev, "picochip,spacc-l2")) {
+	} else if (of_device_is_compatible(np, "picochip,spacc-l2")) {
 		engine->max_ctxs	= SPACC_CRYPTO_L2_MAX_CTXS;
 		engine->cipher_pg_sz	= SPACC_CRYPTO_L2_CIPHER_PG_SZ;
 		engine->hash_pg_sz	= SPACC_CRYPTO_L2_HASH_PG_SZ;
-- 
2.7.4
