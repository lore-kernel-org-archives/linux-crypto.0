From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 5/6] staging: ccree: Fix alignment issues in ssi_ivgen.c
Date: Tue, 18 Jul 2017 22:03:56 +0200
Message-ID: <20170718200357.32646-6-simon@nikanor.nu>
References: <20170718200357.32646-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:36577 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdGRUFW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 16:05:22 -0400
Received: by mail-lf0-f47.google.com with SMTP id d78so17767220lfg.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jul 2017 13:05:22 -0700 (PDT)
In-Reply-To: <20170718200357.32646-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_ivgen.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index f140dbc5195c..86364f81acab 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -202,7 +202,8 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 
 	/* Allocate pool's header for intial enc. key/IV */
 	ivgen_ctx->pool_meta = dma_alloc_coherent(device, SSI_IVPOOL_META_SIZE,
-			&ivgen_ctx->pool_meta_dma, GFP_KERNEL);
+						  &ivgen_ctx->pool_meta_dma,
+						  GFP_KERNEL);
 	if (!ivgen_ctx->pool_meta) {
 		SSI_LOG_ERR("Not enough memory to allocate DMA of pool_meta "
 			   "(%u B)\n", SSI_IVPOOL_META_SIZE);
-- 
2.11.0
