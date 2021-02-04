Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226A0C433E9
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 09:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E9D64F4D
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 09:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhBDJDX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 04:03:23 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12024 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbhBDJCq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 04:02:46 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DWXZc2vYMzjJlJ;
        Thu,  4 Feb 2021 17:00:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 17:01:50 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <tanghui20@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] crypto: hisilicon/hpre - tiny fix
Date:   Thu, 4 Feb 2021 16:59:34 +0800
Message-ID: <1612429176-28084-3-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612429176-28084-1-git-send-email-tanghui20@huawei.com>
References: <1612429176-28084-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update since some special settings only for Kunpeng920.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 0045261..06448b8 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -318,7 +318,7 @@ static int hpre_set_cluster(struct hisi_qm *qm)
 }

 /*
- * For Hi1620, we shoul disable FLR triggered by hardware (BME/PM/SRIOV).
+ * For Kunpeng 920, we shoul disable FLR triggered by hardware (BME/PM/SRIOV).
  * Or it may stay in D3 state when we bind and unbind hpre quickly,
  * as it does FLR triggered by hardware.
  */
@@ -376,11 +376,14 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	if (ret)
 		return -ETIMEDOUT;

-	ret = hpre_cfg_by_dsm(qm);
-	if (ret)
-		dev_err(dev, "acpi_evaluate_dsm err.\n");
+	/* This setting is only needed by Kunpeng 920. */
+	if (qm->ver == QM_HW_V2) {
+		ret = hpre_cfg_by_dsm(qm);
+		if (ret)
+			dev_err(dev, "acpi_evaluate_dsm err.\n");

-	disable_flr_of_bme(qm);
+		disable_flr_of_bme(qm);
+	}

 	return ret;
 }
--
2.8.1

