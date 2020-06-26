Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05849C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 10:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2F7720781
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 10:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgFZKct (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 06:32:49 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6831 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727883AbgFZKcs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 06:32:48 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8AAF1D5B52831880FB40
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jun 2020 18:32:43 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 26 Jun 2020
 18:32:39 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH 1/5] crypto: hisilicon/sec2 - clear SEC debug regs
Date:   Fri, 26 Jun 2020 18:32:05 +0800
Message-ID: <1593167529-22463-2-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
References: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

SEC debug registers aren't cleared even if its driver is removed,
so add a clearing operation in driver removing.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Reviewed-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index a4cb58b..c2567cc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -346,10 +346,17 @@ static int sec_set_user_domain_and_cache(struct hisi_qm *qm)
 /* sec_debug_regs_clear() - clear the sec debug regs */
 static void sec_debug_regs_clear(struct hisi_qm *qm)
 {
+	int i;
+
 	/* clear current_qm */
 	writel(0x0, qm->io_base + QM_DFX_MB_CNT_VF);
 	writel(0x0, qm->io_base + QM_DFX_DB_CNT_VF);
 
+	/* clear sec dfx regs */
+	writel(0x1, qm->io_base + SEC_CTRL_CNT_CLR_CE);
+	for (i = 0; i < ARRAY_SIZE(sec_dfx_regs); i++)
+		readl(qm->io_base + sec_dfx_regs[i].offset);
+
 	/* clear rdclr_en */
 	writel(0x0, qm->io_base + SEC_CTRL_CNT_CLR_CE);
 
-- 
2.8.1

