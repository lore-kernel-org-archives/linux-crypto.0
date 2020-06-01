Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,URIBL_SBL,URIBL_SBL_A,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C025C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 20:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4638D2074B
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 20:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="fzxouead"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgFAU3u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 16:29:50 -0400
Received: from mail-ve1eur02hn2208.outbound.protection.outlook.com ([52.100.10.208]:41954
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727096AbgFAU3t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 16:29:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkL6K199weMsz11bCFH1sSwFZIHnGeUPiyWYyoVydu9DZKX3RSIPswQV1oKcY0aPJwW164UfS5jIw+RtgNuPHxREUofHwHS0hJo9LWclF3YO8LIn3KLE+DXUF9F97MyYmQ6soumEfkyI3ICsjfM63wQ73fy+UybvkJUBjAYCqItsg+myXPKapXFpRu2ou11LrwfmquZlNZSh771HrILni6lIm/a48/e3uVSKFlbA5tdI/skDOzkyVaDuvHFpz4a7lPOvLNkjyVCc1xeMJOD27FWvYA4I/0TcKQoNB21XWjycv7pgNt9dTQbTMTySCFSOu8fksgsXO4lMf+SGcBwNPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P98AxuA238ck8FmM+g+MmiMc9CbnOmaoD8MOmMmXuhc=;
 b=V+GBF3LoFaLmAHMg53hAVycmb5zkk/EAElMuzqyED0+0UTtVqKi3E3BVyLH/YYeO818rdrIw7NL6VZbgJF0aIk7lHc6FW7T8NWZlW+bDqQTJ3Op9H5DObeAQ0zNUp3fxaSlYNyqPZsTnltuYgzbNRqQey+4eVZMC7/lE4rk5j0xblPd1PR2eAgliszTwO2hoeCL3Vdp8htb+XWdLkkizjKkuMQ5qvqoyad1kWifLfpczDMfE5UANBfSYSZ0CB0YaS5aLYLoNQQVkVXMfRUt0eGvMH0qNZqefGfIcJFG+IqvP0jGIv0Up0weI4Ar4ZLvL96N9lKa/ie17wtvvqQT7+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P98AxuA238ck8FmM+g+MmiMc9CbnOmaoD8MOmMmXuhc=;
 b=fzxoueadIebmEBqYfmM//hK09DWoiENocR0Lmy7aRUavZlHrxybtppm7kisMhbs3WJKslYllYF0bZV5cj/v/lzXU5UQtUqpi9qYS1hEZok47Zl0D+OQKmmlkYux2WGeNGyM9FAMePN+wDjOwLwwkGz+IoS2iwAWVqIdF5rCu3Hc=
Authentication-Results: selenic.com; dkim=none (message not signed)
 header.d=none;selenic.com; dmarc=none action=none
 header.from=silexinsight.com;
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
 by AM7PR09MB3957.eurprd09.prod.outlook.com (2603:10a6:20b:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Mon, 1 Jun
 2020 20:28:04 +0000
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2]) by AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2%8]) with mapi id 15.20.3045.024; Mon, 1 Jun 2020
 20:28:04 +0000
From:   Olivier Sobrie <olivier.sobrie@silexinsight.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Olivier Sobrie <olivier.sobrie@silexinsight.com>,
        Waleed Ziad <waleed94ziad@gmail.com>,
        sebastien.rabou@silexinsight.com
