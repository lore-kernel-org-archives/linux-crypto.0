Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A019C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 17:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21E3560F90
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 17:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhGZRQ3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 13:16:29 -0400
Received: from foss.arm.com ([217.140.110.172]:57174 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232241AbhGZRQ3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 13:16:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 538141042;
        Mon, 26 Jul 2021 10:56:57 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B3953F66F;
        Mon, 26 Jul 2021 10:56:55 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
        Ali Saidi <alisaidi@amazon.com>,
        Jon Nettleton <jon@solid-run.com>
Subject: [PATCH v3 2/2] hwrng: Add Arm SMCCC TRNG based driver
Date:   Mon, 26 Jul 2021 18:56:10 +0100
Message-Id: <20210726175610.3311-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210726175610.3311-1-andre.przywara@arm.com>
References: <20210726175610.3311-1-andre.przywara@arm.com>
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
The corresponding platform device is created by the SMCCC core code,
we just match it here by name and provide a module alias.

Since the firmware takes care about serialisation, this can happily
coexist with the arch_get_random_seed() bits.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>

[1] https://developer.arm.com/documentation/den0098/latest/
---
 drivers/char/hw_random/Kconfig          |  14 +++
 drivers/char/hw_random/Makefile         |   1 +
 drivers/char/hw_random/arm_smccc_trng.c | 134 ++++++++++++++++++++++++
 3 files changed, 149 insertions(+)
 create mode 100644 drivers/char/hw_random/arm_smccc_trng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 3f166c8a4099..239eca4d6805 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -524,6 +524,20 @@ config HW_RANDOM_XIPHERA
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
+	  communicating with the firmware:
+	  https://developer.arm.com/documentation/den0098/latest/
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called arm_smccc_trng.
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
index 000000000000..a04f9f9db1fe
--- /dev/null
+++ b/drivers/char/hw_random/arm_smccc_trng.c
@@ -0,0 +1,134 @@
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
+	struct hwrng *trng;
+	int ret;
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
+	if (!ret)
+		dev_info(&pdev->dev,
+			 "ARM SMCCC TRNG firmware random number generator\n");
+
+	return ret;
+}
+
+static struct platform_driver smccc_trng_driver = {
+	.driver = {
+		.name		= "smccc_trng",
+	},
+	.probe		= smccc_trng_probe,
+};
+module_platform_driver(smccc_trng_driver);
+
+MODULE_ALIAS("platform:smccc_trng");
+MODULE_AUTHOR("Andre Przywara");
+MODULE_LICENSE("GPL");
-- 
2.17.6

