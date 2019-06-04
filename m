Return-Path: <SRS0=6z3H=UD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F9EC282CE
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 20:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3481220874
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Jun 2019 20:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="GFf+gvPC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFDUbe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:31:34 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:38164 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFDUbd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jun 2019 16:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559680292; x=1591216292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=GzsSZ1ZIthsTf/ARuWnJotXGJcL1/H1KE/r2e1NtQfo=;
  b=GFf+gvPC5OjeN+RnHydK4L6zMymsVL+bhPh5KFU+KyXvxjnmbdxOfB03
   cmS1f6ZMQb9oepK9iPv8sG5wgGloF/ghI1FNvDeyHZ+wiL2ewtxMjo3ac
   kz2ei5cuNgXpWx+PIUeVeVk0e6qEj/1kYpeB9RwIzcrQF282f0LuIiUvh
   Q=;
X-IronPort-AV: E=Sophos;i="5.60,550,1549929600"; 
   d="scan'208";a="768961315"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 04 Jun 2019 20:31:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 93C8CA2297;
        Tue,  4 Jun 2019 20:31:29 +0000 (UTC)
Received: from EX13D02UWB004.ant.amazon.com (10.43.161.11) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 20:31:29 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D02UWB004.ant.amazon.com (10.43.161.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 4 Jun 2019 20:31:29 +0000
Received: from dev-dsk-alisaidi-i31e-4ac69482.us-east-1.amazon.com
 (10.200.136.151) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 4 Jun 2019 20:31:29 +0000
Received: by dev-dsk-alisaidi-i31e-4ac69482.us-east-1.amazon.com (Postfix, from userid 5131138)
        id A3E6847DE7; Tue,  4 Jun 2019 20:31:28 +0000 (UTC)
From:   Ali Saidi <alisaidi@amazon.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-crypto@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ali Saidi <alisaidi@amazon.com>,
        Ron Rindjunsky <ronrindj@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 3/3] hwrng: Add support for AWS Graviton TRNG
Date:   Tue, 4 Jun 2019 20:31:00 +0000
Message-ID: <20190604203100.15050-4-alisaidi@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
In-Reply-To: <20190604203100.15050-1-alisaidi@amazon.com>
References: <20190604203100.15050-1-alisaidi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

AWS Graviton based systems provide an Arm SMC call in the vendor defined
hypervisor region to read random numbers from a TRNG and return them
to the guest.

Co-developed-by: Ron Rindjunsky <ronrindj@amazon.com>
Signed-off-by: Ali Saidi <alisaidi@amazon.com>
Signed-off-by: Ron Rindjunsky <ronrindj@amazon.com>

---
 MAINTAINERS                           |   6 ++
 drivers/char/hw_random/Kconfig        |  13 ++++
 drivers/char/hw_random/Makefile       |   1 +
 drivers/char/hw_random/graviton-rng.c | 130 ++++++++++++++++++++++++++++++++++
 4 files changed, 150 insertions(+)
 create mode 100644 drivers/char/hw_random/graviton-rng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 005902ea1450..e9c490e3fd9d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2771,6 +2771,12 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/iio/adc/avia-hx711.txt
 F:	drivers/iio/adc/hx711.c
 
+AWS GRAVITON TRNG DRIVER
+M:	Ali Saidi <alisaidi@amazon.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/char/hw_random/graviton-rng.c
+
 AX.25 NETWORK LAYER
 M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 25a7d8ffdb5d..7ca7386a1ac4 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -439,6 +439,19 @@ config HW_RANDOM_OPTEE
 
 	  If unsure, say Y.
 
+config HW_RANDOM_GRAVITON
+	tristate "AWS Graviton Random Number Generator support"
+	depends on HW_RANDOM && ACPI && (ARM64 || COMPILE_TEST)
+	default HW_RANDOM
+	help
+	  This driver provides kernel-side support for the Random Number
+	  Generator SMC found on AWS Graviton systems.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called graviton-rng.
+
+	  If unsure, say Y.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index 7c9ef4a7667f..d1fa72670e98 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -39,3 +39,4 @@ obj-$(CONFIG_HW_RANDOM_MTK)	+= mtk-rng.o
 obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
 obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
 obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
