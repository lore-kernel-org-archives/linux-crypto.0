Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0012F1D63D3
	for <linux-crypto@vger.kernel.org>; Tue,  4 Feb 2025 13:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674894; cv=none; b=S1VxyTXgmhk0SfSqUbcV1m1qtxutv+4kB1cmMFL2HGsFNsYp1/E3H1pP3WZ8ufKc2tR7AsCq+Hss6rSB9uSYQOqzcE1Emg20xvvjmxht/E+MKL0unJKdNJ/AYaU08MDxB4WzPU7/fUZnHqTPz2RW0QhKTjwPsgGkbpLJSnCHr/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674894; c=relaxed/simple;
	bh=B7DAB56Xm3D1cfn4h+ZqUxWnsqL3AZaInKJCIgVdlTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tm7LwtYBsBnxn4/M8yiGBb2ElLB1g1jSVR7by6egysK57+PZHjOSpz5wRQrSdPwuVcAxZWhJ2lMrZyd+c1NRW84v2Y+5r65xObdwbzOgL0AFnCH802s6Pcf3AwR6cjym1NwdBQzHs054x6AzQvu0wMnoAkq6bVud+c9+Yp+0hD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2bYabCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2bYabCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A92C4CEE2;
	Tue,  4 Feb 2025 13:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738674893;
	bh=B7DAB56Xm3D1cfn4h+ZqUxWnsqL3AZaInKJCIgVdlTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2bYabCh0pHHTXgar8sgn7NbpjLWrU6lt3FxW9ROgX1a+Cwp2441ZxQyWcZXfzE12
	 nlEWIiMjahfRrzlQ6uijjFp+WKns9OGMZAk/ips2UPMHNm3jwpggvRaZqQav4nv6NB
	 bi6mJVF0r5UUbXEPNgq1vOkyE2FZBYS4APhJ5Ar36dBS24IqhiY46+h836wtF0d5uR
	 lS8Gs99PAdoExIz22MemNcP6+V1AWct9uaOasARo1knm7TvO4zewYkk1+ojEPbiiR0
	 xuYeHFHcSUmx/p1xY/8TgszSNzjzU0XcaxzSRWdQctpc4V2yNMAIM+941pST+cxIyd
	 266ZjynlMEGDA==
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
Subject: [PATCH 5/5] firmware: turris-mox-rwtm: Add support for ECDSA signatures with HW private key
Date: Tue,  4 Feb 2025 14:14:15 +0100
Message-ID: <20250204131415.27014-6-kabel@kernel.org>
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
the rWTM secure coprocessor. Turris Mox devices have an ECDSA private
key generated and burned into rWTM eFuses when manufactured. This
private key is not readable from the rWTM, but rWTM firmware allows for
signing messages with it and retrieving the public key.

This is exposed to userspace via the keyctl API.

User can find the key by either looking at /proc/keys or listing the
keyring:

  $ cat /proc/keys
  0240b221 ... keyring   .turris-signing-keys: 1
  34ff9ac9 ... turris-si Turris MOX SN 0000000D30000005 rWTM ECDSA ke...

  $ keyctl rlist %:.turris-signing-keys
  889166537

To get the public key:

  $ keyctl read 889166537
  67 bytes of data in key:
  0201a05c 1a79242b 13f2fc02 b48ffdbb 6ee8d5ba 812d6784 5f04f302 c0894d3e
  b93474f9 46235777 5c926fb4 cce89b50 88cf5d10 c07fd9c5 fdcea257 3d8f1c33
  1bf826

To sign a message:

  $ dd if=/dev/urandom of=msg_to_sign bs=64 count=1
  $ keyctl pkey_sign 889166537 0 msg_to_sign >signature

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/firmware/Kconfig           |  17 ++++
 drivers/firmware/turris-mox-rwtm.c | 158 ++++++++++++++++++++++++++++-
 2 files changed, 174 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 71d8b26c4103..9eaef7da2a56 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -257,6 +257,23 @@ config TURRIS_MOX_RWTM
 	  other manufacturing data and also utilize the Entropy Bit Generator
 	  for hardware random number generation.
 
+if TURRIS_MOX_RWTM
+
+config TURRIS_MOX_RWTM_KEYCTL
+	bool "Turris Mox rWTM ECDSA message signing"
+	default y
+	depends on KEYS
+	depends on ASYMMETRIC_KEY_TYPE
+	select CZNIC_PLATFORMS
+	select TURRIS_SIGNING_KEY
+	help
+	  Say Y here to add support for ECDSA message signing with board private
+	  key (each Turris Mox has an ECDSA private key generated in the secure
+	  coprocessor when manufactured). This functionality is exposed via the
+	  keyctl() syscall.
+
+endif # TURRIS_MOX_RWTM
+
 source "drivers/firmware/arm_ffa/Kconfig"
 source "drivers/firmware/broadcom/Kconfig"
 source "drivers/firmware/cirrus/Kconfig"
diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index 16e5f19dfafd..1eac9948148f 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -2,11 +2,13 @@
 /*
  * Turris Mox rWTM firmware driver
  *
- * Copyright (C) 2019, 2024 Marek Behún <kabel@kernel.org>
+ * Copyright (C) 2019, 2024, 2025 Marek Behún <kabel@kernel.org>
  */
 
+#include <crypto/sha2.h>
 #include <linux/align.h>
 #include <linux/armada-37xx-rwtm-mailbox.h>
+#include <linux/cleanup.h>
 #include <linux/completion.h>
 #include <linux/container_of.h>
 #include <linux/device.h>
@@ -14,14 +16,17 @@
 #include <linux/err.h>
 #include <linux/hw_random.h>
 #include <linux/if_ether.h>
+#include <linux/key.h>
 #include <linux/kobject.h>
 #include <linux/mailbox_client.h>
+#include <linux/math.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/sizes.h>
 #include <linux/sysfs.h>
+#include <linux/turris-signing-key.h>
 #include <linux/types.h>
 
 #define DRIVER_NAME		"turris-mox-rwtm"
@@ -34,6 +39,14 @@
  * https://gitlab.labs.nic.cz/turris/mox-boot-builder/tree/master/wtmi.
  */
 
+enum {
+	MOX_ECC_NUM_BITS	= 521,
+	MOX_ECC_NUM_LEN		= DIV_ROUND_UP(MOX_ECC_NUM_BITS, 8),
+	MOX_ECC_NUM_WORDS	= DIV_ROUND_UP(MOX_ECC_NUM_BITS, 32),
+	MOX_ECC_SIG_LEN		= 2 * MOX_ECC_NUM_LEN,
+	MOX_ECC_PUBKEY_LEN	= 1 + MOX_ECC_NUM_LEN,
+};
+
 #define MBOX_STS_SUCCESS	(0 << 30)
 #define MBOX_STS_FAIL		(1 << 30)
 #define MBOX_STS_BADCMD		(2 << 30)
