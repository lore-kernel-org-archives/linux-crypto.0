Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BC81D952D
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718637996; cv=none; b=MMGJpmimHx00UPMwNAe47w6eonm79F7Vb/SpE6Fhbae5GqJ4vCjonpfrJqpUCuGQ4mHoPkGpaS34AilaUPodQMsnZbO/9LU2RE8PmOUSrV1ry/QF6t/DWaWskXqRz1plMnHqhq1mwFiPDVKXKmQgf+gFvNSPjf0aDvRe1UCJWi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718637996; c=relaxed/simple;
	bh=2oLEL5gQO2nK0UvYTwie2sp7OZXrcchbjHuRQjfZwXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcrIRbeKZ0sN9Rk6EL1f9K2J7IWsjvuuy56eoPtfTu80Ha9Q3CRkrhIYHEs0hfuOpY7jWeH1GnVEDBYYRgTbHCV3SZPoguYMNy0m/W6XH8HAFK2xwDJYOadMN74OcGosJ5KpmPsf6cDTlPTtHBCC3wnLp/ULuV6DC+QlohwDVIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9bvILYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9bvILYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09ED7C2BD10;
	Mon, 17 Jun 2024 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718637995;
	bh=2oLEL5gQO2nK0UvYTwie2sp7OZXrcchbjHuRQjfZwXs=;
	h=From:List-Id:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9bvILYU1o6BkjDcKxFxb1TrycxWT1SH1+lJG7VPNY4taQZ2uyTm6LXc4oid4QYlv
	 CCEDLQJnQ+vRWgXGuZTvyPyRh6KzRH7Mbqmvllt1Y1yUtjDZWdeLKR/yvFE0JsXVxY
	 +Euj8r6dyEje1+ltiGLOkJ0Ko3Dt/juZkIIloAtgPrNd+zawuNmmTkuzWELC3DXPdi
	 l0DtpssNYUL4J05s850wJnXwptX/T8iQARAN3CMMCzkf2Z/ZrFdiRntO1wBokCrsD0
	 j51XbK/Bgzk+miX49XLos1qP27Jl5AJCoHAAOnhlhzlWQ1SNx5ZMb5kr4RIn46fdYH
	 FeCueiXY1+rzQ==
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To: Gregory CLEMENT <gregory.clement@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>,
	soc@kernel.org,
	arm@kernel.org,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
Cc: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH v12 6/8] platform: cznic: turris-omnia-mcu: Add support for MCU provided TRNG
Date: Mon, 17 Jun 2024 17:26:04 +0200
Message-ID: <20240617152606.26191-7-kabel@kernel.org>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240617152606.26191-1-kabel@kernel.org>
References: <20240617152606.26191-1-kabel@kernel.org>
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
 drivers/platform/cznic/Kconfig                |   2 +
 drivers/platform/cznic/Makefile               |   1 +
 .../platform/cznic/turris-omnia-mcu-base.c    |   6 +-
 .../platform/cznic/turris-omnia-mcu-gpio.c    |   2 +-
 .../platform/cznic/turris-omnia-mcu-trng.c    | 103 ++++++++++++++++++
 drivers/platform/cznic/turris-omnia-mcu.h     |   8 ++
 6 files changed, 120 insertions(+), 2 deletions(-)
 create mode 100644 drivers/platform/cznic/turris-omnia-mcu-trng.c

diff --git a/drivers/platform/cznic/Kconfig b/drivers/platform/cznic/Kconfig
index e262930b3faf..6edac80d5fa3 100644
--- a/drivers/platform/cznic/Kconfig
+++ b/drivers/platform/cznic/Kconfig
@@ -18,6 +18,7 @@ config TURRIS_OMNIA_MCU
 	depends on I2C
 	select GPIOLIB
 	select GPIOLIB_IRQCHIP
+	select HW_RANDOM
 	select RTC_CLASS
 	select WATCHDOG_CORE
 	help
@@ -27,6 +28,7 @@ config TURRIS_OMNIA_MCU
 	  - board poweroff into true low power mode (with voltage regulators
 	    disabled) and the ability to configure wake up from this mode (via
 	    rtcwake)
+	  - true random number generator (if available on the MCU)
 	  - MCU watchdog
 	  - GPIO pins
 	    - to get front button press events (the front button can be
diff --git a/drivers/platform/cznic/Makefile b/drivers/platform/cznic/Makefile
index 687f7718c0a1..eae4c6b341ff 100644
--- a/drivers/platform/cznic/Makefile
+++ b/drivers/platform/cznic/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_TURRIS_OMNIA_MCU)	+= turris-omnia-mcu.o
 turris-omnia-mcu-y		:= turris-omnia-mcu-base.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-gpio.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-sys-off-wakeup.o
+turris-omnia-mcu-y		+= turris-omnia-mcu-trng.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-watchdog.o
diff --git a/drivers/platform/cznic/turris-omnia-mcu-base.c b/drivers/platform/cznic/turris-omnia-mcu-base.c
index 2d8e5c9a8dd1..c68a7a84a951 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-base.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-base.c
@@ -381,7 +381,11 @@ static int omnia_mcu_probe(struct i2c_client *client)
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
index 471dda5d7e1c..2d970c7f1937 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-gpio.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-gpio.c
@@ -188,7 +188,7 @@ static const struct omnia_gpio omnia_gpios[64] = {
 };
 
 /* mapping from interrupts to indexes of GPIOs in the omnia_gpios array */
