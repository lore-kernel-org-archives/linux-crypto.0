From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 09/17] crypto: talitos - Move reset/init helpers into talitos2.h
Date: Fri,  6 Mar 2015 17:40:25 +0100 (CET)
Message-ID: <20150306164025.D71101A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:54025 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbbCFQk1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 11:40:27 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move reset/init helpers init talitos2.h as they are specific to SEC2

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.c  | 19 -------------------
 drivers/crypto/talitos2.h | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 81a6e47..ffa103b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -55,19 +55,6 @@
 
 #include "talitos.h"
 
-static unsigned int do_reset_channel(struct talitos_private *priv, int ch)
-{
-	unsigned int timeout = TALITOS_TIMEOUT;
-
-	setbits32(priv->chan[ch].reg + TALITOS_CCCR, TALITOS_CCCR_RESET);
-
-	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) & TALITOS_CCCR_RESET)
-	       && --timeout)
-		cpu_relax();
-
-	return timeout;
-}
-
 int talitos_reset_channel(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -118,12 +105,6 @@ static int reset_device(struct device *dev)
 /*
  * Reset and initialize the device
  */
-static void do_init_device(struct talitos_private *priv)
-{
-	setbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_INIT);
-	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
-}
-
 int talitos_init_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
diff --git a/drivers/crypto/talitos2.h b/drivers/crypto/talitos2.h
index e7a91cf..f9da9f2 100644
--- a/drivers/crypto/talitos2.h
+++ b/drivers/crypto/talitos2.h
@@ -202,3 +202,23 @@ extern int talitos_alg_alloc_aead(struct crypto_alg *alg);
 #define DESC_PTR_LNKTBL_JUMP			0x80
 #define DESC_PTR_LNKTBL_RETURN			0x02
 #define DESC_PTR_LNKTBL_NEXT			0x01
+
+static inline unsigned int do_reset_channel(struct talitos_private *priv,
+					    int ch)
+{
+	unsigned int timeout = TALITOS_TIMEOUT;
+
+	setbits32(priv->chan[ch].reg + TALITOS_CCCR, TALITOS_CCCR_RESET);
+
+	while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) & TALITOS_CCCR_RESET)
+	       && --timeout)
+		cpu_relax();
+
+	return timeout;
+}
+
+static inline void do_init_device(struct talitos_private *priv)
+{
+	setbits32(priv->reg + TALITOS_IMR, TALITOS_IMR_INIT);
+	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS_IMR_LO_INIT);
+}
-- 
2.1.0
