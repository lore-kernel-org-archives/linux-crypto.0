Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3BBFC10F14
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 07:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7946218AC
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 07:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbfJHHPZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 03:15:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50308 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730057AbfJHHPZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 03:15:25 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 1B797DE032BBAA1EC3DC;
        Tue,  8 Oct 2019 15:15:22 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 8 Oct 2019
 15:15:12 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <pascalvanl@gmail.com>, <antoine.tenart@bootlin.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: inside-secure - Fix randbuild error
Date:   Tue, 8 Oct 2019 15:15:03 +0800
Message-ID: <20191008071503.55772-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If CRYPTO_DEV_SAFEXCEL is y but CRYPTO_SM3 is m,
building fails:

drivers/crypto/inside-secure/safexcel_hash.o: In function `safexcel_ahash_final':
safexcel_hash.c:(.text+0xbc0): undefined reference to `sm3_zero_message_hash'

Select CRYPTO_SM3 to fix this.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 0f2bc13181ce ("crypto: inside-secure - Added support for basic SM3 ahash")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3e51bae..5af17db 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -751,6 +751,7 @@ config CRYPTO_DEV_SAFEXCEL
 	select CRYPTO_SHA512
 	select CRYPTO_CHACHA20POLY1305
 	select CRYPTO_SHA3
+	select CRYPTO_SM3
 	help
 	  This driver interfaces with the SafeXcel EIP-97 and EIP-197 cryptographic
 	  engines designed by Inside Secure. It currently accelerates DES, 3DES and
-- 
2.7.4


