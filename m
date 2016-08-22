From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] crypto: mxc-scc - check clk_prepare_enable() error
Date: Sun, 21 Aug 2016 23:37:27 -0300
Message-ID: <1471833447-11446-1-git-send-email-festevam@gmail.com>
Cc: s.trumtrar@pengutronix.de, linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36237 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753501AbcHVCiG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Aug 2016 22:38:06 -0400
Received: by mail-qk0-f196.google.com with SMTP id v123so7796686qkh.3
        for <linux-crypto@vger.kernel.org>; Sun, 21 Aug 2016 19:38:06 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

clk_prepare_enable() may fail, so we should better check its return
value and propagate it in the case of failure.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/crypto/mxc-scc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/mxc-scc.c b/drivers/crypto/mxc-scc.c
index ff383ef..ee4be1b0 100644
--- a/drivers/crypto/mxc-scc.c
+++ b/drivers/crypto/mxc-scc.c
@@ -668,7 +668,9 @@ static int mxc_scc_probe(struct platform_device *pdev)
 		return PTR_ERR(scc->clk);
 	}
 
-	clk_prepare_enable(scc->clk);
+	ret = clk_prepare_enable(scc->clk);
+	if (ret)
+		return ret;
 
 	/* clear error status register */
 	writel(0x0, scc->base + SCC_SCM_ERROR_STATUS);
-- 
1.9.1