@@ -69,6 +82,7 @@ enum mbox_cmd {
  * @ram_size:		RAM size of the device
  * @mac_address1:	first MAC address of the device
  * @mac_address2:	second MAC address of the device
+ * @pubkey:		board ECDSA public key
  */
 struct mox_rwtm {
 	struct mbox_client mbox_client;
@@ -87,6 +101,10 @@ struct mox_rwtm {
 	u64 serial_number;
 	int board_version, ram_size;
 	u8 mac_address1[ETH_ALEN], mac_address2[ETH_ALEN];
+
+#ifdef CONFIG_TURRIS_MOX_RWTM_KEYCTL
+	u8 pubkey[MOX_ECC_PUBKEY_LEN];
+#endif
 };
 
 static inline struct device *rwtm_dev(struct mox_rwtm *rwtm)
@@ -260,6 +278,140 @@ static int mox_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	return ret;
 }
 
+#ifdef CONFIG_TURRIS_MOX_RWTM_KEYCTL
+
+static void mox_ecc_number_to_bin(void *dst, const u32 *src)
+{
+	__be32 tmp[MOX_ECC_NUM_WORDS];
+
+	cpu_to_be32_array(tmp, src, MOX_ECC_NUM_WORDS);
+
+	memcpy(dst, (void *)tmp + 2, MOX_ECC_NUM_LEN);
+}
+
+static void mox_ecc_public_key_to_bin(void *dst, u32 src_first,
+				      const u32 *src_rest)
+{
+	__be32 tmp[MOX_ECC_NUM_WORDS - 1];
+	u8 *p = dst;
+
+	/* take 3 bytes from the first word */
+	*p++ = src_first >> 16;
+	*p++ = src_first >> 8;
+	*p++ = src_first;
+
+	/* take the rest of the words */
+	cpu_to_be32_array(tmp, src_rest, MOX_ECC_NUM_WORDS - 1);
+	memcpy(p, tmp, sizeof(tmp));
+}
+
+static int mox_rwtm_sign(const struct key *key, const void *data, void *signature)
+{
+	struct mox_rwtm *rwtm = dev_get_drvdata(turris_signing_key_get_dev(key));
+	struct armada_37xx_rwtm_tx_msg msg = {};
+	u32 offset_r, offset_s;
+	int ret;
+
+	guard(mutex)(&rwtm->busy);
+
+	/*
+	 * For MBOX_CMD_SIGN command:
+	 *   args[0] - must be 1
+	 *   args[1] - address of message M to sign; message is a 521-bit number
+	 *   args[2] - address where the R part of the signature will be stored
+	 *   args[3] - address where the S part of the signature will be stored
+	 *
+	 * M, R and S are 521-bit numbers encoded as seventeen 32-bit words,
+	 * most significat word first.
+	 * Since the message in @data is a sha512 digest, the most significat
+	 * word is always zero.
+	 */
+
+	offset_r = MOX_ECC_NUM_WORDS * sizeof(u32);
+	offset_s = 2 * MOX_ECC_NUM_WORDS * sizeof(u32);
+
+	memset(rwtm->buf, 0, sizeof(u32));
+	memcpy(rwtm->buf + sizeof(u32), data, SHA512_DIGEST_SIZE);
+	be32_to_cpu_array(rwtm->buf, rwtm->buf, MOX_ECC_NUM_WORDS);
+
+	msg.args[0] = 1;
+	msg.args[1] = rwtm->buf_phys;
+	msg.args[2] = rwtm->buf_phys + offset_r;
+	msg.args[3] = rwtm->buf_phys + offset_s;
+
+	ret = mox_rwtm_exec(rwtm, MBOX_CMD_SIGN, &msg, true);
+	if (ret < 0)
+		return ret;
+
+	/* convert R and S parts of the signature */
+	mox_ecc_number_to_bin(signature, rwtm->buf + offset_r);
+	mox_ecc_number_to_bin(signature + MOX_ECC_NUM_LEN, rwtm->buf + offset_s);
+
+	return 0;
+}
+
+static const void *mox_rwtm_get_public_key(const struct key *key)
+{
+	struct mox_rwtm *rwtm = dev_get_drvdata(turris_signing_key_get_dev(key));
+
+	return rwtm->pubkey;
+}
+
+static const struct turris_signing_key_subtype mox_signing_key_subtype = {
+	.key_size		= MOX_ECC_NUM_BITS,
+	.data_size		= SHA512_DIGEST_SIZE,
+	.sig_size		= MOX_ECC_SIG_LEN,
+	.public_key_size	= MOX_ECC_PUBKEY_LEN,
+	.hash_algo		= "sha512",
+	.get_public_key		= mox_rwtm_get_public_key,
+	.sign			= mox_rwtm_sign,
+};
+
+static int mox_register_signing_key(struct mox_rwtm *rwtm)
+{
+	struct armada_37xx_rwtm_rx_msg *reply = &rwtm->reply;
+	struct device *dev = rwtm_dev(rwtm);
+	int ret;
+
+	ret = mox_rwtm_exec(rwtm, MBOX_CMD_ECDSA_PUB_KEY, NULL, false);
+	if (ret == -ENODATA) {
+		dev_warn(dev, "Board has no public key burned!\n");
+	} else if (ret == -EOPNOTSUPP) {
+		dev_notice(dev,
+			   "Firmware does not support the ECDSA_PUB_KEY command\n");
+	} else if (ret < 0) {
+		return ret;
+	} else {
+		char sn[17] = "unknown";
+		char desc[46];
+
+		if (rwtm->has_board_info)
+			sprintf(sn, "%016llX", rwtm->serial_number);
+
+		sprintf(desc, "Turris MOX SN %s rWTM ECDSA key", sn);
+
+		mox_ecc_public_key_to_bin(rwtm->pubkey, ret, reply->status);
+
+		ret = devm_turris_signing_key_create(dev,
+						     &mox_signing_key_subtype,
+						     desc);
+		if (ret)
+			return dev_err_probe(dev, ret,
+					     "Cannot create signing key\n");
+	}
+
+	return 0;
+}
+
+#else /* CONFIG_TURRIS_MOX_RWTM_KEYCTL */
+
+static inline int mox_register_signing_key(struct mox_rwtm *rwtm)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_TURRIS_MOX_RWTM_KEYCTL */
+
 static void rwtm_devm_mbox_release(void *mbox)
 {
 	mbox_free_channel(mbox);
@@ -309,6 +461,10 @@ static int turris_mox_rwtm_probe(struct platform_device *pdev)
 	if (ret < 0)
 		dev_warn(dev, "Cannot read board information: %i\n", ret);
 
+	ret = mox_register_signing_key(rwtm);
+	if (ret < 0)
+		return ret;
+
 	ret = check_get_random_support(rwtm);
 	if (ret < 0) {
 		dev_notice(dev,
-- 
2.45.3

