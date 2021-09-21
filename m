Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A2FC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 21:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3F8761019
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 21:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhIUVub (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Sep 2021 17:50:31 -0400
Received: from 82-65-109-163.subs.proxad.net ([82.65.109.163]:34176 "EHLO
        luna.linkmauve.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhIUVub (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Sep 2021 17:50:31 -0400
Received: by luna.linkmauve.fr (Postfix, from userid 1000)
        id C171DF40B69; Tue, 21 Sep 2021 23:39:45 +0200 (CEST)
From:   Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
To:     linux-crypto@vger.kernel.org
Cc:     Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        Ash Logan <ash@heyquark.com>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.ne@posteo.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/4] crypto: nintendo-aes - add a new AES driver
Date:   Tue, 21 Sep 2021 23:39:27 +0200
Message-Id: <20210921213930.10366-2-linkmauve@linkmauve.fr>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210921213930.10366-1-linkmauve@linkmauve.fr>
References: <20210921213930.10366-1-linkmauve@linkmauve.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This engine implements AES in CBC mode, using 128-bit keys only.  It is
present on both the Wii and the Wii U, and is apparently identical in
both consoles.

The hardware is capable of firing an interrupt when the operation is
done, but this driver currently uses a busy loop, I’m not too sure
whether it would be preferable to switch, nor how to achieve that.

It also supports a mode where no operation is done, and thus could be
used as a DMA copy engine, but I don’t know how to expose that to the
kernel or whether it would even be useful.

In my testing, on a Wii U, this driver reaches 80.7 MiB/s, while the
aes-generic driver only reaches 30.9 MiB/s, so it is a quite welcome
speedup.

This driver was written based on reversed documentation, see:
https://wiibrew.org/wiki/Hardware/AES

Signed-off-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
Tested-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>  # on Wii U
---
 drivers/crypto/Kconfig        |  11 ++
 drivers/crypto/Makefile       |   1 +
 drivers/crypto/nintendo-aes.c | 273 ++++++++++++++++++++++++++++++++++
 3 files changed, 285 insertions(+)
 create mode 100644 drivers/crypto/nintendo-aes.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 9a4c275a1335..adc94ad7462d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -871,4 +871,15 @@ config CRYPTO_DEV_SA2UL
 
 source "drivers/crypto/keembay/Kconfig"
 
+config CRYPTO_DEV_NINTENDO
+	tristate "Support for the Nintendo Wii U AES engine"
+	depends on WII || WIIU || COMPILE_TEST
+	select CRYPTO_AES
+	help
+	  Say 'Y' here to use the Nintendo Wii or Wii U on-board AES
+	  engine for the CryptoAPI AES algorithm.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called nintendo-aes.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index fa22cb19e242..004dae7bbf39 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_CRYPTO_DEV_MARVELL) += marvell/
 obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) += mxs-dcp.o
 obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
 n2_crypto-y := n2_core.o n2_asm.o
+obj-$(CONFIG_CRYPTO_DEV_NINTENDO) += nintendo-aes.o
 obj-$(CONFIG_CRYPTO_DEV_NX) += nx/
 obj-$(CONFIG_CRYPTO_DEV_OMAP) += omap-crypto.o
 obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes-driver.o
