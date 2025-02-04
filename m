Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D8B1DFEF
	for <linux-crypto@vger.kernel.org>; Tue,  4 Feb 2025 13:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674890; cv=none; b=j1Px1DcRroydlnL3NgNxmZnJXhdMNGMz5CydHI1yXdghpmDMSwHQpHO64eG3PG/v7KwP4Ard+h5IyTtujyG89gipgz8aYb+M0TXF35Dr3HDqH53cdY2bZP98pW6SYidfiuV3LkZZ8KYkWfxPvoL3+3rJcn6lwlDf4k6yj+wNLbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674890; c=relaxed/simple;
	bh=tUbIHhIOslf+2m8/EY8pTv4Hgm6scR82m6ZQ4Jyqaps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uacJI4+cPhidMQa1aMFPB2Waq/wlbHvANGVSwHiwEVDuWcIcAcLeQmYMC2s2MqoPBQI03DR6meyayXCNSZCzFxi99joNh7wVtDg+runfv1UorLiMsvakNKnaDc1E/mDhsUHgF1Xm1/TwCnXtAw3tKR6UXPb6/aUj6C2JvIx5weQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t32bLlbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t32bLlbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE992C4CEE4;
	Tue,  4 Feb 2025 13:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738674890;
	bh=tUbIHhIOslf+2m8/EY8pTv4Hgm6scR82m6ZQ4Jyqaps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t32bLlbxDySt0kZ+nrLxzzwAYCMLVjZwacRKPvnGps1b8yMeokBLjWISjWFWS0G7S
	 jD9qbhCDbFv2M23AcPgAydgvd4B+gyW6eW4a/iiNlOLl0ryhRDLoJJcjucwKMZUYXl
	 5wJiueV1TRu+lTdsQNxr94fLGs92rPdvYaY/d8cw6uu9Rz7Y/Uo0VcAHjENbiSshiI
	 bQnbXVdUfJ8+D2m7Ni8D8Qz8aumyYgtayvh/94n5/AE0FFz84BG7GH41rYEYY+rAtM
	 9rCXFkDklBO8JhKGVMUP22BGNTcDjnIhPmAlOnB/pih0+weyc/ZpnCLR/fJktGfkkK
	 qq8UiR9TTyPpA==
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
Subject: [PATCH 4/5] firmware: turris-mox-rwtm: Drop ECDSA signatures via debugfs
Date: Tue,  4 Feb 2025 14:14:14 +0100
Message-ID: <20250204131415.27014-5-kabel@kernel.org>
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

Drop the debugfs implementation of the ECDSA message signing, in
preparation for a new implementation via the keyctl() syscall.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../ABI/testing/debugfs-turris-mox-rwtm       |  14 --
 .../testing/sysfs-firmware-turris-mox-rwtm    |   9 -
 drivers/firmware/turris-mox-rwtm.c            | 184 +-----------------
 3 files changed, 7 insertions(+), 200 deletions(-)
 delete mode 100644 Documentation/ABI/testing/debugfs-turris-mox-rwtm

diff --git a/Documentation/ABI/testing/debugfs-turris-mox-rwtm b/Documentation/ABI/testing/debugfs-turris-mox-rwtm
deleted file mode 100644
index 813987d5de4e..000000000000
--- a/Documentation/ABI/testing/debugfs-turris-mox-rwtm
+++ /dev/null
@@ -1,14 +0,0 @@
-What:		/sys/kernel/debug/turris-mox-rwtm/do_sign
-Date:		Jun 2020
-KernelVersion:	5.8
-Contact:	Marek Behún <kabel@kernel.org>
-Description:
-
-		======= ===========================================================
-		(Write) Message to sign with the ECDSA private key stored in
-		        device's OTP. The message must be exactly 64 bytes
-		        (since this is intended for SHA-512 hashes).
-		(Read)  The resulting signature, 136 bytes. This contains the
-			R and S values of the ECDSA signature, both in
-			big-endian format.
-		======= ===========================================================
diff --git a/Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm b/Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm
index ea5e5b489bc7..26741cb84504 100644
--- a/Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm
+++ b/Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm
@@ -12,15 +12,6 @@ Contact:	Marek Behún <kabel@kernel.org>
 Description:	(Read) MAC addresses burned into eFuses of this Turris Mox board.
 		Format: %pM
 
-What:		/sys/firmware/turris-mox-rwtm/pubkey
-Date:		August 2019
-KernelVersion:	5.4
-Contact:	Marek Behún <kabel@kernel.org>
-Description:	(Read) ECDSA public key (in pubkey hex compressed form) computed
-		as pair to the ECDSA private key burned into eFuses of this
-		Turris Mox Board.
-		Format: string
-
 What:		/sys/firmware/turris-mox-rwtm/ram_size
 Date:		August 2019
 KernelVersion:	5.4
diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index 47fe6261f5a3..16e5f19dfafd 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -5,16 +5,13 @@
  * Copyright (C) 2019, 2024 Marek Behún <kabel@kernel.org>
  */
 
