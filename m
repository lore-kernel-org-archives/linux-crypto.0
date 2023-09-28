Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F22CE7B10
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Sep 2023 09:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjI1JYf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Sep 2023 05:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbjI1JYe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Sep 2023 05:24:34 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CDFAC;
        Thu, 28 Sep 2023 02:24:32 -0700 (PDT)
Received: from kwepemm000009.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Rx7Hq3DJrzNnyN;
        Thu, 28 Sep 2023 17:20:39 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm000009.china.huawei.com (7.193.23.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 28 Sep 2023 17:24:29 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liulongfang@huawei.com>, Weili Qian <qianweili@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - fix the type value of aeq
Date:   Thu, 28 Sep 2023 17:21:03 +0800
Message-ID: <20230928092103.49587-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000009.china.huawei.com (7.193.23.227)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The type of aeq has only 4bits in dw0 17 to 20bits, but 15bits(17 to
31bits) are read in function qm_aeq_thread(). The remaining 11bits(21
to 31bits) are reserved for aeq, but may not be 0. To avoid getting
incorrect value of type, other bits are cleared.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 1638c0a7df31..458d1fe42a24 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -69,6 +69,7 @@
 
 #define QM_AEQE_PHASE(aeqe)		((le32_to_cpu((aeqe)->dw0) >> 16) & 0x1)
 #define QM_AEQE_TYPE_SHIFT		17
+#define QM_AEQE_TYPE_MASK		0xf
 #define QM_AEQE_CQN_MASK		GENMASK(15, 0)
 #define QM_CQ_OVERFLOW			0
 #define QM_EQ_OVERFLOW			1
@@ -1024,7 +1025,8 @@ static irqreturn_t qm_aeq_thread(int irq, void *data)
 	u32 type, qp_id;
 
 	while (QM_AEQE_PHASE(aeqe) == qm->status.aeqc_phase) {
-		type = le32_to_cpu(aeqe->dw0) >> QM_AEQE_TYPE_SHIFT;
+		type = (le32_to_cpu(aeqe->dw0) >> QM_AEQE_TYPE_SHIFT) &
+			QM_AEQE_TYPE_MASK;
 		qp_id = le32_to_cpu(aeqe->dw0) & QM_AEQE_CQN_MASK;
 
 		switch (type) {
-- 
2.33.0

