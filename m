From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: stm32 - Fix OF module alias information
Date: Tue, 25 Apr 2017 14:35:42 +0000
Message-ID: <20170425143542.1069-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Fabien DESSENNE <fabien.dessenne@st.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33200 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948028AbdDYOfw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 10:35:52 -0400
Received: by mail-pg0-f68.google.com with SMTP id 63so11738080pgh.0
        for <linux-crypto@vger.kernel.org>; Tue, 25 Apr 2017 07:35:52 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

The module alias information passed to MODULE_DEVICE_TABLE()
should use stm32_dt_ids instead of undefined sti_dt_ids.

Fixes: b51dbe90912a ("crypto: stm32 - Support for STM32 CRC32 crypto module")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/stm32/stm32_crc32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32_crc32.c b/drivers/crypto/stm32/stm32_crc32.c
index 7652822..ec83b1e 100644
--- a/drivers/crypto/stm32/stm32_crc32.c
+++ b/drivers/crypto/stm32/stm32_crc32.c
@@ -306,7 +306,7 @@ static const struct of_device_id stm32_dt_ids[] = {
 	{ .compatible = "st,stm32f7-crc", },
 	{},
 };
-MODULE_DEVICE_TABLE(of, sti_dt_ids);
+MODULE_DEVICE_TABLE(of, stm32_dt_ids);
 
 static struct platform_driver stm32_crc_driver = {
 	.probe  = stm32_crc_probe,
