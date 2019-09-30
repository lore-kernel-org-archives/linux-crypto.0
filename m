Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DB0C4360C
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 07:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAB8021855
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 07:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfI3HMx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 03:12:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3178 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729525AbfI3HMw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 03:12:52 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 405692E7C6CBD5C69828;
        Mon, 30 Sep 2019 15:12:19 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Mon, 30 Sep 2019 15:12:11 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Shukun Tan <tanshukun1@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH 2/4] crypto: hisilicon - add sgl_sge_nr module param for zip
Date:   Mon, 30 Sep 2019 15:08:53 +0800
Message-ID: <1569827335-21822-3-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1569827335-21822-1-git-send-email-wangzhou1@hisilicon.com>
References: <1569827335-21822-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Shukun Tan <tanshukun1@huawei.com>

Add a module parameter for zip driver to set the number of SGE in one SGL.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.h             |  2 ++
 drivers/crypto/hisilicon/sgl.c            |  2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c | 26 +++++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 978d2ae..103e2fd 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -75,6 +75,8 @@
 
 #define QM_Q_DEPTH			1024
 
+#define HISI_ACC_SGL_SGE_NR_MAX		255
+
 enum qp_state {
 	QP_STOP,
 };
diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 81a9040..f71de0d 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -3,9 +3,9 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include "qm.h"
 
 #define HISI_ACC_SGL_SGE_NR_MIN		1
-#define HISI_ACC_SGL_SGE_NR_MAX		255
 #define HISI_ACC_SGL_NR_MAX		256
 #define HISI_ACC_SGL_ALIGN_SIZE		64
 
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index a82bee5..9d31b80 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -79,6 +79,30 @@ struct hisi_zip_ctx {
 	struct hisi_zip_qp_ctx qp_ctx[HZIP_CTX_Q_NUM];
 };
 
+static int sgl_sge_nr_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	u16 n;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtou16(val, 10, &n);
+	if (ret || n == 0 || n > HISI_ACC_SGL_SGE_NR_MAX)
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
+static const struct kernel_param_ops sgl_sge_nr_ops = {
+	.set = sgl_sge_nr_set,
+	.get = param_get_int,
+};
+
+static u16 sgl_sge_nr = HZIP_SGL_SGE_NR;
+module_param_cb(sgl_sge_nr, &sgl_sge_nr_ops, &sgl_sge_nr, 0444);
+MODULE_PARM_DESC(sgl_sge_nr, "Number of sge in sgl(1-255)");
+
 static void hisi_zip_config_buf_type(struct hisi_zip_sqe *sqe, u8 buf_type)
 {
 	u32 val;
@@ -273,7 +297,7 @@ static int hisi_zip_create_sgl_pool(struct hisi_zip_ctx *ctx)
 		tmp = &ctx->qp_ctx[i];
 		dev = &tmp->qp->qm->pdev->dev;
 		tmp->sgl_pool = hisi_acc_create_sgl_pool(dev, QM_Q_DEPTH << 1,
-							 HZIP_SGL_SGE_NR);
+							 sgl_sge_nr);
 		if (IS_ERR(tmp->sgl_pool)) {
 			if (i == 1)
 				goto err_free_sgl_pool0;
-- 
2.8.1

