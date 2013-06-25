From: Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 6/6] crypto: ux500: use dmaengine_submit API
Date: Tue, 25 Jun 2013 10:54:49 +0200
Message-ID: <1372150489-25594-7-git-send-email-fabio.baltieri@linaro.org>
References: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Fabio Baltieri <fabio.baltieri@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use dmaengine_submit instead of calling desc->tx_submit manually.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 2 +-
 drivers/crypto/ux500/hash/hash_core.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 0cd89df..a999f53 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -594,7 +594,7 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
 		return -EFAULT;
 	}
 
-	cookie = desc->tx_submit(desc);
+	cookie = dmaengine_submit(desc);
 	dma_async_issue_pending(channel);
 
 	return 0;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 3527777..496ae6a 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -192,7 +192,7 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 	desc->callback = hash_dma_callback;
 	desc->callback_param = ctx;
 
-	cookie = desc->tx_submit(desc);
+	cookie = dmaengine_submit(desc);
 	dma_async_issue_pending(channel);
 
 	return 0;
-- 
1.8.2
