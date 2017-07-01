From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 09/10] staging: ccree: Fix alignment issues in ssi_sram_mgr.c
Date: Sun,  2 Jul 2017 01:25:54 +0200
Message-ID: <20170701232555.5538-10-simon@nikanor.nu>
References: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35620 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752145AbdGAX0h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 19:26:37 -0400
Received: by mail-lf0-f49.google.com with SMTP id b207so86273145lfg.2
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 16:26:36 -0700 (PDT)
In-Reply-To: <20170701232555.5538-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_sram_mgr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/ssi_sram_mgr.c
index e05c0c13c2eb..f11116afe89a 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/ssi_sram_mgr.c
@@ -58,7 +58,7 @@ int ssi_sram_mgr_init(struct ssi_drvdata *drvdata)
 			sizeof(struct ssi_sram_mgr_ctx), GFP_KERNEL);
 	if (!drvdata->sram_mgr_handle) {
 		SSI_LOG_ERR("Not enough memory to allocate SRAM_MGR ctx (%zu)\n",
-			sizeof(struct ssi_sram_mgr_ctx));
+			    sizeof(struct ssi_sram_mgr_ctx));
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -90,12 +90,12 @@ ssi_sram_addr_t ssi_sram_mgr_alloc(struct ssi_drvdata *drvdata, u32 size)
 
 	if (unlikely((size & 0x3) != 0)) {
 		SSI_LOG_ERR("Requested buffer size (%u) is not multiple of 4",
-			size);
+			    size);
 		return NULL_SRAM_ADDR;
 	}
 	if (unlikely(size > (SSI_CC_SRAM_SIZE - smgr_ctx->sram_free_offset))) {
 		SSI_LOG_ERR("Not enough space to allocate %u B (at offset %llu)\n",
-			size, smgr_ctx->sram_free_offset);
+			    size, smgr_ctx->sram_free_offset);
 		return NULL_SRAM_ADDR;
 	}
 
-- 
2.11.0
