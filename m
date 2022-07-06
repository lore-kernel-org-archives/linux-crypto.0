Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF54CCA473
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 09:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiGFJPO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 05:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbiGFJPI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 05:15:08 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659A1C23;
        Wed,  6 Jul 2022 02:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657098905; x=1688634905;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+VI0QHCyPONLMhvZQIjJCP6FWIqDVbefx+zx+Z98RBc=;
  b=FqBCdX+dKwjfCTP4qWzmWXOyXVGACg4qF/Ljw8Bsah3nJYe1X/NVDB/c
   UpRnDBSXNg+OJmn0UY1z7fyK+zhcHh6EggVYruSKhPXVLZ9YU/pMNpHPg
   YeUaeHoLdJc1LcyG652+uaAyeiQ2eT1Lt7oj8bGSWNG05UpOtSCGLTymM
   NTZdLbMdUeApSDbPzn93fwig6pVTBnKAfJ4bbHbqJbGdgT8Xt4DE76FDh
   4iSRA9KZw4/ZM0BvD0XssGz1DSPK4+0x5KYPlHN7HBAD4/y+iHmYsTuhH
   udojrgBt4/Hnr2IS73rudankdwaWIumkcq46tBHHtyX3vni0KGHxZWMzI
   A==;
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="170971252"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2022 02:15:04 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Jul 2022 02:15:04 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 6 Jul 2022 02:15:01 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH] crypto: atmel-tdes: initialize tdes_dd while declaring
Date:   Wed, 6 Jul 2022 12:17:27 +0300
Message-ID: <20220706091727.831036-1-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Initialize sha_dd with platform_get_drvdata() when declaring it.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---

Hi,

This patch is based on patch at [1].

[1] https://patchwork.kernel.org/project/linux-crypto/patch/20220705205144.131702-3-u.kleine-koenig@pengutronix.de

Thank you,
Claudiu Beznea

 drivers/crypto/atmel-tdes.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index a5e78aa08bf0..8b7bc1076e0d 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1263,9 +1263,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 
 static int atmel_tdes_remove(struct platform_device *pdev)
 {
-	struct atmel_tdes_dev *tdes_dd;
-
-	tdes_dd = platform_get_drvdata(pdev);
+	struct atmel_tdes_dev *tdes_dd = platform_get_drvdata(pdev);
 
 	spin_lock(&atmel_tdes.lock);
 	list_del(&tdes_dd->list);
-- 
2.33.0

