From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] hwrng: geode - fix return value check in mod_init()
Date: Fri, 16 Sep 2016 01:50:01 +0000
Message-ID: <1473990601-18721-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36311 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755100AbcIPBuI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 21:50:08 -0400
Received: by mail-pf0-f193.google.com with SMTP id n24so2922592pfb.3
        for <linux-crypto@vger.kernel.org>; Thu, 15 Sep 2016 18:50:08 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

In case of error, the function devm_ioremap() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check should
be replaced with NULL test.

Fixes: 6e9b5e76882c ("hwrng: geode - Migrate to managed API")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/hw_random/geode-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 0cae210..e7a2459 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -95,8 +95,8 @@ static int __init mod_init(void)
 				return -ENODEV;
 
 			mem = devm_ioremap(&pdev->dev, rng_base, 0x58);
-			if (IS_ERR(mem))
-				return PTR_ERR(mem);
+			if (!mem)
+				return -ENOMEM;
 			geode_rng.priv = (unsigned long)mem;
 
 			pr_info("AMD Geode RNG detected\n");
