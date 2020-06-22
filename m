Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6250C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 02:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D4C322210
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 02:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgFVCu5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 22:50:57 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58034 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726699AbgFVCu5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 22:50:57 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6A22DBA775458BE50315;
        Mon, 22 Jun 2020 10:50:55 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.201.106) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Mon, 22 Jun 2020 10:50:47 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <akpm@linux-foundation.org>,
        <linux-crypto@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH 2/3] crypto: hisilicon/zip - permit users to specify NUMA node
Date:   Mon, 22 Jun 2020 14:49:00 +1200
Message-ID: <20200622024901.12632-3-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20200622024901.12632-1-song.bao.hua@hisilicon.com>
References: <20200622024901.12632-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.201.106]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If users don't specify NUMA node, the driver will use the ZIP module near
the CPU allocating acomp. Otherwise, it uses the ZIP module according to
the requirement of users.

Cc: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip.h        | 2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c | 6 +++---
 drivers/crypto/hisilicon/zip/zip_main.c   | 5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index f3ed4c0e5493..4484be13812b 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -76,7 +76,7 @@ struct hisi_zip_sqe {
 	u32 rsvd1[4];
 };
 
-int zip_create_qps(struct hisi_qp **qps, int ctx_num);
+int zip_create_qps(struct hisi_qp **qps, int ctx_num, int node);
 int hisi_zip_register_to_crypto(void);
 void hisi_zip_unregister_from_crypto(void);
 #endif
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index c73707c2e539..01fd6a78111d 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -158,13 +158,13 @@ static void hisi_zip_release_qp(struct hisi_zip_qp_ctx *ctx)
 	hisi_qm_release_qp(ctx->qp);
 }
 
-static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type)
+static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int node)
 {
 	struct hisi_qp *qps[HZIP_CTX_Q_NUM] = { NULL };
 	struct hisi_zip *hisi_zip;
 	int ret, i, j;
 
-	ret = zip_create_qps(qps, HZIP_CTX_Q_NUM);
+	ret = zip_create_qps(qps, HZIP_CTX_Q_NUM, node);
 	if (ret) {
 		pr_err("Can not create zip qps!\n");
 		return -ENODEV;
@@ -379,7 +379,7 @@ static int hisi_zip_acomp_init(struct crypto_acomp *tfm)
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(&tfm->base);
 	int ret;
 
-	ret = hisi_zip_ctx_init(ctx, COMP_NAME_TO_TYPE(alg_name));
+	ret = hisi_zip_ctx_init(ctx, COMP_NAME_TO_TYPE(alg_name), tfm->base.node);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 2229a21ae7c8..e2845b2c963d 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -234,9 +234,10 @@ static const struct pci_device_id hisi_zip_dev_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
 
-int zip_create_qps(struct hisi_qp **qps, int qp_num)
+int zip_create_qps(struct hisi_qp **qps, int qp_num, int node)
 {
-	int node = cpu_to_node(smp_processor_id());
+	if (node == NUMA_NO_NODE)
+		node = cpu_to_node(smp_processor_id());
 
 	return hisi_qm_alloc_qps_node(&zip_devices, qp_num, 0, node, qps);
 }
-- 
2.27.0


