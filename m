Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CA6C43331
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 09:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF78A222D0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 09:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfKMJ4H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 04:56:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:52352 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726952AbfKMJ4H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 04:56:07 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B4B9910CDBDA0449886C;
        Wed, 13 Nov 2019 17:56:05 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 17:55:56 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <cyrille.pitchen@atmel.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v3 -next] crypto: atmel - Fix build error of CRYPTO_AUTHENC
Date:   Wed, 13 Nov 2019 17:55:50 +0800
Message-ID: <20191113095550.15104-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20191112072405.40268-1-yuehaibing@huawei.com>
References: <20191112072405.40268-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If CRYPTO_DEV_ATMEL_AUTHENC is m, CRYPTO_DEV_ATMEL_SHA is m,
but CRYPTO_DEV_ATMEL_AES is y, building will fail:

drivers/crypto/atmel-aes.o: In function `atmel_aes_authenc_init_tfm':
atmel-aes.c:(.text+0x670): undefined reference to `atmel_sha_authenc_get_reqsize'
atmel-aes.c:(.text+0x67a): undefined reference to `atmel_sha_authenc_spawn'
drivers/crypto/atmel-aes.o: In function `atmel_aes_authenc_setkey':
atmel-aes.c:(.text+0x7e5): undefined reference to `atmel_sha_authenc_setkey'

Make CRYPTO_DEV_ATMEL_AUTHENC depend on CRYPTO_DEV_ATMEL_AES,
and select CRYPTO_DEV_ATMEL_SHA and CRYPTO_AUTHENC for it under there.

Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to...")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
v3: fix log typo
v2: make CRYPTO_DEV_ATMEL_AUTHENC depends on DEV_ATMEL_AES
---
 drivers/crypto/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index c5cc04d..296e829 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -492,10 +492,9 @@ if CRYPTO_DEV_UX500
 endif # if CRYPTO_DEV_UX500
 
 config CRYPTO_DEV_ATMEL_AUTHENC
-	tristate "Support for Atmel IPSEC/SSL hw accelerator"
+	bool "Support for Atmel IPSEC/SSL hw accelerator"
 	depends on ARCH_AT91 || COMPILE_TEST
-	select CRYPTO_DEV_ATMEL_AES
-	select CRYPTO_DEV_ATMEL_SHA
+	depends on CRYPTO_DEV_ATMEL_AES
 	help
 	  Some Atmel processors can combine the AES and SHA hw accelerators
 	  to enhance support of IPSEC/SSL.
@@ -507,8 +506,9 @@ config CRYPTO_DEV_ATMEL_AES
 	depends on ARCH_AT91 || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_AEAD
-	select CRYPTO_AUTHENC
 	select CRYPTO_SKCIPHER
+	select CRYPTO_AUTHENC if CRYPTO_DEV_ATMEL_AUTHENC
+	select CRYPTO_DEV_ATMEL_SHA if CRYPTO_DEV_ATMEL_AUTHENC
 	help
 	  Some Atmel processors have AES hw accelerator.
 	  Select this if you want to use the Atmel module for
-- 
2.7.4


