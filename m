Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B217C48BD1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30966613C8
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhFKJJa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 05:09:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9077 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhFKJJY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 05:09:24 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G1ZfV0FWtzZcm6;
        Fri, 11 Jun 2021 17:04:34 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 17:07:09 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 17:07:09 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 8/8] crypto: hisilicon/zip - adds the max shaper type rate
Date:   Fri, 11 Jun 2021 17:06:50 +0800
Message-ID: <1623402410-63906-9-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623402410-63906-1-git-send-email-yekai13@huawei.com>
References: <1623402410-63906-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ZIP driver support configure each function's QoS in the Host
for Kunpeng930. The ZIP driver needs to configure the maximum shaper
type rate.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 9e4c49c..f8482ce 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -102,6 +102,8 @@
 #define HZIP_PREFETCH_ENABLE		(~(BIT(26) | BIT(17) | BIT(0)))
 #define HZIP_SVA_PREFETCH_DISABLE	BIT(26)
 #define HZIP_SVA_DISABLE_READY		(BIT(26) | BIT(30))
+#define HZIP_SHAPER_RATE_COMPRESS	252
+#define HZIP_SHAPER_RATE_DECOMPRESS	229
 #define HZIP_DELAY_1_US		1
 #define HZIP_POLL_TIMEOUT_US	1000
 
@@ -823,6 +825,7 @@ static void hisi_zip_qm_uninit(struct hisi_qm *qm)
 
 static int hisi_zip_probe_init(struct hisi_zip *hisi_zip)
 {
+	u32 type_rate = HZIP_SHAPER_RATE_COMPRESS;
 	struct hisi_qm *qm = &hisi_zip->qm;
 	int ret;
 
@@ -830,6 +833,14 @@ static int hisi_zip_probe_init(struct hisi_zip *hisi_zip)
 		ret = hisi_zip_pf_probe_init(hisi_zip);
 		if (ret)
 			return ret;
+		/* enable shaper type 0 */
+		if (qm->ver >= QM_HW_V3) {
+			type_rate |= QM_SHAPER_ENABLE;
+
+			/* ZIP need to enable shaper type 1 */
+			type_rate |= HZIP_SHAPER_RATE_DECOMPRESS << QM_SHAPER_TYPE1_OFFSET;
+			qm->type_rate = type_rate;
+		}
 	}
 
 	return 0;
-- 
2.7.4

