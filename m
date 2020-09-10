Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE73EC433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC00207EA
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgIJMA6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Sep 2020 08:00:58 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730383AbgIJL64 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Sep 2020 07:58:56 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CFC6CFB9CDA11E138A22
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2020 19:57:53 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 19:57:49 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH 1/5] crypto: hisilicon - update mininum queue
Date:   Thu, 10 Sep 2020 19:56:39 +0800
Message-ID: <1599739003-23448-2-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1599739003-23448-1-git-send-email-liulongfang@huawei.com>
References: <1599739003-23448-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

At present, as HPRE/SEC/ZIP modules' parameter 'pf_q_num' is 1,
kernel CRYPTO test will fail on the algorithms from the modules,
since 'QP' hardware resources are not enough for CRYPTO TFM.
To fix this, the minimum value of 'pf_q_num' should be 2.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/qm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 6773f44..0420f4c 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -79,7 +79,7 @@
 #define QM_BASE_CE			QM_ECC_1BIT
 
 #define QM_Q_DEPTH			1024
-
+#define QM_MIN_QNUM                     2
 #define HISI_ACC_SGL_SGE_NR_MAX		255
 
 /* page number for queue file region */
@@ -309,7 +309,7 @@ static inline int q_num_set(const char *val, const struct kernel_param *kp,
 	}
 
 	ret = kstrtou32(val, 10, &n);
-	if (ret || !n || n > q_num)
+	if (ret || n < QM_MIN_QNUM || n > q_num)
 		return -EINVAL;
 
 	return param_set_int(val, kp);
-- 
2.8.1

