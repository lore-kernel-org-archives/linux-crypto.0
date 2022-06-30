Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652E6C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 08:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiF3IiS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 04:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbiF3IiP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 04:38:15 -0400
Received: from m15113.mail.126.com (m15113.mail.126.com [220.181.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5846CE080
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 01:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=jj/Kg
        /5d7qigAWweHWdYBZW+YN0pgPw7ut/+o24/MIY=; b=QhucT6+8EA0BZ0eHf2OGs
        YsShcdt9TQulg4+cNeq2YnXRSUhvBbJG9/54blm6BWtVAHudPFc4cNc2EBflAOui
        A0ot66krrk9pvJtU/AEZWco4Eo9fXIdzGUDlI5nO4EbTdgsLuRlc88GZD0U00aT0
        GJdi9EZG7Jfvqx+eLH6REI=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp3 (Coremail) with SMTP id DcmowADXb5GpYL1iB4f_EA--.25761S2;
        Thu, 30 Jun 2022 16:36:59 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        windhl@126.com, linux-crypto@vger.kernel.org
Subject: [PATCH v2 1/2] crypto: amcc: Hold the reference returned by of_find_compatible_node
Date:   Thu, 30 Jun 2022 16:36:56 +0800
Message-Id: <20220630083657.206122-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcmowADXb5GpYL1iB4f_EA--.25761S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZrW5Kr1rCr1fGrWkGw47twb_yoW5Cr45pF
        4Y939rAryxX3Wjgryktw1ku3WFka97AFWrtF47J34kuwnrXrWkZr12v3yjya40gFyUJw13
        Jr95Kr10yas8Jr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziEkskUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi3AwwF1pED1WUvQAAsa
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In crypto4xx_probe(), we should hold the reference returned by
of_find_compatible_node() and use it to call of_node_put to keep
 refcount balance.

Signed-off-by: Liang He <windhl@126.com>
---
 changelog:
 
 v2: split v1 into two commits, use short coding format for 'np=xx;'
 v1: fix bugs in two directories (amcc,nx) of crypto

 v1-link: https://lore.kernel.org/all/20220621073742.4081013-1-windhl@126.com/

 drivers/crypto/amcc/crypto4xx_core.c | 40 +++++++++++++++++-----------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8278d98074e9..280f4b0e7133 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1378,6 +1378,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	struct resource res;
 	struct device *dev = &ofdev->dev;
 	struct crypto4xx_core_device *core_dev;
+	struct device_node *np;
 	u32 pvr;
 	bool is_revb = true;
 
@@ -1385,29 +1386,36 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	if (rc)
 		return -ENODEV;
 
-	if (of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-crypto")) {
+	np = of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-crypto");
+	if (np) {
 		mtdcri(SDR0, PPC460EX_SDR0_SRST,
 		       mfdcri(SDR0, PPC460EX_SDR0_SRST) | PPC460EX_CE_RESET);
 		mtdcri(SDR0, PPC460EX_SDR0_SRST,
 		       mfdcri(SDR0, PPC460EX_SDR0_SRST) & ~PPC460EX_CE_RESET);
-	} else if (of_find_compatible_node(NULL, NULL,
-			"amcc,ppc405ex-crypto")) {
-		mtdcri(SDR0, PPC405EX_SDR0_SRST,
-		       mfdcri(SDR0, PPC405EX_SDR0_SRST) | PPC405EX_CE_RESET);
-		mtdcri(SDR0, PPC405EX_SDR0_SRST,
-		       mfdcri(SDR0, PPC405EX_SDR0_SRST) & ~PPC405EX_CE_RESET);
-		is_revb = false;
-	} else if (of_find_compatible_node(NULL, NULL,
-			"amcc,ppc460sx-crypto")) {
-		mtdcri(SDR0, PPC460SX_SDR0_SRST,
-		       mfdcri(SDR0, PPC460SX_SDR0_SRST) | PPC460SX_CE_RESET);
-		mtdcri(SDR0, PPC460SX_SDR0_SRST,
-		       mfdcri(SDR0, PPC460SX_SDR0_SRST) & ~PPC460SX_CE_RESET);
 	} else {
-		printk(KERN_ERR "Crypto Function Not supported!\n");
-		return -EINVAL;
+		np = of_find_compatible_node(NULL, NULL, "amcc,ppc405ex-crypto");
+		if (np) {
+			mtdcri(SDR0, PPC405EX_SDR0_SRST,
+				   mfdcri(SDR0, PPC405EX_SDR0_SRST) | PPC405EX_CE_RESET);
+			mtdcri(SDR0, PPC405EX_SDR0_SRST,
+				   mfdcri(SDR0, PPC405EX_SDR0_SRST) & ~PPC405EX_CE_RESET);
+			is_revb = false;
+		} else {
+			np = of_find_compatible_node(NULL, NULL, "amcc,ppc460sx-crypto");
+			if (np) {
+				mtdcri(SDR0, PPC460SX_SDR0_SRST,
+					mfdcri(SDR0, PPC460SX_SDR0_SRST) | PPC460SX_CE_RESET);
+				mtdcri(SDR0, PPC460SX_SDR0_SRST,
+					mfdcri(SDR0, PPC460SX_SDR0_SRST) & ~PPC460SX_CE_RESET);
+			} else {
+				printk(KERN_ERR "Crypto Function Not supported!\n");
+				return -EINVAL;
+			}
+		}
 	}
 
+	of_node_put(np);
+
 	core_dev = kzalloc(sizeof(struct crypto4xx_core_device), GFP_KERNEL);
 	if (!core_dev)
 		return -ENOMEM;
-- 
2.25.1

