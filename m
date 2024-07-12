Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED89416EB40
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jul 2024 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720787205; cv=none; b=bTe+KvuFGLyIytg6Ig+E5lx1uus7URYC2x5cxIxa5ZfpD2RT9Zgp8owNjXv8i8sziYY16yyhE8EcrYNPVCmXNwjQhGW7dyAj7MW9ovYTLxrg3aRs+r0WbqYmCIBCvzEv1TNc7vG43ZOXUeZ+Wt7gRA0TCtHmTTFHLdA+jemwYi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720787205; c=relaxed/simple;
	bh=fMwVVn/39iaoYpY/bh7GA0gYIvqRIDVOj8zzLQiZVIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sf7cT6pPV69JZYIiAA1zkqLoLjIc2uWLDCFrmiMClvdp5wiXdc8x3UtKKOQqN1+maj0xJi1GULUB75DgczpfOxE/csYPRM7KlShjact0hDFY99PL7YpMxMdkwi1dBBORAYIX2nbSy+AT3nHt+sDTE53L4SYr1ZrsRdxSz9ofj3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uz6zQjrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uz6zQjrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFE2C4AF0D;
	Fri, 12 Jul 2024 12:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720787204;
	bh=fMwVVn/39iaoYpY/bh7GA0gYIvqRIDVOj8zzLQiZVIQ=;
	h=From:To:Cc:Subject:Date:From;
	b=Uz6zQjrRpaXTg9vFpluFpp+x1S8PNCez04pmH7X+hguBeiCe1X/CsmKGglgi2VfXg
	 qtpG7tqQB2UwKMNr97Zn4BsrHXcyR0W9N88594qFhjWwrvkCi3L4zv2yEVjqmis2js
	 PFZYKvM4f4IP5DpH11fRo98NbeojiU8OvRsS96Q3tLWeyynejk0UELXC/xk5Lu3ZcU
	 gB8wiabySfunwCvLOxvk38Ku8YG6krqAG3Ar87OgGyk6VOqd+6hmNl7eHOSIyYMZbx
	 lLX8dPQvAyNS4YtvC0iaqX7QFkWgTRKzG6az7UoEqKyJywq4IQX0biFpgHo+ZY9UAN
	 3SmTD+wn5DLbw==
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Cc: Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC crypto] platform: cznic: turris-omnia-mcu: Add support for digital message signing via keyctl
Date: Fri, 12 Jul 2024 14:26:35 +0200
Message-ID: <20240712122635.17734-1-kabel@kernel.org>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for digital message signing with private key stored in the
MCU. Boards with MKL MCUs have a NIST256p ECDSA private key created
when manufactured. The private key is not readable from the MCU, but
MCU allows for signing messages with it and retrieving the public key.

This is exposed to userspace via the keyctl API. The module registers
key type "turris-omnia-mcu", and on device probe, if the board supports
this feature, it allocates the keyring ".turris-omnia-mcu-keys" with one
key.

In userspace, the user can look at /proc/keys or list the keyring:

  $ cat /proc/keys
  0a3b7cd3 ... keyring   .turris-omnia-mcu-keys: 1
  3caf0b1a ... turris-om Turris Omnia SN 0000000A1000023 MCU ECDSA k...

  $ keyctl rlist %:.turris-omnia-mcu-keys
  1018104602

To get public key:

  $ keyctl read 1018104602
  33 bytes of data in key:
  025d9108 1fb538ae 8435c88b b4379171 d6b158a9 55751b91 1d23e6a9 d017f4b2
  1c

To sign a message:

  $ dd if=/dev/urandom of=msg_to_sign bs=32 count=1
  $ keyctl pkey_sign 1018104602 0 msg_to_sign >signature

The key and keyring are dropped when the driver is unbound from
the device.

The keyring and key are created with only the VIEW, READ and SEARCH
permissions for userspace - it is impossible to link / unlink / move
the key, set its attributes, or unlink the keyring from userspace.

I found one thing not possible to prevent without changing code in
security/keys: the userspace can create another key of type
"turris-omnia-mcu" in another keyring, for example:

  $ echo | keyctl padd turris-omnia-mcu TEST @u
  972416162

Nonetheless the driver is written so that using this invalid key that
shouldn't have been create at all will return -EIO:

  $ keyctl pkey_query 972416162 0
  keyctl_pkey_query: I/O error
  $ keyctl pkey_sign 972416162 0 msg_to_sign >signature
  keyctl_pkey_query: I/O error

Signed-off-by: Marek Behún <kabel@kernel.org>
---
Hi Herbert et al.,

this patch depends on patches in soc/soc.git.

I would like to get your thoughts on the following:
- should this driver create the special ".turris-omnia-mcu-keys" keyring,
  as it does in this RFC, or should it put the key into an existing
  keyring, for example user specific (root) keyring? Should it allow
  changing the keyring?
