Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9769E15F316
	for <linux-crypto@vger.kernel.org>; Thu, 18 Apr 2024 12:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713442308; cv=none; b=gfdMCbGi2GXSsJxr2Q1jP6lHPyLzUHcfLJPpufjAOtw7QJqCUuwtpljn9Gmdz12VBmXlA5D03b8CEizJhudyQkb4eeBCNri56iXhLilXh9BL3kigU8EgN7WVn8hOAyPgFLNLl50DYIZaGWyzSquvy70EFhMPJr+aksmM13MMpMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713442308; c=relaxed/simple;
	bh=e8qejmy+qyVsLpQ44Ojhuv2bt/ABa6Z3G28MoRKEekg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zq1BaB7MngKAg2bC3vHdnCHhmJHxB7lBrcx68m7YNi2SiW6LG7+c0nBIiAA7Ym8/qkBv+QQJ4e2jq0xaWdfNj+H2/tN7MqZUUigZvZ3/9u9b2STKAFAOkJ7r18IyxgbuqGmiPew/dVQ3MJ60T5r4em9G0S5bUqZwFhT7J1nT0CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YGAt93DV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YGAt93DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F71C32781;
	Thu, 18 Apr 2024 12:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713442308;
	bh=e8qejmy+qyVsLpQ44Ojhuv2bt/ABa6Z3G28MoRKEekg=;
	h=From:List-Id:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGAt93DVoT3eKlhVjADmhRWzgVHGm46i0SEWwE/0ZTuJL151jZq1nUyPQ4CfiGilE
	 bRQxi2fpjeihKsoALuXwTTUtnxwWy8yOgLS2UJdQNwcZgX7Z2MFfnldfd/Amg3iz1p
	 LRh5Q0BcG0MCYJznt1XDGUJaJ53p/Wr5PApnGRjSTL+/siW3NhXyoBvwO+OISvfEqz
	 EnPbySjCxcgidWcbc7DYvJXhogRtnL0QFrcmHppIQ7VV5zOLEMY6C2sTZXhJ2KQq6P
	 a74n3uK+X70zjTgW7iSu3YW+RwToehVDzKzuRl/ZlmnfDjOCExVmYvcVqulBiBbmyf
	 dvLLnVbv1TCyg==
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To: Gregory CLEMENT <gregory.clement@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>,
	soc@kernel.org,
	Andy Shevchenko <andy@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
Cc: arm@kernel.org,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH v6 09/11] platform: cznic: turris-omnia-mcu: Add support for digital message signing via debugfs
Date: Thu, 18 Apr 2024 14:11:14 +0200
Message-ID: <20240418121116.22184-10-kabel@kernel.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240418121116.22184-1-kabel@kernel.org>
References: <20240418121116.22184-1-kabel@kernel.org>
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

