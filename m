From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: [PATCH v2 1/5] crypto: caam: Fix null dereference at error path
Date: Fri, 26 Jan 2018 17:00:00 +0000
Message-ID: <1516986004-25452-2-git-send-email-pure.logic@nexus-software.ie>
References: <1516986004-25452-1-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: fabio.estevam@nxp.com, peng.fan@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lukas.auer@aisec.fraunhofer.de, rui.silva@linaro.org,
        ryan.harkin@linaro.org, "# 4 . 12+" <stable@vger.kernel.org>,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
To: horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55021 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751860AbeAZRAI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jan 2018 12:00:08 -0500
Received: by mail-wm0-f65.google.com with SMTP id i186so2570637wmi.4
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jan 2018 09:00:08 -0800 (PST)
In-Reply-To: <1516986004-25452-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Rui Miguel Silva <rui.silva@linaro.org>

caam_remove already removes the debugfs entry, so we need to remove the one
immediately before calling caam_remove.

This fix a NULL dereference at error paths is caam_probe fail.

[bod: changed name prefix to "crypto: caam: Fix .."]
[bod: added Fixes tag]

Fixes: 67c2315def06 ("crypto: caam - add Queue Interface (QI) backend
support")

Tested-by: Ryan Harkin <ryan.harkin@linaro.org>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Fabio Estevam <fabio.estevam@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>
Cc: <stable@vger.kernel.org> # 4.12+
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 drivers/crypto/caam/ctrl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 027e121..98986d3 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -809,9 +809,6 @@ static int caam_probe(struct platform_device *pdev)
 	return 0;
 
 caam_remove:
-#ifdef CONFIG_DEBUG_FS
-	debugfs_remove_recursive(ctrlpriv->dfs_root);
-#endif
 	caam_remove(pdev);
 	return ret;
 
-- 
2.7.4
