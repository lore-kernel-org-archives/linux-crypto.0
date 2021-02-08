Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9806C433E9
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D89564E9A
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhBHJsR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:48:17 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12495 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhBHJp1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:45:27 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DZ1GJ1qLQzjL25;
        Mon,  8 Feb 2021 17:40:08 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 17:41:19 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <tudor.ambarus@microchip.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 2/9] crypto: hisilicon/hpre - add algorithm type
Date:   Mon, 8 Feb 2021 17:38:50 +0800
Message-ID: <1612777137-51067-3-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
References: <1612777137-51067-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Algorithm type is brought in to get hardware HPRE queue
to support different algorithms.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h        | 10 +++++++++-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 12 ++++++------
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 11 +++++++++--
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index e784712..7c7bfdd 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -10,6 +10,14 @@
 #define HPRE_PF_DEF_Q_NUM		64
 #define HPRE_PF_DEF_Q_BASE		0
 
+/*
+ * type used in qm sqc DW6.
+ * 0 - Algorithm which has been supported in V2, like RSA, DH and so on;
+ * 1 - ECC algorithm in V3.
+ */
+#define HPRE_V2_ALG_TYPE	0
+#define HPRE_V3_ECC_ALG_TYPE	1
+
 enum {
 	HPRE_CLUSTER0,
 	HPRE_CLUSTER1,
@@ -90,7 +98,7 @@ struct hpre_sqe {
 	__le32 rsvd1[_HPRE_SQE_ALIGN_EXT];
 };
 
-struct hisi_qp *hpre_create_qp(void);
+struct hisi_qp *hpre_create_qp(u8 type);
 int hpre_algs_register(struct hisi_qm *qm);
 void hpre_algs_unregister(struct hisi_qm *qm);
 
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index d89b2f5..712bea9 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -152,12 +152,12 @@ static void hpre_rm_req_from_ctx(struct hpre_asym_request *hpre_req)
 	}
 }
 
-static struct hisi_qp *hpre_get_qp_and_start(void)
+static struct hisi_qp *hpre_get_qp_and_start(u8 type)
 {
 	struct hisi_qp *qp;
 	int ret;
 
-	qp = hpre_create_qp();
+	qp = hpre_create_qp(type);
 	if (!qp) {
 		pr_err("Can not create hpre qp!\n");
 		return ERR_PTR(-ENODEV);
@@ -422,11 +422,11 @@ static void hpre_alg_cb(struct hisi_qp *qp, void *resp)
 	req->cb(ctx, resp);
 }
 
-static int hpre_ctx_init(struct hpre_ctx *ctx)
+static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
 {
 	struct hisi_qp *qp;
 
-	qp = hpre_get_qp_and_start();
+	qp = hpre_get_qp_and_start(type);
 	if (IS_ERR(qp))
 		return PTR_ERR(qp);
 
@@ -674,7 +674,7 @@ static int hpre_dh_init_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
-	return hpre_ctx_init(ctx);
+	return hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
 }
 
 static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
@@ -1100,7 +1100,7 @@ static int hpre_rsa_init_tfm(struct crypto_akcipher *tfm)
 		return PTR_ERR(ctx->rsa.soft_tfm);
 	}
 
-	ret = hpre_ctx_init(ctx);
+	ret = hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
 	if (ret)
 		crypto_free_akcipher(ctx->rsa.soft_tfm);
 
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 3b3481e..e492103 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -218,13 +218,20 @@ static u32 vfs_num;
 module_param_cb(vfs_num, &vfs_num_ops, &vfs_num, 0444);
 MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63), 0(default)");
 
-struct hisi_qp *hpre_create_qp(void)
+struct hisi_qp *hpre_create_qp(u8 type)
 {
 	int node = cpu_to_node(smp_processor_id());
 	struct hisi_qp *qp = NULL;
 	int ret;
 
-	ret = hisi_qm_alloc_qps_node(&hpre_devices, 1, 0, node, &qp);
+	if (type != HPRE_V2_ALG_TYPE && type != HPRE_V3_ECC_ALG_TYPE)
+		return NULL;
+
+	/*
+	 * type: 0 - RSA/DH. algorithm supported in V2,
+	 *       1 - ECC algorithm in V3.
+	 */
+	ret = hisi_qm_alloc_qps_node(&hpre_devices, 1, type, node, &qp);
 	if (!ret)
 		return qp;
 
-- 
2.8.1

