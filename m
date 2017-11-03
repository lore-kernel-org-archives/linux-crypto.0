From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH] crypto: marvell - Add a NULL entry at the end of mv_cesa_plat_id_table[]
Date: Fri,  3 Nov 2017 17:52:01 +0100
Message-ID: <20171103165201.18997-1-boris.brezillon@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:38264 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbdKCQwS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 12:52:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

struct platform_device_id should be NULL terminated to let the core detect
where the last entry is.

Fixes: 07c50a8be41a ("crypto: marvell - Add a platform_device_id table")
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 577dc6773fa0..6dabb261bac4 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -594,6 +594,7 @@ static int mv_cesa_remove(struct platform_device *pdev)
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
 	{ .name = "mv_crypto" },
+	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(platform, mv_cesa_plat_id_table);
 
-- 
2.11.0
