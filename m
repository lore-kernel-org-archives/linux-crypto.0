From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 2/4] crypto: talitos - export the talitos_submit function
Date: Tue, 3 Jul 2012 19:16:52 +0300
Message-ID: <1341332214-5525-2-git-send-email-horia.geanta@freescale.com>
References: <1341332214-5525-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sandeep Malik <Sandeep.Malik@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:21340
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457Ab2GCQRo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Jul 2012 12:17:44 -0400
In-Reply-To: <1341332214-5525-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch exports the talitos_submit function so that on
need basis same can be used by other entities.

Signed-off-by: Sandeep Malik <Sandeep.Malik@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c |   11 ++++++-----
 drivers/crypto/talitos.h |    6 ++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index bb3e63f..2561aea 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -192,11 +192,11 @@ static int init_device(struct device *dev)
  * callback must check err and feedback in descriptor header
  * for device processing status.
  */
-static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
-			  void (*callback)(struct device *dev,
-					   struct talitos_desc *desc,
-					   void *context, int error),
-			  void *context)
+int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
+		   void (*callback)(struct device *dev,
+				    struct talitos_desc *desc,
+				    void *context, int error),
+		   void *context)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request;
@@ -237,6 +237,7 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 
 	return -EINPROGRESS;
 }
+EXPORT_SYMBOL(talitos_submit);
 
 /*
  * process what was done, notify callback of error if not
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 9835e3a..41b80f6 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -133,6 +133,12 @@ struct talitos_private {
 	struct hwrng rng;
 };
 
+extern int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
+			  void (*callback)(struct device *dev,
+					   struct talitos_desc *desc,
+					   void *context, int error),
+			  void *context);
+
 /* .features flag */
 #define TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT 0x00000001
 #define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
-- 
1.7.3.4
