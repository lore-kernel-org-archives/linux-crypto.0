From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 6/6] staging: ccree: Fix alignment issues in ssi_request_mgr.c
Date: Tue, 18 Jul 2017 22:03:57 +0200
Message-ID: <20170718200357.32646-7-simon@nikanor.nu>
References: <20170718200357.32646-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:32774 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbdGRUFY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 16:05:24 -0400
Received: by mail-lf0-f52.google.com with SMTP id z78so22207509lff.0
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 13:05:23 -0700 (PDT)
In-Reply-To: <20170718200357.32646-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_request_mgr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 3f39150cda4f..2eda82f317d2 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -136,7 +136,9 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 
 	/* Allocate DMA word for "dummy" completion descriptor use */
 	req_mgr_h->dummy_comp_buff = dma_alloc_coherent(&drvdata->plat_dev->dev,
-		sizeof(u32), &req_mgr_h->dummy_comp_buff_dma, GFP_KERNEL);
+							sizeof(u32),
+							&req_mgr_h->dummy_comp_buff_dma,
+							GFP_KERNEL);
 	if (!req_mgr_h->dummy_comp_buff) {
 		SSI_LOG_ERR("Not enough memory to allocate DMA (%zu) dropped "
 			   "buffer\n", sizeof(u32));
-- 
2.11.0
