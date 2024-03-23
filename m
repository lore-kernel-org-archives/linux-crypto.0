Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4213922625
	for <linux-crypto@vger.kernel.org>; Sat, 23 Mar 2024 16:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711212264; cv=none; b=SORuAwnHC665EfWrnPmHtwU/mqz51k67rF2miKCtVBLumG7kL5HSoqdnXdlqY3TSr4q+t06yj7YjV3lms0ImbqLsTksce0t5XFjC2Gw0GIUU+aBX7AbMcNfXZILEk+1In9jXXovd5vdNc62XBM9RRGQs+jS7vly8Q+GiG0TUJ/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711212264; c=relaxed/simple;
	bh=qWhalT5AFc1DCUsjm2smHCmR8gPAi8ueh2u9ZzM/EO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etYyjAmtlY87YElgiY6xDds2VSvfIjOcN03WNSu4LmlprZj4Af4psOinGZ4g4zhEoWLl0leVj36ijov770ev78nHws0SDK09aMM+ROzR3kO5ndbvVCMgD4wJVAEdhHL+W3qZY1qQs1A2gEB3tRiThw2AEwcUEBw6Ki4owvwWMSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ciykNqV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ciykNqV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FABC433A6;
	Sat, 23 Mar 2024 16:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711212263;
	bh=qWhalT5AFc1DCUsjm2smHCmR8gPAi8ueh2u9ZzM/EO4=;
	h=From:List-Id:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciykNqV6DNyO2GnPcg7Mzpqmz+IO7hbdziknNYL4ZYcPrCzrDSoEZlwhKB/CO2gRq
	 jiy86hKo1bd/FIBaPEb409mzobSuN2GYivo1J7aUP9bwtajSar03f8lmsPm2ZYMxsd
	 Zg6qrOmFZ8XrocjLmF4iA0uoJbnB0DqJzaAO8maSsUoaUntO0+lRq3601wiEW0qO1q
	 /oEcEgc5twpRVZOoLkACfxRt6AeH7JAmHCVeIbNM193x8AVZDupJX1pgZxRXG7c1v3
	 CPdwawrSYm9N5yJcNLvf2okuy82EbszJLr5vOjK08xBNCxf/imQ10bnNYDtCVClIRT
	 cLsRqDAYQrMhA==
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	soc@kernel.org,
	arm@kernel.org,
	Andy Shevchenko <andy@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
Cc: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH v5 07/11] platform: cznic: turris-omnia-mcu: Add support for MCU provided TRNG
Date: Sat, 23 Mar 2024 17:43:55 +0100
Message-ID: <20240323164359.21642-8-kabel@kernel.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240323164359.21642-1-kabel@kernel.org>
References: <20240323164359.21642-1-kabel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for true random number generator provided by the MCU.
New Omnia boards come without the Atmel SHA204-A chip. Instead the
crypto functionality is provided by new microcontroller, which has
a TRNG peripheral.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/platform/cznic/Kconfig                |  2 +
 drivers/platform/cznic/Makefile               |  1 +
 .../platform/cznic/turris-omnia-mcu-base.c    |  6 +-
 .../platform/cznic/turris-omnia-mcu-gpio.c    |  2 +-
 .../platform/cznic/turris-omnia-mcu-trng.c    | 89 +++++++++++++++++++
 drivers/platform/cznic/turris-omnia-mcu.h     |  8 ++
 6 files changed, 106 insertions(+), 2 deletions(-)
 create mode 100644 drivers/platform/cznic/turris-omnia-mcu-trng.c

diff --git a/drivers/platform/cznic/Kconfig b/drivers/platform/cznic/Kconfig
index e2649cdecc38..750d5f47dba8 100644
--- a/drivers/platform/cznic/Kconfig
+++ b/drivers/platform/cznic/Kconfig
@@ -19,6 +19,7 @@ config TURRIS_OMNIA_MCU
 	depends on I2C
 	select GPIOLIB
 	select GPIOLIB_IRQCHIP