Subject: [PATCH v2 2/2] hwrng: ba431-rng: add support for BA431 hwrng
Date:   Mon,  1 Jun 2020 16:27:40 +0200
Message-Id: <20200601142740.443548-3-olivier.sobrie@silexinsight.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601142740.443548-1-olivier.sobrie@silexinsight.com>
References: <20200601142740.443548-1-olivier.sobrie@silexinsight.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0004.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::14) To AM7PR09MB3621.eurprd09.prod.outlook.com
 (2603:10a6:20b:10d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:3173:2902:9670:18b) by AM4PR0902CA0004.eurprd09.prod.outlook.com (2603:10a6:200:9b::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Mon, 1 Jun 2020 20:28:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a02:a03f:a7df:f300:3173:2902:9670:18b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb4e32b0-b204-42dd-a0a5-08d8066a49cf
X-MS-TrafficTypeDiagnostic: AM7PR09MB3957:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR09MB3957237DAEF0AFCCFE010443F48A0@AM7PR09MB3957.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0421BF7135
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3wiO/n7YuKj+4tKryltFKOp1J39yjj38WvhvyQZtHd8mKGcyi5ZEnFX7Ss9Pisb5fYyY0jqgo1KlG/CnSDbEPCiejQabDEu6wYHCdOAI5oJIPcjLtbEJs2sY4CS7ObdA62xYOsmExFo3czK/CQE4w+QJENkttQB8397rwTQJtCtZQXK1f/thnriaqw+QR+6FqhD2UxN0XBukA/PRKgCAkgBKzqGYxThBiy8Ra+aOuEJmv+XpiN+Biz47NYlEBd5ayWz0o0jTsZWeqIrpJhvLZz0IeOmLIrGwKCoreo5TrDQ+NUgsiUT4j526hHts5nptj7Mbl0rmB3jBrXKEUvVvrzq+hmoPYISknw9Flk5DWaJOtx/kjPWG4XO++3EY7CYmcVdj+rAHQvBKkENXR2BQZiN7FPJbQAugivKmSyAriFbkVgLEvR/JQTjWQQdguhSLDWU55bV5jTtlXIZhjSwi7E3GGSzEvVGLdvw4rwzB0vciWU/r3JCZqtHVf/BJcthC9HnX92QQNHmN/V5m3vmLll4Ld6XFn0niV4q2mwqarDFJTB4zMwG3Hhq1hL7NFxV2I7u82art0J84dK6ovhwDBo3EXkmHSqt5Ky3Svbeb52+67PBPJtqriqWNE2urdS/Ti7cjAPqF8mWTtGsgU89z29eGbLEhHYUboItuVheFlucGBqgLvFKn4BqTiuXvaz3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM7PR09MB3621.eurprd09.prod.outlook.com;PTR:;CAT:OSPM;SFTY:;SFS:(366004)(396003)(346002)(136003)(39830400003)(376002)(5660300002)(36756003)(6496006)(52116002)(66556008)(8936002)(1076003)(86362001)(16526019)(186003)(66476007)(66946007)(2616005)(8676002)(44832011)(107886003)(4326008)(508600001)(2906002)(316002)(6486002)(110136005)(54906003)(6666004)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: BNJVU7FZDWWJ+7LfnwI1zoV1CZy4L2qt9VWexIlnU4z9CP5BFzbuO8AoYC4AGDhOgbdKQMlkSwj1HyU0wjySGI2uz6rnj4eOQWifxkWLgB/AOI947EhunYvbdVbYgj1taDTN4+nPV0FeCZgBCFkrXJV+52YypKKTgMnoG+Ynhz0MljyttkABo4/0w7nImVpl2hdkhqUww7s09jBhEkisulBLoPplWwe+6DTr+BFFfcn4hjLL1WA85/WxsJc/ew+gCBkBWNfslmV0qf8M5gFuY0vtHhFt2Vm2LSRjvZxUcTdlQLHTvf9fVB9FFrXWM2qoant1FbCsagPkHX4EClPimvGrBlH8T+jcYoD01Y+mSIxeQEhvKgTsqDfYlw4DlVv5EM8ZSkYGyC9gT4DkPTMglmDG0dz2EmFANmcBhLrSAviSA+G6eiOM/CFAjatjmN1cuor7ugBYnE/Nmdm09Itna+m0Fo8WfsntLInDJQNcwWxlD2xjXv8gZ/XENOiFQLWa3qF+HKyPSutLUepHqgR7btxvdyQGspovIXkxn7OkHNA=
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4e32b0-b204-42dd-a0a5-08d8066a49cf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2020 20:28:04.8465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6v3div4q3RIO+GYUiGoXTLVzGVVKHkTv2y39Riv5tfbmwbxQc459LGgcE/c1RoaRYx0DcfTzhtrd4t7QvaeAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB3957
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Silex insight BA431 is an IP designed to generate random numbers that
can be integrated in various FPGA.
This driver adds support for it through the hwrng interface.

This driver is used in Silex Insight Viper OEM boards.

Signed-off-by: Olivier Sobrie <olivier.sobrie@silexinsight.com>
Signed-off-by: Waleed Ziad <waleed94ziad@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/hw_random/Kconfig     |  12 ++
 drivers/char/hw_random/Makefile    |   1 +
 drivers/char/hw_random/ba431-rng.c | 234 +++++++++++++++++++++++++++++
 3 files changed, 247 insertions(+)
 create mode 100644 drivers/char/hw_random/ba431-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 9bc46da8d77a8..4f50ee02c639e 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -74,6 +74,18 @@ config HW_RANDOM_ATMEL
 
 	  If unsure, say Y.
 
+config HW_RANDOM_BA431
+	tristate "Silex Insight BA431 Random Number Generator support"
+	default HW_RANDOM
+	help
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware based on Silex Insight BA431 IP.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ba431-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_BCM2835
 	tristate "Broadcom BCM2835/BCM63xx Random Number Generator support"
 	depends on ARCH_BCM2835 || ARCH_BCM_NSP || ARCH_BCM_5301X || \
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index a7801b49ce6c0..02ccadafcca99 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_HW_RANDOM_TIMERIOMEM) += timeriomem-rng.o
 obj-$(CONFIG_HW_RANDOM_INTEL) += intel-rng.o
 obj-$(CONFIG_HW_RANDOM_AMD) += amd-rng.o
 obj-$(CONFIG_HW_RANDOM_ATMEL) += atmel-rng.o
