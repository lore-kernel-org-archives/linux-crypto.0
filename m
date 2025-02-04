Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E6420DD71
	for <linux-crypto@vger.kernel.org>; Tue,  4 Feb 2025 13:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674875; cv=none; b=HsnRUAQhpzi4GnfNyHvHYyBwg46shPSo8C5E4BoCf5fTanpqQv292zhehDTwMkUCyt5v8sXTWGiXp43GAEHIJbzXk1L8MwvLU59ksL41VzuBFcYk/KzRXikyxFc1TgbrQyjG9cXnui/Q3wCBkrejTj7Hc7aRJDONw8O45M+z4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674875; c=relaxed/simple;
	bh=x1ygPA8J4qnuyDNUMKtqKy91nBFfJUfK5w83C12NV2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GHG1EXBBuuWt2eO1/kDp05OZvzujLrTlU7Xv10lm1Jl6vmUp/cX0pZgn9SnOxvNm2pKZi7Iy2aupR7fAemsezFeON49KHYXFozmHQ1LWgPnWGtS/hTOvYt+hOuOwg6Vv1MWjFy6q6rNR2WC5T9T3+atgR5m8XVb59e61mBjqSyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xy1VEjDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xy1VEjDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F4DC4CEEA;
	Tue,  4 Feb 2025 13:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738674874;
	bh=x1ygPA8J4qnuyDNUMKtqKy91nBFfJUfK5w83C12NV2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy1VEjDK7Mv/Bad0x5ax8F/X87+Jb0ktSc8Q11SbC4EeRRhi6k8u3nG2yhndX8RuI
	 hgrKqWFJrd1AyyrqO1qK0RcLnCHrNvC2SwueWjs+wrBAqd9mXOKjKrGbO123jHgnUq
	 nXFwJhv604JjCpFuLUgS2JpLdnPym0jQ15cIdEMr8f0aA5HJxnvF0F3ahwTxRM5ztU
	 ombP8ozvOqGU31j/kZXAgjPHxCXroRURL7vRWmLDmhZpCDO+KpJ1VTJDJTNUbQiTI5
	 YG4ULW0ZHlZ+EkQFysKTDU/570hOS7IhCBpVJ38vR3r1bO65ZD9iq6v+AvcXpvEVdW
	 T6rhTUOXebvog==
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
Subject: [PATCH 2/5] platform: cznic: Add keyctl helpers for Turris platform
Date: Tue,  4 Feb 2025 14:14:12 +0100
Message-ID: <20250204131415.27014-3-kabel@kernel.org>
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

Some Turris devices support signing messages with a per-device unique
asymmetric key that was created on the device at manufacture time.

Add helper module that helps to expose this ability via the keyctl()
syscall.

A device-specific driver can register a signing key by calling
devm_turris_signing_key_create().

Both the `.turris-signing-keys` keyring and the signing key are created
with only the VIEW, READ and SEARCH permissions for userspace - it is
impossible to link / unlink / move them, set their attributes, or unlink
the keyring from userspace.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 MAINTAINERS                                 |   1 +
 drivers/platform/cznic/Kconfig              |   5 +
 drivers/platform/cznic/Makefile             |   2 +
 drivers/platform/cznic/turris-signing-key.c | 192 ++++++++++++++++++++
 include/linux/turris-signing-key.h          |  33 ++++
 5 files changed, 233 insertions(+)
 create mode 100644 drivers/platform/cznic/turris-signing-key.c
 create mode 100644 include/linux/turris-signing-key.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 896a307fa065..e37c3f3425a9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2442,6 +2442,7 @@ F:	include/dt-bindings/bus/moxtet.h
 F:	include/linux/armada-37xx-rwtm-mailbox.h
 F:	include/linux/moxtet.h
 F:	include/linux/turris-omnia-mcu-interface.h
+F:	include/linux/turris-signing-key.h
 
 ARM/FARADAY FA526 PORT
 M:	Hans Ulli Kroll <ulli.kroll@googlemail.com>
diff --git a/drivers/platform/cznic/Kconfig b/drivers/platform/cznic/Kconfig
index 49c383eb6785..2b4c91ede6d8 100644
--- a/drivers/platform/cznic/Kconfig
+++ b/drivers/platform/cznic/Kconfig
@@ -77,4 +77,9 @@ config TURRIS_OMNIA_MCU_TRNG
 
 endif # TURRIS_OMNIA_MCU
 
