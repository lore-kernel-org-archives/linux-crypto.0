From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/4] crypto: ux500: Delete an error message for a failed
 memory allocation in ux500_cryp_probe()
Date: Wed, 14 Feb 2018 11:18:18 +0100
Message-ID: <e099a8a5-e7dd-5170-f46e-83c3609e8137@users.sourceforge.net>
References: <20dcb583-5455-b5b9-94df-db9d1e21931f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20dcb583-5455-b5b9-94df-db9d1e21931f@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 10:12:38 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 765f53e548ab..50bfc7b4c641 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1416,7 +1416,6 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 	dev_dbg(dev, "[%s]", __func__);
 	device_data = devm_kzalloc(dev, sizeof(*device_data), GFP_ATOMIC);
 	if (!device_data) {
-		dev_err(dev, "[%s]: kzalloc() failed!", __func__);
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.16.1
