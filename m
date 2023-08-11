Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F053C04A94
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 14:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjHKOKy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 10:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbjHKOKw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 10:10:52 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946112709
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 07:10:51 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RMlzM2kgWz1GDDq
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 22:09:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 22:10:48 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <shenyang39@huawei.com>,
        <liulongfang@huawei.com>, Weili Qian <qianweili@huawei.com>
Subject: [PATCH v2 6/7] crypto: hisilicon/qm - fix the type value of aeq
Date:   Fri, 11 Aug 2023 22:07:48 +0800
Message-ID: <20230811140749.5202-7-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230811140749.5202-1-qianweili@huawei.com>
References: <20230811140749.5202-1-qianweili@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The type of aeq has only 17 to 20 bits, but 17 to 31 bits are read in
function qm_aeq_thread(), fix it.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c9ed30b181bb..a1539974f95a 100755
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -73,6 +73,7 @@
 
 #define QM_AEQE_PHASE(aeqe)		((le32_to_cpu((aeqe)->dw0) >> 16) & 0x1)
 #define QM_AEQE_TYPE_SHIFT		17
+#define QM_AEQE_TYPE_MASK		0xf
 #define QM_AEQE_CQN_MASK		GENMASK(15, 0)
 #define QM_CQ_OVERFLOW			0
 #define QM_EQ_OVERFLOW			1
@@ -1137,7 +1138,8 @@ static irqreturn_t qm_aeq_thread(int irq, void *data)
 	u32 type, qp_id;
 
 	while (QM_AEQE_PHASE(aeqe) == qm->status.aeqc_phase) {
-		type = le32_to_cpu(aeqe->dw0) >> QM_AEQE_TYPE_SHIFT;
+		type = (le32_to_cpu(aeqe->dw0) >> QM_AEQE_TYPE_SHIFT) &
+			QM_AEQE_TYPE_MASK;
 		qp_id = le32_to_cpu(aeqe->dw0) & QM_AEQE_CQN_MASK;
 
 		switch (type) {
-- 
2.33.0

