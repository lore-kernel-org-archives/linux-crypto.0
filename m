From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 12/18] crypto: talitos - don't check the number of channels at
 each interrupt
Date: Fri,  6 Oct 2017 15:04:55 +0200 (CEST)
Message-ID: <50273eb4d8c1f2de846a8711e26883f51d83f8fb.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The number of channels is known from the beginning, no need to
test it everytime.
This patch defines two additional done functions handling only channel 0.
Then the probe registers the correct one based on the number of channels.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 27 +++++++++++++++------------
 drivers/crypto/talitos.h |  4 ++++
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 83b2a70a1ba7..e7e1bada03df 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -390,8 +390,6 @@ static void talitos1_done_##name(unsigned long data)			\
 									\
 	if (ch_done_mask & 0x10000000)					\
 		flush_channel(dev, 0, 0, 0);			\
-	if (priv->num_channels == 1)					\
-		goto out;						\
 	if (ch_done_mask & 0x40000000)					\
 		flush_channel(dev, 1, 0, 0);			\
 	if (ch_done_mask & 0x00010000)					\
@@ -399,7 +397,6 @@ static void talitos1_done_##name(unsigned long data)			\
 	if (ch_done_mask & 0x00040000)					\
 		flush_channel(dev, 3, 0, 0);			\
 									\
-out:									\
 	/* At this point, all completed channels have been processed */	\
 	/* Unmask done interrupts for channels completed later on. */	\
 	spin_lock_irqsave(&priv->reg_lock, flags);			\
@@ -409,6 +406,7 @@ out:									\
 }
 
 DEF_TALITOS1_DONE(4ch, TALITOS1_ISR_4CHDONE)
+DEF_TALITOS1_DONE(ch0, TALITOS1_ISR_CH_0_DONE)
 
 #define DEF_TALITOS2_DONE(name, ch_done_mask)				\
 static void talitos2_done_##name(unsigned long data)			\
@@ -419,8 +417,6 @@ static void talitos2_done_##name(unsigned long data)			\
 									\
 	if (ch_done_mask & 1)						\
 		flush_channel(dev, 0, 0, 0);				\
-	if (priv->num_channels == 1)					\
-		goto out;						\
 	if (ch_done_mask & (1 << 2))					\
 		flush_channel(dev, 1, 0, 0);				\
 	if (ch_done_mask & (1 << 4))					\
@@ -428,7 +424,6 @@ static void talitos2_done_##name(unsigned long data)			\
 	if (ch_done_mask & (1 << 6))					\
 		flush_channel(dev, 3, 0, 0);				\
 									\
-out:									\
 	/* At this point, all completed channels have been processed */	\
 	/* Unmask done interrupts for channels completed later on. */	\
 	spin_lock_irqsave(&priv->reg_lock, flags);			\
@@ -438,6 +433,7 @@ out:									\
 }
 
 DEF_TALITOS2_DONE(4ch, TALITOS2_ISR_4CHDONE)
+DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
 DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
 DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 
@@ -3237,17 +3233,24 @@ static int talitos_probe(struct platform_device *ofdev)
 		goto err_out;
 
 	if (of_device_is_compatible(np, "fsl,sec1.0")) {
-		tasklet_init(&priv->done_task[0], talitos1_done_4ch,
-			     (unsigned long)dev);
-	} else {
-		if (!priv->irq[1]) {
-			tasklet_init(&priv->done_task[0], talitos2_done_4ch,
+		if (priv->num_channels == 1)
+			tasklet_init(&priv->done_task[0], talitos1_done_ch0,
 				     (unsigned long)dev);
-		} else {
+		else
+			tasklet_init(&priv->done_task[0], talitos1_done_4ch,
+				     (unsigned long)dev);
+	} else {
+		if (priv->irq[1]) {
 			tasklet_init(&priv->done_task[0], talitos2_done_ch0_2,
 				     (unsigned long)dev);
 			tasklet_init(&priv->done_task[1], talitos2_done_ch1_3,
 				     (unsigned long)dev);
+		} else if (priv->num_channels == 1) {
+			tasklet_init(&priv->done_task[0], talitos2_done_ch0,
+				     (unsigned long)dev);
+		} else {
+			tasklet_init(&priv->done_task[0], talitos2_done_4ch,
+				     (unsigned long)dev);
 		}
 	}
 
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 6112ff1fc334..2f04d83c3062 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -208,9 +208,13 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 #define TALITOS_ISR			0x1010  /* interrupt status register */
 #define   TALITOS1_ISR_4CHERR		ISR1_FORMAT(0xa) /* 4 ch errors mask */
 #define   TALITOS1_ISR_4CHDONE		ISR1_FORMAT(0x5) /* 4 ch done mask */
+#define   TALITOS1_ISR_CH_0_ERR		(2 << 28) /* ch 0 errors mask */
+#define   TALITOS1_ISR_CH_0_DONE	(1 << 28) /* ch 0 done mask */
 #define   TALITOS1_ISR_TEA_ERR		0x00000040
 #define   TALITOS2_ISR_4CHERR		ISR2_FORMAT(0xa) /* 4 ch errors mask */
 #define   TALITOS2_ISR_4CHDONE		ISR2_FORMAT(0x5) /* 4 ch done mask */
+#define   TALITOS2_ISR_CH_0_ERR		2 /* ch 0 errors mask */
+#define   TALITOS2_ISR_CH_0_DONE	1 /* ch 0 done mask */
 #define   TALITOS2_ISR_CH_0_2_ERR	ISR2_FORMAT(0x2) /* ch 0, 2 err mask */
 #define   TALITOS2_ISR_CH_0_2_DONE	ISR2_FORMAT(0x1) /* ch 0, 2 done mask */
 #define   TALITOS2_ISR_CH_1_3_ERR	ISR2_FORMAT(0x8) /* ch 1, 3 err mask */
-- 
2.13.3
