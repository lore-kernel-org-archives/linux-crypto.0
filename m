Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34836 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbeLMJwd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 04:52:33 -0500
Received: by mail-qk1-f194.google.com with SMTP id w204so765462qka.2
        for <linux-crypto@vger.kernel.org>; Thu, 13 Dec 2018 01:52:32 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, shawnguo@kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: mxc-scc - fix build warnings on ARM64
Date: Thu, 13 Dec 2018 07:52:32 -0200
Message-Id: <1544694752-9293-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The following build warnings are seen when building for ARM64 allmodconfig:

drivers/crypto/mxc-scc.c:181:20: warning: format '%d' expects argument of type 'int', but argument 5 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
drivers/crypto/mxc-scc.c:186:21: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
drivers/crypto/mxc-scc.c:277:21: warning: format '%d' expects argument of type 'int', but argument 4 has type 'size_t' {aka 'long unsigned int'} [-Wformat=]
drivers/crypto/mxc-scc.c:339:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
drivers/crypto/mxc-scc.c:340:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Fix them by using the %zu specifier to print a size_t variable and using
a plain %x to print the result of a readl().

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/crypto/mxc-scc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/mxc-scc.c b/drivers/crypto/mxc-scc.c
index e01c463..5190867 100644
--- a/drivers/crypto/mxc-scc.c
+++ b/drivers/crypto/mxc-scc.c
@@ -178,12 +178,12 @@ static int mxc_scc_get_data(struct mxc_scc_ctx *ctx,
 	else
 		from = scc->black_memory;
 
-	dev_dbg(scc->dev, "pcopy: from 0x%p %d bytes\n", from,
+	dev_dbg(scc->dev, "pcopy: from 0x%p %zu bytes\n", from,
 		ctx->dst_nents * 8);
 	len = sg_pcopy_from_buffer(ablkreq->dst, ctx->dst_nents,
 				   from, ctx->size, ctx->offset);
 	if (!len) {
-		dev_err(scc->dev, "pcopy err from 0x%p (len=%d)\n", from, len);
+		dev_err(scc->dev, "pcopy err from 0x%p (len=%zu)\n", from, len);
 		return -EINVAL;
 	}
 
@@ -274,7 +274,7 @@ static int mxc_scc_put_data(struct mxc_scc_ctx *ctx,
 	len = sg_pcopy_to_buffer(req->src, ctx->src_nents,
 				 to, len, ctx->offset);
 	if (!len) {
-		dev_err(scc->dev, "pcopy err to 0x%p (len=%d)\n", to, len);
+		dev_err(scc->dev, "pcopy err to 0x%p (len=%zu)\n", to, len);
 		return -EINVAL;
 	}
 
@@ -335,9 +335,9 @@ static void mxc_scc_ablkcipher_next(struct mxc_scc_ctx *ctx,
 		return;
 	}
 
-	dev_dbg(scc->dev, "Start encryption (0x%p/0x%p)\n",
-		(void *)readl(scc->base + SCC_SCM_RED_START),
-		(void *)readl(scc->base + SCC_SCM_BLACK_START));
+	dev_dbg(scc->dev, "Start encryption (0x%x/0x%x)\n",
+		readl(scc->base + SCC_SCM_RED_START),
+		readl(scc->base + SCC_SCM_BLACK_START));
 
 	/* clear interrupt control registers */
 	writel(SCC_SCM_INTR_CTRL_CLR_INTR,
-- 
2.7.4
