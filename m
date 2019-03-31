Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF122C10F00
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 769C721726
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="HAg6mY11"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731102AbfCaDPo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 23:15:44 -0400
Received: from mail.nic.cz ([217.31.204.67]:37862 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731062AbfCaDPn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 23:15:43 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 0B133635B6;
        Sun, 31 Mar 2019 05:15:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1554002139; bh=rMA7FDsFAXZRV3uzVRbcuoU0H/z8u9pHphliha3N23c=;
        h=From:To:Date;
        b=HAg6mY11t7PwBTBy1uX5S+HJPzC/OenLwKRE/WQhu/kowx8byWMQJJZ5tqAkOsahs
         kyUBvBncgTAATYH7EUEugcPLXyZN09iTAFx8kjXtL9BXKodQ1Ekgf0w5EzGTNQpden
         6YVsBSqvT1tAYuDptC6eY7H+2o3vtkgq0ddwHOPs=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Jassi Brar <jassisinghbrar@gmail.com>
Cc:     Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH v3 crypto+mailbox+firmware RESEND 2/6] mailbox: Add support for Armada 37xx rWTM mailbox
Date:   Sun, 31 Mar 2019 05:15:33 +0200
Message-Id: <20190331031537.10626-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190331031537.10626-1-marek.behun@nic.cz>
References: <20190331031537.10626-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.99.2 at mail
X-Virus-Status: Clean
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds support for the mailbox via which the kernel can communicate
with the firmware running on the secure processor of the Armada 37xx
SOC.

The rWTM secure processor has access to internal eFuses and
cryptographic circuits, such as the Entropy Bit Generator to generate
true random numbers.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/mailbox/Kconfig                    |  10 +
 drivers/mailbox/Makefile                   |   2 +
 drivers/mailbox/armada-37xx-rwtm-mailbox.c | 225 +++++++++++++++++++++
 include/linux/armada-37xx-rwtm-mailbox.h   |  23 +++
 4 files changed, 260 insertions(+)
 create mode 100644 drivers/mailbox/armada-37xx-rwtm-mailbox.c
 create mode 100644 include/linux/armada-37xx-rwtm-mailbox.h

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index d86e7a4ac04d..595542bfae85 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -41,6 +41,16 @@ config PL320_MBOX
 	  Management Engine, primarily for cpufreq. Say Y here if you want
 	  to use the PL320 IPCM support.
 
+config ARMADA_37XX_RWTM_MBOX
+	tristate "Armada 37xx rWTM BIU Mailbox"
+	depends on ARCH_MVEBU || COMPILE_TEST
+	depends on OF
+	help
+	  Mailbox implementation for communication with the the firmware
+	  running on the Cortex-M3 rWTM secure processor of the Armada 37xx
+	  SOC. Say Y here if you are building for such a device (for example
+	  the Turris Mox router).
+
 config OMAP2PLUS_MBOX
 	tristate "OMAP2+ Mailbox framework support"
 	depends on ARCH_OMAP2PLUS
diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
index 8be3bcbcf882..c22fad6f696b 100644
--- a/drivers/mailbox/Makefile
+++ b/drivers/mailbox/Makefile
@@ -9,6 +9,8 @@ obj-$(CONFIG_ARM_MHU)	+= arm_mhu.o
 
 obj-$(CONFIG_IMX_MBOX)	+= imx-mailbox.o
 
+obj-$(CONFIG_ARMADA_37XX_RWTM_MBOX)	+= armada-37xx-rwtm-mailbox.o
+
 obj-$(CONFIG_PLATFORM_MHU)	+= platform_mhu.o
 
 obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
