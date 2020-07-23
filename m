Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0495C433F2
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA06D2080D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 07:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgGWHWE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 03:22:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8361 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726956AbgGWHWE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 03:22:04 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1CE4FF507321F7B980D2;
        Thu, 23 Jul 2020 15:21:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Jul 2020 15:21:45 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v3 09/10] crypto: hisilicon/qm - register callback function to 'pci_driver.shutdown'
Date:   Thu, 23 Jul 2020 15:19:39 +0800
Message-ID: <1595488780-22085-10-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595488780-22085-1-git-send-email-shenyang39@huawei.com>
References: <1595488780-22085-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since the drivers such as HPRE/SEC/ZIP do not implement
'pci_driver.shutdow', a RAS will be triggered at OS rebooting or shutting
down as the hardware device is processing request.
    The log looks like this:
     NOTICE:  [NimbusSecNodeType1]:[2372L]This is sec, Base = 0x141800000
     NOTICE:  [NimbusSecHandle]:[2319L] SecIntSt = 0x3
     NOTICE:  [NimbusSecHandle]:[2320L] SecQmIntStatus = 0x2
     NOTICE:  [PrintSecurityType]:[344L] SecurityType is RECOVERABLE!

This patch offers a new API in qm to shutdown devices, and add shutdown
callbacks in ACC driver based on this new API.

So the running devices will be stopped when the OS reboot or shutdown.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  1 +
 drivers/crypto/hisilicon/qm.c             | 17 +++++++++++++++++
 drivers/crypto/hisilicon/qm.h             |  1 +
 drivers/crypto/hisilicon/sec2/sec_main.c  |  1 +
 drivers/crypto/hisilicon/zip/zip_main.c   |  1 +
 5 files changed, 21 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 9bb6f5a..f3436f70 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -939,6 +939,7 @@ static struct pci_driver hpre_pci_driver = {
 	.sriov_configure	= IS_ENABLED(CONFIG_PCI_IOV) ?
 				  hisi_qm_sriov_configure : NULL,
 	.err_handler		= &hpre_err_handler,
+	.shutdown		= hisi_qm_dev_shutdown,
 };
 
 static void hpre_register_debugfs(void)
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index fa371ed..cc3a41c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3836,6 +3836,23 @@ static int qm_irq_register(struct hisi_qm *qm)
 	return ret;
 }
 
+/**
+ * hisi_qm_dev_shutdown() - Shutdown device.
+ * @pdev: The device will be shutdown.
+ *
+ * This function will stop qm when OS shutdown or rebooting.
+ */
+void hisi_qm_dev_shutdown(struct pci_dev *pdev)
+{
+	struct hisi_qm *qm = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = hisi_qm_stop(qm, QM_NORMAL);
+	if (ret)
+		dev_err(&pdev->dev, "Fail to stop qm in shutdown!\n");
+}
+EXPORT_SYMBOL_GPL(hisi_qm_dev_shutdown);
+
 static void hisi_qm_controller_reset(struct work_struct *rst_work)
 {
 	struct hisi_qm *qm = container_of(rst_work, struct hisi_qm, rst_work);
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index bd00897..233ed09e 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -378,4 +378,5 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num);
 int hisi_qm_alg_register(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
 void hisi_qm_alg_unregister(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
+void hisi_qm_dev_shutdown(struct pci_dev *pdev);
 #endif
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index e06172c..7751ab27 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -949,6 +949,7 @@ static struct pci_driver sec_pci_driver = {
 	.remove = sec_remove,
 	.err_handler = &sec_err_handler,
 	.sriov_configure = hisi_qm_sriov_configure,
+	.shutdown = hisi_qm_dev_shutdown,
 };
 
 static void sec_register_debugfs(void)
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 996d7ae..d8ed450 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -880,6 +880,7 @@ static struct pci_driver hisi_zip_pci_driver = {
 	.sriov_configure	= IS_ENABLED(CONFIG_PCI_IOV) ?
 					hisi_qm_sriov_configure : NULL,
 	.err_handler		= &hisi_zip_err_handler,
+	.shutdown		= hisi_qm_dev_shutdown,
 };
 
 static void hisi_zip_register_debugfs(void)
-- 
2.7.4

