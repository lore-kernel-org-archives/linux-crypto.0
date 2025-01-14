Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A331ADC6A;
	Tue, 14 Jan 2025 09:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736848605; cv=none; b=cMih/mql87LU5A5wQbFrV2FmB15JO70cQfpKPcZxFRp0m1laJTOHTK0n6HPOZ1jH+WSosMiMyxu8m85VKM+3bdeQ5/bvI9jHXf+bLfHH/0VVxxrkTmpH1W4/x0d7Pnn5z4l0zeHoCN3TigaoO8/rKxjwFRCCLA2zfeLS9wQh+qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736848605; c=relaxed/simple;
	bh=6/f8KFQddy2s34NVUfLM8qvh2q9HJtui40udrWnrUec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N6CvcMFWKKlamOqkClXV89iFjMOWd9L0D3OG/Ijq7HbVNOBk84doYll7FJHzOg8P8A6MvskmZffLynzN9SZQUokdz7h+HT0nCDLwe8LeE+g7+nhHu1laP2hPQ4Vl0oailFN6Tst/U8EO0F40n8orEPGJy6TfpmScekPuUcMKi4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.90])
	by gateway (Coremail) with SMTP id _____8Axjq_UNIZnHiBjAA--.39493S3;
	Tue, 14 Jan 2025 17:56:36 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.90])
	by front1 (Coremail) with SMTP id qMiowMBxReSoNIZnct0hAA--.2343S5;
	Tue, 14 Jan 2025 17:56:21 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org,
	herbert@gondor.apana.org.au,
	gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	arnd@arndb.de,
	derek.kiernan@amd.com,
	dragan.cvetic@amd.com,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>
Subject: [PATCH v1 3/3] misc: ls6000se-sdf: Add driver for Loongson 6000SE SDF
Date: Tue, 14 Jan 2025 17:55:27 +0800
Message-Id: <20250114095527.23722-4-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxReSoNIZnct0hAA--.2343S5
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Jr15Cw18urWkAry7Wr4DAwc_yoW7Cw48pF
	s5Ca45Cr4UWF47Kr43Jr4Uuay3Jas2gry2gry2kw1F93sIyFWkGryrta4DtFsxXrWDGrya
	qa45KrW5uF4DA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
	XwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AK
	xVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8_gA5UUUUU==

Loongson Secure Device Function device supports the functions specified
in "GB/T 36322-2018". This driver is only responsible for sending user
data to SDF devices or returning SDF device data to users.

Co-developed-by: Yinggang Gu <guyinggang@loongson.cn>
Signed-off-by: Yinggang Gu <guyinggang@loongson.cn>
Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
---
 MAINTAINERS                 |   1 +
 drivers/misc/Kconfig        |   9 +++
 drivers/misc/Makefile       |   1 +
 drivers/misc/ls6000se-sdf.c | 123 ++++++++++++++++++++++++++++++++++++
 4 files changed, 134 insertions(+)
 create mode 100644 drivers/misc/ls6000se-sdf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e65a7f4ea4..e313e0daf8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13485,6 +13485,7 @@ M:	Qunqin Zhao <zhaoqunqin@loongson.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/loongson/
+F:	drivers/misc/ls6000se-sdf.c
 
 LOONGSON-2 APB DMA DRIVER
 M:	Binbin Zhou <zhoubinbin@loongson.cn>
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 09cbe3f0ab..10a3ea59a1 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -634,6 +634,15 @@ config MCHP_LAN966X_PCI
 	    - lan966x-miim (MDIO_MSCC_MIIM)
 	    - lan966x-switch (LAN966X_SWITCH)
 
+config LS6000SE_SDF
+	tristate "Loongson Secure Device Function driver"
+	depends on MFD_LS6000SE
+	help
+	  Loongson Secure Device Function device is the child device of Loongson
+	  Security Module device, it supports the functions specified in
+	  GB/T 36322-2018.  This driver will use the interface of Loongson Security
+	  Module driver.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 40bf953185..b273ec7802 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -74,3 +74,4 @@ lan966x-pci-objs		:= lan966x_pci.o
 lan966x-pci-objs		+= lan966x_pci.dtbo.o
 obj-$(CONFIG_MCHP_LAN966X_PCI)	+= lan966x-pci.o
 obj-y				+= keba/
