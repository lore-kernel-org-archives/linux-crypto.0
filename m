From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4/4] hwrng: pseries-rng - remove incorrect __init/__exit markups
Date: Mon,  9 Mar 2015 10:36:38 -0700
Message-ID: <1425922598-16538-4-git-send-email-dmitry.torokhov@gmail.com>
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
attributes.

Similarly probe() methods should not be marked __init unless
platform_driver_probe() is used.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/hw_random/pseries-rng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index bcf86f9..63ce51d 100644
--- a/drivers/char/hw_random/pseries-rng.c
+++ b/drivers/char/hw_random/pseries-rng.c
@@ -61,13 +61,13 @@ static struct hwrng pseries_rng = {
 	.read		= pseries_rng_read,
 };
 
-static int __init pseries_rng_probe(struct vio_dev *dev,
+static int pseries_rng_probe(struct vio_dev *dev,
 		const struct vio_device_id *id)
 {
 	return hwrng_register(&pseries_rng);
 }
 
-static int __exit pseries_rng_remove(struct vio_dev *dev)
+static int pseries_rng_remove(struct vio_dev *dev)
 {
 	hwrng_unregister(&pseries_rng);
 	return 0;
-- 
2.2.0.rc0.207.ga3a616c