+config TURRIS_SIGNING_KEY
+	tristate
+	depends on KEYS
+	depends on ASYMMETRIC_KEY_TYPE
+
 endif # CZNIC_PLATFORMS
diff --git a/drivers/platform/cznic/Makefile b/drivers/platform/cznic/Makefile
index ce6d997f34d6..2b8606a9486b 100644
--- a/drivers/platform/cznic/Makefile
+++ b/drivers/platform/cznic/Makefile
@@ -6,3 +6,5 @@ turris-omnia-mcu-$(CONFIG_TURRIS_OMNIA_MCU_GPIO)		+= turris-omnia-mcu-gpio.o
 turris-omnia-mcu-$(CONFIG_TURRIS_OMNIA_MCU_SYSOFF_WAKEUP)	+= turris-omnia-mcu-sys-off-wakeup.o
 turris-omnia-mcu-$(CONFIG_TURRIS_OMNIA_MCU_TRNG)		+= turris-omnia-mcu-trng.o
 turris-omnia-mcu-$(CONFIG_TURRIS_OMNIA_MCU_WATCHDOG)		+= turris-omnia-mcu-watchdog.o
+
+obj-$(CONFIG_TURRIS_SIGNING_KEY) += turris-signing-key.o
diff --git a/drivers/platform/cznic/turris-signing-key.c b/drivers/platform/cznic/turris-signing-key.c
new file mode 100644
index 000000000000..3b12e5245fb7
--- /dev/null
+++ b/drivers/platform/cznic/turris-signing-key.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Some of CZ.NIC's Turris devices support signing messages with a per-device unique asymmetric
+ * cryptographic key that was burned into the device at manufacture.
+ *
+ * This helper module exposes this message signing ability via the keyctl() syscall. Upon load, it
+ * creates the `.turris-signing-keys` keyring. A device-specific driver then has to create a signing
+ * key by calling devm_turris_signing_key_create().
+ *
+ * 2025 by Marek Behún <kabel@kernel.org>
+ */
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/key-type.h>
+#include <linux/key.h>
+#include <linux/keyctl.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <linux/turris-signing-key.h>
+
+static int turris_signing_key_instantiate(struct key *, struct key_preparsed_payload *)
+{
+	return 0;
+}
+
+static void turris_signing_key_describe(const struct key *key, struct seq_file *m)
+{
+	const struct turris_signing_key_subtype *subtype = dereference_key_rcu(key);
+
+	if (!subtype)
+		return;
+
+	seq_printf(m, "%s: %*phN", key->description, subtype->public_key_size,
+		   subtype->get_public_key(key));
+}
+
+static long turris_signing_key_read(const struct key *key, char *buffer, size_t buflen)
+{
+	const struct turris_signing_key_subtype *subtype = dereference_key_rcu(key);
+
+	if (!subtype)
+		return -EIO;
+
+	if (buffer) {
+		if (buflen > subtype->public_key_size)
+			buflen = subtype->public_key_size;
+
+		memcpy(buffer, subtype->get_public_key(key), subtype->public_key_size);
+	}
+
+	return subtype->public_key_size;
+}
+
+static bool turris_signing_key_asym_valid_params(const struct turris_signing_key_subtype *subtype,
+						 const struct kernel_pkey_params *params)
+{
+	if (params->encoding && strcmp(params->encoding, "raw"))
+		return false;
+
+	if (params->hash_algo && strcmp(params->hash_algo, subtype->hash_algo))
+		return false;
+
+	return true;
+}
+
+static int turris_signing_key_asym_query(const struct kernel_pkey_params *params,
+					 struct kernel_pkey_query *info)
+{
+	const struct turris_signing_key_subtype *subtype = dereference_key_rcu(params->key);
+
+	if (!subtype)
+		return -EIO;
+
+	if (!turris_signing_key_asym_valid_params(subtype, params))
+		return -EINVAL;
+
+	info->supported_ops = KEYCTL_SUPPORTS_SIGN;
+	info->key_size = subtype->key_size;
+	info->max_data_size = subtype->data_size;
+	info->max_sig_size = subtype->sig_size;
+	info->max_enc_size = 0;
+	info->max_dec_size = 0;
+
+	return 0;
+}
+
+static int turris_signing_key_asym_eds_op(struct kernel_pkey_params *params,
+				 const void *in, void *out)
+{
+	const struct turris_signing_key_subtype *subtype = dereference_key_rcu(params->key);
+	int err;
+
+	if (!subtype)
+		return -EIO;
+
+	if (!turris_signing_key_asym_valid_params(subtype, params))
+		return -EINVAL;
+
+	if (params->op != kernel_pkey_sign)
+		return -EOPNOTSUPP;
+
+	if (params->in_len != subtype->data_size || params->out_len != subtype->sig_size)
+		return -EINVAL;
+
+	err = subtype->sign(params->key, in, out);
+	if (err)
+		return err;
+
+	return subtype->sig_size;
+}
+
+static struct key_type turris_signing_key_type = {
+	.name		= "turris-signing-key",
+	.instantiate	= turris_signing_key_instantiate,
+	.describe	= turris_signing_key_describe,
+	.read		= turris_signing_key_read,
+	.asym_query	= turris_signing_key_asym_query,
+	.asym_eds_op	= turris_signing_key_asym_eds_op,
+};
+
+static struct key *turris_signing_keyring;
+
+static void turris_signing_key_release(void *key)
+{
+	key_unlink(turris_signing_keyring, key);
+	key_put(key);
+}
+
+int
+devm_turris_signing_key_create(struct device *dev, const struct turris_signing_key_subtype *subtype,
+			       const char *desc)
+{
+	struct key *key;
+	key_ref_t kref;
+
+	kref = key_create(make_key_ref(turris_signing_keyring, true),
+			  turris_signing_key_type.name, desc, NULL, 0,
+			  (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_VIEW | KEY_USR_READ |
+			  KEY_USR_SEARCH,
+			  KEY_ALLOC_BUILT_IN | KEY_ALLOC_SET_KEEP | KEY_ALLOC_NOT_IN_QUOTA);
+	if (IS_ERR(kref))
+		return PTR_ERR(kref);
+
+	key = key_ref_to_ptr(kref);
+	key->payload.data[1] = dev;
+	rcu_assign_keypointer(key, subtype);
+
+	return devm_add_action_or_reset(dev, turris_signing_key_release, key);
+}
+EXPORT_SYMBOL_GPL(devm_turris_signing_key_create);
+
+static int turris_signing_key_init(void)
+{
+	int err;
+
+	err = register_key_type(&turris_signing_key_type);
+	if (err)
+		return err;
+
+	turris_signing_keyring = keyring_alloc(".turris-signing-keys",
+					       GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
+					       (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_VIEW |
+					       KEY_USR_READ | KEY_USR_SEARCH,
+					       KEY_ALLOC_BUILT_IN | KEY_ALLOC_SET_KEEP |
+					       KEY_ALLOC_NOT_IN_QUOTA,
+					       NULL, NULL);
+	if (IS_ERR(turris_signing_keyring)) {
+		pr_err("Cannot allocate Turris keyring\n");
+
+		unregister_key_type(&turris_signing_key_type);
+
+		return PTR_ERR(turris_signing_keyring);
+	}
+
+	return 0;
+}
+module_init(turris_signing_key_init);
+
+static void turris_signing_key_exit(void)
+{
+	key_put(turris_signing_keyring);
+	unregister_key_type(&turris_signing_key_type);
+}
+module_exit(turris_signing_key_exit);
+
+MODULE_AUTHOR("Marek Behun <kabel@kernel.org>");
+MODULE_DESCRIPTION("CZ.NIC's Turris signing key helper");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/turris-signing-key.h b/include/linux/turris-signing-key.h
new file mode 100644
index 000000000000..032ca8cbf636
--- /dev/null
+++ b/include/linux/turris-signing-key.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * 2025 by Marek Behún <kabel@kernel.org>
+ */
+
+#ifndef __TURRIS_SIGNING_KEY_H
+#define __TURRIS_SIGNING_KEY_H
+
+#include <linux/key.h>
+#include <linux/types.h>
+
+struct device;
+
+struct turris_signing_key_subtype {
+	u16 key_size;
+	u8 data_size;
+	u8 sig_size;
+	u8 public_key_size;
+	const char *hash_algo;
+	const void *(*get_public_key)(const struct key *key);
+	int (*sign)(const struct key *key, const void *msg, void *signature);
+};
+
+static inline struct device *turris_signing_key_get_dev(const struct key *key)
+{
+	return key->payload.data[1];
+}
+
+int
+devm_turris_signing_key_create(struct device *dev, const struct turris_signing_key_subtype *subtype,
+			       const char *desc);
+
+#endif /* __TURRIS_SIGNING_KEY_H */
-- 
2.45.3

