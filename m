Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B58C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 08:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiGFI41 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 04:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiGFI4X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 04:56:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44842497D;
        Wed,  6 Jul 2022 01:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657097782; x=1688633782;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dXzeYA9cVkoxc6fZ0AVx6fTERxzncJqGTnR7aJd9/qc=;
  b=Gt8ifQFNH6/j3batxV/ahG8RbptHuoUqpCkn4tjuuOOsHH1UnDsTXtPJ
   KgV4PzwplBJ0uP1ZP8v0kxmuqPYKkcZETzR5VMn2LXD4r1wJFdGfRF0IA
   jSYhO6ZdJ0Yd2w/8mzvTLmK3054bvy54cOsl4TYz20chRiFxLz5nulHN2
   W8ckzqVjwkuoh77w4zFB5L7yWsP5T6makd5B0iDlfese++/6zEYvBp0Ef
   DYrEepjGmpAp5FEqa/0ESM7CiTUW66jO0xEnZLsZ1YFNXlSBoKmHiOcfe
   hORcTKYXWkXXYk/GPDjtwg1MJavAfelhfVjpKji1jTebrrEXNOlUycejf
   g==;
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="103245014"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2022 01:56:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 6 Jul 2022 01:56:21 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 6 Jul 2022 01:56:19 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH] crypto: atmel-sha: initialize sha_dd while declaring
Date:   Wed, 6 Jul 2022 11:58:44 +0300
Message-ID: <20220706085844.830650-1-claudiu.beznea@microchip.com>
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

[1] https://patchwork.kernel.org/project/linux-crypto/patch/20220705205144.131702-2-u.kleine-koenig@pengutronix.de

Thank you,
Claudiu Beznea

 drivers/crypto/atmel-sha.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index e054e0ac6fc2..ca4b01926d1b 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2666,9 +2666,7 @@ static int atmel_sha_probe(struct platform_device *pdev)
 
 static int atmel_sha_remove(struct platform_device *pdev)
 {
-	struct atmel_sha_dev *sha_dd;
-
-	sha_dd = platform_get_drvdata(pdev);
+	struct atmel_sha_dev *sha_dd = platform_get_drvdata(pdev);
 
 	spin_lock(&atmel_sha.lock);
 	list_del(&sha_dd->list);
-- 
2.34.1