As described in a similar commit 50524d787de3 ("firmware:
turris-mox-rwtm: support ECDSA signatures via debugfs"):
  The optimal solution would be to register an akcipher provider via
  kernel's crypto API, but crypto API does not yet support accessing
  akcipher API from userspace (and probably won't for some time, see
  https://www.spinics.net/lists/linux-crypto/msg38388.html).

Therefore we add support for accessing this signature generation
mechanism via debugfs for now, so that userspace can access it.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../ABI/testing/debugfs-turris-omnia-mcu      |  13 ++
 .../sysfs-bus-i2c-devices-turris-omnia-mcu    |  13 ++
 MAINTAINERS                                   |   1 +
 drivers/platform/cznic/Kconfig                |   2 +
 drivers/platform/cznic/Makefile               |   1 +
 .../platform/cznic/turris-omnia-mcu-base.c    |  45 +++-
 .../platform/cznic/turris-omnia-mcu-debugfs.c | 209 ++++++++++++++++++
 drivers/platform/cznic/turris-omnia-mcu.h     |  23 ++
 8 files changed, 306 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/debugfs-turris-omnia-mcu
 create mode 100644 drivers/platform/cznic/turris-omnia-mcu-debugfs.c

diff --git a/Documentation/ABI/testing/debugfs-turris-omnia-mcu b/Documentation/ABI/testing/debugfs-turris-omnia-mcu
new file mode 100644
index 000000000000..1665005c2dcd
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-turris-omnia-mcu
@@ -0,0 +1,13 @@
+What:		/sys/kernel/debug/turris-omnia-mcu/do_sign
+Date:		July 2024
+KernelVersion:	6.10
+Contact:	Marek Behún <kabel@kernel.org>
+Description:
+
+		======= ===========================================================
+		(Write) Message to sign with the ECDSA private key stored in MCU.
+		        The message must be exactly 32 bytes long (since this is
+		        intended to be a SHA-256 hash).
+		(Read)  The resulting signature, 64 bytes. This contains the R and
+			S values of the ECDSA signature, both in big-endian format.
+		======= ===========================================================
diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-devices-turris-omnia-mcu b/Documentation/ABI/testing/sysfs-bus-i2c-devices-turris-omnia-mcu
index 564119849388..b239224cf9bc 100644
--- a/Documentation/ABI/testing/sysfs-bus-i2c-devices-turris-omnia-mcu
+++ b/Documentation/ABI/testing/sysfs-bus-i2c-devices-turris-omnia-mcu
@@ -90,6 +90,19 @@ Description:	(RO) Contains the microcontroller type (STM32, GD32, MKL).
 
 		Format: %s.
 
+What:		/sys/bus/i2c/devices/<mcu_device>/public_key
+Date:		July 2024
+KernelVersion:	6.10
+Contact:	Marek Behún <kabel@kernel.org>
+Description:	(RO) Contains board ECDSA public key.
+
+		Only available if MCU supports signing messages with the ECDSA
+		algorithm. If so, the board has a private key stored in the MCU
+		that was generated during manufacture and cannot be retrieved
+		from the MCU.
+
+		Format: %s.
+
 What:		/sys/bus/i2c/devices/<mcu_device>/reset_selector
 Date:		July 2024
 KernelVersion:	6.10
diff --git a/MAINTAINERS b/MAINTAINERS
index b37f7ca81785..d21084ce32ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2139,6 +2139,7 @@ M:	Marek Behún <kabel@kernel.org>
 S:	Maintained
 W:	https://www.turris.cz/
 F:	Documentation/ABI/testing/debugfs-moxtet
+F:	Documentation/ABI/testing/debugfs-turris-omnia-mcu
 F:	Documentation/ABI/testing/sysfs-bus-i2c-devices-turris-omnia-mcu
 F:	Documentation/ABI/testing/sysfs-bus-moxtet-devices
 F:	Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm
diff --git a/drivers/platform/cznic/Kconfig b/drivers/platform/cznic/Kconfig
index 750d5f47dba8..2d45495c0a2d 100644
--- a/drivers/platform/cznic/Kconfig
+++ b/drivers/platform/cznic/Kconfig
@@ -30,6 +30,8 @@ config TURRIS_OMNIA_MCU
 	    disabled) and the ability to configure wake up from this mode (via
 	    rtcwake)
 	  - true random number generator (if available on the MCU)
+	  - ECDSA message signing with board private key (if available on the
+	    MCU)
 	  - MCU watchdog
 	  - GPIO pins
 	    - to get front button press events (the front button can be
diff --git a/drivers/platform/cznic/Makefile b/drivers/platform/cznic/Makefile
index eae4c6b341ff..af9213928404 100644
--- a/drivers/platform/cznic/Makefile
+++ b/drivers/platform/cznic/Makefile
@@ -6,3 +6,4 @@ turris-omnia-mcu-y		+= turris-omnia-mcu-gpio.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-sys-off-wakeup.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-trng.o
 turris-omnia-mcu-y		+= turris-omnia-mcu-watchdog.o
+turris-omnia-mcu-$(CONFIG_DEBUG_FS) += turris-omnia-mcu-debugfs.o
diff --git a/drivers/platform/cznic/turris-omnia-mcu-base.c b/drivers/platform/cznic/turris-omnia-mcu-base.c
index 7fe4a3df93a6..ec08443551a7 100644
--- a/drivers/platform/cznic/turris-omnia-mcu-base.c
+++ b/drivers/platform/cznic/turris-omnia-mcu-base.c
@@ -159,6 +159,16 @@ static ssize_t board_revision_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(board_revision);
 
+static ssize_t public_key_show(struct device *dev, struct device_attribute *a,
+			       char *buf)
+{
+	struct omnia_mcu *mcu = i2c_get_clientdata(to_i2c_client(dev));
+
+	return sysfs_emit(buf, "%*phN\n", OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN,
+			  mcu->board_public_key);
+}
+static DEVICE_ATTR_RO(public_key);
+
 static struct attribute *omnia_mcu_base_attrs[] = {
 	&dev_attr_fw_version_hash_application.attr,
 	&dev_attr_fw_version_hash_bootloader.attr,
@@ -168,6 +178,7 @@ static struct attribute *omnia_mcu_base_attrs[] = {
 	&dev_attr_serial_number.attr,
 	&dev_attr_first_mac_address.attr,
 	&dev_attr_board_revision.attr,
+	&dev_attr_public_key.attr,
 	NULL
 };
 
@@ -183,6 +194,9 @@ static umode_t omnia_mcu_base_attrs_visible(struct kobject *kobj,
 	     a == &dev_attr_board_revision.attr) &&
 	    !(mcu->features & FEAT_BOARD_INFO))
 		mode = 0;
+	else if (a == &dev_attr_public_key.attr &&
+		 !(mcu->features & FEAT_CRYPTO))
+		mode = 0;
 
 	return mode;
 }
@@ -333,6 +347,24 @@ static int omnia_mcu_read_board_info(struct omnia_mcu *mcu)
 	return 0;
 }
 
