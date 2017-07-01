From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 07/10] staging: ccree: Fix alignment issues in ssi_ivgen.c
Date: Sun,  2 Jul 2017 01:25:52 +0200
Message-ID: <20170701232555.5538-8-simon@nikanor.nu>
References: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35617 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbdGAX0f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 19:26:35 -0400
Received: by mail-lf0-f49.google.com with SMTP id b207so86273032lfg.2
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 16:26:34 -0700 (PDT)
In-Reply-To: <20170701232555.5538-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_ivgen.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 5ff3368c04d9..0260fbd08be8 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -166,7 +166,8 @@ void ssi_ivgen_fini(struct ssi_drvdata *drvdata)
 	if (ivgen_ctx->pool_meta) {
 		memset(ivgen_ctx->pool_meta, 0, SSI_IVPOOL_META_SIZE);
 		dma_free_coherent(device, SSI_IVPOOL_META_SIZE,
-			ivgen_ctx->pool_meta, ivgen_ctx->pool_meta_dma);
+				  ivgen_ctx->pool_meta,
+				  ivgen_ctx->pool_meta_dma);
 	}
 
 	ivgen_ctx->pool = NULL_SRAM_ADDR;
-- 
2.11.0