-#include <crypto/sha2.h>
 #include <linux/align.h>
 #include <linux/armada-37xx-rwtm-mailbox.h>
 #include <linux/completion.h>
 #include <linux/container_of.h>
-#include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
-#include <linux/fs.h>
 #include <linux/hw_random.h>
 #include <linux/if_ether.h>
 #include <linux/kobject.h>
@@ -37,11 +34,6 @@
  * https://gitlab.labs.nic.cz/turris/mox-boot-builder/tree/master/wtmi.
  */
 
-#define MOX_ECC_NUMBER_WORDS	17
-#define MOX_ECC_NUMBER_LEN	(MOX_ECC_NUMBER_WORDS * sizeof(u32))
-
-#define MOX_ECC_SIGNATURE_WORDS	(2 * MOX_ECC_NUMBER_WORDS)
-
 #define MBOX_STS_SUCCESS	(0 << 30)
 #define MBOX_STS_FAIL		(1 << 30)
 #define MBOX_STS_BADCMD		(2 << 30)
@@ -77,10 +69,6 @@ enum mbox_cmd {
  * @ram_size:		RAM size of the device
  * @mac_address1:	first MAC address of the device
  * @mac_address2:	second MAC address of the device
- * @has_pubkey:		whether board ECDSA public key is present
- * @pubkey:		board ECDSA public key
- * @last_sig:		last ECDSA signature generated with board ECDSA private key
- * @last_sig_done:	whether the last ECDSA signing is complete
  */
 struct mox_rwtm {
 	struct mbox_client mbox_client;
@@ -99,20 +87,6 @@ struct mox_rwtm {
 	u64 serial_number;
 	int board_version, ram_size;
 	u8 mac_address1[ETH_ALEN], mac_address2[ETH_ALEN];
-
-	bool has_pubkey;
-	u8 pubkey[135];
-
-#ifdef CONFIG_DEBUG_FS
-	/*
-	 * Signature process. This is currently done via debugfs, because it
-	 * does not conform to the sysfs standard "one file per attribute".
-	 * It should be rewritten via crypto API once akcipher API is available
-	 * from userspace.
-	 */
-	u32 last_sig[MOX_ECC_SIGNATURE_WORDS];
-	bool last_sig_done;
-#endif
 };
 
 static inline struct device *rwtm_dev(struct mox_rwtm *rwtm)
@@ -120,24 +94,23 @@ static inline struct device *rwtm_dev(struct mox_rwtm *rwtm)
 	return rwtm->mbox_client.dev;
 }
 
-#define MOX_ATTR_RO(name, format, cat)				\
+#define MOX_ATTR_RO(name, format)				\
 static ssize_t							\
 name##_show(struct device *dev, struct device_attribute *a,	\
 	    char *buf)						\
 {								\
 	struct mox_rwtm *rwtm = dev_get_drvdata(dev);		\
-	if (!rwtm->has_##cat)					\
+	if (!rwtm->has_board_info)				\
 		return -ENODATA;				\
 	return sysfs_emit(buf, format, rwtm->name);		\
 }								\
 static DEVICE_ATTR_RO(name)
 
-MOX_ATTR_RO(serial_number, "%016llX\n", board_info);
-MOX_ATTR_RO(board_version, "%i\n", board_info);
-MOX_ATTR_RO(ram_size, "%i\n", board_info);
-MOX_ATTR_RO(mac_address1, "%pM\n", board_info);
-MOX_ATTR_RO(mac_address2, "%pM\n", board_info);
-MOX_ATTR_RO(pubkey, "%s\n", pubkey);
+MOX_ATTR_RO(serial_number, "%016llX\n");
+MOX_ATTR_RO(board_version, "%i\n");
+MOX_ATTR_RO(ram_size, "%i\n");
+MOX_ATTR_RO(mac_address1, "%pM\n");
+MOX_ATTR_RO(mac_address2, "%pM\n");
 
 static struct attribute *turris_mox_rwtm_attrs[] = {
 	&dev_attr_serial_number.attr,
@@ -145,7 +118,6 @@ static struct attribute *turris_mox_rwtm_attrs[] = {
 	&dev_attr_ram_size.attr,
 	&dev_attr_mac_address1.attr,
 	&dev_attr_mac_address2.attr,
-	&dev_attr_pubkey.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(turris_mox_rwtm);
@@ -247,24 +219,6 @@ static int mox_get_board_info(struct mox_rwtm *rwtm)
 		pr_info("           burned RAM size %i MiB\n", rwtm->ram_size);
 	}
 
-	ret = mox_rwtm_exec(rwtm, MBOX_CMD_ECDSA_PUB_KEY, NULL, false);
-	if (ret == -ENODATA) {
-		dev_warn(dev, "Board has no public key burned!\n");
-	} else if (ret == -EOPNOTSUPP) {
-		dev_notice(dev,
-			   "Firmware does not support the ECDSA_PUB_KEY command\n");
-	} else if (ret < 0) {
-		return ret;
-	} else {
-		u32 *s = reply->status;
-
-		rwtm->has_pubkey = true;
-		sprintf(rwtm->pubkey,
-			"%06x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x",
-			ret, s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7],
-			s[8], s[9], s[10], s[11], s[12], s[13], s[14], s[15]);
-	}
-
 	return 0;
 }
 
