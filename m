Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00107C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Nov 2021 04:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhKTEwz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Nov 2021 23:52:55 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26340 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhKTEwz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Nov 2021 23:52:55 -0500
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hx1D501CVzbhk8;
        Sat, 20 Nov 2021 12:44:52 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 20 Nov 2021 12:49:50 +0800
Received: from huawei.com (10.69.192.56) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Sat, 20 Nov
 2021 12:49:50 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon - modify the value of engine type rate
Date:   Sat, 20 Nov 2021 12:47:36 +0800
Message-ID: <20211120044739.5667-2-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211120044739.5667-1-yekai13@huawei.com>
References: <20211120044739.5667-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Modify the value of type rate from new QM spec.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c  | 2 +-
 drivers/crypto/hisilicon/zip/zip_main.c   | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 65a641396c07..ebfab3e14499 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -103,7 +103,7 @@
 #define HPRE_QM_PM_FLR			BIT(11)
 #define HPRE_QM_SRIOV_FLR		BIT(12)
 
-#define HPRE_SHAPER_TYPE_RATE		128
+#define HPRE_SHAPER_TYPE_RATE		640
 #define HPRE_VIA_MSI_DSM		1
 #define HPRE_SQE_MASK_OFFSET		8
 #define HPRE_SQE_MASK_LEN		24
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 90551bf38b52..26d3ab1d308b 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -105,7 +105,7 @@
 
 #define SEC_SQE_MASK_OFFSET		64
 #define SEC_SQE_MASK_LEN		48
-#define SEC_SHAPER_TYPE_RATE		128
+#define SEC_SHAPER_TYPE_RATE		400
 
 struct sec_hw_error {
 	u32 int_msk;
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 873971ef9aee..1a237d95d482 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -103,8 +103,8 @@
 #define HZIP_PREFETCH_ENABLE		(~(BIT(26) | BIT(17) | BIT(0)))
 #define HZIP_SVA_PREFETCH_DISABLE	BIT(26)
 #define HZIP_SVA_DISABLE_READY		(BIT(26) | BIT(30))
-#define HZIP_SHAPER_RATE_COMPRESS	252
-#define HZIP_SHAPER_RATE_DECOMPRESS	229
+#define HZIP_SHAPER_RATE_COMPRESS	750
+#define HZIP_SHAPER_RATE_DECOMPRESS	140
 #define HZIP_DELAY_1_US		1
 #define HZIP_POLL_TIMEOUT_US	1000
 
-- 
2.33.0