+obj-$(CONFIG_HW_RANDOM_BA431) += ba431-rng.o
 obj-$(CONFIG_HW_RANDOM_GEODE) += geode-rng.o
 obj-$(CONFIG_HW_RANDOM_N2RNG) += n2-rng.o
 n2-rng-y := n2-drv.o n2-asm.o
diff --git a/drivers/char/hw_random/ba431-rng.c b/drivers/char/hw_random/ba431-rng.c
new file mode 100644
index 0000000000000..a39e3abf50b94
--- /dev/null
+++ b/drivers/char/hw_random/ba431-rng.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Silex Insight
+
+#include <linux/delay.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+
+#define BA431_RESET_DELAY			1 /* usec */
+#define BA431_RESET_READ_STATUS_TIMEOUT		1000 /* usec */
+#define BA431_RESET_READ_STATUS_INTERVAL	10 /* usec */
+#define BA431_READ_RETRY_INTERVAL		1 /* usec */
+
+#define BA431_REG_CTRL				0x00
+#define BA431_REG_FIFO_LEVEL			0x04
+#define BA431_REG_STATUS			0x30
+#define BA431_REG_FIFODATA			0x80
+
+#define BA431_CTRL_ENABLE			BIT(0)
+#define BA431_CTRL_SOFTRESET			BIT(8)
+
+#define BA431_STATUS_STATE_MASK			(BIT(1) | BIT(2) | BIT(3))
+#define BA431_STATUS_STATE_OFFSET		1
+
+enum ba431_state {
+	BA431_STATE_RESET,
+	BA431_STATE_STARTUP,
+	BA431_STATE_FIFOFULLON,
+	BA431_STATE_FIFOFULLOFF,
+	BA431_STATE_RUNNING,
+	BA431_STATE_ERROR
+};
+
+struct ba431_trng {
+	struct device *dev;
+	void __iomem *base;
+	struct hwrng rng;
+	atomic_t reset_pending;
+	struct work_struct reset_work;
+};
+
+static inline u32 ba431_trng_read_reg(struct ba431_trng *ba431, u32 reg)
+{
+	return ioread32(ba431->base + reg);
+}
+
+static inline void ba431_trng_write_reg(struct ba431_trng *ba431, u32 reg,
+					u32 val)
+{
+	iowrite32(val, ba431->base + reg);
+}
+
+static inline enum ba431_state ba431_trng_get_state(struct ba431_trng *ba431)
+{
+	u32 status = ba431_trng_read_reg(ba431, BA431_REG_STATUS);
+
+	return (status & BA431_STATUS_STATE_MASK) >> BA431_STATUS_STATE_OFFSET;
+}
+
+static int ba431_trng_is_in_error(struct ba431_trng *ba431)
+{
+	enum ba431_state state = ba431_trng_get_state(ba431);
+
+	if ((state < BA431_STATE_STARTUP) ||
+	    (state >= BA431_STATE_ERROR))
+		return 1;
+
+	return 0;
+}
+
+static int ba431_trng_reset(struct ba431_trng *ba431)
+{
+	int ret;
+
+	/* Disable interrupts, random generation and enable the softreset */
+	ba431_trng_write_reg(ba431, BA431_REG_CTRL, BA431_CTRL_SOFTRESET);
+	udelay(BA431_RESET_DELAY);
+	ba431_trng_write_reg(ba431, BA431_REG_CTRL, BA431_CTRL_ENABLE);
+
+	/* Wait until the state changed */
+	if (readx_poll_timeout(ba431_trng_is_in_error, ba431, ret, !ret,
+			       BA431_RESET_READ_STATUS_INTERVAL,
+			       BA431_RESET_READ_STATUS_TIMEOUT)) {
+		dev_err(ba431->dev, "reset failed (state: %d)\n",
+			ba431_trng_get_state(ba431));
+		return -ETIMEDOUT;
+	}
+
+	dev_info(ba431->dev, "reset done\n");
+
+	return 0;
+}
+
+static void ba431_trng_reset_work(struct work_struct *work)
+{
+	struct ba431_trng *ba431 = container_of(work, struct ba431_trng,
+						reset_work);
+	ba431_trng_reset(ba431);
+	atomic_set(&ba431->reset_pending, 0);
+}
+
+static void ba431_trng_schedule_reset(struct ba431_trng *ba431)
+{
+	if (atomic_cmpxchg(&ba431->reset_pending, 0, 1))
+		return;
+
+	schedule_work(&ba431->reset_work);
+}
+
+static int ba431_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	struct ba431_trng *ba431 = container_of(rng, struct ba431_trng, rng);
+	u32 *data = buf;
+	unsigned int level, i;
+	int n = 0;
+
+	while (max > 0) {
+		level = ba431_trng_read_reg(ba431, BA431_REG_FIFO_LEVEL);
+		if (!level) {
+			if (ba431_trng_is_in_error(ba431)) {
+				ba431_trng_schedule_reset(ba431);
+				break;
+			}
+
+			if (!wait)
+				break;
+
+			udelay(BA431_READ_RETRY_INTERVAL);
+			continue;
+		}
+
+		i = level;
+		do {
+			data[n++] = ba431_trng_read_reg(ba431,
+							BA431_REG_FIFODATA);
+			max -= sizeof(*data);
+		} while (--i && (max > 0));
+
+		if (ba431_trng_is_in_error(ba431)) {
+			n -= (level - i);
+			ba431_trng_schedule_reset(ba431);
+			break;
+		}
+	}
+
+	n *= sizeof(data);
+	return (n || !wait) ? n : -EIO;
+}
+
+static void ba431_trng_cleanup(struct hwrng *rng)
+{
+	struct ba431_trng *ba431 = container_of(rng, struct ba431_trng, rng);
+
+	ba431_trng_write_reg(ba431, BA431_REG_CTRL, 0);
+	cancel_work_sync(&ba431->reset_work);
+}
+
+static int ba431_trng_init(struct hwrng *rng)
+{
+	struct ba431_trng *ba431 = container_of(rng, struct ba431_trng, rng);
+
+	return ba431_trng_reset(ba431);
+}
+
+static int ba431_trng_probe(struct platform_device *pdev)
+{
+	struct ba431_trng *ba431;
+	struct resource *res;
+	int ret;
+
+	ba431 = devm_kzalloc(&pdev->dev, sizeof(*ba431), GFP_KERNEL);
+	if (!ba431)
+		return -ENOMEM;
+
+	ba431->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ba431->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ba431->base))
+		return PTR_ERR(ba431->base);
+
+	atomic_set(&ba431->reset_pending, 0);
+	INIT_WORK(&ba431->reset_work, ba431_trng_reset_work);
+	ba431->rng.name = pdev->name;
+	ba431->rng.init = ba431_trng_init;
+	ba431->rng.cleanup = ba431_trng_cleanup;
+	ba431->rng.read = ba431_trng_read;
+
+	platform_set_drvdata(pdev, ba431);
+
+	ret = hwrng_register(&ba431->rng);
+	if (ret) {
+		dev_err(&pdev->dev, "BA431 registration failed (%d)\n", ret);
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "BA431 TRNG registered\n");
+
+	return 0;
+}
+
+static int ba431_trng_remove(struct platform_device *pdev)
+{
+	struct ba431_trng *ba431 = platform_get_drvdata(pdev);
+
+	hwrng_unregister(&ba431->rng);
+
+	return 0;
+}
+
+static const struct of_device_id ba431_trng_dt_ids[] = {
+	{ .compatible = "silex-insight,ba431-rng", .data = NULL },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ba431_trng_dt_ids);
+
+static struct platform_driver ba431_trng_driver = {
+	.driver = {
+		.name = "ba431-rng",
+		.of_match_table = ba431_trng_dt_ids,
+	},
+	.probe = ba431_trng_probe,
+	.remove = ba431_trng_remove,
+};
+
+module_platform_driver(ba431_trng_driver);
+
+MODULE_AUTHOR("Olivier Sobrie <olivier@sobrie.be>");
+MODULE_DESCRIPTION("TRNG driver for Silex Insight BA431");
+MODULE_LICENSE("GPL");
-- 
2.26.2

