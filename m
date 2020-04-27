Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FCA5C55199
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 08:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE130206D4
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 08:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgD0IWK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 04:22:10 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:13555 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgD0IWK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 04:22:10 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee45ea69624d8a-77155; Mon, 27 Apr 2020 16:21:56 +0800 (CST)
X-RM-TRANSID: 2ee45ea69624d8a-77155
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee25ea6961f1f8-765f6;
        Mon, 27 Apr 2020 16:21:55 +0800 (CST)
X-RM-TRANSID: 2ee25ea6961f1f8-765f6
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] crypto: bcm - Use the defined variable to clean code
Date:   Mon, 27 Apr 2020 16:22:18 +0800
Message-Id: <20200427082218.12372-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the defined variable "dev" to make the code cleaner.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/crypto/bcm/cipher.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 99ece630f..d748ee0a6 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4717,7 +4717,7 @@ static int spu_dt_read(struct platform_device *pdev)
 
 	matched_spu_type = of_device_get_match_data(dev);
 	if (!matched_spu_type) {
-		dev_err(&pdev->dev, "Failed to match device\n");
+		dev_err(dev, "Failed to match device\n");
 		return -ENODEV;
 	}
 
@@ -4731,7 +4731,7 @@ static int spu_dt_read(struct platform_device *pdev)
 		spu->reg_vbase[i] = devm_ioremap_resource(dev, spu_ctrl_regs);
 		if (IS_ERR(spu->reg_vbase[i])) {
 			err = PTR_ERR(spu->reg_vbase[i]);
-			dev_err(&pdev->dev, "Failed to map registers: %d\n",
+			dev_err(dev, "Failed to map registers: %d\n",
 				err);
 			spu->reg_vbase[i] = NULL;
 			return err;
@@ -4757,7 +4757,7 @@ static int bcm_spu_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto failure;
 
-	err = spu_mb_init(&pdev->dev);
+	err = spu_mb_init(dev);
 	if (err < 0)
 		goto failure;
 
@@ -4766,7 +4766,7 @@ static int bcm_spu_probe(struct platform_device *pdev)
 	else if (spu->spu_type == SPU_TYPE_SPU2)
 		iproc_priv.bcm_hdr_len = 0;
 
-	spu_functions_register(&pdev->dev, spu->spu_type, spu->spu_subtype);
+	spu_functions_register(dev, spu->spu_type, spu->spu_subtype);
 
 	spu_counters_init();
 
-- 
2.20.1.windows.1