- should this driver prohibit changing owner of the key and other
  attributes, as it does in this RFC, or should it allow giving access
  to the key to other users?

Marek
---
 drivers/platform/cznic/Kconfig                |   4 +
 drivers/platform/cznic/Makefile               |   1 +
 .../platform/cznic/turris-omnia-mcu-base.c    |  30 +-
 .../platform/cznic/turris-omnia-mcu-keyctl.c  | 294 ++++++++++++++++++
 drivers/platform/cznic/turris-omnia-mcu.h     |  15 +
 5 files changed, 342 insertions(+), 2 deletions(-)
 create mode 100644 drivers/platform/cznic/turris-omnia-mcu-keyctl.c

diff --git a/drivers/platform/cznic/Kconfig b/drivers/platform/cznic/Kconfig
index 2a5235cf6844..9bc0f976d13f 100644
--- a/drivers/platform/cznic/Kconfig
+++ b/drivers/platform/cznic/Kconfig
@@ -21,6 +21,8 @@ config TURRIS_OMNIA_MCU
 	select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	select HW_RANDOM
+	select KEYS
+	select ASYMMETRIC_KEY_TYPE
 	select RTC_CLASS
 	select WATCHDOG_CORE
 	help
@@ -31,6 +33,8 @@ config TURRIS_OMNIA_MCU
 	    disabled) and the ability to configure wake up from this mode (via
 	    rtcwake)
 	  - true random number generator (if available on the MCU)
+	  - ECDSA message signing with board private key (if available on the
+	    MCU)
 	  - MCU watchdog
 	  - GPIO pins
 	    - to get front button press events (the front button can be
diff --git a/drivers/platform/cznic/Makefile b/drivers/platform/cznic/Makefile
index eae4c6b341ff..ad42cbbb4fb0 100644
--- a/drivers/platform/cznic/Makefile
+++ b/drivers/platform/cznic/Makefile
@@ -3,6 +3,7 @@
 obj-$(CONFIG_TURRIS_OMNIA_MCU)	+= turris-omnia-mcu.o
 turris-omnia-mcu-y		:= turris-omnia-mcu-base.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-gpio.o
+turris-omnia-mcu-y		+= turris-omnia-mcu-keyctl.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-sys-off-wakeup.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-trng.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-watchdog.o
diff --git a/drivers/platform/cznic/turris-omnia-mcu-base.c b/drivers/platform/cznic/turris-omnia-mcu-base.c
index c68a7a84a951..b2fb4fbb33e8 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-base.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-base.c
@@ -385,7 +385,11 @@ static int omnia_mcu_probe(struct i2c_client *client)
 	if (err)
 		return err;
 
-	return omnia_mcu_register_trng(mcu);
+	err = omnia_mcu_register_trng(mcu);
+	if (err)
+		return err;
+
+	return omnia_mcu_register_keyctl(mcu);
 }
 
 static const struct of_device_id of_omnia_mcu_match[] = {
@@ -401,7 +405,29 @@ static struct i2c_driver omnia_mcu_driver = {
 		.dev_groups = omnia_mcu_groups,
 	},
 };
-module_i2c_driver(omnia_mcu_driver);
+
+static int __init omnia_mcu_driver_init(void)
+{
+	int err;
+
+	err = omnia_mcu_keyctl_init();
+	if (err)
+		return err;
+
+	err = i2c_add_driver(&omnia_mcu_driver);
+	if (err)
+		omnia_mcu_keyctl_exit();
+
+	return err;
+}
+module_init(omnia_mcu_driver_init);
+
+static void __exit omnia_mcu_driver_exit(void)
+{
+	i2c_del_driver(&omnia_mcu_driver);
+	omnia_mcu_keyctl_exit();
+}
+module_exit(omnia_mcu_driver_exit);
 
 MODULE_AUTHOR("Marek Behun <kabel@kernel.org>");
 MODULE_DESCRIPTION("CZ.NIC's Turris Omnia MCU");
