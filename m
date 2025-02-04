Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D1E20DD71
	for <linux-crypto@vger.kernel.org>; Tue,  4 Feb 2025 13:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674870; cv=none; b=VncLHH4/mVTRlcSf+JN1ocr75sj0X4Zvq2mJHIbW6/shXef+SKuHlvjyXDPZGS4i3Hrck+bJyoKVxvCRxLvIpAJi58BWXCfHBLM30GqIyjCoywVKOASAn7abeZTlDk6o7BMEt+f3MT1Pj0UEViWzp3cs01Gz1ajoqngXUAsWJCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674870; c=relaxed/simple;
	bh=C4Y0oFTe87ATUsaE5Py2t5kX/LwIzq+3MQv5G5HA0WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tOhhytIcc/RJhrPKVkbmAd3ua1PbE/fHlIRxrwPgyzC9te25DIbfbOqPt3DY9d9pH6eJVNjPivcJv7DUlw5VzMVfeSuiMCQxPsyusRcMwQD9TH2rVgcrUDbGSYsjRkvMi2dOJoBJJfZz9HuPEIhFaXk+TeZ1I3z/VDJAC10S8dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBfKmrUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBfKmrUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF47C4AF09;
	Tue,  4 Feb 2025 13:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738674869;
	bh=C4Y0oFTe87ATUsaE5Py2t5kX/LwIzq+3MQv5G5HA0WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBfKmrUFm5hJvgxoIUuqE2AUIK6nQELHLG/hTTs3zDrDFpAvbiM0nnDh7ypBO2u2n
	 7tpCdL0oIaSxr+K03i2fGyEaDir4kKq3gKicnsZVP2acfOVfXZ2KfYQWi+JkFl/QNp
	 etOlhN8byVK0Fa9SqzPkCJS95NnjpXLSDJ0TuKCsqiIbkpWnlb8ZbT1hgraPPS3x/B
	 WEZ0/hZhFzN6VSVR2dFnPgtqoAj2t1nUpmymfNsZ9OxwbjaI1RwWfewhQlCrywLwVc
	 /7u1S61mnX2uFLvmRQOMLZiaDPhr8NkgSskryjkeQiNpyqKDycOlixd8g0wj3FOpGz
	 kYr2Y3ZLqQS9Q==
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
	soc@kernel.org
Cc: arm@kernel.org,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 1/5] platform: cznic: turris-omnia-mcu: Refactor requesting MCU interrupt
Date: Tue,  4 Feb 2025 14:14:11 +0100
Message-ID: <20250204131415.27014-2-kabel@kernel.org>
X-Mailer: git-send-email 2.45.3
In-Reply-To: <20250204131415.27014-1-kabel@kernel.org>
References: <20250204131415.27014-1-kabel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Refactor the code that gets and requests the TRNG MCU interrupt in the
TRNG part of the driver into a helper function and put it into the GPIO
part of the driver.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../platform/cznic/turris-omnia-mcu-gpio.c    | 21 ++++++++++++++++++-
 .../platform/cznic/turris-omnia-mcu-trng.c    | 17 ++++-----------
 drivers/platform/cznic/turris-omnia-mcu.h     |  4 +++-
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/platform/cznic/turris-omnia-mcu-gpio.c b/drivers/platform/cznic/turris-omnia-mcu-gpio.c
index 5f35f7c5d5d7..932383f7491a 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-gpio.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-gpio.c
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #include <linux/devm-helpers.h>
 #include <linux/errno.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio/driver.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
@@ -195,7 +196,7 @@ static const struct omnia_gpio omnia_gpios[64] = {
 };
 
 /* mapping from interrupts to indexes of GPIOs in the omnia_gpios array */