diff --git a/drivers/mailbox/armada-37xx-rwtm-mailbox.c b/drivers/mailbox/armada-37xx-rwtm-mailbox.c
new file mode 100644
index 000000000000..97f90e97a83c
--- /dev/null
+++ b/drivers/mailbox/armada-37xx-rwtm-mailbox.c
@@ -0,0 +1,225 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * rWTM BIU Mailbox driver for Armada 37xx
+ *
+ * Author: Marek Behun <marek.behun@nic.cz>
+ */
+
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/mailbox_controller.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/armada-37xx-rwtm-mailbox.h>
+
+#define DRIVER_NAME	"armada-37xx-rwtm-mailbox"
+
+/* relative to rWTM BIU Mailbox Registers */
+#define RWTM_MBOX_PARAM(i)		(0x0 + ((i) << 2))
+#define RWTM_MBOX_COMMAND		0x40
+#define RWTM_MBOX_RETURN_STATUS		0x80
+#define RWTM_MBOX_STATUS(i)		(0x84 + ((i) << 2))
+#define RWTM_MBOX_FIFO_STATUS		0xc4
+#define FIFO_STS_RDY			0x100
+#define FIFO_STS_CNTR_MASK		0x7
+#define FIFO_STS_CNTR_MAX		4
+
+#define RWTM_HOST_INT_RESET		0xc8
+#define RWTM_HOST_INT_MASK		0xcc
+#define SP_CMD_COMPLETE			BIT(0)
+#define SP_CMD_QUEUE_FULL_ACCESS	BIT(17)
+#define SP_CMD_QUEUE_FULL		BIT(18)
+
+struct a37xx_mbox {
+	struct device *dev;
+	struct mbox_controller controller;
+	void __iomem *base;
+	int irq;
+};
+
+static void a37xx_mbox_receive(struct mbox_chan *chan)
+{
+	struct a37xx_mbox *mbox = chan->con_priv;
+	struct armada_37xx_rwtm_rx_msg rx_msg;
+	int i;
+
+	rx_msg.retval = readl(mbox->base + RWTM_MBOX_RETURN_STATUS);
+	for (i = 0; i < 16; ++i)
+		rx_msg.status[i] = readl(mbox->base + RWTM_MBOX_STATUS(i));
+
+	mbox_chan_received_data(chan, &rx_msg);
+}
+
+static irqreturn_t a37xx_mbox_irq_handler(int irq, void *data)
+{
+	struct mbox_chan *chan = data;
+	struct a37xx_mbox *mbox = chan->con_priv;
+	u32 reg;
+
+	reg = readl(mbox->base + RWTM_HOST_INT_RESET);
+
+	if (reg & SP_CMD_COMPLETE)
+		a37xx_mbox_receive(chan);
+
+	if (reg & (SP_CMD_QUEUE_FULL_ACCESS | SP_CMD_QUEUE_FULL))
+		dev_err(mbox->dev, "Secure processor command queue full\n");
+
+	writel(reg, mbox->base + RWTM_HOST_INT_RESET);
+	if (reg)
+		mbox_chan_txdone(chan, 0);
+
+	return reg ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static int a37xx_mbox_send_data(struct mbox_chan *chan, void *data)
+{
+	struct a37xx_mbox *mbox = chan->con_priv;
+	struct armada_37xx_rwtm_tx_msg *msg = data;
+	int i;
+	u32 reg;
+
+	if (!data)
+		return -EINVAL;
+
+	reg = readl(mbox->base + RWTM_MBOX_FIFO_STATUS);
+	if (!(reg & FIFO_STS_RDY))
+		dev_warn(mbox->dev, "Secure processor not ready\n");
+
+	if ((reg & FIFO_STS_CNTR_MASK) >= FIFO_STS_CNTR_MAX) {
+		dev_err(mbox->dev, "Secure processor command queue full\n");
+		return -EBUSY;
+	}
+
+	for (i = 0; i < 16; ++i)
+		writel(msg->args[i], mbox->base + RWTM_MBOX_PARAM(i));
+	writel(msg->command, mbox->base + RWTM_MBOX_COMMAND);
+
+	return 0;
+}
+
+static int a37xx_mbox_startup(struct mbox_chan *chan)
+{
+	struct a37xx_mbox *mbox = chan->con_priv;
+	u32 reg;
+	int ret;
+
+	ret = devm_request_irq(mbox->dev, mbox->irq, a37xx_mbox_irq_handler, 0,
+			       DRIVER_NAME, chan);
+	if (ret < 0) {
+		dev_err(mbox->dev, "Cannot request irq\n");
+		return ret;
+	}
+
+	/* enable IRQ generation */
+	reg = readl(mbox->base + RWTM_HOST_INT_MASK);
+	reg &= ~(SP_CMD_COMPLETE | SP_CMD_QUEUE_FULL_ACCESS | SP_CMD_QUEUE_FULL);
+	writel(reg, mbox->base + RWTM_HOST_INT_MASK);
+
+	return 0;
+}
+
+static void a37xx_mbox_shutdown(struct mbox_chan *chan)
+{
+	u32 reg;
+	struct a37xx_mbox *mbox = chan->con_priv;
+
+	/* disable interrupt generation */
+	reg = readl(mbox->base + RWTM_HOST_INT_MASK);
+	reg |= SP_CMD_COMPLETE | SP_CMD_QUEUE_FULL_ACCESS | SP_CMD_QUEUE_FULL;
+	writel(reg, mbox->base + RWTM_HOST_INT_MASK);
+
+	devm_free_irq(mbox->dev, mbox->irq, chan);
+}
+
+static const struct mbox_chan_ops a37xx_mbox_ops = {
+	.send_data	= a37xx_mbox_send_data,
+	.startup	= a37xx_mbox_startup,
+	.shutdown	= a37xx_mbox_shutdown,
+};
+
+static int armada_37xx_mbox_probe(struct platform_device *pdev)
+{
+	struct a37xx_mbox *mbox;
+	struct resource *regs;
+	struct mbox_chan *chans;
+	int ret;
+
+	mbox = devm_kzalloc(&pdev->dev, sizeof(*mbox), GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	/* Allocated one channel */
+	chans = devm_kzalloc(&pdev->dev, sizeof(*chans), GFP_KERNEL);
+	if (!chans)
+		return -ENOMEM;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	mbox->base = devm_ioremap_resource(&pdev->dev, regs);
+	if (IS_ERR(mbox->base)) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		return PTR_ERR(mbox->base);
+	}
+
+	mbox->irq = platform_get_irq(pdev, 0);
+	if (mbox->irq < 0) {
+		dev_err(&pdev->dev, "Cannot get irq\n");
+		return mbox->irq;
+	}
+
+	mbox->dev = &pdev->dev;
+
+	/* Hardware supports only one channel. */
+	chans[0].con_priv = mbox;
+	mbox->controller.dev = mbox->dev;
+	mbox->controller.num_chans = 1;
+	mbox->controller.chans = chans;
+	mbox->controller.ops = &a37xx_mbox_ops;
+	mbox->controller.txdone_irq = true;
+
+	ret = mbox_controller_register(&mbox->controller);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register mailbox controller\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, mbox);
+	return ret;
+}
+
+static int armada_37xx_mbox_remove(struct platform_device *pdev)
+{
+	struct a37xx_mbox *mbox = platform_get_drvdata(pdev);
+
+	if (!mbox)
+		return -EINVAL;
+
+	mbox_controller_unregister(&mbox->controller);
+
+	return 0;
+}
+
+static const struct of_device_id armada_37xx_mbox_match[] = {
+	{ .compatible = "marvell,armada-3700-rwtm-mailbox" },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, armada_37xx_mbox_match);
+
+static struct platform_driver armada_37xx_mbox_driver = {
+	.probe	= armada_37xx_mbox_probe,
+	.remove	= armada_37xx_mbox_remove,
+	.driver	= {
+		.name		= DRIVER_NAME,
+		.of_match_table	= armada_37xx_mbox_match,
+	},
+};
+
+module_platform_driver(armada_37xx_mbox_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("rWTM BIU Mailbox driver for Armada 37xx");
+MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
diff --git a/include/linux/armada-37xx-rwtm-mailbox.h b/include/linux/armada-37xx-rwtm-mailbox.h
new file mode 100644
index 000000000000..57bb54f6767a
--- /dev/null
+++ b/include/linux/armada-37xx-rwtm-mailbox.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * rWTM BIU Mailbox driver for Armada 37xx
+ *
+ * Author: Marek Behun <marek.behun@nic.cz>
+ */
+
+#ifndef _LINUX_ARMADA_37XX_RWTM_MAILBOX_H_
+#define _LINUX_ARMADA_37XX_RWTM_MAILBOX_H_
+
+#include <linux/types.h>
+
+struct armada_37xx_rwtm_tx_msg {
+	u16 command;
+	u32 args[16];
+};
+
+struct armada_37xx_rwtm_rx_msg {
+	u32 retval;
+	u32 status[16];
+};
+
+#endif /* _LINUX_ARMADA_37XX_RWTM_MAILBOX_H_ */
-- 
2.19.2

