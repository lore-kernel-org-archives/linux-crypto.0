From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/2] n2rng: Combine substrings for two messages in
 n2rng_probe()
Date: Wed, 19 Apr 2017 11:11:35 +0200
Message-ID: <fef1883c-4338-5f8a-5dfe-e970b424fbc5@users.sourceforge.net>
References: <4d9fbb01-e12f-eb5c-7ecd-5a2a10fd5110@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>,
        Shannon Nelson <shannon.nelson@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <4d9fbb01-e12f-eb5c-7ecd-5a2a10fd5110@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Apr 2017 10:50:04 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/char/hw_random/n2-drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 92dd4e925315..f3e67c768101 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -723,16 +723,16 @@ static int n2rng_probe(struct platform_device *op)
 		if (sun4v_hvapi_register(HV_GRP_RNG,
 					 np->hvapi_major,
 					 &np->hvapi_minor)) {
-			dev_err(&op->dev, "Cannot register suitable "
-				"HVAPI version.\n");
+			dev_err(&op->dev,
+				"Cannot register suitable HVAPI version.\n");
 			goto out;
 		}
 	}
 
 	if (np->flags & N2RNG_FLAG_MULTI) {
 		if (np->hvapi_major < 2) {
-			dev_err(&op->dev, "multi-unit-capable RNG requires "
-				"HVAPI major version 2 or later, got %lu\n",
+			dev_err(&op->dev,
+				"multi-unit-capable RNG requires HVAPI major version 2 or later, got %lu\n",
 				np->hvapi_major);
 			goto out_hvapi_unregister;
 		}
-- 
2.12.2

