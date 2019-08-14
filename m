Return-Path: <SRS0=c3b/=WK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E24C433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 09:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02E092084F
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Aug 2019 09:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfHNJbP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Aug 2019 05:31:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44810 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbfHNJbD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Aug 2019 05:31:03 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 46C17AB08D79185D4B96;
        Wed, 14 Aug 2019 17:31:01 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 14 Aug 2019 17:30:50 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH 4/5] crypto: hisilicon - add missing single_release
Date:   Wed, 14 Aug 2019 17:28:38 +0800
Message-ID: <1565774919-31853-5-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1565774919-31853-1-git-send-email-wangzhou1@hisilicon.com>
References: <1565774919-31853-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix to add missing single_release in qm_regs_fops.

Fixes: 263c9959c937 ("crypto: hisilicon - add queue management driver for HiSilicon QM module")
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/qm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 796fdbf..d72e062 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -958,6 +958,7 @@ static const struct file_operations qm_regs_fops = {
 	.owner = THIS_MODULE,
 	.open = qm_regs_open,
 	.read = seq_read,
+	.release = single_release,
 };
 
 static int qm_create_debugfs_file(struct hisi_qm *qm, enum qm_debug_file index)
-- 
2.8.1