-const u8 omnia_int_to_gpio_idx[32] = {
+static const u8 omnia_int_to_gpio_idx[32] = {
 	[__bf_shf(OMNIA_INT_CARD_DET)]			= 4,
 	[__bf_shf(OMNIA_INT_MSATA_IND)]			= 5,
 	[__bf_shf(OMNIA_INT_USB30_OVC)]			= 6,
@@ -1093,3 +1094,21 @@ int omnia_mcu_register_gpiochip(struct omnia_mcu *mcu)
 
 	return 0;
 }
+
+int omnia_mcu_request_irq(struct omnia_mcu *mcu, u32 spec,
+			  irq_handler_t thread_fn, const char *devname)
+{
+	u8 irq_idx;
+	int irq;
+
+	if (!spec)
+		return -EINVAL;
+
+	irq_idx = omnia_int_to_gpio_idx[__bf_shf(spec)];
+	irq = gpiod_to_irq(gpio_device_get_desc(mcu->gc.gpiodev, irq_idx));
+	if (irq < 0)
+		return irq;
+
+	return devm_request_threaded_irq(&mcu->client->dev, irq, NULL,
+					 thread_fn, IRQF_ONESHOT, devname, mcu);
+}
diff --git a/drivers/platform/cznic/turris-omnia-mcu-trng.c b/drivers/platform/cznic/turris-omnia-mcu-trng.c
index 9a1d9292dc9a..e3826959e6de 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-trng.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-trng.c
@@ -5,12 +5,9 @@
  * 2024 by Marek Behún <kabel@kernel.org>
  */
 
-#include <linux/bitfield.h>
 #include <linux/completion.h>
 #include <linux/container_of.h>
 #include <linux/errno.h>
-#include <linux/gpio/consumer.h>
-#include <linux/gpio/driver.h>
 #include <linux/hw_random.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
@@ -62,17 +59,12 @@ static int omnia_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 int omnia_mcu_register_trng(struct omnia_mcu *mcu)
 {
 	struct device *dev = &mcu->client->dev;
-	u8 irq_idx, dummy;
-	int irq, err;
+	u8 dummy;
+	int err;
 
 	if (!(mcu->features & OMNIA_FEAT_TRNG))
 		return 0;
 
-	irq_idx = omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)];
-	irq = gpiod_to_irq(gpio_device_get_desc(mcu->gc.gpiodev, irq_idx));
-	if (irq < 0)
-		return dev_err_probe(dev, irq, "Cannot get TRNG IRQ\n");
-
 	/*
 	 * If someone else cleared the TRNG interrupt but did not read the
 	 * entropy, a new interrupt won't be generated, and entropy collection
@@ -86,9 +78,8 @@ int omnia_mcu_register_trng(struct omnia_mcu *mcu)
 
 	init_completion(&mcu->trng_entropy_ready);
 
-	err = devm_request_threaded_irq(dev, irq, NULL, omnia_trng_irq_handler,
-					IRQF_ONESHOT, "turris-omnia-mcu-trng",
-					mcu);
+	err = omnia_mcu_request_irq(mcu, OMNIA_INT_TRNG, omnia_trng_irq_handler,
+				    "turris-omnia-mcu-trng");
 	if (err)
 		return dev_err_probe(dev, err, "Cannot request TRNG IRQ\n");
 
diff --git a/drivers/platform/cznic/turris-omnia-mcu.h b/drivers/platform/cznic/turris-omnia-mcu.h
index 088541be3f4c..f2084880a00c 100644
--- a/drivers/platform/cznic/turris-omnia-mcu.h
+++ b/drivers/platform/cznic/turris-omnia-mcu.h
@@ -12,6 +12,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/hw_random.h>
 #include <linux/if_ether.h>
+#include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
@@ -91,9 +92,10 @@ struct omnia_mcu {
 };
 
 #ifdef CONFIG_TURRIS_OMNIA_MCU_GPIO
-extern const u8 omnia_int_to_gpio_idx[32];
 extern const struct attribute_group omnia_mcu_gpio_group;
 int omnia_mcu_register_gpiochip(struct omnia_mcu *mcu);
+int omnia_mcu_request_irq(struct omnia_mcu *mcu, u32 spec,
+			  irq_handler_t thread_fn, const char *devname);
 #else
 static inline int omnia_mcu_register_gpiochip(struct omnia_mcu *mcu)
 {
-- 
2.45.3