diff --git a/drivers/platform/cznic/turris-omnia-mcu-keyctl.c b/drivers/platform/cznic/turris-omnia-mcu-keyctl.c
new file mode 100644
index 000000000000..79c361c0618d
--- /dev/null
+++ b/drivers/platform/cznic/turris-omnia-mcu-keyctl.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CZ.NIC's Turris Omnia MCU ECDSA message signing via keyctl
+ *
+ * 2024 by Marek Behún <kabel@kernel.org>
+ */
+
+#include <crypto/sha2.h>
+#include <linux/bitfield.h>
+#include <linux/cleanup.h>
+#include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/key-type.h>
+#include <linux/key.h>
+#include <linux/keyctl.h>
+#include <linux/mutex.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <linux/turris-omnia-mcu-interface.h>
+#include "turris-omnia-mcu.h"
+
+#define OMNIA_CMD_CRYPTO_SIGN_MESSAGE_LEN	32
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
+		complete(&mcu->msg_signed_completion);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int omnia_key_instantiate(struct key *, struct key_preparsed_payload *)
+{
+	return 0;
+}
+
+static void omnia_key_describe(const struct key *key, struct seq_file *m)
+{
+	struct omnia_mcu *mcu = dereference_key_rcu(key);
+
+	if (!mcu)
+		return;
+
+	seq_printf(m, "%s: %*phN", key->description,
+		   OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN, mcu->board_public_key);
+}
+
+static long omnia_key_read(const struct key *key, char *buffer, size_t buflen)
+{
+	struct omnia_mcu *mcu = dereference_key_rcu(key);
+
+	if (!mcu)
+		return -EIO;
+
+	if (buffer) {
+		if (buflen > OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN)
+			buflen = OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN;
+
+		memcpy(buffer, mcu->board_public_key, buflen);
+	}
+
+	return OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN;
+}
+
+static bool omnia_asym_valid_params(const struct kernel_pkey_params *params)
+{
+	if (params->encoding && strcmp(params->encoding, "raw"))
+		return false;
+
+	if (params->hash_algo && strcmp(params->hash_algo, "sha256"))
+		return false;
+
+	return true;
+}
+
+static int omnia_key_asym_query(const struct kernel_pkey_params *params,
+				struct kernel_pkey_query *info)
+{
+	struct omnia_mcu *mcu = dereference_key_rcu(params->key);
+
+	if (!mcu)
+		return -EIO;
+
+	if (!omnia_asym_valid_params(params))
+		return -EINVAL;
+
+	info->supported_ops = KEYCTL_SUPPORTS_SIGN;
+	info->key_size = 256;
+	info->max_data_size = SHA256_DIGEST_SIZE;
+	info->max_sig_size = OMNIA_MCU_CRYPTO_SIGNATURE_LEN;
+	info->max_enc_size = 0;
+	info->max_dec_size = 0;
+
+	return 0;
+}
+
+static int omnia_key_asym_eds_op(struct kernel_pkey_params *params,
+				 const void *in, void *out)
+{
+	struct omnia_mcu *mcu = dereference_key_rcu(params->key);
+	u8 cmd[1 + SHA256_DIGEST_SIZE], reply;
+	int err;
+
+	if (!mcu)
+		return -EIO;
+
+	if (!omnia_asym_valid_params(params))
+		return -EINVAL;
+
+	if (params->op != kernel_pkey_sign)
+		return -EOPNOTSUPP;
+
+	if (params->in_len != SHA256_DIGEST_SIZE ||
+	    params->out_len != OMNIA_MCU_CRYPTO_SIGNATURE_LEN)
+		return -EINVAL;
+
+	scoped_guard(mutex, &mcu->sign_lock) {
+		if (mcu->sign_requested)
+			return -EBUSY;
+
+		cmd[0] = OMNIA_CMD_CRYPTO_SIGN_MESSAGE;
+		memcpy(&cmd[1], in, SHA256_DIGEST_SIZE);
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
+	if (wait_for_completion_interruptible(&mcu->msg_signed_completion))
+		return -EINTR;
+
+	guard(mutex)(&mcu->sign_lock);
+
+	if (mcu->sign_err)
+		return mcu->sign_err;
+
+	memcpy(out, mcu->signature, params->out_len);
+
+	/* forget the signature, for security */
+	memzero_explicit(mcu->signature, sizeof(mcu->signature));
+
+	return params->out_len;
+}
+
+static struct key_type omnia_mcu_key_type = {
+	.name		= "turris-omnia-mcu",
+	.instantiate	= omnia_key_instantiate,
+	.describe	= omnia_key_describe,
+	.read		= omnia_key_read,
+	.asym_query	= omnia_key_asym_query,
+	.asym_eds_op	= omnia_key_asym_eds_op,
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
+	memcpy(mcu->board_public_key, &reply[1], OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN);
+
+	return 0;
+}
+
+static struct key *omnia_keyring;
+
+static void omnia_release_key(void *key)
+{
+	key_unlink(omnia_keyring, key);
+	key_put(key);
+}
+
+int omnia_mcu_register_keyctl(struct omnia_mcu *mcu)
+{
+	struct device *dev = &mcu->client->dev;
+	struct key *key;
+	key_ref_t kref;
+	char desc[48];
+	int irq, err;
+	u8 irq_idx;
+
+	if (!(mcu->features & OMNIA_FEAT_CRYPTO))
+		return 0;
+
+	err = omnia_mcu_read_public_key(mcu);
+	if (err)
+		return dev_err_probe(dev, err, "Cannot read board public key\n");
+
+	irq_idx = omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_MESSAGE_SIGNED)];
+	irq = gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
+	if (irq < 0)
+		return dev_err_probe(dev, irq,
+				     "Cannot get MESSAGE_SIGNED IRQ\n");
+
+	err = devm_mutex_init(dev, &mcu->sign_lock);
+	if (err)
+		return err;
+
+	init_completion(&mcu->msg_signed_completion);
+
+	err = devm_request_threaded_irq(dev, irq, NULL,
+					omnia_msg_signed_irq_handler,
+					IRQF_ONESHOT,
+					"turris-omnia-mcu-keyctl", mcu);
+	if (err)
+		return dev_err_probe(dev, err,
+				     "Cannot request MESSAGE_SIGNED IRQ\n");
+
+	sprintf(desc, "Turris Omnia SN %016llX MCU ECDSA key",
+		mcu->board_serial_number);
+
+	kref = key_create(make_key_ref(omnia_keyring, true),
+			  omnia_mcu_key_type.name, desc, NULL, 0,
+			  (KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			  KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH,
+			  KEY_ALLOC_BUILT_IN | KEY_ALLOC_SET_KEEP |
+			  KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(kref))
+		return dev_err_probe(dev, PTR_ERR(kref), "Cannot create key\n");
+
+	key = key_ref_to_ptr(kref);
+	rcu_assign_keypointer(key, mcu);
+
+	return devm_add_action_or_reset(dev, omnia_release_key, key);
+}
+
+int omnia_mcu_keyctl_init(void)
+{
+	int err;
+
+	err = register_key_type(&omnia_mcu_key_type);
+	if (err)
+		return err;
+
+	omnia_keyring = keyring_alloc(".turris-omnia-mcu-keys",
+				      GLOBAL_ROOT_UID, GLOBAL_ROOT_GID,
+				      current_cred(),
+				      (KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				      KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH,
+				      KEY_ALLOC_BUILT_IN | KEY_ALLOC_SET_KEEP |
+				      KEY_ALLOC_NOT_IN_QUOTA,
+				      NULL, NULL);
+	if (IS_ERR(omnia_keyring)) {
+		pr_err("Cannot allocate Turris Omnia MCU keyring\n");
+
+		unregister_key_type(&omnia_mcu_key_type);
+
+		return PTR_ERR(omnia_keyring);
+	}
+
+	return 0;
+}
+
+void omnia_mcu_keyctl_exit(void)
+{
+	key_put(omnia_keyring);
+	unregister_key_type(&omnia_mcu_key_type);
+}
diff --git a/drivers/platform/cznic/turris-omnia-mcu.h b/drivers/platform/cznic/turris-omnia-mcu.h
index 2ca56ae13aa9..3371e4f635cd 100644
--- a/drivers/platform/cznic/turris-omnia-mcu.h
+++ b/drivers/platform/cznic/turris-omnia-mcu.h
@@ -20,6 +20,9 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
+#define OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN	(1 + 32)
+#define OMNIA_MCU_CRYPTO_SIGNATURE_LEN	64
+
 struct i2c_client;
 struct rtc_device;
 
@@ -32,6 +35,7 @@ struct omnia_mcu {
 	u64 board_serial_number;
 	u8 board_first_mac[ETH_ALEN];
 	u8 board_revision;
+	u8 board_public_key[OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN];
 
 	/* GPIO chip */
 	struct gpio_chip gc;
@@ -53,6 +57,13 @@ struct omnia_mcu {
 	/* true random number generator */
 	struct hwrng trng;
 	struct completion trng_entropy_ready;
+
+	/* MCU ECDSA message signing via keyctl */
+	struct completion msg_signed_completion;
+	struct mutex sign_lock;
+	bool sign_requested;
+	u8 signature[OMNIA_MCU_CRYPTO_SIGNATURE_LEN];
+	int sign_err;
 };
 
 int omnia_cmd_write_read(const struct i2c_client *client,
@@ -187,8 +198,12 @@ extern const struct attribute_group omnia_mcu_gpio_group;
 extern const struct attribute_group omnia_mcu_poweroff_group;
 
 int omnia_mcu_register_gpiochip(struct omnia_mcu *mcu);
+int omnia_mcu_register_keyctl(struct omnia_mcu *mcu);
 int omnia_mcu_register_sys_off_and_wakeup(struct omnia_mcu *mcu);
 int omnia_mcu_register_trng(struct omnia_mcu *mcu);
 int omnia_mcu_register_watchdog(struct omnia_mcu *mcu);
 
+int omnia_mcu_keyctl_init(void);
+void omnia_mcu_keyctl_exit(void);
+
 #endif /* __TURRIS_OMNIA_MCU_H */
-- 
2.44.2

