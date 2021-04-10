Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7965C433B4
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Apr 2021 09:53:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1560610C8
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Apr 2021 09:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhDJJxq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Apr 2021 05:53:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15660 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhDJJxp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Apr 2021 05:53:45 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FHVcJ2whfzpWJG;
        Sat, 10 Apr 2021 17:50:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Sat, 10 Apr 2021 17:53:21 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] crypto: hisilicon/hpre - delete redundant log and return in advance
Date:   Sat, 10 Apr 2021 17:50:32 +0800
Message-ID: <1618048232-12634-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

'hpre_cfg_by_dsm' has checked and printed error path internally. It is not
necessary to do it here, so remove it.

It should return error immediately when return value of 'hpre_cfg_by_dsm'
is non-zero, and no need to execute the remaining sentences.

Signed-off-by: Hui Tang <tanghui20@huawei.com>

---
v1 -> v2:
   - Return immediately when return value of 'hpre_cfg_by_dsm' is
     non-zero.
v2 -> v3:
   - Add description for return if function fails.
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index a8c7921..264684a 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -384,7 +384,7 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	if (qm->ver == QM_HW_V2) {
 		ret = hpre_cfg_by_dsm(qm);
 		if (ret)
-			dev_err(dev, "acpi_evaluate_dsm err.\n");
+			return ret;
 
 		disable_flr_of_bme(qm);
 	}
-- 
2.8.1

