Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21152C61DA4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Feb 2023 09:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjBCJiM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Feb 2023 04:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjBCJiK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2023 04:38:10 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FD14C29;
        Fri,  3 Feb 2023 01:38:08 -0800 (PST)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4P7Vrx54vDz16MkV;
        Fri,  3 Feb 2023 17:36:01 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 3 Feb 2023 17:38:06 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 2/5] crypto: hisilicon/qm - change data type in min_t
Date:   Fri, 3 Feb 2023 17:37:27 +0800
Message-ID: <20230203093730.49314-3-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230203093730.49314-1-qianweili@huawei.com>
References: <20230203093730.49314-1-qianweili@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

'act_q_num = min_t(int, act_q_num, max_qp_num)', 'act_q_num'
and 'max_qp_num' are 'u32' type, change min_t() to use 'u32'
type instead of 'int'.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 4e277168b48d..c440d79f2e84 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3493,7 +3493,7 @@ static int qm_vf_q_assign(struct hisi_qm *qm, u32 num_vfs)
 			act_q_num = q_num;
 		}
 
-		act_q_num = min_t(int, act_q_num, max_qp_num);
+		act_q_num = min_t(u32, act_q_num, max_qp_num);
 		ret = hisi_qm_set_vft(qm, i, q_base, act_q_num);
 		if (ret) {
 			for (j = num_vfs; j > i; j--)
-- 
2.33.0

