Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0760C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 13:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB2F860F0F
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 13:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbhJ0Ncd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 09:32:33 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:12225 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236324AbhJ0Ncc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 09:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635341407; x=1666877407;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BkK/TZLyRyOl87sayCRYS99QcdZzIba8r4AMDj5GxCQ=;
  b=Qakr/Etkr/9wszBdW1aBMCyuDxfMBRMUeuajpXba8aJ2yx2nhsFYB8H4
   kxlVryUNTyqFs3BgiuY5MWPx5nUS3hg+zUMUcDrmocj5AdNfkF4Wbt/g/
   Nh2bChI+/AJAQ6UBBi2NnH4a4/SvzboGPRXU6jl25crwSN0t+7zvqlvby
   qUF12cRe4vTTd/9DGhY9yzJnpca2kMDGh+MXhvd/+KFuFGWBO2lQGL7to
   qv9JdSqx4vORf6PyFoGyLYjzdkEoMEJamKmbDhh6zRKczJ5maztwAzfbq
   IQrM6rVAopX+29bivCdjEOPLV2OEOJyPfJm6w0ZZXXyc6t7Xnu4hHnJbe
   Q==;
IronPort-SDR: C8w4r3XVy3FIOAtoHc818KUL1hhv0BRX+i50CmNLk4D7oCvU04PKCwAeaOhXwWvyPss/f+R6zc
 KUFM9+iPt7bnUUYZHXSBUc2OX/8VHBZYNPreKu1LIVgr81YbVHXzm7E5UzyInrQApygwD0gmMZ
 hJO7Iz4+TaL244WsD1t6Owbjdot06gPX0+LgLwrnBbjpOs4ueQgw+JPfS+MNfUlLcWEjWDUO3l
 gw/alQf8derbXvoXI8OcOxvdTTSyjJ3F/hzW4m0UvpPI5Dh2ZshKv585kXAP0NoExAk0lzdpQl
 Ae676hdlExkMerEWZe+3Ompe
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="74442186"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2021 06:30:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 27 Oct 2021 06:30:06 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 27 Oct 2021 06:30:03 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <herbert@gondor.apana.org.au>
CC:     <weo@reccoware.de>, <nicolas.ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] crypto: atmel-aes: Reestablish the correct tfm context at dequeue
Date:   Wed, 27 Oct 2021 16:30:01 +0300
Message-ID: <20211027133001.332635-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In case there were more requests from different tfms in the crypto
queue, only the context of the last initialized tfm was considered.

Fixes: ec2088b66f7a ("crypto: atmel-aes - Allocate aes dev at tfm init time")
Reported-by: Wolfgang Ocker <weo@reccoware.de>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/crypto/atmel-aes.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 9391ccc03382..fe0558403191 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -960,6 +960,7 @@ static int atmel_aes_handle_queue(struct atmel_aes_dev *dd,
 	ctx = crypto_tfm_ctx(areq->tfm);
 
 	dd->areq = areq;
+	dd->ctx = ctx;
 	start_async = (areq != new_areq);
 	dd->is_async = start_async;
 
@@ -1274,7 +1275,6 @@ static int atmel_aes_init_tfm(struct crypto_skcipher *tfm)
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_start;
 
 	return 0;
@@ -1291,7 +1291,6 @@ static int atmel_aes_ctr_init_tfm(struct crypto_skcipher *tfm)
 
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_ctr_start;
 
 	return 0;
@@ -1783,7 +1782,6 @@ static int atmel_aes_gcm_init(struct crypto_aead *tfm)
 
 	crypto_aead_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_gcm_start;
 
 	return 0;
@@ -1927,7 +1925,6 @@ static int atmel_aes_xts_init_tfm(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct atmel_aes_reqctx) +
 				    crypto_skcipher_reqsize(ctx->fallback_tfm));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_xts_start;
 
 	return 0;
@@ -2154,7 +2151,6 @@ static int atmel_aes_authenc_init_tfm(struct crypto_aead *tfm,
 	crypto_aead_set_reqsize(tfm, (sizeof(struct atmel_aes_authenc_reqctx) +
 				      auth_reqsize));
 	ctx->base.dd = dd;
-	ctx->base.dd->ctx = &ctx->base;
 	ctx->base.start = atmel_aes_authenc_start;
 
 	return 0;
-- 
2.25.1

