Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A20C43461
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D7C9214F1
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgIJMU1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Sep 2020 08:20:27 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11785 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730383AbgIJMRx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Sep 2020 08:17:53 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C17CA991818B70B42AF8;
        Thu, 10 Sep 2020 19:26:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Sep 2020 19:26:39 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] crypto: hisilicon/hpre - delete an useless member
Date:   Thu, 10 Sep 2020 19:25:20 +0800
Message-ID: <1599737122-20734-2-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1599737122-20734-1-git-send-email-yumeng18@huawei.com>
References: <1599737122-20734-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove unused member 'debug_root' in 'struct hpre_debug'.

Fixes: 848974151618("crypto: hisilicon - Add debugfs for HPRE")
Fixes: dadbe4c11753("crypto: hisilicon/hpre - update debugfs ...")
Signed-off-by: Meng Yu <yumeng18@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index ed730d1..f69252b 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -56,7 +56,6 @@ struct hpre_dfx {
  * Just relevant for PF.
  */
 struct hpre_debug {
-	struct dentry *debug_root;
 	struct hpre_dfx dfx[HPRE_DFX_FILE_NUM];
 	struct hpre_debugfs_file files[HPRE_DEBUGFS_FILE_NUM];
 };
-- 
2.8.1

