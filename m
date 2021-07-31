Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9A7C432BE
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Jul 2021 03:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB5F60F35
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Jul 2021 03:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbhGaD1q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jul 2021 23:27:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7906 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbhGaD1k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jul 2021 23:27:40 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gc8kB3ddgz82PD;
        Sat, 31 Jul 2021 11:23:46 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 31 Jul 2021 11:27:30 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 31 Jul
 2021 11:27:29 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 4/5] crypto: hisilicon/sec - fix the CTR mode BD configuration
Date:   Sat, 31 Jul 2021 11:26:35 +0800
Message-ID: <1627701996-4589-5-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1627701996-4589-1-git-send-email-yekai13@huawei.com>
References: <1627701996-4589-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CTR counter is 32bit rollover default on the BD.
But the NIST standard is 128bit rollover. it cause the
testing failed, so need to fix the BD configuration.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 6 ++++++
 drivers/crypto/hisilicon/sec2/sec_crypto.h | 6 ++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 010bde9..3b698ad 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -42,6 +42,8 @@
 #define SEC_DE_OFFSET_V3		9
 #define SEC_SCENE_OFFSET_V3	5
 #define SEC_CKEY_OFFSET_V3	13
+#define SEC_CTR_CNT_OFFSET	25
+#define SEC_CTR_CNT_ROLLOVER	2
 #define SEC_SRC_SGL_OFFSET_V3	11
 #define SEC_DST_SGL_OFFSET_V3	14
 #define SEC_CALG_OFFSET_V3	4
@@ -1301,6 +1303,10 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 		cipher = SEC_CIPHER_DEC;
 	sec_sqe3->c_icv_key |= cpu_to_le16(cipher);
 
+	/* Set the CTR counter mode is 128bit rollover */
+	sec_sqe3->auth_mac_key = cpu_to_le32((u32)SEC_CTR_CNT_ROLLOVER <<
+					SEC_CTR_CNT_OFFSET);
+
 	if (req->use_pbuf) {
 		bd_param |= SEC_PBUF << SEC_SRC_SGL_OFFSET_V3;
 		bd_param |= SEC_PBUF << SEC_DST_SGL_OFFSET_V3;
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 9f71c35..5e039b5 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -354,8 +354,10 @@ struct sec_sqe3 {
 	 * akey_len: 9~14 bits
 	 * a_alg: 15~20 bits
 	 * key_sel: 21~24 bits
-	 * updata_key: 25 bits
-	 * reserved: 26~31 bits
+	 * ctr_count_mode/sm4_xts: 25~26 bits
+	 * sva_prefetch: 27 bits
+	 * key_wrap_num: 28~30 bits
+	 * update_key: 31 bits
 	 */
 	__le32 auth_mac_key;
 	__le32 salt;
-- 
2.7.4

