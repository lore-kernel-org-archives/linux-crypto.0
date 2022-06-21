Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B4FCCA482
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jun 2022 07:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347315AbiFUHjR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jun 2022 03:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347322AbiFUHih (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jun 2022 03:38:37 -0400
Received: from mail-m965.mail.126.com (mail-m965.mail.126.com [123.126.96.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDE8411440
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2022 00:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=SQErp
        zelIM2uQrL/wj/6CR6vyBSbP0OiSeVxleKVGek=; b=fEVc/bofoJl4PehTJIm2u
        3mwjHKl6GQ1eH9CE2kAoUGmT0FE2xcmq0X7bgkvp0UosSK/AgFUh1ewnCtZCHCq7
        w8i2GbWqZNk+XjnEZzCzm6hZGT9lhuWwsrEPrQZROjNyhTfzu1oJBdtJwS01edXC
        zKjisQjcwJwKUs3QIVORtM=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp10 (Coremail) with SMTP id NuRpCgCHl69HdbFiRLM3FA--.37065S2;
        Tue, 21 Jun 2022 15:37:44 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, windhl@126.com
Subject: [PATCH] crypto: Hold the reference returned by of_find_compatible_node
Date:   Tue, 21 Jun 2022 15:37:42 +0800
Message-Id: <20220621073742.4081013-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NuRpCgCHl69HdbFiRLM3FA--.37065S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZrW5Kr17JFyxCw48trW8JFb_yoW5CrykpF
        4Y9ayUAryxXa4jgry8Jrn5ua4Fva93ZFWrJF47G3s8uwnxXFWkZF42vr4jvF95WFyrGr13
        JFZ5Kw18Aa48Jr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U5WrZUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi7QknF1pEAPvrZgAAs8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In nx842_pseries_init() and crypto4xx_probe(), we should hold the
reference returned by of_find_compatible_node() and use it to call
of_node_put to keep refcount balance.

Signed-off-by: Liang He <windhl@126.com>
---
 drivers/crypto/amcc/crypto4xx_core.c  | 13 ++++++++-----
 drivers/crypto/nx/nx-common-pseries.c |  5 ++++-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8278d98074e9..169b6a05e752 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1378,6 +1378,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	struct resource res;
 	struct device *dev = &ofdev->dev;
 	struct crypto4xx_core_device *core_dev;
+	struct device_node *np;
 	u32 pvr;
 	bool is_revb = true;
 
@@ -1385,20 +1386,20 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	if (rc)
 		return -ENODEV;
 
-	if (of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-crypto")) {
+	if ((np = of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-crypto")) != NULL) {
 		mtdcri(SDR0, PPC460EX_SDR0_SRST,
 		       mfdcri(SDR0, PPC460EX_SDR0_SRST) | PPC460EX_CE_RESET);
 		mtdcri(SDR0, PPC460EX_SDR0_SRST,
 		       mfdcri(SDR0, PPC460EX_SDR0_SRST) & ~PPC460EX_CE_RESET);
-	} else if (of_find_compatible_node(NULL, NULL,
-			"amcc,ppc405ex-crypto")) {
+	} else if ((np = of_find_compatible_node(NULL, NULL,
+			"amcc,ppc405ex-crypto")) != NULL) {
 		mtdcri(SDR0, PPC405EX_SDR0_SRST,
 		       mfdcri(SDR0, PPC405EX_SDR0_SRST) | PPC405EX_CE_RESET);
 		mtdcri(SDR0, PPC405EX_SDR0_SRST,
 		       mfdcri(SDR0, PPC405EX_SDR0_SRST) & ~PPC405EX_CE_RESET);
 		is_revb = false;
-	} else if (of_find_compatible_node(NULL, NULL,
-			"amcc,ppc460sx-crypto")) {
+	} else if ((np = of_find_compatible_node(NULL, NULL,
+			"amcc,ppc460sx-crypto")) != NULL) {
 		mtdcri(SDR0, PPC460SX_SDR0_SRST,
 		       mfdcri(SDR0, PPC460SX_SDR0_SRST) | PPC460SX_CE_RESET);
 		mtdcri(SDR0, PPC460SX_SDR0_SRST,
@@ -1408,6 +1409,8 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		return -EINVAL;
 	}
 
+	of_node_put(np);
+
 	core_dev = kzalloc(sizeof(struct crypto4xx_core_device), GFP_KERNEL);
 	if (!core_dev)
 		return -ENOMEM;
diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 7584a34ba88c..3ea334b7f820 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -1208,10 +1208,13 @@ static struct vio_driver nx842_vio_driver = {
 static int __init nx842_pseries_init(void)
 {
 	struct nx842_devdata *new_devdata;
+	struct device_node *np;
 	int ret;
 
-	if (!of_find_compatible_node(NULL, NULL, "ibm,compression"))
+	np = of_find_compatible_node(NULL, NULL, "ibm,compression");
+	if (!np)
 		return -ENODEV;
+	of_node_put(np);
 
 	RCU_INIT_POINTER(devdata, NULL);
 	new_devdata = kzalloc(sizeof(*new_devdata), GFP_KERNEL);
-- 
2.25.1

