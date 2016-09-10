From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] hwrng: st - Fix missing clk_disable_unprepare() on error in st_rng_probe()
Date: Sat, 10 Sep 2016 12:03:42 +0000
Message-ID: <1473509022-3478-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-crypto@vger.kernel.org
To: Patrice Chotard <patrice.chotard@st.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:35899 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbcIJMDr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Sep 2016 08:03:47 -0400
Received: by mail-pa0-f65.google.com with SMTP id ez1so5144373pab.3
        for <linux-crypto@vger.kernel.org>; Sat, 10 Sep 2016 05:03:47 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix the missing clk_disable_unprepare() before return
from st_rng_probe() in the error handling case.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/hw_random/st-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_random/st-rng.c
index 7e8aa6b..938ec10 100644
--- a/drivers/char/hw_random/st-rng.c
+++ b/drivers/char/hw_random/st-rng.c
@@ -108,6 +108,7 @@ static int st_rng_probe(struct platform_device *pdev)
 	ret = hwrng_register(&ddata->ops);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register HW RNG\n");
+		clk_disable_unprepare(clk);
 		return ret;
 	}
 
