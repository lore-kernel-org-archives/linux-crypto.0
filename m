Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AAFC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Mar 2022 03:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiCRD1C (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 23:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiCRD1B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 23:27:01 -0400
X-Greylist: delayed 67 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Mar 2022 20:25:43 PDT
Received: from mail.meizu.com (edge01.meizu.com [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD22714F121
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 20:25:43 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 18 Mar
 2022 11:24:36 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Fri, 18 Mar
 2022 11:24:34 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <sgoutham@marvell.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Haowen Bai <baihaowen@meizu.com>
Subject: [PATCH] hwrng: cavium: fix possible NULL pointer dereference
Date:   Fri, 18 Mar 2022 11:24:32 +0800
Message-ID: <1647573872-19278-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pdev is NULL but dereference to pdev->dev

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/char/hw_random/cavium-rng-vf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
index 6f66919..bffcb01 100644
--- a/drivers/char/hw_random/cavium-rng-vf.c
+++ b/drivers/char/hw_random/cavium-rng-vf.c
@@ -179,7 +179,7 @@ static int cavium_map_pf_regs(struct cavium_rng *rng)
 	pdev = pci_get_device(PCI_VENDOR_ID_CAVIUM,
 			      PCI_DEVID_CAVIUM_RNG_PF, NULL);
 	if (!pdev) {
-		dev_err(&pdev->dev, "Cannot find RNG PF device\n");
+		printk(KERN_ERR "Cannot find RNG PF device\n");
 		return -EIO;
 	}
 
-- 
2.7.4

