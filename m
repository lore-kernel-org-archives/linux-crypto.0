From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: ux500 - fix error return code in hash_dma_final()
Date: Fri, 22 Mar 2013 21:18:44 +0800
Message-ID: <CAPgLHd94xmvDhOm7xFAV0Ef2O4DFST+npQYN7sfRKVL+y+Msdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, linus.walleij@linaro.org,
	andreas.westin@stericsson.com, arnd@arndb.de, rubini@unipv.it
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:45373 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3CVNSq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Mar 2013 09:18:46 -0400
Received: by mail-bk0-f50.google.com with SMTP id jg9so1839485bkc.23
        for <linux-crypto@vger.kernel.org>; Fri, 22 Mar 2013 06:18:44 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/crypto/ux500/hash/hash_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 8d16d3a..d99b671 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -939,6 +939,7 @@ static int hash_dma_final(struct ahash_request *req)
 	if (!ctx->device->dma.nents) {
 		dev_err(device_data->dev, "[%s] "
 				"ctx->device->dma.nents = 0", __func__);
+		ret = ctx->device->dma.nents;
 		goto out;
 	}
 
@@ -946,6 +947,7 @@ static int hash_dma_final(struct ahash_request *req)
 	if (bytes_written != req->nbytes) {
 		dev_err(device_data->dev, "[%s] "
 				"hash_dma_write() failed!", __func__);
+		ret = bytes_written;
 		goto out;
 	}
 
