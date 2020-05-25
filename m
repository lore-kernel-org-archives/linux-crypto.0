Return-Path: <SRS0=4LZm=7H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85753C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F7742071C
	for <linux-crypto@archiver.kernel.org>; Mon, 25 May 2020 20:07:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=silexinside.onmicrosoft.com header.i=@silexinside.onmicrosoft.com header.b="hFbUk1KA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390350AbgEYUH0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 May 2020 16:07:26 -0400
Received: from mail-db5eur03hn2211.outbound.protection.outlook.com ([52.100.12.211]:3649
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390748AbgEYUHZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 May 2020 16:07:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJ8cfZR8rQZskRpVK78XdDPIU41lv+zqPEI9rcxhF+x/n8d1pIvGV71QsQXs7IdKy5Q+kt4LOQ22IkmAofjsgBHX6ArCy15BGWtblc4KljyUtYt+oj+5C1hVcBvaD/YyyzphCj0LmcYkcsafaUh/+4JcBtfN2jFJztdBd+IVZ+qhcjOc0PMh24BN5d3KSk3uCKhj6jt0bgfKx70Jv+iRbFQvj6iwZ92noYTRN/scw2LPTWYyFmppK/upgKVg9dnMH6w/2t9N1qnwcAo5VMMyQpl2Z+KNTcarCQ2/c8wRy7ulALimzoBZL+Lko3gxi3lb9s5tLtkMAz/B+qfZbHGeMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3Scp1U+UH6TjxNGZ8CS1RRLgKP1gtpZRn/wGeY1I+A=;
 b=ny0ywH5qwZat+hdu9LYAyH6ajvzbpXwM6IaJE6ccGtFVmrRY5m7V/Y+8gvCT/lh3ZnflUFmsDiuZ6ng948DgroHtU/OJiX+Ra0QotdGdWjNOgjNs4BL7Lz99KXPzdLq3wbFFvrJgepdD854LgqoQpl2LmNL3fdXcSAZVhrvPM23Di+YxKCZdACznf4JqGglhvpM+BqStliR8PDvOeUYhXR6X0wqBDj2iuBO1O/n7EMk4hA+HQHQ7a8y8qMRHaQMF8J5QGogiyteAiiQ/VGZEcM8rGyR7jcPyILZsCd36AzFCTnciCjb6AWcVBDZcVn0HLOV9bHQp+11wiuX2ieOdBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silexinsight.com; dmarc=pass action=none
 header.from=silexinsight.com; dkim=pass header.d=silexinsight.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silexinside.onmicrosoft.com; s=selector2-silexinside-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3Scp1U+UH6TjxNGZ8CS1RRLgKP1gtpZRn/wGeY1I+A=;
 b=hFbUk1KA9QqjZcgOo7cN05LaQOiOdnRlJG2rILT60iDU8HEf9BHjgS+cZwzytUngazPaQ4KtpIARh5vT7s90bf/O0rHkoIdLtnsFduz9nDNWdTFfK8NH05tW+ie3rXzj7+XSoExwYm5KLsfo5+7wqcuTvonSH6XmvKpGvBH5n5g=
Authentication-Results: selenic.com; dkim=none (message not signed)
 header.d=none;selenic.com; dmarc=none action=none
 header.from=silexinsight.com;
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com (2603:10a6:20b:10d::15)
 by AM7PR09MB3735.eurprd09.prod.outlook.com (2603:10a6:20b:dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 20:07:01 +0000
Received: from AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2]) by AM7PR09MB3621.eurprd09.prod.outlook.com
 ([fe80::e902:acdf:8750:e9e2%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 20:07:01 +0000
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
Subject: [PATCH 3/3] hwrng: ba431-rng: add support for BA431 hwrng
Date:   Mon, 25 May 2020 21:56:06 +0200
Message-Id: <20200525195606.2941649-4-olivier.sobrie@silexinsight.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
References: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To AM7PR09MB3621.eurprd09.prod.outlook.com
 (2603:10a6:20b:10d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a02:a03f:a7df:f300:30f9:36cf:6713:51ae) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 20:07:00 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a02:a03f:a7df:f300:30f9:36cf:6713:51ae]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5bf6853-76a2-4f9e-cbb5-08d800e72f9d
X-MS-TrafficTypeDiagnostic: AM7PR09MB3735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR09MB373526525739967DB01ECA40F4B30@AM7PR09MB3735.eurprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iEpyE3+7uRU8HgGfSly0ziVaRK2a4aRv7BWwUQBn/b+rivZJPfFttnEe16PenMd48QAgLHiWVUEb/paFAsIsTvME//rJ4NcKKLbY9TFqBg/8dhcyqbXyx6j6jM5LuoXf20l30tnun6EA30f8dCOyBe7v1S+T+h8Jr56DR3dX/4epLe+lbBURQumE85PNH/FjIHfWL6RVfS/4kPtLlaxFr1t9Z6chhXhkVY5fEgpmOHyxlXsb5+vLqZtsqvJEolkJAUlUg6eNaUPRIUi/+6/FH9fT52cJvREomWwX0Is/gpL00ws89L1iMPJxP/Z9ADIALDP9qLpO57WKdGJpU4KbcIb5QKIjPhei465KY2BHnGjxJsngzqmuxMdLSan17KRScaz7UjDHQxBOD8O0exJ3g5z31vJFX3c1nS1uXKrNdel+6UJ7hkBcxh2EqEYkkttEZgeklHmblS6Aiw2QN74x72AcCZSF73IOZZHoHoDbrqRiBF4bTdx0TMUAyUGNJQA+ETTNF2dAu7r7s+KJGd6rqHRWRWrv8keLofuRMq/jGzuhZNoyCAJJa5J5nJggVpoRTFG1LazmUi7yqw942Y0ARuK0BHoyQVDU0CfdEjaGOMi0WqDNWh3mQulzhs45X8cPKMBjhcdBiAdm9uJt1y00LX5fRYGILzrt+jB26choHapCryBkftQ6623tOM6Ti1dv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:AM7PR09MB3621.eurprd09.prod.outlook.com;PTR:;CAT:OSPM;SFTY:;SFS:(396003)(39840400004)(136003)(376002)(346002)(366004)(186003)(16526019)(66556008)(52116002)(2616005)(2906002)(66476007)(6496006)(107886003)(44832011)(66946007)(54906003)(110136005)(316002)(508600001)(6486002)(8936002)(36756003)(1076003)(4326008)(5660300002)(8676002)(86362001)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: WBlE+Cr83h5BgIVaotgP5mw/boJo2E20AFMCEXMJD/JILHYNvnQXQbvTZG15NIJtg8JBRqiKtMQzp87KyxLsyUPloXxiPva/7w0o6PXshkFB5EUep3sVQ+08qNBNq/vKqWKTAtpn2wswLdW/xEungTOANR7s/gAnxjnpfwjs49tUk7haprlbd2oIlAGkWi2YUkB+DTDiKzjUTiQHKA66pE4uhtLq+/4i8d/oHVrx4Y9P6LkhC5XP2Rq07uaXO/XUxLLLKm7kSsVqdimmF/in5bvPiCRIFzOF0Wn5zuyDL74Aihx6U4Uf0JpLiuU8jqVHCHtklkXTdELR29leK2wDfFZgQsMi/v0uTObcYjFRMYzgB2AxP49TEAbl0ZKih62x1Xv/i1oEdSN3byj8s9LgPl+ATk5kSu3fQ9T1h5y6qkIT2kRalFHeLUe6LqYaPzXXB3hKcV3lGPkC6U0CR7UypMRyYCk0IeSG5l4og6NlE5cNSKmAld1gRZaJK95fDyymVY3vzCnPqs7nEIJoLHZUuxpeg7A/Xzb42ROfcDROK/0=
X-OriginatorOrg: silexinsight.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5bf6853-76a2-4f9e-cbb5-08d800e72f9d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 20:07:01.0256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a02f6f9b-0f64-4420-b881-fca545d421d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DRYqtDEI8xOk30caBlnV3+d4sz02hO0o4wqEUDR49nD7s8MqUlS3KBgYE3iK4Twq6v9FIHyr8wqkwZTa/+/uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR09MB3735
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
---
 drivers/char/hw_random/Kconfig     |  10 ++
 drivers/char/hw_random/Makefile    |   1 +
 drivers/char/hw_random/ba431-rng.c | 240 +++++++++++++++++++++++++++++
 3 files changed, 251 insertions(+)
 create mode 100644 drivers/char/hw_random/ba431-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 9bc46da8d77a8..ef8928fc9999d 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -74,6 +74,16 @@ config HW_RANDOM_ATMEL
 
 	  If unsure, say Y.
 
+config HW_RANDOM_BA431
+	tristate "Silex Insight BA431 Random Number Generator support"
+	default HW_RANDOM
+	help
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware based on Silex Insight BA431 IP.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ba431-rng
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
index 0000000000000..d3bec75d405e4
--- /dev/null
+++ b/drivers/char/hw_random/ba431-rng.c
@@ -0,0 +1,240 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2018 Silex Insight sa.
+
+#include <linux/delay.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+
+#define BA431_RESET_DELAY			1 /* usec */
+#define BA431_RESET_READ_STATUS_RETRIES		100
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
+	unsigned int i;
+	enum ba431_state state;
+
+	/* Disable interrupts, random generation and enable the softreset */
+	ba431_trng_write_reg(ba431, BA431_REG_CTRL, BA431_CTRL_SOFTRESET);
+	udelay(BA431_RESET_DELAY);
+	ba431_trng_write_reg(ba431, BA431_REG_CTRL, BA431_CTRL_ENABLE);
+
+	/* Wait until the state changed */
+	for (i = 0; i < BA431_RESET_READ_STATUS_RETRIES; ++i) {
+		state = ba431_trng_get_state(ba431);
+		if (state >= BA431_STATE_STARTUP)
+			break;
+
+		udelay(BA431_RESET_READ_STATUS_INTERVAL);
+	}
+
+	if ((state < BA431_STATE_STARTUP) || (state >= BA431_STATE_ERROR)) {
+		dev_err(ba431->dev, "reset failed (state: %d)\n",
+			state);
+		return -1;
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