+obj-$(CONFIG_LS6000SE_SDF)	+= ls6000se-sdf.o
diff --git a/drivers/misc/ls6000se-sdf.c b/drivers/misc/ls6000se-sdf.c
new file mode 100644
index 0000000000..646d54b6e4
--- /dev/null
+++ b/drivers/misc/ls6000se-sdf.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (C) 2025 Loongson Technology Corporation Limited */
+
+#include <linux/init.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mfd/ls6000se.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+
+#define SE_SDF_BUFSIZE	(PAGE_SIZE * 2)
+
+struct sdf_dev {
+	struct miscdevice miscdev;
+	struct lsse_ch *se_ch;
+	struct completion sdf_completion;
+};
+
+struct sdf_msg {
+	u32 cmd;
+	u32 data_off;
+	u32 data_len;
+	u32 pad[5];
+};
+
+static void sdf_complete(struct lsse_ch *ch)
+{
+	struct sdf_dev *sdf = ch->priv;
+
+	complete(&sdf->sdf_completion);
+}
+
+static int send_sdf_cmd(struct sdf_dev *sdf, int len)
+{
+	struct sdf_msg *smsg = sdf->se_ch->smsg;
+
+	smsg->data_len = len;
+
+	return se_send_ch_requeset(sdf->se_ch);
+}
+
+static ssize_t sdf_read(struct file *file, char __user *buf,
+			size_t cnt, loff_t *offt)
+{
+	struct sdf_dev *sdf = container_of(file->private_data,
+					   struct sdf_dev, miscdev);
+	struct sdf_msg *rmsg;
+
+	if (!wait_for_completion_timeout(&sdf->sdf_completion, HZ*5))
+		return -ETIME;
+
+	rmsg = (struct sdf_msg *)sdf->se_ch->rmsg;
+	if (copy_to_user(buf,
+			 sdf->se_ch->data_buffer + rmsg->data_off, rmsg->data_len))
+		return -EFAULT;
+
+	return rmsg->data_len;
+}
+
+static ssize_t sdf_write(struct file *file, const char __user *buf,
+			 size_t cnt, loff_t *offt)
+{
+	struct sdf_dev *sdf = container_of(file->private_data,
+					   struct sdf_dev, miscdev);
+	int ret;
+
+	if (copy_from_user(sdf->se_ch->data_buffer, buf, cnt))
+		return -EFAULT;
+
+	ret = send_sdf_cmd(sdf, cnt);
+
+	return ret ? -EFAULT : cnt;
+}
+
+static const struct file_operations sdf_fops = {
+	.owner = THIS_MODULE,
+	.write = sdf_write,
+	.read = sdf_read,
+};
+
+static int sdf_probe(struct platform_device *pdev)
+{
+	struct sdf_msg *smsg;
+	struct sdf_dev *sdf;
+	static int idx;
+
+	sdf = devm_kzalloc(&pdev->dev, sizeof(*sdf), GFP_KERNEL);
+	if (!sdf)
+		return -ENOMEM;
+	init_completion(&sdf->sdf_completion);
+
+	sdf->se_ch = se_init_ch(pdev->dev.parent, SE_CH_SDF, SE_SDF_BUFSIZE,
+				sizeof(struct sdf_msg) * 2, sdf, sdf_complete);
+	smsg = sdf->se_ch->smsg;
+	smsg->cmd = SE_CMD_SDF;
+	smsg->data_off = sdf->se_ch->off;
+	sdf->miscdev.minor = MISC_DYNAMIC_MINOR;
+	sdf->miscdev.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
+					   "lsse_sdf%d", idx++);
+	sdf->miscdev.fops = &sdf_fops;
+
+	return misc_register(&sdf->miscdev);
+}
+
+static struct platform_driver loongson_sdf_driver = {
+	.probe	= sdf_probe,
+	.driver  = {
+		.name  = "ls6000se-sdf",
+	},
+};
+module_platform_driver(loongson_sdf_driver);
+
+MODULE_ALIAS("platform:ls6000se-sdf");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yinggang Gu <guyinggang@loongson.cn>");
+MODULE_AUTHOR("Qunqin Zhao <zhaoqunqin@loongson.cn>");
+MODULE_DESCRIPTION("Loongson Secure Device Function driver");
-- 
2.43.0

