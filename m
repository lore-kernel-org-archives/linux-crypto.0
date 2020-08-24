Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63E4C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 03:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFF302078A
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 03:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgHXDO3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Aug 2020 23:14:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43150 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728005AbgHXDO2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Aug 2020 23:14:28 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A002B5F3E3C19C7C41B4;
        Mon, 24 Aug 2020 11:14:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Mon, 24 Aug 2020 11:14:16 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH RESEND 09/10] crypto: hisilicon/zip - supplement some comments
Date:   Mon, 24 Aug 2020 11:11:48 +0800
Message-ID: <1598238709-58699-10-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598238709-58699-1-git-send-email-shenyang39@huawei.com>
References: <1598238709-58699-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Supplement some comments.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 7697fa5..49fad18 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -285,7 +285,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	writel(HZIP_DECOMP_CHECK_ENABLE | HZIP_ALL_COMP_DECOMP_EN,
 	       base + HZIP_CLOCK_GATE_CTRL);
 
-	/* enable sqc writeback */
+	/* enable sqc,cqc writeback */
 	writel(SQC_CACHE_ENABLE | CQC_CACHE_ENABLE | SQC_CACHE_WB_ENABLE |
 	       CQC_CACHE_WB_ENABLE | FIELD_PREP(SQC_CACHE_WB_THRD, 1) |
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), base + QM_CACHE_CTL);
@@ -358,7 +358,7 @@ static int current_qm_write(struct ctrl_debug_file *file, u32 val)
 	if (val > qm->vfs_num)
 		return -EINVAL;
 
-	/* Calculate curr_qm_qp_num and store */
+	/* According PF or VF Dev ID to calculation curr_qm_qp_num and store */
 	if (val == 0) {
 		qm->debug.curr_qm_qp_num = qm->qp_num;
 	} else {
-- 
2.7.4

