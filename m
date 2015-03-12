From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/6] hwrng: add devm_* interfaces
Date: Thu, 12 Mar 2015 14:00:02 -0700
Message-ID: <1426194007-22182-2-git-send-email-dmitry.torokhov@gmail.com>
References: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426194007-22182-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This change adds devm_hwrng_register and devm_hwrng_unregister which
use can simplify error unwinding and unbinding code paths in device
drivers.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/hw_random/core.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/hw_random.h     |  4 ++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 32a8a86..83161dd 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -536,6 +536,48 @@ void hwrng_unregister(struct hwrng *rng)
 }
 EXPORT_SYMBOL_GPL(hwrng_unregister);
 
+static void devm_hwrng_release(struct device *dev, void *res)
+{
+	hwrng_unregister(*(struct hwrng **)res);
+}
+
+static int devm_hwrng_match(struct device *dev, void *res, void *data)
+{
+	struct hwrng **r = res;
+
+	if (WARN_ON(!r || !*r))
+		return 0;
+
+	return *r == data;
+}
+
+int devm_hwrng_register(struct device *dev, struct hwrng *rng)
+{
+	struct hwrng **ptr;
+	int error;
+
+	ptr = devres_alloc(devm_hwrng_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	error = hwrng_register(rng);
+	if (error) {
+		devres_free(ptr);
+		return error;
+	}
+
+	*ptr = rng;
+	devres_add(dev, ptr);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_hwrng_register);
+
+void devm_hwrng_unregister(struct device *dev, struct hwrng *rng)
+{
+	devres_release(dev, devm_hwrng_release, devm_hwrng_match, rng);
+}
+EXPORT_SYMBOL_GPL(devm_hwrng_unregister);
+
 static int __init hwrng_modinit(void)
 {
 	return register_miscdev();
diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index eb7b414..4f7d8f4 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -50,10 +50,14 @@ struct hwrng {
 	struct completion cleanup_done;
 };
 
+struct device;
+
 /** Register a new Hardware Random Number Generator driver. */
 extern int hwrng_register(struct hwrng *rng);
+extern int devm_hwrng_register(struct device *dev, struct hwrng *rng);
 /** Unregister a Hardware Random Number Generator driver. */
 extern void hwrng_unregister(struct hwrng *rng);
+extern void devm_hwrng_unregister(struct device *dve, struct hwrng *rng);
 /** Feed random bits into the pool. */
 extern void add_hwgenerator_randomness(const char *buffer, size_t count, size_t entropy);
 
-- 
2.2.0.rc0.207.ga3a616c
