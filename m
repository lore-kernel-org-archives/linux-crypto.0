Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA02FC04FDF
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 14:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbjHKOKy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 10:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjHKOKw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 10:10:52 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7152D72
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 07:10:51 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RMlxT6Y4XzqSgG
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 22:07:57 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 11 Aug 2023 22:10:49 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <shenyang39@huawei.com>,
        <liulongfang@huawei.com>, Weili Qian <qianweili@huawei.com>
Subject: [PATCH v2 7/7] crypto: hisilicon/qm - increase function communication waiting time
Date:   Fri, 11 Aug 2023 22:07:49 +0800
Message-ID: <20230811140749.5202-8-qianweili@huawei.com>
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

When multiple VFs, for example, 63, are enabled, the communication
between the PF and all VFs cannot be completed within the current
waiting time. Therefore, adjust waiting time more than the maximum
mailbox execution time.

Fixes: 3cd53a27c2fc ("crypto: hisilicon/qm - add callback to support communication")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a1539974f95a..5d633f774c83 100755
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -181,9 +181,9 @@
 #define QM_IFC_INT_DISABLE		BIT(0)
 #define QM_IFC_INT_STATUS_MASK		BIT(0)
 #define QM_IFC_INT_SET_MASK		BIT(0)
-#define QM_WAIT_DST_ACK			10
-#define QM_MAX_PF_WAIT_COUNT		10
-#define QM_MAX_VF_WAIT_COUNT		40
+#define QM_WAIT_DST_ACK			100
+#define QM_MAX_PF_WAIT_COUNT		50
+#define QM_MAX_VF_WAIT_COUNT		100
 #define QM_VF_RESET_WAIT_US            20000
 #define QM_VF_RESET_WAIT_CNT           3000
 #define QM_VF_RESET_WAIT_TIMEOUT_US    \
-- 
2.33.0