@@ -306,128 +260,6 @@ static int mox_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	return ret;
 }
 
-#ifdef CONFIG_DEBUG_FS
-static int rwtm_debug_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-
-	return nonseekable_open(inode, file);
-}
-
-static ssize_t do_sign_read(struct file *file, char __user *buf, size_t len,
-			    loff_t *ppos)
-{
-	struct mox_rwtm *rwtm = file->private_data;
-	ssize_t ret;
-
-	/* only allow one read, of whole signature, from position 0 */
-	if (*ppos != 0)
-		return 0;
-
-	if (len < sizeof(rwtm->last_sig))
-		return -EINVAL;
-
-	if (!rwtm->last_sig_done)
-		return -ENODATA;
-
-	ret = simple_read_from_buffer(buf, len, ppos, rwtm->last_sig,
-				      sizeof(rwtm->last_sig));
-	rwtm->last_sig_done = false;
-
-	return ret;
-}
-
-static ssize_t do_sign_write(struct file *file, const char __user *buf,
-			     size_t len, loff_t *ppos)
-{
-	struct mox_rwtm *rwtm = file->private_data;
-	struct armada_37xx_rwtm_tx_msg msg;
-	loff_t dummy = 0;
-	ssize_t ret;
-
-	if (len != SHA512_DIGEST_SIZE)
-		return -EINVAL;
-
-	/* if last result is not zero user has not read that information yet */
-	if (rwtm->last_sig_done)
-		return -EBUSY;
-
-	if (!mutex_trylock(&rwtm->busy))
-		return -EBUSY;
-
-	/*
-	 * Here we have to send:
-	 *   1. Address of the input to sign.
-	 *      The input is an array of 17 32-bit words, the first (most
-	 *      significat) is 0, the rest 16 words are copied from the SHA-512
-	 *      hash given by the user and converted from BE to LE.
-	 *   2. Address of the buffer where ECDSA signature value R shall be
-	 *      stored by the rWTM firmware.
-	 *   3. Address of the buffer where ECDSA signature value S shall be
-	 *      stored by the rWTM firmware.
-	 */
-	memset(rwtm->buf, 0, sizeof(u32));
-	ret = simple_write_to_buffer(rwtm->buf + sizeof(u32),
-				     SHA512_DIGEST_SIZE, &dummy, buf, len);
-	if (ret < 0)
-		goto unlock_mutex;
-	be32_to_cpu_array(rwtm->buf, rwtm->buf, MOX_ECC_NUMBER_WORDS);
-
-	msg.args[0] = 1;
-	msg.args[1] = rwtm->buf_phys;
-	msg.args[2] = rwtm->buf_phys + MOX_ECC_NUMBER_LEN;
-	msg.args[3] = rwtm->buf_phys + 2 * MOX_ECC_NUMBER_LEN;
-
-	ret = mox_rwtm_exec(rwtm, MBOX_CMD_SIGN, &msg, true);
-	if (ret < 0)
-		goto unlock_mutex;
-
-	/*
-	 * Here we read the R and S values of the ECDSA signature
-	 * computed by the rWTM firmware and convert their words from
-	 * LE to BE.
-	 */
-	memcpy(rwtm->last_sig, rwtm->buf + MOX_ECC_NUMBER_LEN,
-	       sizeof(rwtm->last_sig));
-	cpu_to_be32_array(rwtm->last_sig, rwtm->last_sig,
-			  MOX_ECC_SIGNATURE_WORDS);
-	rwtm->last_sig_done = true;
-
-	mutex_unlock(&rwtm->busy);
-	return len;
-unlock_mutex:
-	mutex_unlock(&rwtm->busy);
-	return ret;
-}
-
-static const struct file_operations do_sign_fops = {
-	.owner	= THIS_MODULE,
-	.open	= rwtm_debug_open,
-	.read	= do_sign_read,
-	.write	= do_sign_write,
-};
-
-static void rwtm_debugfs_release(void *root)
-{
-	debugfs_remove_recursive(root);
-}
-
-static void rwtm_register_debugfs(struct mox_rwtm *rwtm)
-{
-	struct dentry *root;
-
-	root = debugfs_create_dir("turris-mox-rwtm", NULL);
-
-	debugfs_create_file_unsafe("do_sign", 0600, root, rwtm, &do_sign_fops);
-
-	devm_add_action_or_reset(rwtm_dev(rwtm), rwtm_debugfs_release, root);
-}
-#else
-static inline void rwtm_register_debugfs(struct mox_rwtm *rwtm)
-{
-}
-#endif
-
 static void rwtm_devm_mbox_release(void *mbox)
 {
 	mbox_free_channel(mbox);
@@ -491,8 +323,6 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Cannot register HWRNG!\n");
 
-	rwtm_register_debugfs(rwtm);
-
 	dev_info(dev, "HWRNG successfully registered\n");
 
 	/*
-- 
2.45.3