diff --git a/drivers/crypto/nintendo-aes.c b/drivers/crypto/nintendo-aes.c
new file mode 100644
index 000000000000..79ae77500999
--- /dev/null
+++ b/drivers/crypto/nintendo-aes.c
@@ -0,0 +1,273 @@
+/*
+ * Copyright (C) 2021 Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/mod_devicetable.h>
+#include <linux/crypto.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <crypto/aes.h>
+#include <crypto/internal/skcipher.h>
+
+#include <linux/io.h>
+#include <linux/delay.h>
+
+/* Addresses of the registers */
+#define AES_CTRL 0
+#define AES_SRC  4
+#define AES_DEST 8
+#define AES_KEY  12
+#define AES_IV   16
+
+#define AES_CTRL_EXEC       0x80000000
+#define AES_CTRL_EXEC_RESET 0x00000000
+#define AES_CTRL_EXEC_INIT  0x80000000
+#define AES_CTRL_IRQ        0x40000000
+#define AES_CTRL_ERR        0x20000000
+#define AES_CTRL_ENA        0x10000000
+#define AES_CTRL_DEC        0x08000000
+#define AES_CTRL_IV         0x00001000
+#define AES_CTRL_BLOCK      0x00000fff
+
+#define OP_TIMEOUT 0x1000
+
+#define AES_DIR_DECRYPT 0
+#define AES_DIR_ENCRYPT 1
+
+static void __iomem *base;
+static spinlock_t lock;
+
+/* Write a 128 bit field (either a writable key or IV) */
+static inline void
+writefield(u32 reg, const void *_value)
+{
+	const u32 *value = _value;
+	int i;
+
+	for (i = 0; i < 4; i++)
+		iowrite32be(value[i], base + reg);
+}
+
+static int
+do_crypt(const void *src, void *dst, u32 len, u32 flags)
+{
+	u32 blocks = ((len >> 4) - 1) & AES_CTRL_BLOCK;
+	u32 status;
+	u32 counter = OP_TIMEOUT;
+	u32 i;
+
+	/* Flush out all of src, we can’t know whether any of it is in cache */
+	for (i = 0; i < len; i += 32)
+		__asm__("dcbf 0, %0" : : "r" (src + i));
+	__asm__("sync" : : : "memory");
+
+	/* Set the addresses for DMA */
+	iowrite32be(virt_to_phys((void *)src), base + AES_SRC);
+	iowrite32be(virt_to_phys(dst), base + AES_DEST);
+
+	/* Start the operation */
+	iowrite32be(flags | blocks, base + AES_CTRL);
+
+	/* TODO: figure out how to use interrupts here, this will probably
+	 * lower throughput but let the CPU do other things while the AES
+	 * engine is doing its work. */
+	do {
+		status = ioread32be(base + AES_CTRL);
+		cpu_relax();
+	} while ((status & AES_CTRL_EXEC) && --counter);
+
+	/* Do we ever get called with dst ≠ src?  If so we have to invalidate
+	 * dst in addition to the earlier flush of src. */
+	if (unlikely(dst != src)) {
+		for (i = 0; i < len; i += 32)
+			__asm__("dcbi 0, %0" : : "r" (dst + i));
+		__asm__("sync" : : : "memory");
+	}
+
+	return counter ? 0 : 1;
+}
+
+static void
+nintendo_aes_crypt(const void *src, void *dst, u32 len, u8 *iv, int dir,
+		   bool firstchunk)
+{
+	u32 flags = 0;
+	unsigned long iflags;
+	int ret;
+
+	flags |= AES_CTRL_EXEC_INIT /* | AES_CTRL_IRQ */ | AES_CTRL_ENA;
+
+	if (dir == AES_DIR_DECRYPT)
+		flags |= AES_CTRL_DEC;
+
+	if (!firstchunk)
+		flags |= AES_CTRL_IV;
+
+	/* Start the critical section */
+	spin_lock_irqsave(&lock, iflags);
+
+	if (firstchunk)
+		writefield(AES_IV, iv);
+
+	ret = do_crypt(src, dst, len, flags);
+	BUG_ON(ret);
+
+	spin_unlock_irqrestore(&lock, iflags);
+}
+
+static int nintendo_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
+				    unsigned int len)
+{
+	/* The hardware only supports AES-128 */
+	if (len != AES_KEYSIZE_128)
+		return -EINVAL;
+
+	writefield(AES_KEY, key);
+	return 0;
+}
+
+static int nintendo_skcipher_crypt(struct skcipher_request *req, int dir)
+{
+	struct skcipher_walk walk;
+	unsigned int nbytes;
+	int err;
+	char ivbuf[AES_BLOCK_SIZE];
+	unsigned int ivsize;
+
+	bool firstchunk = true;
+
+	/* Reset the engine */
+	iowrite32be(0, base + AES_CTRL);
+
+	err = skcipher_walk_virt(&walk, req, false);
+	ivsize = min(sizeof(ivbuf), walk.ivsize);
+
+	while ((nbytes = walk.nbytes) != 0) {
+		unsigned int chunkbytes = round_down(nbytes, AES_BLOCK_SIZE);
+		unsigned int ret = nbytes % AES_BLOCK_SIZE;
+
+		if (walk.total == chunkbytes && dir == AES_DIR_DECRYPT) {
+			/* If this is the last chunk and we're decrypting, take
+			 * note of the IV (which is the last ciphertext block)
+			 */
+			memcpy(ivbuf, walk.src.virt.addr + walk.total - ivsize,
+			       ivsize);
+		}
+
+		nintendo_aes_crypt(walk.src.virt.addr, walk.dst.virt.addr,
+				   chunkbytes, walk.iv, dir, firstchunk);
+
+		if (walk.total == chunkbytes && dir == AES_DIR_ENCRYPT) {
+			/* If this is the last chunk and we're encrypting, take
+			 * note of the IV (which is the last ciphertext block)
+			 */
+			memcpy(walk.iv,
+			       walk.dst.virt.addr + walk.total - ivsize,
+			       ivsize);
+		} else if (walk.total == chunkbytes && dir == AES_DIR_DECRYPT) {
+			memcpy(walk.iv, ivbuf, ivsize);
+		}
+
+		err = skcipher_walk_done(&walk, ret);
+		firstchunk = false;
+	}
+
+	return err;
+}
+
+static int nintendo_cbc_encrypt(struct skcipher_request *req)
+{
+	return nintendo_skcipher_crypt(req, AES_DIR_ENCRYPT);
+}
+
+static int nintendo_cbc_decrypt(struct skcipher_request *req)
+{
+	return nintendo_skcipher_crypt(req, AES_DIR_DECRYPT);
+}
+
+static struct skcipher_alg nintendo_alg = {
+	.base.cra_name		= "cbc(aes)",
+	.base.cra_driver_name	= "cbc-aes-nintendo",
+	.base.cra_priority	= 400,
+	.base.cra_flags		= CRYPTO_ALG_KERN_DRIVER_ONLY,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_alignmask	= 15,
+	.base.cra_module	= THIS_MODULE,
+	.setkey			= nintendo_setkey_skcipher,
+	.encrypt		= nintendo_cbc_encrypt,
+	.decrypt		= nintendo_cbc_decrypt,
+	.min_keysize		= AES_KEYSIZE_128,
+	.max_keysize		= AES_KEYSIZE_128,
+	.ivsize			= AES_BLOCK_SIZE,
+};
+
+static int nintendo_aes_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+
+	crypto_unregister_skcipher(&nintendo_alg);
+	devm_iounmap(dev, base);
+	base = NULL;
+
+	return 0;
+}
+
+static int nintendo_aes_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	spin_lock_init(&lock);
+
+	ret = crypto_register_skcipher(&nintendo_alg);
+	if (ret)
+		goto eiomap;
+
+	dev_notice(dev, "Nintendo Wii and Wii U AES engine enabled\n");
+	return 0;
+
+ eiomap:
+	devm_iounmap(dev, base);
+
+	dev_err(dev, "Nintendo Wii and Wii U AES initialization failed\n");
+	return ret;
+}
+
+static const struct of_device_id nintendo_aes_of_match[] = {
+	{ .compatible = "nintendo,hollywood-aes", },
+	{ .compatible = "nintendo,latte-aes", },
+	{/* sentinel */},
+};
+MODULE_DEVICE_TABLE(of, nintendo_aes_of_match);
+
+static struct platform_driver nintendo_aes_driver = {
+	.driver = {
+		.name = "nintendo-aes",
+		.of_match_table = nintendo_aes_of_match,
+	},
+	.probe = nintendo_aes_probe,
+	.remove = nintendo_aes_remove,
+};
+
+module_platform_driver(nintendo_aes_driver);
+
+MODULE_AUTHOR("Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>");
+MODULE_DESCRIPTION("Nintendo Wii and Wii U Hardware AES driver");
+MODULE_LICENSE("GPL");
-- 
2.33.0

