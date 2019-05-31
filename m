Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB05C04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 09:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC42E26723
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 09:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbfEaJuK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 05:50:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40930 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbfEaJuK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 05:50:10 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ACCDA8E05209A883BF1B;
        Fri, 31 May 2019 17:50:07 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Fri, 31 May 2019
 17:49:56 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: atmel-i2c - Fix build error while CRC16 set to m
Date:   Fri, 31 May 2019 17:49:00 +0800
Message-ID: <20190531094900.12708-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If CRYPTO_DEV_ATMEL_ECC is set m, which select CRC16 to m,
while CRYPTO_DEV_ATMEL_SHA204A is set to y, building fails.

drivers/crypto/atmel-i2c.o: In function `atmel_i2c_checksum':
atmel-i2c.c:(.text+0x16): undefined reference to `crc16'

Add CRC16 dependency to CRYPTO_DEV_ATMEL_SHA204A, and also make
CRYPTO_DEV_ATMEL_ECC depends on CRC16.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index fe01a99..7aebff8 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -528,7 +528,7 @@ config CRYPTO_DEV_ATMEL_ECC
 	depends on I2C
 	select CRYPTO_DEV_ATMEL_I2C
 	select CRYPTO_ECDH
-	select CRC16
+	depends on CRC16
 	help
 	  Microhip / Atmel ECC hw accelerator.
 	  Select this if you want to use the Microchip / Atmel module for
@@ -540,6 +540,7 @@ config CRYPTO_DEV_ATMEL_ECC
 config CRYPTO_DEV_ATMEL_SHA204A
 	tristate "Support for Microchip / Atmel SHA accelerator and RNG"
 	depends on I2C
+	depends on CRC16
 	select CRYPTO_DEV_ATMEL_I2C
 	select HW_RANDOM
 	help
-- 
2.7.4


