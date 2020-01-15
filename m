Return-Path: <SRS0=cdcO=3E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E898DC33CB7
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 14:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6A682467A
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 14:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uVIpAFmd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgAOOOU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jan 2020 09:14:20 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43345 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbgAOOOT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jan 2020 09:14:19 -0500
Received: by mail-pl1-f195.google.com with SMTP id p27so6890717pli.10
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jan 2020 06:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gt6F4uTsWktpFFyX7CiQDNWqBR7Eg8dmS5mipvr7KTw=;
        b=uVIpAFmd6iprxfTy28Obl/jazf2tlIos2uTiAZBgwcDBz+3vvvMkRyeviyyY2UMM7C
         GW+vdPPOaxlHMB6D5wJW168wbl5t/fR260nHisVeCOhNu4tAQuse+tfzv4bmfdbhQeC2
         qFcrcl8RukC+2AF5PWnwLkFDs5LE9lgVgMSDDUJrtOabLhR8fWUGLXMUJBTSMgGNQ5lx
         SBE0UNlJOAFXqxcM+X464j+hHJXj0lYAilwpJftSueRHiyCJeTWvA8MXslELoR01JGbA
         uI7aCFSf23kkvX722CgrN7MZeLI2NPmEO0jN3/BjJbkBUN3Cjoo+V/71k2aJzxe1jkwz
         CfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gt6F4uTsWktpFFyX7CiQDNWqBR7Eg8dmS5mipvr7KTw=;
        b=UjL9/If7Oe44ESDUmzhgmFfw/W3IwJ8+5EEPSX7OfCCu2qOMdn0sO5lHk+dcKWr4Tp
         aGBIYQUZzieTFCkC3nAJQYr5xsGic4xPThbGGUHRpBBmpdZnwCyKoe2tBe5rBjk5JzLO
         XXQ7yDX9FJExVEUWV89rtKLBe/dthsi9u5WejkADB6ri/clu7b5xVIg0WgXSNjZYdU86
         A2V08hb5qSc+D8d38S056b/F7BM0oyWFwoGa3S2wii5yGbLIh+XbO1sfXf55wiUHqtkn
         sn0QKKsRX5iy82GmkPis+R240f4mF1A3Rf3n+lliaqtBVFoTC10OEjw2gRULEIpI7XT7
         HqPQ==
X-Gm-Message-State: APjAAAWdw2lfF+Z3cD7ONM771OVB6GiYId8gXppqSqrskQJUVujTnyMR
        IvrwDxL/5caFDwVzcknZO8Hkzw==
X-Google-Smtp-Source: APXvYqw1WVju2xcX7lOnVABkuUPrOjdfIgwbmNj8fzUvwYrfsT29oM2IUDuh72sKOdrUgFxHL/6b5Q==
X-Received: by 2002:a17:90a:1ae9:: with SMTP id p96mr36512294pjp.8.1579097658957;
        Wed, 15 Jan 2020 06:14:18 -0800 (PST)
Received: from localhost.localdomain ([104.238.63.136])
        by smtp.gmail.com with ESMTPSA id a15sm22591980pfh.169.2020.01.15.06.14.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 15 Jan 2020 06:14:18 -0800 (PST)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, dave.jiang@intel.com,
        grant.likely@arm.com, jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v12 3/4] crypto: hisilicon - Remove module_param uacce_mode
Date:   Wed, 15 Jan 2020 22:12:47 +0800
Message-Id: <1579097568-17542-4-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579097568-17542-1-git-send-email-zhangfei.gao@linaro.org>
References: <1579097568-17542-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the module_param uacce_mode, which is not used currently.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 31ae6a7..853b97e 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -298,9 +298,6 @@ static u32 pf_q_num = HZIP_PF_DEF_Q_NUM;
 module_param_cb(pf_q_num, &pf_q_num_ops, &pf_q_num, 0444);
 MODULE_PARM_DESC(pf_q_num, "Number of queues in PF(v1 1-4096, v2 1-1024)");
 
-static int uacce_mode;
-module_param(uacce_mode, int, 0);
-
 static u32 vfs_num;
 module_param(vfs_num, uint, 0444);
 MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63)");
@@ -796,6 +793,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, hisi_zip);
 
 	qm = &hisi_zip->qm;
+	qm->use_dma_api = true;
 	qm->pdev = pdev;
 	qm->ver = rev_id;
 
@@ -803,20 +801,6 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	qm->dev_name = hisi_zip_name;
 	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ? QM_HW_PF :
 								QM_HW_VF;
-	switch (uacce_mode) {
-	case 0:
-		qm->use_dma_api = true;
-		break;
-	case 1:
-		qm->use_dma_api = false;
-		break;
-	case 2:
-		qm->use_dma_api = true;
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	ret = hisi_qm_init(qm);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to init qm!\n");
@@ -1015,12 +999,10 @@ static int __init hisi_zip_init(void)
 		goto err_pci;
 	}
 
-	if (uacce_mode == 0 || uacce_mode == 2) {
-		ret = hisi_zip_register_to_crypto();
-		if (ret < 0) {
-			pr_err("Failed to register driver to crypto.\n");
-			goto err_crypto;
-		}
+	ret = hisi_zip_register_to_crypto();
+	if (ret < 0) {
+		pr_err("Failed to register driver to crypto.\n");
+		goto err_crypto;
 	}
 
 	return 0;
@@ -1035,8 +1017,7 @@ static int __init hisi_zip_init(void)
 
 static void __exit hisi_zip_exit(void)
 {
-	if (uacce_mode == 0 || uacce_mode == 2)
-		hisi_zip_unregister_from_crypto();
+	hisi_zip_unregister_from_crypto();
 	pci_unregister_driver(&hisi_zip_pci_driver);
 	hisi_zip_unregister_debugfs();
 }
-- 
2.7.4

