From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3 09/17] crypto: talitos - Add a feature to tag SEC1
Date: Fri, 17 Apr 2015 16:32:05 +0200 (CEST)
Message-ID: <20150417143205.9D8171A242C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David S Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We add a new feature in the features field, to mark compatible
"fsl,sec1.0"
We also define a helper function called has_ftr_sec1() to help
functions quickly determine if they are running on SEC1 or SEC2+.
When only SEC1 or SEC2 is compiled in, has_ftr_sec1() return
trivial corresponding value. If both are compiled in, feature
field is checked.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c |  3 +++
 drivers/crypto/talitos.h | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index bca6ded..db95023 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2709,6 +2709,9 @@ static int talitos_probe(struct platform_device *ofdev)
 				  TALITOS_FTR_SHA224_HWINIT |
 				  TALITOS_FTR_HMAC_OK;
 
+	if (of_device_is_compatible(np, "fsl,sec1.0"))
+		priv->features |= TALITOS_FTR_SEC1;
+
 	priv->chan = kzalloc(sizeof(struct talitos_channel) *
 			     priv->num_channels, GFP_KERNEL);
 	if (!priv->chan) {
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index f078da1..b0bdb4e 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -156,6 +156,23 @@ extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 #define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
 #define TALITOS_FTR_SHA224_HWINIT 0x00000004
 #define TALITOS_FTR_HMAC_OK 0x00000008
+#define TALITOS_FTR_SEC1 0x00000010
+
+/*
+ * If both CONFIG_CRYPTO_DEV_TALITOS1 and CONFIG_CRYPTO_DEV_TALITOS2 are
+ * defined, we check the features which are set according to the device tree.
+ * Otherwise, we answer true or false directly
+ */
+static inline bool has_ftr_sec1(struct talitos_private *priv)
+{
+#if defined(CONFIG_CRYPTO_DEV_TALITOS1) && defined(CONFIG_CRYPTO_DEV_TALITOS2)
+	return priv->features & TALITOS_FTR_SEC1 ? true : false;
+#elif defined(CONFIG_CRYPTO_DEV_TALITOS1)
+	return true;
+#else
+	return false;
+#endif
+}
 
 /*
  * TALITOS_xxx_LO addresses point to the low data bits (32-63) of the register
-- 
2.1.0
