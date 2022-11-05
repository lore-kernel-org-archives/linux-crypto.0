Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A0D6C4321E
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Nov 2022 10:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiKEKAB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Nov 2022 06:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiKEKAA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Nov 2022 06:00:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279D9193F6;
        Sat,  5 Nov 2022 02:59:59 -0700 (PDT)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N4Cf16dn5zRnsC;
        Sat,  5 Nov 2022 17:59:53 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 5 Nov 2022 17:59:57 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 5 Nov
 2022 17:59:57 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 4/4] crypto: hisilicon/debugfs - delete redundant null assignment operations
Date:   Sat, 5 Nov 2022 09:53:57 +0000
Message-ID: <20221105095357.21199-5-yekai13@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221105095357.21199-1-yekai13@huawei.com>
References: <20221105095357.21199-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There is no security data in the pointer. It is only a value transferred
as a structure. So not need to set the pointer to null.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index 9f1bfabd7ae2..bcd5cdaea736 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -822,7 +822,6 @@ static void dfx_regs_uninit(struct hisi_qm *qm,
 		dregs[i].regs = NULL;
 	}
 	kfree(dregs);
-	dregs = NULL;
 }
 
 static struct dfx_diff_registers *dfx_regs_init(struct hisi_qm *qm,
-- 
2.17.1

