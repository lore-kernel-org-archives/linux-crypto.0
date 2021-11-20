Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE085C433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbhKTEw4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:52:56 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:28161 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbhKTEwz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:52:55 -0500
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hx1Hl6jLVz8vQX;
        Sat, 20 Nov 2021 12:48:03 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 20 Nov 2021 12:49:50 +0800
Received: from huawei.com (10.69.192.56) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 20 Nov
 2021 12:49:50 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon/qm - some optimizations of ths qos write process
Date:   Sat, 20 Nov 2021 12:47:38 +0800
Message-ID: <20211120044739.5667-4-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211120044739.5667-1-yekai13@huawei.com>
References: <20211120044739.5667-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Optimize overly long functions.
2. Fix the format symbol does not match the actual type.
3. Use the PCI_DEVFN to get the function id.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 87 ++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b5837e8b2ab4..88e638491e8f 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4231,66 +4231,69 @@ static ssize_t qm_qos_value_init(const char *buf, unsigned long *val)
 	return 0;
 }
 
+static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
+			       unsigned long *val,
+			       unsigned int *fun_index)
+{
+	char tbuf_bdf[QM_DBG_READ_LEN] = {0};
+	char val_buf[QM_QOS_VAL_MAX_LEN] = {0};
+	u32 tmp1, device, function;
+	int ret, bus;
+
+	ret = sscanf(buf, "%s %s", tbuf_bdf, val_buf);
+	if (ret != QM_QOS_PARAM_NUM)
+		return -EINVAL;
+
+	ret = qm_qos_value_init(val_buf, val);
+	if (*val == 0 || *val > QM_QOS_MAX_VAL || ret) {
+		pci_err(qm->pdev, "input qos value is error, please set 1~1000!\n");
+		return -EINVAL;
+	}
+
+	ret = sscanf(tbuf_bdf, "%u:%x:%u.%u", &tmp1, &bus, &device, &function);
+	if (ret != QM_QOS_BDF_PARAM_NUM) {
+		pci_err(qm->pdev, "input pci bdf value is error!\n");
+		return -EINVAL;
+	}
+
+	*fun_index = PCI_DEVFN(device, function);
+
+	return 0;
+}
+
 static ssize_t qm_algqos_write(struct file *filp, const char __user *buf,
 			       size_t count, loff_t *pos)
 {
 	struct hisi_qm *qm = filp->private_data;
 	char tbuf[QM_DBG_READ_LEN];
-	int tmp1, bus, device, function;
-	char tbuf_bdf[QM_DBG_READ_LEN] = {0};
-	char val_buf[QM_QOS_VAL_MAX_LEN] = {0};
 	unsigned int fun_index;
-	unsigned long val = 0;
+	unsigned long val;
 	int len, ret;
 
 	if (qm->fun_type == QM_HW_VF)
 		return -EINVAL;
 
-	/* Mailbox and reset cannot be operated at the same time */
-	if (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
-		pci_err(qm->pdev, "dev resetting, write alg qos failed!\n");
-		return -EAGAIN;
-	}
-
-	if (*pos != 0) {
-		ret = 0;
-		goto err_get_status;
-	}
+	if (*pos != 0)
+		return 0;
 
-	if (count >= QM_DBG_READ_LEN) {
-		ret = -ENOSPC;
-		goto err_get_status;
-	}
+	if (count >= QM_DBG_READ_LEN)
+		return -ENOSPC;
 
 	len = simple_write_to_buffer(tbuf, QM_DBG_READ_LEN - 1, pos, buf, count);
-	if (len < 0) {
-		ret = len;
-		goto err_get_status;
-	}
+	if (len < 0)
+		return len;
 
 	tbuf[len] = '\0';
-	ret = sscanf(tbuf, "%s %s", tbuf_bdf, val_buf);
-	if (ret != QM_QOS_PARAM_NUM) {
-		ret = -EINVAL;
-		goto err_get_status;
-	}
-
-	ret = qm_qos_value_init(val_buf, &val);
-	if (val == 0 || val > QM_QOS_MAX_VAL || ret) {
-		pci_err(qm->pdev, "input qos value is error, please set 1~1000!\n");
-		ret = -EINVAL;
-		goto err_get_status;
-	}
+	ret = qm_get_qos_value(qm, tbuf, &val, &fun_index);
+	if (ret)
+		return ret;
 
-	ret = sscanf(tbuf_bdf, "%d:%x:%d.%d", &tmp1, &bus, &device, &function);
-	if (ret != QM_QOS_BDF_PARAM_NUM) {
-		pci_err(qm->pdev, "input pci bdf value is error!\n");
-		ret = -EINVAL;
-		goto err_get_status;
+	/* Mailbox and reset cannot be operated at the same time */
+	if (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
+		pci_err(qm->pdev, "dev resetting, write alg qos failed!\n");
+		return -EAGAIN;
 	}
 
-	fun_index = device * 8 + function;
-
 	ret = qm_pm_get_sync(qm);
 	if (ret) {
 		ret = -EINVAL;
@@ -4304,6 +4307,8 @@ static ssize_t qm_algqos_write(struct file *filp, const char __user *buf,
 		goto err_put_sync;
 	}
 
+	pci_info(qm->pdev, "the qos value of function%u is set to %lu.\n",
+		 fun_index, val);
 	ret = count;
 
 err_put_sync:
-- 
2.33.0

