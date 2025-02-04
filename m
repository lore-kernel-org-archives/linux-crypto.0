Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCF321770E
	for <linux-crypto@vger.kernel.org>; Tue,  4 Feb 2025 13:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674884; cv=none; b=daDcGwCFUefW5bqP/PvIrH/vbg0I43blw43jHIC5J2QI6OG5DdPB2/BiLkCEd7RVkzZpvybjbHwU38z2NXOkJhWUc7zMAJN/2Tb1BNIWlfhOKqLAYTsHOeaRXRTgNgXM/9D0Eo026kCJ0CvY4U8GLbRufJrj7aiJxJERIV1afNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674884; c=relaxed/simple;
	bh=mUuhldH3XFGgE5Bt6wurmm0YH4002fJXCdOHWBu31FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FriaNzn3X1DTZ8dgAWa/nd6pUV1WpE9AjnJ0R7F0Yg+MLB4Hz7T/VVxrqga+Aq6T0pXtgqPpyeZCyz+w6ZnkrEXe4Tf4VkVj8wTPCcwx9hmh4/9IKwQbYjnWqRv6M5ZBzvnT2jBlsOxIMx4a0i2fSte+69yn5spl4c0DqYncUAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xce2ANRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xce2ANRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B61C4CEDF;
	Tue,  4 Feb 2025 13:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738674884;
	bh=mUuhldH3XFGgE5Bt6wurmm0YH4002fJXCdOHWBu31FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xce2ANRdMeXx0FejqBdqRMKEe0MziS9zBDEqR4ISfpilXA0crLAp0617z0OzHh4Bp
	 LOEOD04BjuzrfbZcI/GeYvaLpyznV0R66zJOa6zTrgumS3hJ69QmhA0S4uIi1DCOMI
	 smkMNnSuoautaPRuWMfJjVpSQcNYQT6co48HCTPekYmGo/nH1fQ2igqbtdflWuUX26
	 KsgqBmPJedt2uDge4zIPp7zm3tiaVxXC+hCJtO7XurTN2cNh8o95VNLijiHe8fE78m
	 /GtQ1ygjWnHn9u7dln7Ar0X0niOXm1FxtLN9gcSu3ueZ0bAklgajOm8MUQOdYf8W/A
	 M6KevN7N9WgLw==
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
Subject: [PATCH 3/5] platform: cznic: turris-omnia-mcu: Add support for digital message signing with HW private key
Date: Tue,  4 Feb 2025 14:14:13 +0100
Message-ID: <20250204131415.27014-4-kabel@kernel.org>
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

Add support for digital message signing with the private key stored in
the MCU. Turris Omnia boards with MKL MCUs have a NIST256p ECDSA private
key generated and burned into MCU's flash when manufactured. The private
key is not readable from the MCU, but MCU allows for signing messages
with it and retrieving the public key.

This is exposed to userspace via the keyctl API.

In userspace, the user can look at /proc/keys or list the keyring:

  $ cat /proc/keys
  0a3b7cd3 ... keyring   .turris-signing-keys: 1
  3caf0b1a ... turris-om Turris Omnia SN 0000000A1000023 MCU ECDSA k...

  $ keyctl rlist %:.turris-signing-keys
  1018104602

To get the public key:

  $ keyctl read 1018104602
  33 bytes of data in key:
  025d9108 1fb538ae 8435c88b b4379171 d6b158a9 55751b91 1d23e6a9 d017f4b2
  1c

To sign a message:

  $ dd if=/dev/urandom of=msg_to_sign bs=32 count=1
  $ keyctl pkey_sign 1018104602 0 msg_to_sign >signature

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/platform/cznic/Kconfig                |  12 ++
 drivers/platform/cznic/Makefile               |   1 +
 .../platform/cznic/turris-omnia-mcu-base.c    |   4 +
 .../platform/cznic/turris-omnia-mcu-keyctl.c  | 162 ++++++++++++++++++
 drivers/platform/cznic/turris-omnia-mcu.h     |  29 ++++
 5 files changed, 208 insertions(+)
 create mode 100644 drivers/platform/cznic/turris-omnia-mcu-keyctl.c

diff --git a/drivers/platform/cznic/Kconfig b/drivers/platform/cznic/Kconfig
index 2b4c91ede6d8..8318beb7ec94 100644
--- a/drivers/platform/cznic/Kconfig
+++ b/drivers/platform/cznic/Kconfig
@@ -75,6 +75,18 @@ config TURRIS_OMNIA_MCU_TRNG
 	  Say Y here to add support for the true random number generator
 	  provided by CZ.NIC's Turris Omnia MCU.
 
+config TURRIS_OMNIA_MCU_KEYCTL
+	bool "Turris Omnia MCU ECDSA message signing"
+	default y
+	depends on KEYS
+	depends on ASYMMETRIC_KEY_TYPE
+	depends on TURRIS_OMNIA_MCU_GPIO
+	select TURRIS_SIGNING_KEY
+	help
+	  Say Y here to add support for ECDSA message signing with board private
+	  key (if available on the MCU). This is exposed via the keyctl()
+	  syscall.
+
 endif # TURRIS_OMNIA_MCU
 
 config TURRIS_SIGNING_KEY
