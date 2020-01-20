Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA16C33CA1
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD332077C
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 07:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgATHaY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 02:30:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:43072 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbgATHaY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 02:30:24 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C58CA76E02C39FD2C868;
        Mon, 20 Jan 2020 15:30:22 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 20 Jan 2020 15:30:12 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH 4/4] crypto: hisilicon: Fix duplicate print when qm occur multiple errors
Date:   Mon, 20 Jan 2020 15:30:09 +0800
Message-ID: <1579505409-3776-5-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579505409-3776-1-git-send-email-tanshukun1@huawei.com>
References: <1579505409-3776-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If all possible errors occurs at the same time, the error_status will be
all 1s. The doorbell timeout error and FIFO overflow error will be print
in each cycle, which should be print just once.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 59 ++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2c0e22f..79f84dc6 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1019,41 +1019,38 @@ static void qm_hw_error_uninit_v2(struct hisi_qm *qm)
 
 static void qm_log_hw_error(struct hisi_qm *qm, u32 error_status)
 {
-	const struct hisi_qm_hw_error *err = qm_hw_error;
+	const struct hisi_qm_hw_error *err;
 	struct device *dev = &qm->pdev->dev;
 	u32 reg_val, type, vf_num;
+	int i;
 
-	while (err->msg) {
-		if (err->int_msk & error_status) {
-			dev_err(dev, "%s [error status=0x%x] found\n",
-				err->msg, err->int_msk);
-
-			if (error_status & QM_DB_TIMEOUT) {
-				reg_val = readl(qm->io_base +
-						QM_ABNORMAL_INF01);
-				type = (reg_val & QM_DB_TIMEOUT_TYPE) >>
-				       QM_DB_TIMEOUT_TYPE_SHIFT;
-				vf_num = reg_val & QM_DB_TIMEOUT_VF;
-				dev_err(dev, "qm %s doorbell timeout in function %u\n",
-					qm_db_timeout[type], vf_num);
-			}
-
-			if (error_status & QM_OF_FIFO_OF) {
-				reg_val = readl(qm->io_base +
-						QM_ABNORMAL_INF00);
-				type = (reg_val & QM_FIFO_OVERFLOW_TYPE) >>
-				       QM_FIFO_OVERFLOW_TYPE_SHIFT;
-				vf_num = reg_val & QM_FIFO_OVERFLOW_VF;
-
-				if (type < ARRAY_SIZE(qm_fifo_overflow))
-					dev_err(dev, "qm %s fifo overflow in function %u\n",
-						qm_fifo_overflow[type],
-						vf_num);
-				else
-					dev_err(dev, "unknown error type\n");
-			}
+	for (i = 0; i < ARRAY_SIZE(qm_hw_error); i++) {
+		err = &qm_hw_error[i];
+		if (!(err->int_msk & error_status))
+			continue;
+
+		dev_err(dev, "%s [error status=0x%x] found\n",
+			err->msg, err->int_msk);
+
+		if (err->int_msk & QM_DB_TIMEOUT) {
+			reg_val = readl(qm->io_base + QM_ABNORMAL_INF01);
+			type = (reg_val & QM_DB_TIMEOUT_TYPE) >>
+			       QM_DB_TIMEOUT_TYPE_SHIFT;
+			vf_num = reg_val & QM_DB_TIMEOUT_VF;
+			dev_err(dev, "qm %s doorbell timeout in function %u\n",
+				qm_db_timeout[type], vf_num);
+		} else if (err->int_msk & QM_OF_FIFO_OF) {
+			reg_val = readl(qm->io_base + QM_ABNORMAL_INF00);
+			type = (reg_val & QM_FIFO_OVERFLOW_TYPE) >>
+			       QM_FIFO_OVERFLOW_TYPE_SHIFT;
+			vf_num = reg_val & QM_FIFO_OVERFLOW_VF;
+
+			if (type < ARRAY_SIZE(qm_fifo_overflow))
+				dev_err(dev, "qm %s fifo overflow in function %u\n",
+					qm_fifo_overflow[type], vf_num);
+			else
+				dev_err(dev, "unknown error type\n");
 		}
-		err++;
 	}
 }
 
-- 
2.7.4

