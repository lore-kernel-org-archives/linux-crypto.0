From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/4] crypto: ux500: Adjust two condition checks in
 ux500_cryp_probe()
Date: Wed, 14 Feb 2018 11:19:40 +0100
Message-ID: <d79ef7ab-cf49-6b32-01d8-e4aa77424e39@users.sourceforge.net>
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
Date: Wed, 14 Feb 2018 10:38:44 +0100

The local variable "cryp_error" was used only for two condition checks.

* Check the return values from these function calls directly instead.

* Delete this variable which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 50bfc7b4c641..07cc92f88933 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1404,7 +1404,6 @@ static void cryp_algs_unregister_all(void)
 static int ux500_cryp_probe(struct platform_device *pdev)
 {
 	int ret;
-	int cryp_error = 0;
 	struct resource *res = NULL;
 	struct resource *res_irq = NULL;
 	struct cryp_device_data *device_data;
@@ -1478,15 +1477,13 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		goto out_clk_unprepare;
 	}
 
-	cryp_error = cryp_check(device_data);
-	if (cryp_error != 0) {
+	if (cryp_check(device_data)) {
 		dev_err(dev, "[%s]: cryp_init() failed!", __func__);
 		ret = -EINVAL;
 		goto out_power;
 	}
 
-	cryp_error = cryp_configure_protection(device_data, &prot);
-	if (cryp_error != 0) {
+	if (cryp_configure_protection(device_data, &prot)) {
 		dev_err(dev, "[%s]: cryp_configure_protection() failed!",
 			__func__);
 		ret = -EINVAL;
-- 
2.16.1