diff --git a/drivers/platform/cznic/Makefile b/drivers/platform/cznic/Makefile
index 2b8606a9486b..ccad7bec82e1 100644
--- a/drivers/platform/cznic/Makefile
+++ b/drivers/platform/cznic/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_TURRIS_OMNIA_MCU)	+= turris-omnia-mcu.o
 turris-omnia-mcu-y		:= turris-omnia-mcu-base.o
 turris-omnia-mcu-$(CONFIG_TURRIS_OMNIA_MCU_GPIO)		+= turris-omnia-mcu-gpio.o
+turris-omnia-mcu-$(CONFIG_TURRIS_OMNIA_MCU_KEYCTL)		+= turris-omnia-mcu-keyctl.o
 turris-omnia-mcu-$(CONFIG_TURRIS_OMNIA_MCU_SYSOFF_WAKEUP)	+= turris-omnia-mcu-sys-off-wakeup.o
 turris-omnia-mcu-$(CONFIG_TURRIS_OMNIA_MCU_TRNG)		+= turris-omnia-mcu-trng.o
 turris-omnia-mcu-$(CONFIG_TURRIS_OMNIA_MCU_WATCHDOG)		+= turris-omnia-mcu-watchdog.o
diff --git a/drivers/platform/cznic/turris-omnia-mcu-base.c b/drivers/platform/cznic/turris-omnia-mcu-base.c
index 770e680b96f9..e8fc0d7b3343 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-base.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-base.c
@@ -392,6 +392,10 @@ static int omnia_mcu_probe(struct i2c_client *client)
 	if (err)
 		return err;
 
+	err = omnia_mcu_register_keyctl(mcu);
+	if (err)
+		return err;
+
 	return omnia_mcu_register_trng(mcu);
 }
 
