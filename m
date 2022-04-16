Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B4CC433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Apr 2022 10:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiDPKyU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Apr 2022 06:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiDPKyT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Apr 2022 06:54:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96D43A5CF;
        Sat, 16 Apr 2022 03:51:47 -0700 (PDT)
Received: from kwepemi100009.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KgVPX2DsdzgYv5;
        Sat, 16 Apr 2022 18:51:44 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 kwepemi100009.china.huawei.com (7.221.188.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 18:51:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 18:51:45 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon/qm - set function with static
Date:   Sat, 16 Apr 2022 18:45:57 +0800
Message-ID: <20220416104559.10826-3-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220416104559.10826-1-qianweili@huawei.com>
References: <20220416104559.10826-1-qianweili@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

These functions 'hisi_qm_create_qp' and 'hisi_qm_set_vft' are not
used outside qm.c, so they are marked as static.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 6 ++----
 include/linux/hisi_acc_qm.h   | 2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 009132333d2b..582220178ec8 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2660,7 +2660,7 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
  * return created qp, -EBUSY if all qps in qm allocated, -ENOMEM if allocating
  * qp memory fails.
  */
-struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
+static struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
 {
 	struct hisi_qp *qp;
 	int ret;
@@ -2678,7 +2678,6 @@ struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
 
 	return qp;
 }
-EXPORT_SYMBOL_GPL(hisi_qm_create_qp);
 
 /**
  * hisi_qm_release_qp() - Release a qp back to its qm.
@@ -3550,7 +3549,7 @@ EXPORT_SYMBOL_GPL(hisi_qm_uninit);
  *
  * qm hw v1 does not support this interface.
  */
-int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number)
+static int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number)
 {
 	if (!base || !number)
 		return -EINVAL;
@@ -3562,7 +3561,6 @@ int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number)
 
 	return qm->ops->get_vft(qm, base, number);
 }
-EXPORT_SYMBOL_GPL(hisi_qm_get_vft);
 
 /**
  * hisi_qm_set_vft() - Set vft to a qm.
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 0b1585bc37f9..6fabfba014dd 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -433,13 +433,11 @@ int hisi_qm_init(struct hisi_qm *qm);
 void hisi_qm_uninit(struct hisi_qm *qm);
 int hisi_qm_start(struct hisi_qm *qm);
 int hisi_qm_stop(struct hisi_qm *qm, enum qm_stop_reason r);
-struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type);
 int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg);
 int hisi_qm_stop_qp(struct hisi_qp *qp);
 void hisi_qm_release_qp(struct hisi_qp *qp);
 int hisi_qp_send(struct hisi_qp *qp, const void *msg);
 int hisi_qm_get_free_qp_num(struct hisi_qm *qm);
-int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number);
 void hisi_qm_debug_init(struct hisi_qm *qm);
 void hisi_qm_debug_regs_clear(struct hisi_qm *qm);
 int hisi_qm_sriov_enable(struct pci_dev *pdev, int max_vfs);
-- 
2.33.0