-static const u8 omnia_int_to_gpio_idx[32] = {
+const u8 omnia_int_to_gpio_idx[32] = {
 	[__bf_shf(OMNIA_INT_CARD_DET)]			= 4,
 	[__bf_shf(OMNIA_INT_MSATA_IND)]			= 5,
 	[__bf_shf(OMNIA_INT_USB30_OVC)]			= 6,
diff --git a/drivers/platform/cznic/turris-omnia-mcu-trng.c b/drivers/platform/cznic/turris-omnia-mcu-trng.c
new file mode 100644
index 000000000000..ad953fb3c37a
--- /dev/null
+++ b/drivers/platform/cznic/turris-omnia-mcu-trng.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CZ.NIC's Turris Omnia MCU TRNG driver
+ *
+ * 2024 by Marek Behún <kabel@kernel.org>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/completion.h>
+#include <linux/container_of.h>
+#include <linux/errno.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
+#include <linux/hw_random.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/minmax.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <linux/turris-omnia-mcu-interface.h>
+#include "turris-omnia-mcu.h"
+
+#define OMNIA_CMD_TRNG_MAX_ENTROPY_LEN	64
+
+static irqreturn_t omnia_trng_irq_handler(int irq, void *dev_id)
+{
+	struct omnia_mcu *mcu = dev_id;
+
+	complete(&mcu->trng_entropy_ready);
+
+	return IRQ_HANDLED;
+}
+
+static int omnia_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct omnia_mcu *mcu = container_of(rng, struct omnia_mcu, trng);
+	u8 reply[1 + OMNIA_CMD_TRNG_MAX_ENTROPY_LEN];
+	int err, bytes;
+
+	if (!wait && !completion_done(&mcu->trng_entropy_ready))
+		return 0;
+
+	do {
+		if (wait_for_completion_interruptible(&mcu->trng_entropy_ready))
+			return -ERESTARTSYS;
+
+		err = omnia_cmd_read(mcu->client,
+				     OMNIA_CMD_TRNG_COLLECT_ENTROPY,
+				     reply, sizeof(reply));
+		if (err)
+			return err;
+
+		bytes = min3(reply[0], max, OMNIA_CMD_TRNG_MAX_ENTROPY_LEN);
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
+	u8 irq_idx, dummy;
+	int irq, err;
+
+	if (!(mcu->features & OMNIA_FEAT_TRNG))
+		return 0;
+
+	irq_idx = omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)];
+	irq = gpiod_to_irq(gpio_device_get_desc(mcu->gc.gpiodev, irq_idx));
+	if (!irq)
+		return dev_err_probe(dev, -ENXIO, "Cannot get TRNG IRQ\n");
+
+	/*
+	 * If someone else cleared the TRNG interrupt but did not read the
+	 * entropy, a new interrupt won't be generated, and entropy collection
+	 * will be stuck. Ensure an interrupt will be generated by executing
+	 * the collect entropy command (and discarding the result).
+	 */
+	err = omnia_cmd_read(mcu->client, OMNIA_CMD_TRNG_COLLECT_ENTROPY,
+			     &dummy, 1);
+	if (err)
+		return err;
+
+	init_completion(&mcu->trng_entropy_ready);
+
+	err = devm_request_threaded_irq(dev, irq, NULL, omnia_trng_irq_handler,
+					IRQF_ONESHOT, "turris-omnia-mcu-trng",
+					mcu);
+	if (err)
+		return dev_err_probe(dev, err, "Cannot request TRNG IRQ\n");
+
+	mcu->trng.name = "turris-omnia-mcu-trng";
+	mcu->trng.read = omnia_trng_read;
+
+	err = devm_hwrng_register(dev, &mcu->trng);
+	if (err)
+		return dev_err_probe(dev, err, "Cannot register TRNG\n");
+
+	return 0;
+}
diff --git a/drivers/platform/cznic/turris-omnia-mcu.h b/drivers/platform/cznic/turris-omnia-mcu.h
index dc59f415f611..2ca56ae13aa9 100644
--- a/drivers/platform/cznic/turris-omnia-mcu.h
+++ b/drivers/platform/cznic/turris-omnia-mcu.h
@@ -9,7 +9,9 @@
 #define __TURRIS_OMNIA_MCU_H
 
 #include <linux/bitops.h>
+#include <linux/completion.h>
 #include <linux/gpio/driver.h>
+#include <linux/hw_random.h>
 #include <linux/if_ether.h>
 #include <linux/mutex.h>
 #include <linux/types.h>
@@ -47,6 +49,10 @@ struct omnia_mcu {
 
 	/* MCU watchdog */
 	struct watchdog_device wdt;
+
+	/* true random number generator */
+	struct hwrng trng;
+	struct completion trng_entropy_ready;
 };
 
 int omnia_cmd_write_read(const struct i2c_client *client,
@@ -176,11 +182,13 @@ static inline int omnia_cmd_read_u8(const struct i2c_client *client, u8 cmd,
 	return omnia_cmd_read(client, cmd, reply, sizeof(*reply));
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
2.44.2

