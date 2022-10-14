Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293DFC43219
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Oct 2022 09:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiJNJnw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Oct 2022 05:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJNJnv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2022 05:43:51 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA1C14DF05;
        Fri, 14 Oct 2022 02:43:50 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MphDH5zTbz1P7CB;
        Fri, 14 Oct 2022 17:39:11 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 14 Oct 2022 17:43:48 +0800
Received: from huawei.com (10.67.165.24) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 14 Oct
 2022 17:43:48 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 3/3] crypto: hisilicon/qm - delete redundancy check
Date:   Fri, 14 Oct 2022 09:38:07 +0000
Message-ID: <20221014093807.3101-4-yekai13@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221014093807.3101-1-yekai13@huawei.com>
References: <20221014093807.3101-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Because the permission on the VF debugfs file is "0444". So
the VF function checking is redundant in qos writing api.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 661cc964e2eb..318896df1f89 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4634,9 +4634,6 @@ static ssize_t qm_algqos_write(struct file *filp, const char __user *buf,
 	unsigned long val;
 	int len, ret;
 
-	if (qm->fun_type == QM_HW_VF)
-		return -EINVAL;
-
 	if (*pos != 0)
 		return 0;
 
-- 
2.33.0

