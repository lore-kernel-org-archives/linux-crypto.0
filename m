From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: drop pointless static qualifier in atmel_aes_probe()
Date: Mon, 24 Oct 2016 14:51:22 +0000
Message-ID: <1477320682-6881-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35460 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932206AbcJXOvx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 10:51:53 -0400
Received: by mail-pf0-f195.google.com with SMTP id s8so16794222pfj.2
        for <linux-crypto@vger.kernel.org>; Mon, 24 Oct 2016 07:51:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

There is no need to have the 'struct atmel_aes_dev *aes_dd' variable
static since new value always be assigned before use it.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 6b656f4..0e3d0d6 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2311,7 +2311,7 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 static int atmel_aes_remove(struct platform_device *pdev)
 {
-	static struct atmel_aes_dev *aes_dd;
+	struct atmel_aes_dev *aes_dd;
 
 	aes_dd = platform_get_drvdata(pdev);
 	if (!aes_dd)
