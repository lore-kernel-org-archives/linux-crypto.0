From: Axel Lin <axel.lin@ingics.com>
Subject: [PATCH] crypto: sahara - Fix misuse of IS_ENABLED
Date: Mon, 10 Aug 2015 15:18:36 +0800
Message-ID: <1439191116.22743.1.camel@ingics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36577 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbbHJHSl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 03:18:41 -0400
Received: by pdco4 with SMTP id o4so68392462pdc.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2015 00:18:41 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IS_ENABLED should only be used for CONFIG_* symbols.
So use #ifdef DEBUG instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/crypto/sahara.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 397a500b..b2661a5 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -384,11 +384,9 @@ static char *sahara_state[4] = { "Idle", "Busy", "Error", "HW Fault" };
 
 static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
 {
+#ifdef DEBUG
 	u8 state;
 
-	if (!IS_ENABLED(DEBUG))
-		return;
-
 	state = SAHARA_STATUS_GET_STATE(status);
 
 	dev_dbg(dev->device, "%s: Status Register = 0x%08x\n",
@@ -432,15 +430,14 @@ static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
 		sahara_read(dev, SAHARA_REG_CDAR));
 	dev_dbg(dev->device, "Initial DAR: 0x%08x\n\n",
 		sahara_read(dev, SAHARA_REG_IDAR));
+#endif
 }
 
 static void sahara_dump_descriptors(struct sahara_dev *dev)
 {
+#ifdef DEBUG
 	int i;
 
-	if (!IS_ENABLED(DEBUG))
-		return;
-
 	for (i = 0; i < SAHARA_MAX_HW_DESC; i++) {
 		dev_dbg(dev->device, "Descriptor (%d) (0x%08x):\n",
 			i, dev->hw_phys_desc[i]);
@@ -453,15 +450,14 @@ static void sahara_dump_descriptors(struct sahara_dev *dev)
 			dev->hw_desc[i]->next);
 	}
 	dev_dbg(dev->device, "\n");
+#endif
 }
 
 static void sahara_dump_links(struct sahara_dev *dev)
 {
+#ifdef DEBUG
 	int i;
 
-	if (!IS_ENABLED(DEBUG))
-		return;
-
 	for (i = 0; i < SAHARA_MAX_HW_LINK; i++) {
 		dev_dbg(dev->device, "Link (%d) (0x%08x):\n",
 			i, dev->hw_phys_link[i]);
@@ -471,6 +467,7 @@ static void sahara_dump_links(struct sahara_dev *dev)
 			dev->hw_link[i]->next);
 	}
 	dev_dbg(dev->device, "\n");
+#endif
 }
 
 static int sahara_hw_descriptor_create(struct sahara_dev *dev)
-- 
2.1.0
