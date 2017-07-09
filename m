From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH 2/2] staging: ccree: use sizeof(*var) in kmalloc
Date: Sun, 9 Jul 2017 00:45:59 -0500
Message-ID: <20170709054559.GA9095@embeddedgus>
References: <20170709054337.GA9031@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.107]:11755 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750859AbdGIFqD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jul 2017 01:46:03 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 77869A498F
        for <linux-crypto@vger.kernel.org>; Sun,  9 Jul 2017 00:46:00 -0500 (CDT)
Content-Disposition: inline
In-Reply-To: <20170709054337.GA9031@embeddedgus>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the following checkpatch warning:

CHECK: Prefer kmalloc(sizeof(*buff_mgr_handle)...)
over kmalloc(sizeof(struct buff_mgr_handle)...)

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 18a8694..9caff9b 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -1725,7 +1725,7 @@ int ssi_buffer_mgr_init(struct ssi_drvdata *drvdata)
 	struct buff_mgr_handle *buff_mgr_handle;
 	struct device *dev = &drvdata->plat_dev->dev;
 
-	buff_mgr_handle = kmalloc(sizeof(struct buff_mgr_handle), GFP_KERNEL);
+	buff_mgr_handle = kmalloc(sizeof(*buff_mgr_handle), GFP_KERNEL);
 	if (!buff_mgr_handle)
 		return -ENOMEM;
 
-- 
2.5.0
