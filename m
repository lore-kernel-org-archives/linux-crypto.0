From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/4] crypto: ux500: Delete two unnecessary variable
 initialisations in ux500_cryp_probe()
Date: Wed, 14 Feb 2018 11:22:28 +0100
Message-ID: <b8fb9abe-2ac4-d720-b676-79083fc7e5e6@users.sourceforge.net>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:33111 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966996AbeBNKWk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Feb 2018 05:22:40 -0500
In-Reply-To: <20dcb583-5455-b5b9-94df-db9d1e21931f@users.sourceforge.net>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 10:56:38 +0100

Two local variables will eventually be set to appropriate pointers
a bit later. Thus omit their explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/ux500/cryp/cryp_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 7c811d7eb274..cb31b59c9d53 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -1404,8 +1404,8 @@ static void cryp_algs_unregister_all(void)
 static int ux500_cryp_probe(struct platform_device *pdev)
 {
 	int ret;
-	struct resource *res = NULL;
-	struct resource *res_irq = NULL;
+	struct resource *res;
+	struct resource *res_irq;
 	struct cryp_device_data *device_data;
 	struct cryp_protection_config prot = {
 		.privilege_access = CRYP_STATE_ENABLE
-- 
2.16.1
