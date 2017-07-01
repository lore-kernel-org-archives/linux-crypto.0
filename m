From: =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
Subject: [PATCH 05/10] staging: ccree: Fix alignment issues in ssi_fips_local.c
Date: Sun,  2 Jul 2017 01:25:50 +0200
Message-ID: <20170701232555.5538-6-simon@nikanor.nu>
References: <20170701232555.5538-1-simon@nikanor.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        =?UTF-8?q?Simon=20Sandstr=C3=B6m?= <simon@nikanor.nu>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36466 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbdGAX0d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jul 2017 19:26:33 -0400
Received: by mail-lf0-f43.google.com with SMTP id h22so86298481lfk.3
        for <linux-crypto@vger.kernel.org>; Sat, 01 Jul 2017 16:26:33 -0700 (PDT)
In-Reply-To: <20170701232555.5538-1-simon@nikanor.nu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes checkpatch.pl alignment warnings.

Signed-off-by: Simon Sandström <simon@nikanor.nu>
---
 drivers/staging/ccree/ssi_fips_local.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index aefb71dc9e9a..c16bfab39699 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -150,8 +150,7 @@ static void fips_dsr(unsigned long devarg)
 
 	/* after verifing that there is nothing to do, Unmask AXI completion interrupt */
 	CC_HAL_WRITE_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR),
-		CC_HAL_READ_REGISTER(
-		CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
+			      CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IMR)) & ~irq);
 }
 
 enum cc_fips_error cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
-- 
2.11.0
