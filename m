From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 2/4] crypto: s5p-sss - Remove unused variant field from state container
Date: Fri, 17 Mar 2017 16:49:20 +0200
Message-ID: <20170317144922.27379-3-krzk@kernel.org>
References: <20170317144922.27379-1-krzk@kernel.org>
Cc: Nathan Royce <nroycea+kernel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751031AbdCQPQY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 11:16:24 -0400
In-Reply-To: <20170317144922.27379-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The driver uses type of device (variant) only during probe so there is
no need to store it for later.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 6c620487e9c2..35ea84b7d775 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -190,8 +190,6 @@ struct s5p_aes_dev {
 	struct crypto_queue		queue;
 	bool				busy;
 	spinlock_t			lock;
-
-	struct samsung_aes_variant	*variant;
 };
 
 static struct s5p_aes_dev *s5p_dev;
@@ -852,7 +850,6 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	}
 
 	pdata->busy = false;
-	pdata->variant = variant;
 	pdata->dev = dev;
 	platform_set_drvdata(pdev, pdata);
 	s5p_dev = pdata;
-- 
2.9.3
