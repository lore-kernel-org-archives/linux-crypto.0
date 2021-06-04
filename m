Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2324DC4743C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 17:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0756F613F8
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 17:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFDREN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Jun 2021 13:04:13 -0400
Received: from foss.arm.com ([217.140.110.172]:43528 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhFDREN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jun 2021 13:04:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACCD61063;
        Fri,  4 Jun 2021 10:02:26 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D5503F73D;
        Fri,  4 Jun 2021 10:02:24 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Ali Saidi <alisaidi@amazon.com>
Subject: [PATCH] hwrng: Add Arm SMCCC TRNG based driver
Date:   Fri,  4 Jun 2021 18:02:16 +0100
Message-Id: <20210604170216.4705-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "Arm True Random Number Generator Firmware Interface"[1] provides
an SMCCC based interface to a true hardware random number generator.
So far we are using that in arch_get_random_seed(), but it might be
useful to expose the entropy through the /dev/hwrng device as well. This
allows to assess the quality of the implementation, by using "rngtest"
from the rng-tools package, for example.

Add a simple platform driver implementing the hw_random interface.
We unconditionally instantiate the platform device in the driver file,
then probe for the existence of the SMCCC TRNG implementation in the
driver's probe routine.
Since the firmware takes care about serialisation, this can happily
coexist with the arch_get_random_seed() bits.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>

[1] https://developer.arm.com/documentation/den0098/latest/
---
Hi,

as Ard mentioned in some recent thread, we might consider this driver
now (which was dismissed when arch_get_random() got SMCCC TRNG support).

The device/driver instantiation is not really great, ideally we let
some generic SMCCC discovery instantiate the device or trigger the driver
probe.
Let me know what you think!

Btw: this can be easily tested in a KVM guest (on a recent host kernel).

Cheers,
Andre

 drivers/char/hw_random/Kconfig          |  11 ++
 drivers/char/hw_random/Makefile         |   1 +
 drivers/char/hw_random/arm_smccc_trng.c | 162 ++++++++++++++++++++++++
 3 files changed, 174 insertions(+)
 create mode 100644 drivers/char/hw_random/arm_smccc_trng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1fe006f3f12f..7d65a0da2170 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -524,6 +524,17 @@ config HW_RANDOM_XIPHERA
 	  To compile this driver as a module, choose M here: the
 	  module will be called xiphera-trng.
 
+config HW_RANDOM_ARM_SMCCC_TRNG
+	tristate "Arm SMCCC TRNG firmware interface support"
+	depends on HAVE_ARM_SMCCC_DISCOVERY
+	default HW_RANDOM
+	help
+	  Say 'Y' to enable the True Random Number Generator driver using
+	  the Arm SMCCC TRNG firmware interface. This reads entropy from
+	  higher exception levels (firmware, hypervisor). Uses SMCCC for
+	  communicating with the firmware.
+	  https://developer.arm.com/documentation/den0098/latest/
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 8933fada74f2..a5a1c765a394 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -45,3 +45,4 @@ obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
 obj-$(CONFIG_HW_RANDOM_NPCM) += npcm-rng.o
 obj-$(CONFIG_HW_RANDOM_CCTRNG) += cctrng.o
 obj-$(CONFIG_HW_RANDOM_XIPHERA) += xiphera-trng.o
+obj-$(CONFIG_HW_RANDOM_ARM_SMCCC_TRNG) += arm_smccc_trng.o
diff --git a/drivers/char/hw_random/arm_smccc_trng.c b/drivers/char/hw_random/arm_smccc_trng.c
new file mode 100644
index 000000000000..584ed5ffe1ce
--- /dev/null
+++ b/drivers/char/hw_random/arm_smccc_trng.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Randomness driver for the ARM SMCCC TRNG Firmware Interface
+ * https://developer.arm.com/documentation/den0098/latest/
+ *
+ *  Copyright (C) 2020 Arm Ltd.
+ *
+ * The ARM TRNG firmware interface specifies a protocol to read entropy
+ * from a higher exception level, to abstract from any machine specific
+ * implemenations and allow easier use in hypervisors.
+ *
+ * The firmware interface is realised using the SMCCC specification.
+ */
+
+#include <linux/bits.h>
+#include <linux/device.h>
+#include <linux/hw_random.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/arm-smccc.h>
+
+#ifdef CONFIG_ARM64
+#define ARM_SMCCC_TRNG_RND	ARM_SMCCC_TRNG_RND64
+#define MAX_BITS_PER_CALL	(3 * 64UL)
+#else
+#define ARM_SMCCC_TRNG_RND	ARM_SMCCC_TRNG_RND32
+#define MAX_BITS_PER_CALL	(3 * 32UL)
+#endif
+
+/* We don't want to allow the firmware to stall us forever. */
+#define SMCCC_TRNG_MAX_TRIES	20
+
+#define SMCCC_RET_TRNG_INVALID_PARAMETER	-2
+#define SMCCC_RET_TRNG_NO_ENTROPY		-3
+
+static int smccc_trng_init(struct hwrng *rng)
+{
+	return 0;
+}
+
+static int copy_from_registers(char *buf, struct arm_smccc_res *res,
+			       size_t bytes)
+{
+	unsigned int chunk, copied;
+
+	if (bytes == 0)
+		return 0;
+
+	chunk = min(bytes, sizeof(long));
+	memcpy(buf, &res->a3, chunk);
+	copied = chunk;
+	if (copied >= bytes)
+		return copied;
+
+	chunk = min((bytes - copied), sizeof(long));
+	memcpy(&buf[copied], &res->a2, chunk);
+	copied += chunk;
+	if (copied >= bytes)
+		return copied;
+
+	chunk = min((bytes - copied), sizeof(long));
+	memcpy(&buf[copied], &res->a1, chunk);
+
+	return copied + chunk;
+}
+
+static int smccc_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct arm_smccc_res res;
+	u8 *buf = data;
+	unsigned int copied = 0;
+	int tries = 0;
+
+	while (copied < max) {
+		size_t bits = min_t(size_t, (max - copied) * BITS_PER_BYTE,
+				  MAX_BITS_PER_CALL);
+
+		arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_RND, bits, &res);
+		if ((int)res.a0 < 0)
+			return (int)res.a0;
+
+		switch ((int)res.a0) {
+		case SMCCC_RET_SUCCESS:
+			copied += copy_from_registers(buf + copied, &res,
+						      bits / BITS_PER_BYTE);
+			tries = 0;
+			break;
+		case SMCCC_RET_TRNG_NO_ENTROPY:
+			if (!wait)
+				return copied;
+			tries++;
+			if (tries >= SMCCC_TRNG_MAX_TRIES)
+				return copied;
+			cond_resched();
+			break;
+		}
+	}
+
+	return copied;
+}
+
+static int smccc_trng_probe(struct platform_device *pdev)
+{
+	struct arm_smccc_res res;
+	struct hwrng *trng;
+	u32 version;
+	int ret;
+
+	/* We need ARM SMCCC v1.1, with its autodetection feature. */
+	if (arm_smccc_get_version() < ARM_SMCCC_VERSION_1_1)
+		return -ENODEV;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_VERSION, &res);
+	if ((int)res.a0 < 0)
+		return -ENODEV;
+	version = res.a0;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_TRNG_FEATURES,
+			     ARM_SMCCC_TRNG_RND, &res);
+	if ((int)res.a0 < 0)
+		return -ENODEV;
+
+	trng = devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
+	if (!trng)
+		return -ENOMEM;
+
+	trng->name = "smccc_trng";
+	trng->init = smccc_trng_init;
+	trng->read = smccc_trng_read;
+
+	platform_set_drvdata(pdev, trng);
+	ret = devm_hwrng_register(&pdev->dev, trng);
+	if (ret)
+		return -ENOENT;
+
+	dev_info(&pdev->dev,
+		 "ARM SMCCC TRNG firmware random number generator v%d.%d\n",
+		 version >> 16, version & 0xffff);
+
+	return 0;
+}
+
+static struct platform_driver smccc_trng_driver = {
+	.driver = {
+		.name		= "smccc_trng",
+	},
+	.probe		= smccc_trng_probe,
+};
+
+module_platform_driver(smccc_trng_driver);
+
+static int __init smccc_trng_dev_init(void)
+{
+	platform_device_register_simple("smccc_trng", -1, NULL, 0);
+
+	return 0;
+}
+
+device_initcall(smccc_trng_dev_init);
+
+MODULE_AUTHOR("Andre Przywara");
+MODULE_LICENSE("GPL");
-- 
2.17.5

