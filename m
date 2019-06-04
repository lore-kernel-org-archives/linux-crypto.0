Return-Path: <SRS0=6z3H=UD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C18FBC28CC6
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 14:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A632024A3B
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 14:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfFDOyS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jun 2019 10:54:18 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17665 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727563AbfFDOyS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jun 2019 10:54:18 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5E0234E8820ACC109B4F;
        Tue,  4 Jun 2019 22:54:14 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 4 Jun 2019
 22:54:04 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <ebiggers@google.com>, <rob.rice@broadcom.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: bcm - Make some symbols static
Date:   Tue, 4 Jun 2019 22:53:51 +0800
Message-ID: <20190604145351.19392-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix sparse warnings:

drivers/crypto/bcm/cipher.c:99:6: warning: symbol 'BCMHEADER' was not declared. Should it be static?
drivers/crypto/bcm/cipher.c:2096:6: warning: symbol 'spu_no_incr_hash' was not declared. Should it be static?
drivers/crypto/bcm/cipher.c:4823:5: warning: symbol 'bcm_spu_probe' was not declared. Should it be static?
drivers/crypto/bcm/cipher.c:4867:5: warning: symbol 'bcm_spu_remove' was not declared. Should it be static?
drivers/crypto/bcm/spu2.c:52:6: warning: symbol 'spu2_cipher_type_names' was not declared. Should it be static?
drivers/crypto/bcm/spu2.c:56:6: warning: symbol 'spu2_cipher_mode_names' was not declared. Should it be static?
drivers/crypto/bcm/spu2.c:60:6: warning: symbol 'spu2_hash_type_names' was not declared. Should it be static?
drivers/crypto/bcm/spu2.c:66:6: warning: symbol 'spu2_hash_mode_names' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/bcm/cipher.c |  8 ++++----
 drivers/crypto/bcm/spu2.c   | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 25f8d39..d972ffa 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -96,7 +96,7 @@ MODULE_PARM_DESC(aead_pri, "Priority for AEAD algos");
  * 0x70 - ring 2
  * 0x78 - ring 3
  */
-char BCMHEADER[] = { 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x28 };
+static char BCMHEADER[] = { 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x28 };
 /*
  * Some SPU hw does not use BCM header on SPU messages. So BCM_HDR_LEN
  * is set dynamically after reading SPU type from device tree.
@@ -2094,7 +2094,7 @@ static int __ahash_init(struct ahash_request *req)
  * Return: true if incremental hashing is not supported
  *         false otherwise
  */
-bool spu_no_incr_hash(struct iproc_ctx_s *ctx)
+static bool spu_no_incr_hash(struct iproc_ctx_s *ctx)
 {
 	struct spu_hw *spu = &iproc_priv.spu;
 
@@ -4820,7 +4820,7 @@ static int spu_dt_read(struct platform_device *pdev)
 	return 0;
 }
 
-int bcm_spu_probe(struct platform_device *pdev)
+static int bcm_spu_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct spu_hw *spu = &iproc_priv.spu;
@@ -4864,7 +4864,7 @@ int bcm_spu_probe(struct platform_device *pdev)
 	return err;
 }
 
-int bcm_spu_remove(struct platform_device *pdev)
+static int bcm_spu_remove(struct platform_device *pdev)
 {
 	int i;
 	struct device *dev = &pdev->dev;
diff --git a/drivers/crypto/bcm/spu2.c b/drivers/crypto/bcm/spu2.c
index bf7ac62..960b472 100644
--- a/drivers/crypto/bcm/spu2.c
+++ b/drivers/crypto/bcm/spu2.c
@@ -49,21 +49,21 @@ enum spu2_proto_sel {
 	SPU2_DTLS_AEAD = 10
 };
 
-char *spu2_cipher_type_names[] = { "None", "AES128", "AES192", "AES256",
+static char *spu2_cipher_type_names[] = { "None", "AES128", "AES192", "AES256",
 	"DES", "3DES"
 };
 
-char *spu2_cipher_mode_names[] = { "ECB", "CBC", "CTR", "CFB", "OFB", "XTS",
-	"CCM", "GCM"
+static char *spu2_cipher_mode_names[] = { "ECB", "CBC", "CTR", "CFB", "OFB",
+	"XTS", "CCM", "GCM"
 };
 
-char *spu2_hash_type_names[] = { "None", "AES128", "AES192", "AES256",
+static char *spu2_hash_type_names[] = { "None", "AES128", "AES192", "AES256",
 	"Reserved", "Reserved", "MD5", "SHA1", "SHA224", "SHA256", "SHA384",
 	"SHA512", "SHA512/224", "SHA512/256", "SHA3-224", "SHA3-256",
 	"SHA3-384", "SHA3-512"
 };
 
-char *spu2_hash_mode_names[] = { "CMAC", "CBC-MAC", "XCBC-MAC", "HMAC",
+static char *spu2_hash_mode_names[] = { "CMAC", "CBC-MAC", "XCBC-MAC", "HMAC",
 	"Rabin", "CCM", "GCM", "Reserved"
 };
 
-- 
2.7.4


