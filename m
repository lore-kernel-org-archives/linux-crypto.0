Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C734C4360F
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ECB721726
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 03:15:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nic.cz header.i=@nic.cz header.b="mfaterPc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbfCaDPy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Mar 2019 23:15:54 -0400
Received: from mail.nic.cz ([217.31.204.67]:37894 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731133AbfCaDPo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Mar 2019 23:15:44 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 56685635ED;
        Sun, 31 Mar 2019 05:15:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1554002139; bh=nPE45lLr/6pOB2OZu9U3RrPg1+mqdpeNAZquFwsydiA=;
        h=From:To:Date;
        b=mfaterPcEFkPnoSQRhoQrUnerm4uMFlzxpZWjYaUQqQEy5QY3gHySMwHPzz28aNRs
         cy8QiQxGfkQ7S2tob7bGRdVJE+gz8Ft2ssf4AokUDGizj+uEhtyUply0triMRlcrLK
         N4b4i6+SY3QOUalSI4nNbalKAMFNJjD7rc1cM7b0=
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
Subject: [PATCH v3 crypto+mailbox+firmware RESEND 5/6] firmware: Add Turris Mox rWTM firmware driver
Date:   Sun, 31 Mar 2019 05:15:36 +0200
Message-Id: <20190331031537.10626-6-marek.behun@nic.cz>
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

This adds a driver to communicate with the firmware running on the
secure processor of the Turris Mox router, enabling the kernel to
retrieve true random numbers from the Entropy Bit Generator and to
sign messages with the ECDSA private key burned into each Turris Mox
device when manufacturing.

This also adds support to read other information burned into eFuses:
 - serial number
 - board version
 - MAC addresses
 - RAM size
 - ECDSA public key (this is not read directly from eFuses, rather it
   is computed by the firmware as pair to the burned private key)

The source code of the firmware is open source and can be found at
https://gitlab.labs.nic.cz/turris/mox-boot-builder/tree/master/wtmi

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 drivers/firmware/Kconfig           |  14 +
 drivers/firmware/Makefile          |   1 +
 drivers/firmware/turris-mox-rwtm.c | 508 +++++++++++++++++++++++++++++
 3 files changed, 523 insertions(+)
 create mode 100644 drivers/firmware/turris-mox-rwtm.c

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index cac16c4b0df3..616c8c1f4174 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -267,6 +267,20 @@ config TI_SCI_PROTOCOL
 	  This protocol library is used by client drivers to use the features
 	  provided by the system controller.
 
+config TURRIS_MOX_RWTM
+	tristate "Turris Mox rWTM secure firmware driver"
+	depends on HAS_DMA && OF
+	depends on MAILBOX
+	select HW_RANDOM
+	select ARMADA_37XX_RWTM_MBOX
+	help
+	  This driver communicates with the firmware on the Cortex-M3 secure
+	  processor of the Turris Mox router. Enable if you are building for
+	  Turris Mox, and you will be able to read the serial number and
+	  other manufacturing data, sign messages with the internal ECDSA-521
+	  private key and utilize the Entropy Bit Generator as hardware random
+	  number generator.
+
 config HAVE_ARM_SMCCC
 	bool
 
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 80feb635120f..7300787141f5 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_QCOM_SCM_64)	+= qcom_scm-64.o
 obj-$(CONFIG_QCOM_SCM_32)	+= qcom_scm-32.o
 CFLAGS_qcom_scm-32.o :=$(call as-instr,.arch armv7-a\n.arch_extension sec,-DREQUIRES_SEC=1) -march=armv7-a
 obj-$(CONFIG_TI_SCI_PROTOCOL)	+= ti_sci.o
+obj-$(CONFIG_TURRIS_MOX_RWTM)	+= turris-mox-rwtm.o
 
 obj-$(CONFIG_ARM_SCMI_PROTOCOL)	+= arm_scmi/
 obj-y				+= broadcom/
diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
new file mode 100644
index 000000000000..e5d66460f85b
--- /dev/null
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -0,0 +1,508 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Turris Mox rWTM firmware driver
+ *
+ * Copyright (C) 2019 Marek Behun <marek.behun@nic.cz>
+ */
+
+#include <linux/armada-37xx-rwtm-mailbox.h>
+#include <linux/completion.h>
+#include <linux/dma-mapping.h>
+#include <linux/hw_random.h>
+#include <linux/mailbox_client.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#define DRIVER_NAME		"turris-mox-rwtm"
+
+/*
+ * The macros and constants below come from Turris Mox's rWTM firmware code.
+ * This firmware is open source and it's sources can be found at
+ * https://gitlab.labs.nic.cz/turris/mox-boot-builder/tree/master/wtmi.
+ */
+
+#define MBOX_STS_SUCCESS	(0 << 30)
+#define MBOX_STS_FAIL		(1 << 30)
+#define MBOX_STS_BADCMD		(2 << 30)
+#define MBOX_STS_ERROR(s)	((s) & (3 << 30))
+#define MBOX_STS_VALUE(s)	(((s) >> 10) & 0xfffff)
+#define MBOX_STS_CMD(s)		((s) & 0x3ff)
+
+enum mbox_cmd {
+	MBOX_CMD_GET_RANDOM	= 1,
+	MBOX_CMD_BOARD_INFO	= 2,
+	MBOX_CMD_ECDSA_PUB_KEY	= 3,
+	MBOX_CMD_HASH		= 4,
+	MBOX_CMD_SIGN		= 5,
+	MBOX_CMD_VERIFY		= 6,
+
+	MBOX_CMD_OTP_READ	= 7,
+	MBOX_CMD_OTP_WRITE	= 8,
+};
+
+struct mox_kobject;
+
+struct mox_rwtm {
+	struct device *dev;
+	struct mbox_client mbox_client;
+	struct mbox_chan *mbox;
+	struct mox_kobject *kobj;
+	struct hwrng hwrng;
+
+	struct armada_37xx_rwtm_rx_msg reply;
+
+	void *buf;
+	dma_addr_t buf_phys;
+
+	/*
+	 * If cmd_done_cb is not null, it is called on rWTM reply event.
+	 * Otherwise cmd_done completion is completed.
+	 */
+	struct mutex busy;
+	struct completion cmd_done;
+	void (*cmd_done_cb)(struct mox_rwtm *rwtm);
+
+	/* board information */
+	int has_board_info;
+	u64 serial_number;
+	int board_version, ram_size;
+	u8 mac_address1[6], mac_address2[6];
+
+	/* public key burned in eFuse */
+	int has_pubkey;
+	u8 pubkey[135];
+
+	/* signature process */
+	struct kernfs_node *do_sign_kn;
+	u32 last_sig[34];
+	int last_sig_result;
+};
+
+struct mox_kobject {
+	struct kobject kobj;
+	struct mox_rwtm *rwtm;
+};
+
+static inline struct kobject *rwtm_to_kobj(struct mox_rwtm *rwtm)
+{
+	return &rwtm->kobj->kobj;
+}
+
+static inline struct mox_rwtm *to_rwtm(struct kobject *kobj)
+{
+	return container_of(kobj, struct mox_kobject, kobj)->rwtm;
+}
+
+static void mox_kobj_release(struct kobject *kobj)
+{
+	kfree(to_rwtm(kobj)->kobj);
+}
+
+static struct kobj_type mox_kobj_ktype = {
+	.release	= mox_kobj_release,
+	.sysfs_ops	= &kobj_sysfs_ops,
+};
+
+static int mox_kobj_create(struct mox_rwtm *rwtm)
+{
+	rwtm->kobj = kzalloc(sizeof(*rwtm->kobj), GFP_KERNEL);
+	if (!rwtm->kobj)
+		return -ENOMEM;
+
+	kobject_init(rwtm_to_kobj(rwtm), &mox_kobj_ktype);
+	if (kobject_add(rwtm_to_kobj(rwtm), firmware_kobj, "turris-mox-rwtm")) {
+		kobject_put(rwtm_to_kobj(rwtm));
+		return -ENXIO;
+	}
+
+	rwtm->kobj->rwtm = rwtm;
+
+	return 0;
+}
+
+#define MOX_ATTR_RO(name, format, cat)				\
+static ssize_t							\
+name##_show(struct kobject *kobj, struct kobj_attribute *a,	\
+	    char *buf)						\
+{								\
+	struct mox_rwtm *rwtm = to_rwtm(kobj);	\
+	if (!rwtm->has_##cat)					\
+		return -ENODATA;				\
+	return sprintf(buf, format, rwtm->name);		\
+}								\
+static struct kobj_attribute mox_attr_##name = __ATTR_RO(name)
+
+MOX_ATTR_RO(serial_number, "%016llX\n", board_info);
+MOX_ATTR_RO(board_version, "%i\n", board_info);
+MOX_ATTR_RO(ram_size, "%i\n", board_info);
+MOX_ATTR_RO(mac_address1, "%pM\n", board_info);
+MOX_ATTR_RO(mac_address2, "%pM\n", board_info);
+MOX_ATTR_RO(pubkey, "%s\n", pubkey);
+
+static int mox_get_status(enum mbox_cmd cmd, u32 retval)
+{
+	if (MBOX_STS_CMD(retval) != cmd ||
+	    MBOX_STS_ERROR(retval) != MBOX_STS_SUCCESS)
+		return -EIO;
+	else if (MBOX_STS_ERROR(retval) == MBOX_STS_FAIL)
+		return -(int)MBOX_STS_VALUE(retval);
+	else
+		return MBOX_STS_VALUE(retval);
+}
+
+static ssize_t
+do_sign_show(struct kobject *kobj, struct kobj_attribute *a, char *buf)
+{
+	struct mox_rwtm *rwtm = to_rwtm(kobj);
+	int ret = rwtm->last_sig_result;
+
+	if (!ret)
+		return -ENODATA;
+
+	if (ret == 1) {
+		/* 2 arrays of 17 32-bit words are 136 bytes */
+		memcpy(buf, rwtm->last_sig, 136);
+		ret = 136;
+	}
+
+	rwtm->last_sig_result = 0;
+
+	return ret;
+}
+
+static void
+mox_signing_done(struct mox_rwtm *rwtm)
+{
+	struct armada_37xx_rwtm_rx_msg *reply = &rwtm->reply;
+	int ret;
+
+	ret = mox_get_status(MBOX_CMD_SIGN, reply->retval);
+	if (ret < 0) {
+		rwtm->last_sig_result = ret;
+	} else {
+		/*
+		 * Here we read the R and S values of the ECDSA signature
+		 * computed by the rWTM firmware and convert their words from
+		 * LE to BE.
+		 */
+		memcpy(rwtm->last_sig, rwtm->buf + 68, 136);
+		cpu_to_be32_array(rwtm->last_sig, rwtm->last_sig, 34);
+		rwtm->last_sig_result = 1;
+	}
+
+	rwtm->cmd_done_cb = NULL;
+	mutex_unlock(&rwtm->busy);
+
+	sysfs_notify_dirent(rwtm->do_sign_kn);
+}
+
+static ssize_t
+do_sign_store(struct kobject *kobj, struct kobj_attribute *a, const char *buf,
+	      size_t count)
+{
+	struct mox_rwtm *rwtm = to_rwtm(kobj);
+	struct armada_37xx_rwtm_tx_msg msg;
+	int ret;
+
+	/* the input is a SHA-512 hash, so exactly 64 bytes have to be read */
+	if (count != 64)
+		return -EINVAL;
+
+	/* if last result is not zero user has not read that information yet */
+	if (rwtm->last_sig_result)
+		return -EBUSY;
+
+	if (!mutex_trylock(&rwtm->busy))
+		return -EBUSY;
+
+	rwtm->cmd_done_cb = mox_signing_done;
+
+	/*
+	 * Here we have to send:
+	 *   1. Address of the input to sign.
+	 *      The input is an array of 17 32-bit words, the first (most
+	 *      significat) is 0, the rest 16 words are copied from the SHA-512
+	 *      hash given by the user and converted from BE to LE.
+	 *   2. Address of the buffer where ECDSA signature value R shall be
+	 *      stored by the rWTM firmware.
+	 *   3. Address of the buffer where ECDSA signature value S shall be
+	 *      stored by the rWTM firmware.
+	 */
+	memset(rwtm->buf, 0, 4);
+	memcpy(rwtm->buf + 4, buf, 64);
+	be32_to_cpu_array(rwtm->buf, rwtm->buf, 17);
+
+	msg.command = MBOX_CMD_SIGN;
+	msg.args[0] = 1;
+	msg.args[1] = rwtm->buf_phys;
+	msg.args[2] = rwtm->buf_phys + 68;
+	msg.args[3] = rwtm->buf_phys + 2 * 68;
+	ret = mbox_send_message(rwtm->mbox, &msg);
+	if (ret < 0)
+		goto unlock_mutex;
+
+	return count;
+unlock_mutex:
+	rwtm->cmd_done_cb = NULL;
+	mutex_unlock(&rwtm->busy);
+	return ret;
+}
+
+/* only root should be able to sign */
+static struct kobj_attribute mox_attr_do_sign =
+	__ATTR(do_sign, 0600, do_sign_show, do_sign_store);
+
+static const struct attribute *mox_rwtm_attrs[] = {
+	&mox_attr_serial_number.attr,
+	&mox_attr_board_version.attr,
+	&mox_attr_ram_size.attr,
+	&mox_attr_mac_address1.attr,
+	&mox_attr_mac_address2.attr,
+	&mox_attr_pubkey.attr,
+	&mox_attr_do_sign.attr,
+	NULL
+};
+
+static void mox_rwtm_rx_callback(struct mbox_client *cl, void *data)
+{
+	struct mox_rwtm *rwtm = dev_get_drvdata(cl->dev);
+	struct armada_37xx_rwtm_rx_msg *msg = data;
+
+	rwtm->reply = *msg;
+	if (rwtm->cmd_done_cb)
+		rwtm->cmd_done_cb(rwtm);
+	else
+		complete(&rwtm->cmd_done);
+}
+
+static void reply_to_mac_addr(u8 *mac, u32 t1, u32 t2)
+{
+	mac[0] = t1 >> 8;
+	mac[1] = t1;
+	mac[2] = t2 >> 24;
+	mac[3] = t2 >> 16;
+	mac[4] = t2 >> 8;
+	mac[5] = t2;
+}
+
+static int mox_get_board_info(struct mox_rwtm *rwtm)
+{
+	struct armada_37xx_rwtm_tx_msg msg;
+	struct armada_37xx_rwtm_rx_msg *reply = &rwtm->reply;
+	int ret;
+
+	msg.command = MBOX_CMD_BOARD_INFO;
+	ret = mbox_send_message(rwtm->mbox, &msg);
+	if (ret < 0)
+		return ret;
+
+	ret = wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2);
+	if (ret < 0)
+		return ret;
+
+	ret = mox_get_status(MBOX_CMD_BOARD_INFO, reply->retval);
+	if (ret < 0 && ret != -ENODATA) {
+		return ret;
+	} else if (ret == -ENODATA) {
+		dev_warn(rwtm->dev,
+			 "Board does not have manufacturing information burned!\n");
+	} else {
+		rwtm->serial_number = reply->status[1];
+		rwtm->serial_number <<= 32;
+		rwtm->serial_number |= reply->status[0];
+			rwtm->board_version = reply->status[2];
+		rwtm->ram_size = reply->status[3];
+		reply_to_mac_addr(rwtm->mac_address1, reply->status[4],
+				  reply->status[5]);
+		reply_to_mac_addr(rwtm->mac_address2, reply->status[6],
+				  reply->status[7]);
+		rwtm->has_board_info = 1;
+
+		pr_info("Turris Mox serial number %016llX\n",
+			rwtm->serial_number);
+		pr_info("           board version %i\n", rwtm->board_version);
+		pr_info("           burned RAM size %i MiB\n", rwtm->ram_size);
+	}
+
+	msg.command = MBOX_CMD_ECDSA_PUB_KEY;
+	ret = mbox_send_message(rwtm->mbox, &msg);
+	if (ret < 0)
+		return ret;
+
+	ret = wait_for_completion_timeout(&rwtm->cmd_done, HZ / 2);
+	if (ret < 0)
+		return ret;
+
+	ret = mox_get_status(MBOX_CMD_ECDSA_PUB_KEY, reply->retval);
+	if (ret < 0 && ret != -ENODATA) {
+		return ret;
+	} else if (ret == -ENODATA) {
+		dev_warn(rwtm->dev, "Board has no public key burned!\n");
+	} else {
+		u32 *s = reply->status;
+
+		rwtm->has_pubkey = 1;
+		sprintf(rwtm->pubkey,
+			"%06x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x%08x",
+			ret, s[0], s[1], s[2], s[3], s[4], s[5], s[6], s[7],
+			s[8], s[9], s[10], s[11], s[12], s[13], s[14], s[15]);
+	}
+
+	return 0;
+}
+
+static int mox_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct mox_rwtm *rwtm = (struct mox_rwtm *) rng->priv;
+	struct armada_37xx_rwtm_tx_msg msg;
+	int ret;
+
+	if (max > 4096)
+		max = 4096;
+
+	msg.command = MBOX_CMD_GET_RANDOM;
+	msg.args[0] = 1;
+	msg.args[1] = rwtm->buf_phys;
+	msg.args[2] = (max + 3) & ~3;
+
+	if (!wait) {
+		if (!mutex_trylock(&rwtm->busy))
+			return -EBUSY;
+	} else {
+		mutex_lock(&rwtm->busy);
+	}
+
+	ret = mbox_send_message(rwtm->mbox, &msg);
+	if (ret < 0)
+		goto unlock_mutex;
+
+	ret = wait_for_completion_interruptible(&rwtm->cmd_done);
+	if (ret < 0)
+		goto unlock_mutex;
+
+	ret = mox_get_status(MBOX_CMD_GET_RANDOM, rwtm->reply.retval);
+	if (ret < 0)
+		goto unlock_mutex;
+
+	memcpy(data, rwtm->buf, max);
+	ret = max;
+
+unlock_mutex:
+	mutex_unlock(&rwtm->busy);
+	return ret;
+}
+
+static int turris_mox_rwtm_probe(struct platform_device *pdev)
+{
+	struct mox_rwtm *rwtm;
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	rwtm = devm_kzalloc(dev, sizeof(*rwtm), GFP_KERNEL);
+	if (!rwtm)
+		return -ENOMEM;
+
+	rwtm->dev = dev;
+	rwtm->buf = dmam_alloc_coherent(dev, PAGE_SIZE, &rwtm->buf_phys,
+					GFP_KERNEL);
+	if (!rwtm->buf)
+		return -ENOMEM;
+
+	ret = mox_kobj_create(rwtm);
+	if (ret < 0) {
+		dev_err(dev, "Cannot create turris-mox-rwtm kobject!\n");
+		return ret;
+	}
+
+	ret = sysfs_create_files(rwtm_to_kobj(rwtm), mox_rwtm_attrs);
+	if (ret < 0) {
+		dev_err(dev, "Cannot create sysfs files!\n");
+		goto put_kobj;
+	}
+
+	rwtm->do_sign_kn = sysfs_get_dirent(rwtm->kobj->kobj.sd, "do_sign");
+	if (!rwtm->do_sign_kn) {
+		dev_err(dev, "Cannot get do_sign node\n");
+		ret = -ENXIO;
+		goto remove_files;
+	}
+
+	platform_set_drvdata(pdev, rwtm);
+
+	mutex_init(&rwtm->busy);
+
+	rwtm->mbox_client.dev = dev;
+	rwtm->mbox_client.rx_callback = mox_rwtm_rx_callback;
+
+	rwtm->mbox = mbox_request_channel(&rwtm->mbox_client, 0);
+	if (IS_ERR(rwtm->mbox)) {
+		ret = PTR_ERR(rwtm->mbox);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Cannot request mailbox channel: %i\n",
+				ret);
+		goto remove_files;
+	}
+
+	init_completion(&rwtm->cmd_done);
+
+	ret = mox_get_board_info(rwtm);
+	if (ret < 0)
+		dev_warn(dev, "Cannot read board information: %i\n", ret);
+
+	rwtm->hwrng.name = DRIVER_NAME "_hwrng";
+	rwtm->hwrng.read = mox_hwrng_read;
+	rwtm->hwrng.priv = (unsigned long) rwtm;
+	rwtm->hwrng.quality = 1024;
+
+	ret = devm_hwrng_register(dev, &rwtm->hwrng);
+	if (ret < 0) {
+		dev_err(dev, "Cannot register HWRNG: %i\n", ret);
+		goto free_channel;
+	}
+
+	return 0;
+
+free_channel:
+	mbox_free_channel(rwtm->mbox);
+remove_files:
+	sysfs_remove_files(rwtm_to_kobj(rwtm), mox_rwtm_attrs);
+put_kobj:
+	kobject_put(rwtm_to_kobj(rwtm));
+	return ret;
+}
+
+static int turris_mox_rwtm_remove(struct platform_device *pdev)
+{
+	struct mox_rwtm *rwtm = platform_get_drvdata(pdev);
+
+	sysfs_put(rwtm->do_sign_kn);
+	sysfs_remove_files(rwtm_to_kobj(rwtm), mox_rwtm_attrs);
+	kobject_put(rwtm_to_kobj(rwtm));
+	mbox_free_channel(rwtm->mbox);
+
+	return 0;
+}
+
+static const struct of_device_id turris_mox_rwtm_match[] = {
+	{ .compatible = "cznic,turris-mox-rwtm", },
+	{ },
+};
+
+MODULE_DEVICE_TABLE(of, turris_mox_rwtm_match);
+
+static struct platform_driver turris_mox_rwtm_driver = {
+	.probe	= turris_mox_rwtm_probe,
+	.remove	= turris_mox_rwtm_remove,
+	.driver	= {
+		.name		= DRIVER_NAME,
+		.of_match_table	= turris_mox_rwtm_match,
+	},
+};
+module_platform_driver(turris_mox_rwtm_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Turris Mox rWTM firmware driver");
+MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
-- 
2.19.2

