Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203E5C04E30
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 02:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3DF6206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 02:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y2RNUSwA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfLJCn4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 21:43:56 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44608 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfLJCn4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 21:43:56 -0500
Received: by mail-pl1-f194.google.com with SMTP id bh2so5511658plb.11
        for <linux-crypto@vger.kernel.org>; Mon, 09 Dec 2019 18:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W9XtgUwCaqLhMYMb2ALmzrvWt2lsT7N00PF81eXUGSY=;
        b=Y2RNUSwAXifJcQebUPMgVLxf/MudfCJaiOKVS3Ae26rZaAh6MymPdTdO4VoQrfMxVK
         IYKXAga4IeE37eq/4LxHdQ6qu4uNCZZpOEkeDCfBNc1kbbR2/9TKYRbSdN8UMu3dKBMC
         mPLiY9gBOjp81TQjQR1z9/vd33QGfFPrJeX5v6Z+fmV/p4APogD9ScTCoMGO5vbVooHm
         TnjwvC6pze8E+kaJ3obAxvVJ+MUGFYRSlF7gmFoGi5MyD8wDc0wQ94OYPLwcA88cADvm
         OHXIZIqYYLXpMvHrN9NUw4CNGKRdU2+3mIAjJbqDdCUw8r56wgL/LBR+keX70INz6Xqp
         xtgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W9XtgUwCaqLhMYMb2ALmzrvWt2lsT7N00PF81eXUGSY=;
        b=dJPALIyKNCQo3CESbCnBSf6vEb15WCvyHJO+WsQ93petqMyaLXSQDy2r5hRYeN3nnV
         KdW9/CWYFv2/nvrrGRNt+M9ZUZVvVKwTdyBe6Tv8PP/I8uSmKWvs8WcKtAyjWxP6d0Eb
         iFVz1IBrOPR6BvdYnRs+Vx9pvS89n7o9oGuOrXNYHDLhwgryqGWsbeN2T+3yJ6EhdEcf
         bOXdAr2F9xn1kuhQRhTzDmDBFD9RzOu/nu5ci134DqPJ8Unv2Vg1r+A1o89J3Adi255w
         vQc1M31qQEy7M/aCBT4HC9UhqZ4kpTFcStwhCTs8fFR/SEKpE8JzU67do8mVpafb52wR
         TAWg==
X-Gm-Message-State: APjAAAWlXE5FHPwrSFQ8hNjRerRg3fZi4/QUozy7Wr0QnqbAWLnSYm2c
        X53+G4dk2A4CoLX6cnXNb43hKA==
X-Google-Smtp-Source: APXvYqxBqtx8iA2DT4qIA5nj1lktg2CQY6/O9s2mldV+OZ5S9h9gqqGn4i0CA56hzavR1lMONxwQhA==
X-Received: by 2002:a17:902:c58e:: with SMTP id p14mr32342459plx.202.1575945835911;
        Mon, 09 Dec 2019 18:43:55 -0800 (PST)
Received: from localhost.localdomain ([240e:362:417:e00:ed89:9d55:8cd5:6d38])
        by smtp.gmail.com with ESMTPSA id r6sm826422pfh.91.2019.12.09.18.43.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 09 Dec 2019 18:43:55 -0800 (PST)
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        jonathan.cameron@huawei.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org
Cc:     linux-accelerators@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [RESEND PATCH v9 3/4] crypto: hisilicon - Remove module_param uacce_mode
Date:   Tue, 10 Dec 2019 10:42:34 +0800
Message-Id: <1575945755-27380-4-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575945755-27380-1-git-send-email-zhangfei.gao@linaro.org>
References: <1575945755-27380-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the module_param uacce_mode, which is not used currently.

Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index e1bab1a..93345f0 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -297,9 +297,6 @@ static u32 pf_q_num = HZIP_PF_DEF_Q_NUM;
 module_param_cb(pf_q_num, &pf_q_num_ops, &pf_q_num, 0444);
 MODULE_PARM_DESC(pf_q_num, "Number of queues in PF(v1 1-4096, v2 1-1024)");
 
-static int uacce_mode;
-module_param(uacce_mode, int, 0);
-
 static u32 vfs_num;
 module_param(vfs_num, uint, 0444);
 MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63)");
@@ -791,6 +788,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, hisi_zip);
 
 	qm = &hisi_zip->qm;
+	qm->use_dma_api = true;
 	qm->pdev = pdev;
 	qm->ver = rev_id;
 
@@ -798,20 +796,6 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1010,12 +994,10 @@ static int __init hisi_zip_init(void)
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
@@ -1030,8 +1012,7 @@ static int __init hisi_zip_init(void)
 
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

