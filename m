Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15ABFC55185
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 02:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED9672077D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 02:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDWCQc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 22:16:32 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:41808 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgDWCQc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 22:16:32 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C7611C999EA6A38D239B;
        Thu, 23 Apr 2020 10:16:28 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Thu, 23 Apr 2020 10:16:19 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <wangzhou1@hisilicon.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] crypto: hisilicon/qm - Make qm_controller_reset() static
Date:   Thu, 23 Apr 2020 10:22:36 +0800
Message-ID: <1587608556-113975-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix the following sparse warning:

drivers/crypto/hisilicon/qm.c:3079:5: warning: symbol 'qm_controller_reset'
was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 80c5525..69d02cb 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3076,7 +3076,7 @@ static int qm_controller_reset_done(struct hisi_qm *qm)
 	return 0;
 }
 
-int qm_controller_reset(struct hisi_qm *qm)
+static int qm_controller_reset(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
-- 
2.6.2

