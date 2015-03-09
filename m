From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3/4] hwrng: octeon - remove incorrect __exit markups
Date: Mon,  9 Mar 2015 10:36:37 -0700
Message-ID: <1425922598-16538-3-git-send-email-dmitry.torokhov@gmail.com>
References: <1425922598-16538-1-git-send-email-dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425922598-16538-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Even if bus is not hot-pluggable, the devices can be unbound from the
driver via sysfs, so we should not be using __exit annotations on
remove() methods. The only exception is drivers registered with
platform_driver_probe() which specifically disables sysfs bind/unbind
attributes

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/hw_random/octeon-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
index be1c3f6..6234a4a 100644
--- a/drivers/char/hw_random/octeon-rng.c
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -105,7 +105,7 @@ static int octeon_rng_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit octeon_rng_remove(struct platform_device *pdev)
+static int octeon_rng_remove(struct platform_device *pdev)
 {
 	struct hwrng *rng = platform_get_drvdata(pdev);
 
@@ -119,7 +119,7 @@ static struct platform_driver octeon_rng_driver = {
 		.name		= "octeon_rng",
 	},
 	.probe		= octeon_rng_probe,
-	.remove		= __exit_p(octeon_rng_remove),
+	.remove		= octeon_rng_remove,
 };
 
 module_platform_driver(octeon_rng_driver);
-- 
2.2.0.rc0.207.ga3a616c
