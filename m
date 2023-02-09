Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAFBC61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 12:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjBIMhC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 07:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjBIMhB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 07:37:01 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9813457759;
        Thu,  9 Feb 2023 04:36:59 -0800 (PST)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PCGTb1SVmzJr0l;
        Thu,  9 Feb 2023 20:32:19 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 9 Feb 2023 20:36:56 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH v2 2/5] crypto: hisilicon/qm - use min() instead of min_t()
Date:   Thu, 9 Feb 2023 20:36:14 +0800
Message-ID: <20230209123617.30545-3-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230209123617.30545-1-qianweili@huawei.com>
References: <20230209123617.30545-1-qianweili@huawei.com>
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

'act_q_num = min_t(int, act_q_num, max_qp_num)', the type
of 'act_q_num' and 'max_qp_num' are both 'u32', so
use min() instead of min_t().

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 4e277168b48d..1f3dcdb934d2 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3493,7 +3493,7 @@ static int qm_vf_q_assign(struct hisi_qm *qm, u32 num_vfs)
 			act_q_num = q_num;
 		}
 
-		act_q_num = min_t(int, act_q_num, max_qp_num);
+		act_q_num = min(act_q_num, max_qp_num);
 		ret = hisi_qm_set_vft(qm, i, q_base, act_q_num);
 		if (ret) {
 			for (j = num_vfs; j > i; j--)
-- 
2.33.0