+obj-$(CONFIG_HW_RANDOM_GRAVITON) += graviton-rng.o
diff --git a/drivers/char/hw_random/graviton-rng.c b/drivers/char/hw_random/graviton-rng.c
new file mode 100644
index 000000000000..898c8bb98a20
--- /dev/null
+++ b/drivers/char/hw_random/graviton-rng.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * AWS Graviton TRNG driver
+ *
+ * Copyright (C) 2019 Amazon Corp.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/arm-smccc.h>
+#include <linux/device.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/acpi.h>
+#include <linux/psci.h>
+#include <linux/module.h>
+
+#define AWS_GRAVITON_UUID \
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_32, \
+			   ARM_SMCCC_OWNER_VENDOR_HV, 0xFF01)
+#define AWS_GRAVITON_GET_VER \
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_32, \
+			   ARM_SMCCC_OWNER_VENDOR_HV, 0xFF03)
+#define AWS_GRAVITON_GET_RND \
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64, \
+			   ARM_SMCCC_OWNER_VENDOR_HV, 0)
+
+/**
+ *  UID of the Graviton TRNG API: 1b64036c-badc-483e-99d23e283f067bdd
+ */
+#define GRVTN_TRNG_UUID_0		0x6c03641b
+#define GRVTN_TRNG_UUID_1		0x3e48dcba
+#define GRVTN_TRNG_UUID_2		0x283ed299
+#define GRVTN_TRNG_UUID_3		0xdd7b063f
+
+static void grvtn_smccc_conduit(u64 call_id, struct arm_smccc_res *res)
+{
+	if (acpi_psci_use_hvc())
+		arm_smccc_1_1_hvc(call_id, res);
+	else
+		arm_smccc_1_1_smc(call_id, res);
+}
+
+static int grvtn_trng_read(struct hwrng *trng, void *buf, size_t max, bool wait)
+{
+	struct arm_smccc_res res;
+	int err = 0;
+	/* timeout after one waiting period */
+	int iter_remain = 2;
+	size_t count = max > sizeof(ulong) * 2 ? sizeof(ulong) * 2 : max;
+	size_t total = count;
+
+	do {
+		if (err && wait)
+			/* Nominal wait is 5us */
+			udelay(err);
+
+		grvtn_smccc_conduit(AWS_GRAVITON_GET_RND, &res);
+		err = (int) res.a0;
+
+		if (err < 0)
+			return err;
+
+		iter_remain--;
+	} while (iter_remain && err && wait);
+
+	if (err)
+		return 0;
+
+	if (count > sizeof(ulong)) {
+		memcpy(buf, &res.a1, sizeof(ulong));
+		count -= sizeof(ulong);
+		buf += sizeof(ulong);
+	}
+	memcpy(buf, &res.a2, count);
+	return total;
+}
+
+static int grvtn_trng_probe(struct platform_device *pdev)
+{
+	int err;
+	struct arm_smccc_res res;
+	static struct hwrng ops = {
+		.name = "graviton",
+		.read = grvtn_trng_read,
+		.quality = 1024, /* all bits are sourced from a HW TRNG */
+	};
+
+	grvtn_smccc_conduit(AWS_GRAVITON_UUID, &res);
+
+	if (res.a0 != GRVTN_TRNG_UUID_0 || res.a1 != GRVTN_TRNG_UUID_1 ||
+	    res.a2 != GRVTN_TRNG_UUID_2 || res.a3 != GRVTN_TRNG_UUID_3) {
+		dev_err(&pdev->dev, "failed to match UUID\n");
+		return -ENXIO;
+	}
+
+	grvtn_smccc_conduit(AWS_GRAVITON_GET_VER, &res);
+	dev_info(&pdev->dev, "Graviton TRNG, SMC version %d.%d\n",
+		(u32)res.a0, (u32)res.a1);
+
+	platform_set_drvdata(pdev, &ops);
+	err = devm_hwrng_register(&pdev->dev, &ops);
+	if (err)
+		dev_err(&pdev->dev, "failed to register hwrng");
+	return err;
+}
+
+static const struct acpi_device_id grvtn_trng_acpi_match[] = {
+	{ "AMZN0010", },
+	{}
+};
+
+MODULE_DEVICE_TABLE(acpi, grvtn_trng_acpi_match);
+
+static struct platform_driver grvtn_trng_driver = {
+	.probe  = grvtn_trng_probe,
+	.driver = {
+		.name = "graviton-rng",
+		.owner = THIS_MODULE,
+		.acpi_match_table = ACPI_PTR(grvtn_trng_acpi_match),
+	},
+};
+
+module_platform_driver(grvtn_trng_driver);
+
+MODULE_AUTHOR("Amazon.com, Inc. or it's affiliates");
+MODULE_DESCRIPTION("Graviton TRNG driver");
+MODULE_LICENSE("GPL v2");
-- 
2.15.3.AMZN