+	select HW_RANDOM
 	select RTC_CLASS
 	select WATCHDOG_CORE
 	help
@@ -28,6 +29,7 @@ config TURRIS_OMNIA_MCU
 	  - board poweroff into true low power mode (with voltage regulators
 	    disabled) and the ability to configure wake up from this mode (via
 	    rtcwake)
+	  - true random number generator (if available on the MCU)
 	  - MCU watchdog
 	  - GPIO pins
 	    - to get front button press events (the front button can be
diff --git a/drivers/platform/cznic/Makefile b/drivers/platform/cznic/Makefile
index a43997a12d74..8fd4c6cbcb1b 100644
--- a/drivers/platform/cznic/Makefile
+++ b/drivers/platform/cznic/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_TURRIS_OMNIA_MCU)	+= turris-omnia-mcu.o
 turris-omnia-mcu-objs		:= turris-omnia-mcu-base.o
 turris-omnia-mcu-objs		+= turris-omnia-mcu-gpio.o
 turris-omnia-mcu-objs		+= turris-omnia-mcu-sys-off-wakeup.o
+turris-omnia-mcu-objs		+= turris-omnia-mcu-trng.o
 turris-omnia-mcu-objs		+= turris-omnia-mcu-watchdog.o
diff --git a/drivers/platform/cznic/turris-omnia-mcu-base.c b/drivers/platform/cznic/turris-omnia-mcu-base.c
index 5a45834003cd..30771004a627 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-base.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-base.c
@@ -335,7 +335,11 @@ static int omnia_mcu_probe(struct i2c_client *client)
 	if (err)
 		return err;
 