+static int omnia_mcu_read_public_key(struct omnia_mcu *mcu)
+{
+	u8 reply[1 + OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN];
+	int err;
+
+	err = omnia_cmd_read(mcu->client, CMD_CRYPTO_GET_PUBLIC_KEY, reply,
+			     sizeof(reply));
+	if (err)
+		return err;
+
+	if (reply[0] != OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN)
+		return -EIO;
+
+	memcpy(mcu->board_public_key, &reply[1], sizeof(mcu->board_public_key));
+
+	return 0;
+}
+
 static int omnia_mcu_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -361,6 +393,13 @@ static int omnia_mcu_probe(struct i2c_client *client)
 					     "Cannot read board info\n");
 	}
 
+	if (mcu->features & FEAT_CRYPTO) {
+		err = omnia_mcu_read_public_key(mcu);
+		if (err)
+			return dev_err_probe(dev, err,
+					     "Cannot read board public key\n");
+	}
+
 	err = omnia_mcu_register_sys_off_and_wakeup(mcu);
 	if (err)
 		return err;
@@ -373,7 +412,11 @@ static int omnia_mcu_probe(struct i2c_client *client)
 	if (err)
 		return err;
 
-	return omnia_mcu_register_trng(mcu);
+	err = omnia_mcu_register_trng(mcu);
+	if (err)
+		return err;
+
+	return omnia_mcu_register_debugfs(mcu);
 }
 
 static const struct of_device_id of_omnia_mcu_match[] = {
diff --git a/drivers/platform/cznic/turris-omnia-mcu-debugfs.c b/drivers/platform/cznic/turris-omnia-mcu-debugfs.c
new file mode 100644
index 000000000000..484664f8d75c
--- /dev/null
+++ b/drivers/platform/cznic/turris-omnia-mcu-debugfs.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CZ.NIC's Turris Omnia MCU ECDSA message signing via debugfs
+ *
+ * 2024 by Marek Behún <kabel@kernel.org>
+ */
+
+#include <linux/bitfield.h>
+#include <linux/completion.h>
+#include <linux/debugfs.h>
+#include <linux/devm-helpers.h>
+#include <linux/i2c.h>
+#include <linux/irqdomain.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/string.h>
+#include <linux/turris-omnia-mcu-interface.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include "turris-omnia-mcu.h"
+
+#define CMD_CRYPTO_SIGN_MESSAGE_LEN	32
+
+enum {
+	SIGN_STATE_CLOSED	= 0,
+	SIGN_STATE_OPEN		= 1,
+	SIGN_STATE_REQUESTED	= 2,
+	SIGN_STATE_COLLECTED	= 3,
+};
+
+static irqreturn_t omnia_msg_signed_irq_handler(int irq, void *dev_id)
+{
+	u8 reply[1 + OMNIA_MCU_CRYPTO_SIGNATURE_LEN];
+	struct omnia_mcu *mcu = dev_id;
+	int err;
+
+	err = omnia_cmd_read(mcu->client, CMD_CRYPTO_COLLECT_SIGNATURE, reply,
+			     sizeof(reply));
+	if (!err && reply[0] != OMNIA_MCU_CRYPTO_SIGNATURE_LEN)
+		err = -EIO;
+
+	guard(mutex)(&mcu->sign_lock);
+
+	if (mcu->sign_state == SIGN_STATE_REQUESTED) {
+		mcu->sign_err = err;
+		if (!err)
+			memcpy(mcu->signature, &reply[1],
+			       OMNIA_MCU_CRYPTO_SIGNATURE_LEN);
+		mcu->sign_state = SIGN_STATE_COLLECTED;
+		complete(&mcu->msg_signed_completion);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int do_sign_open(struct inode *inode, struct file *file)
+{
+	struct omnia_mcu *mcu = inode->i_private;
+
+	guard(mutex)(&mcu->sign_lock);
+
+	/* do_sign is allowed to be opened only once */
+	if (mcu->sign_state != SIGN_STATE_CLOSED)
+		return -EBUSY;
+
+	mcu->sign_state = SIGN_STATE_OPEN;
+
+	file->private_data = mcu;
+
+	return nonseekable_open(inode, file);
+}
+
+static int do_sign_release(struct inode *inode, struct file *file)
+{
+	struct omnia_mcu *mcu = file->private_data;
+
+	guard(mutex)(&mcu->sign_lock);
+
+	mcu->sign_state = SIGN_STATE_CLOSED;
+
+	/* forget signature on release even if it was not read, for security */
+	memzero_explicit(mcu->signature, sizeof(mcu->signature));
+
+	return 0;
+}
+
+static ssize_t do_sign_read(struct file *file, char __user *buf, size_t len,
+			    loff_t *ppos)
+{
+	struct omnia_mcu *mcu = file->private_data;
+
+	/* only allow read of one whole signature */
+	if (len != sizeof(mcu->signature))
+		return -EINVAL;
+
+	scoped_guard(mutex, &mcu->sign_lock)
+		if (mcu->sign_state != SIGN_STATE_REQUESTED &&
+		    mcu->sign_state != SIGN_STATE_COLLECTED)
+			return -ENODATA;
+
+	if (wait_for_completion_interruptible(&mcu->msg_signed_completion))
+		return -EINTR;
+
+	guard(mutex)(&mcu->sign_lock);
+
+	mcu->sign_state = SIGN_STATE_OPEN;
+
+	if (mcu->sign_err)
+		return mcu->sign_err;
+
+	if (copy_to_user(buf, mcu->signature, len))
+		return -EFAULT;
+
+	/* on read forget the signature, for security */
+	memzero_explicit(mcu->signature, sizeof(mcu->signature));
+
+	return len;
+}
+
+static ssize_t do_sign_write(struct file *file, const char __user *buf,
+			     size_t len, loff_t *ppos)
+{
+	u8 cmd[1 + CMD_CRYPTO_SIGN_MESSAGE_LEN], reply;
+	struct omnia_mcu *mcu = file->private_data;
+	int err;
+
+	/*
+	 * the input is a SHA-256 hash of a message to sign, so exactly
+	 * 32 bytes have to be read
+	 */
+	if (len != CMD_CRYPTO_SIGN_MESSAGE_LEN)
+		return -EINVAL;
+
+	cmd[0] = CMD_CRYPTO_SIGN_MESSAGE;
+
+	if (copy_from_user(&cmd[1], buf, len))
+		return -EFAULT;
+
+	guard(mutex)(&mcu->sign_lock);
+
+	if (mcu->sign_state != SIGN_STATE_OPEN)
+		return -EBUSY;
+
+	err = omnia_cmd_write_read(mcu->client, cmd, sizeof(cmd), &reply, 1);
+	if (err)
+		return err;
+
+	if (reply)
+		mcu->sign_state = SIGN_STATE_REQUESTED;
+
+	return reply ? len : -EBUSY;
+}
+
+static const struct file_operations do_sign_fops = {
+	.owner		= THIS_MODULE,
+	.open		= do_sign_open,
+	.read		= do_sign_read,
+	.write		= do_sign_write,
+	.release	= do_sign_release,
+	.llseek		= no_llseek,
+};
+
+int omnia_mcu_register_debugfs(struct omnia_mcu *mcu)
+{
+	struct device *dev = &mcu->client->dev;
+	struct dentry *root, *entry;
+	int irq, err;
+	u8 irq_idx;
+
+	if (!(mcu->features & FEAT_CRYPTO))
+		return 0;
+
+	irq_idx = omnia_int_to_gpio_idx[__bf_shf(INT_MESSAGE_SIGNED)];
+	irq = devm_irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
+	if (irq < 0)
+		return dev_err_probe(dev, irq,
+				     "Cannot map MESSAGE_SIGNED IRQ\n");
+
+	err = devm_mutex_init(dev, &mcu->sign_lock);
+	if (err)
+		return err;
+
+	mcu->sign_state = 0;
+
+	init_completion(&mcu->msg_signed_completion);
+
+	err = devm_request_threaded_irq(dev, irq, NULL,
+					omnia_msg_signed_irq_handler,
+					IRQF_ONESHOT,
+					"turris-omnia-mcu-debugfs", mcu);
+	if (err)
+		return dev_err_probe(dev, err,
+				     "Cannot request MESSAGE_SIGNED IRQ\n");
+
+	root = devm_debugfs_create_dir(dev, "turris-omnia-mcu", NULL);
+	if (IS_ERR(root))
+		return dev_err_probe(dev, PTR_ERR(root),
+				     "Cannot create debugfs dir\n");
+
+
+	entry = debugfs_create_file_unsafe("do_sign", 0600, root, mcu,
+					   &do_sign_fops);
+	if (IS_ERR(entry))
+		return dev_err_probe(dev, PTR_ERR(entry),
+				     "Cannot create debugfs entry\n");
+
+	return 0;
+}
diff --git a/drivers/platform/cznic/turris-omnia-mcu.h b/drivers/platform/cznic/turris-omnia-mcu.h
index e0cf10f8c32e..5ce639d5ec67 100644
--- a/drivers/platform/cznic/turris-omnia-mcu.h
+++ b/drivers/platform/cznic/turris-omnia-mcu.h
@@ -21,6 +21,9 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
+#define OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN	33
+#define OMNIA_MCU_CRYPTO_SIGNATURE_LEN	64
+
 struct omnia_mcu {
 	struct i2c_client *client;
 	const char *type;
@@ -30,6 +33,7 @@ struct omnia_mcu {
 	u64 board_serial_number;
 	u8 board_first_mac[ETH_ALEN];
 	u8 board_revision;
+	u8 board_public_key[OMNIA_MCU_CRYPTO_PUBLIC_KEY_LEN];
 
 	/* GPIO chip */
 	struct gpio_chip gc;
@@ -51,6 +55,16 @@ struct omnia_mcu {
 	/* true random number generator */
 	struct hwrng trng;
 	struct completion trng_completion;
+
+#ifdef CONFIG_DEBUG_FS
+	/* MCU ECDSA message signing via debugfs */
+	struct dentry *debugfs_root;
+	struct completion msg_signed_completion;
+	struct mutex sign_lock;
+	unsigned int sign_state;
+	u8 signature[OMNIA_MCU_CRYPTO_SIGNATURE_LEN];
+	int sign_err;
+#endif
 };
 
 int omnia_cmd_write_read(const struct i2c_client *client,
@@ -162,4 +176,13 @@ int omnia_mcu_register_sys_off_and_wakeup(struct omnia_mcu *mcu);
 int omnia_mcu_register_trng(struct omnia_mcu *mcu);
 int omnia_mcu_register_watchdog(struct omnia_mcu *mcu);
 
+#ifdef CONFIG_DEBUG_FS
+int omnia_mcu_register_debugfs(struct omnia_mcu *mcu);
+#else
+static inline int omnia_mcu_register_debugfs(struct omnia_mcu *mcu)
+{
+	return 0;
+}
+#endif
+
 #endif /* __TURRIS_OMNIA_MCU_H */
-- 
2.43.2