diff --git a/drivers/platform/cznic/turris-omnia-mcu-keyctl.c b/drivers/platform/cznic/turris-omnia-mcu-keyctl.c
new file mode 100644
index 000000000000..dc40f942f082
--- /dev/null
+++ b/drivers/platform/cznic/turris-omnia-mcu-keyctl.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CZ.NIC's Turris Omnia MCU ECDSA message signing via keyctl
+ *
+ * 2025 by Marek Behún <kabel@kernel.org>
+ */
+
+#include <crypto/sha2.h>
+#include <linux/cleanup.h>
+#include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/key.h>
+#include <linux/mutex.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <linux/turris-omnia-mcu-interface.h>
+#include <linux/turris-signing-key.h>
+#include "turris-omnia-mcu.h"
+
+static irqreturn_t omnia_msg_signed_irq_handler(int irq, void *dev_id)
+{
+	u8 reply[1 + OMNIA_MCU_CRYPTO_SIGNATURE_LEN];
+	struct omnia_mcu *mcu = dev_id;
+	int err;
+
+	err = omnia_cmd_read(mcu->client, OMNIA_CMD_CRYPTO_COLLECT_SIGNATURE,
+			     reply, sizeof(reply));
+	if (!err && reply[0] != OMNIA_MCU_CRYPTO_SIGNATURE_LEN)
+		err = -EIO;
+
+	guard(mutex)(&mcu->sign_lock);
+
+	if (mcu->sign_requested) {
+		mcu->sign_err = err;
+		if (!err)
+			memcpy(mcu->signature, &reply[1],
+			       OMNIA_MCU_CRYPTO_SIGNATURE_LEN);
+		mcu->sign_requested = false;
+		complete(&mcu->msg_signed);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int omnia_mcu_sign(const struct key *key, const void *msg,
+			  void *signature)
+{
+	struct omnia_mcu *mcu = dev_get_drvdata(turris_signing_key_get_dev(key));
+	u8 cmd[1 + SHA256_DIGEST_SIZE], reply;
+	int err;
+
+	scoped_guard(mutex, &mcu->sign_lock) {
+		if (mcu->sign_requested)
+			return -EBUSY;
+
+		cmd[0] = OMNIA_CMD_CRYPTO_SIGN_MESSAGE;
+		memcpy(&cmd[1], msg, SHA256_DIGEST_SIZE);
+
+		err = omnia_cmd_write_read(mcu->client, cmd, sizeof(cmd),
+					   &reply, 1);
+		if (err)
+			return err;
+
+		if (!reply)
+			return -EBUSY;
+
+		mcu->sign_requested = true;
+	}
+
+	if (wait_for_completion_interruptible(&mcu->msg_signed))
+		return -EINTR;
+
+	guard(mutex)(&mcu->sign_lock);
+
+	if (mcu->sign_err)
+		return mcu->sign_err;
+
+	memcpy(signature, mcu->signature, OMNIA_MCU_CRYPTO_SIGNATURE_LEN);
+
+	/* forget the signature, for security */
+	memzero_explicit(mcu->signature, sizeof(mcu->signature));
+
+	return OMNIA_MCU_CRYPTO_SIGNATURE_LEN;
+}
+
+static const void *omnia_mcu_get_public_key(const struct key *key)
+{
+	struct omnia_mcu *mcu = dev_get_drvdata(turris_signing_key_get_dev(key));
+
+	return mcu->board_public_key;
+}
+
+static const struct turris_signing_key_subtype omnia_signing_key_subtype = {
+	.key_size		= 256,
+	.data_size		= SHA256_DIGEST_SIZE,
+	.sig_size		= OMNIA_MCU_CRYPTO_SIGNATURE_LEN,
+	.public_key_size	= OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN,
+	.hash_algo		= "sha256",
+	.get_public_key		= omnia_mcu_get_public_key,
+	.sign			= omnia_mcu_sign,
+};
+
+static int omnia_mcu_read_public_key(struct omnia_mcu *mcu)
+{
+	u8 reply[1 + OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN];
+	int err;
+
+	err = omnia_cmd_read(mcu->client, OMNIA_CMD_CRYPTO_GET_PUBLIC_KEY,
+			     reply, sizeof(reply));
+	if (err)
+		return err;
+
+	if (reply[0] != OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN)
+		return -EIO;
+
+	memcpy(mcu->board_public_key, &reply[1],
+	       OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN);
+
+	return 0;
+}
+
+int omnia_mcu_register_keyctl(struct omnia_mcu *mcu)
+{
+	struct device *dev = &mcu->client->dev;
+	char desc[48];
+	int err;
+
+	if (!(mcu->features & OMNIA_FEAT_CRYPTO))
+		return 0;
+
+	err = omnia_mcu_read_public_key(mcu);
+	if (err)
+		return dev_err_probe(dev, err,
+				     "Cannot read board public key\n");
+
+	err = devm_mutex_init(dev, &mcu->sign_lock);
+	if (err)
+		return err;
+
+	init_completion(&mcu->msg_signed);
+
+	err = omnia_mcu_request_irq(mcu, OMNIA_INT_MESSAGE_SIGNED,
+				    omnia_msg_signed_irq_handler,
+				    "turris-omnia-mcu-keyctl");
+	if (err)
+		return dev_err_probe(dev, err,
+				     "Cannot request MESSAGE_SIGNED IRQ\n");
+
+	sprintf(desc, "Turris Omnia SN %016llX MCU ECDSA key",
+		mcu->board_serial_number);
+
+	err = devm_turris_signing_key_create(dev, &omnia_signing_key_subtype,
+					     desc);
+	if (err)
+		return dev_err_probe(dev, err, "Cannot create signing key\n");
+
+	return 0;
+}
diff --git a/drivers/platform/cznic/turris-omnia-mcu.h b/drivers/platform/cznic/turris-omnia-mcu.h
index f2084880a00c..8473a3031917 100644
--- a/drivers/platform/cznic/turris-omnia-mcu.h
+++ b/drivers/platform/cznic/turris-omnia-mcu.h
@@ -18,6 +18,11 @@
 #include <linux/watchdog.h>
 #include <linux/workqueue.h>
 
+enum {
+	OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN	= 1 + 32,
+	OMNIA_MCU_CRYPTO_SIGNATURE_LEN	= 64,
+};
+
 struct i2c_client;
 struct rtc_device;
 
@@ -56,6 +61,12 @@ struct rtc_device;
  * @wdt:			watchdog driver structure
  * @trng:			RNG driver structure
  * @trng_entropy_ready:		RNG entropy ready completion
+ * @msg_signed:			message signed completion
+ * @sign_lock:			mutex to protect message signing state
+ * @sign_requested:		flag indicating that message signing was requested but not completed
+ * @sign_err:			message signing error number, filled in interrupt handler
+ * @signature:			message signing signature, filled in interrupt handler
+ * @board_public_key:		board public key, if stored in MCU
  */
 struct omnia_mcu {
 	struct i2c_client *client;
@@ -89,6 +100,15 @@ struct omnia_mcu {
 	struct hwrng trng;
 	struct completion trng_entropy_ready;
 #endif
+
+#ifdef CONFIG_TURRIS_OMNIA_MCU_KEYCTL
+	struct completion msg_signed;
+	struct mutex sign_lock;
+	bool sign_requested;
+	int sign_err;
+	u8 signature[OMNIA_MCU_CRYPTO_SIGNATURE_LEN];
+	u8 board_public_key[OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN];
+#endif
 };
 
 #ifdef CONFIG_TURRIS_OMNIA_MCU_GPIO
@@ -103,6 +123,15 @@ static inline int omnia_mcu_register_gpiochip(struct omnia_mcu *mcu)
 }
 #endif
 
+#ifdef CONFIG_TURRIS_OMNIA_MCU_KEYCTL
+int omnia_mcu_register_keyctl(struct omnia_mcu *mcu);
+#else
+static inline int omnia_mcu_register_keyctl(struct omnia_mcu *mcu)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_TURRIS_OMNIA_MCU_SYSOFF_WAKEUP
 extern const struct attribute_group omnia_mcu_poweroff_group;
 int omnia_mcu_register_sys_off_and_wakeup(struct omnia_mcu *mcu);
-- 
2.45.3