-	return omnia_mcu_register_gpiochip(mcu);
+	err = omnia_mcu_register_gpiochip(mcu);
+	if (err)
+		return err;
+
+	return omnia_mcu_register_trng(mcu);
 }
 
 static const struct of_device_id of_omnia_mcu_match[] = {
diff --git a/drivers/platform/cznic/turris-omnia-mcu-gpio.c b/drivers/platform/cznic/turris-omnia-mcu-gpio.c
index 7f885be23a47..90b2caa679ea 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-gpio.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-gpio.c
@@ -161,7 +161,7 @@ static const struct omnia_gpio {
 };
 
 /* mapping from interrupts to indexes of GPIOs in the omnia_gpios array */
-static const u8 omnia_int_to_gpio_idx[32] = {
+const u8 omnia_int_to_gpio_idx[32] = {
 	[__bf_shf(INT_CARD_DET)]		= 4,
 	[__bf_shf(INT_MSATA_IND)]		= 5,
 	[__bf_shf(INT_USB30_OVC)]		= 6,
diff --git a/drivers/platform/cznic/turris-omnia-mcu-trng.c b/drivers/platform/cznic/turris-omnia-mcu-trng.c
new file mode 100644
index 000000000000..b08111b5c337
--- /dev/null
+++ b/drivers/platform/cznic/turris-omnia-mcu-trng.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CZ.NIC's Turris Omnia MCU TRNG driver
+ *
+ * 2024 by Marek Behún <kabel@kernel.org>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/completion.h>
+#include <linux/devm-helpers.h>
+#include <linux/irqdomain.h>
+#include <linux/minmax.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/turris-omnia-mcu-interface.h>
+#include <linux/types.h>
+
+#include "turris-omnia-mcu.h"
+
+#define CMD_TRNG_MAX_ENTROPY_LEN	64
+
+static irqreturn_t omnia_trng_irq_handler(int irq, void *dev_id)
+{
+	struct omnia_mcu *mcu = dev_id;
+
+	complete(&mcu->trng_completion);
+
+	return IRQ_HANDLED;
+}
+
+static int omnia_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct omnia_mcu *mcu = (struct omnia_mcu *)rng->priv;
+	u8 reply[1 + CMD_TRNG_MAX_ENTROPY_LEN];
+	int err, bytes;
+
+	if (!wait && !completion_done(&mcu->trng_completion))
+		return 0;
+
+	do {
+		if (wait_for_completion_interruptible(&mcu->trng_completion))
+			return -EINTR;
+
+		err = omnia_cmd_read(mcu->client, CMD_TRNG_COLLECT_ENTROPY,
+				     reply, sizeof(reply));
+		if (err)
+			return err;
+
+		bytes = min3(reply[0], max, CMD_TRNG_MAX_ENTROPY_LEN);
+	} while (wait && !bytes);
+
+	memcpy(data, &reply[1], bytes);
+
+	return bytes;
+}
+
+int omnia_mcu_register_trng(struct omnia_mcu *mcu)
+{
+	struct device *dev = &mcu->client->dev;
+	int irq, err;
+	u8 irq_idx;
+
+	if (!(mcu->features & FEAT_TRNG))
+		return 0;
+
+	irq_idx = omnia_int_to_gpio_idx[__bf_shf(INT_TRNG)];
+	irq = devm_irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
+	if (irq <= 0)
+		return dev_err_probe(dev, irq ?: -ENXIO,
+				     "Cannot map TRNG IRQ\n");
+
+	init_completion(&mcu->trng_completion);
+
+	err = devm_request_threaded_irq(dev, irq, NULL, omnia_trng_irq_handler,
+					IRQF_ONESHOT, "turris-omnia-mcu-trng",
+					mcu);
+	if (err)
+		return dev_err_probe(dev, err, "Cannot request TRNG IRQ\n");
+
+	mcu->trng.name = "turris-omnia-mcu-trng";
+	mcu->trng.read = omnia_trng_read;
+	mcu->trng.priv = (unsigned long)mcu;
+
+	err = devm_hwrng_register(dev, &mcu->trng);
+	if (err)
+		return dev_err_probe(dev, err, "Cannot register TRNG\n");
+
+	return 0;
+}
diff --git a/drivers/platform/cznic/turris-omnia-mcu.h b/drivers/platform/cznic/turris-omnia-mcu.h
index 3e2c96079e64..f5b8f7ed3e6e 100644
--- a/drivers/platform/cznic/turris-omnia-mcu.h
+++ b/drivers/platform/cznic/turris-omnia-mcu.h
@@ -9,7 +9,9 @@
 #define __TURRIS_OMNIA_MCU_H
 
 #include <linux/bitops.h>
+#include <linux/completion.h>
 #include <linux/gpio/driver.h>
+#include <linux/hw_random.h>
 #include <linux/i2c.h>
 #include <linux/if_ether.h>
 #include <linux/mutex.h>
@@ -46,6 +48,10 @@ struct omnia_mcu {
 
 	/* MCU watchdog */
 	struct watchdog_device wdt;
+
+	/* true random number generator */
+	struct hwrng trng;
+	struct completion trng_completion;
 };
 
 static inline int omnia_cmd_write(const struct i2c_client *client, void *cmd,
@@ -166,11 +172,13 @@ static inline int omnia_cmd_read_u8(const struct i2c_client *client, u8 cmd)
 	return err ?: reply;
 }
 
+extern const u8 omnia_int_to_gpio_idx[32];
 extern const struct attribute_group omnia_mcu_gpio_group;
 extern const struct attribute_group omnia_mcu_poweroff_group;
 
 int omnia_mcu_register_gpiochip(struct omnia_mcu *mcu);
 int omnia_mcu_register_sys_off_and_wakeup(struct omnia_mcu *mcu);
+int omnia_mcu_register_trng(struct omnia_mcu *mcu);
 int omnia_mcu_register_watchdog(struct omnia_mcu *mcu);
 
 #endif /* __TURRIS_OMNIA_MCU_H */
-- 
2.43.2

