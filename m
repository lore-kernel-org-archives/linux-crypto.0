From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] hwrng: atmel - use clk_disable_unprepare instead of clk_disable
Date: Fri, 11 Nov 2016 14:56:47 +0000
Message-ID: <1478876207-29820-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35119 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932961AbcKKPLS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 10:11:18 -0500
Received: by mail-pf0-f194.google.com with SMTP id i88so2657775pfk.2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Nov 2016 07:11:18 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Since clk_prepare_enable() is used to get trng->clk, we should
use clk_disable_unprepare() to release it for the error path.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/hw_random/atmel-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
index ae7cae5..661c82c 100644
--- a/drivers/char/hw_random/atmel-rng.c
+++ b/drivers/char/hw_random/atmel-rng.c
@@ -94,7 +94,7 @@ static int atmel_trng_probe(struct platform_device *pdev)
 	return 0;
 
 err_register:
-	clk_disable(trng->clk);
+	clk_disable_unprepare(trng->clk);
 	return ret;
 }
