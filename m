Return-Path: <SRS0=7trJ=RM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CE2C43381
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Mar 2019 18:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3362081B
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Mar 2019 18:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfCISc2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Mar 2019 13:32:28 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47748 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfCISc2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Mar 2019 13:32:28 -0500
Received: from localhost (unknown [IPv6:2001:4d48:ad55:2401:2e9d:8edc:9d6d:a777])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andrewsh)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 2300727DB0E;
        Sat,  9 Mar 2019 18:32:26 +0000 (GMT)
From:   Andrej Shadura <andrew.shadura@collabora.co.uk>
To:     =?UTF-8?q?Ji=C5=99=C3=AD=20Kosina?= <jikos@kernel.org>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        kernel@collabora.com, Theodore Ts'o <tytso@mit.edu>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2] HID: add driver for U2F Zero built-in LED and RNG
Date:   Sat,  9 Mar 2019 18:32:13 +0000
Message-Id: <20190309183213.7598-1-andrew.shadura@collabora.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

U2F Zero supports custom commands for blinking the LED and getting data
from the internal hardware RNG. Expose the blinking function as a LED
device, and the internal hardware RNG as an HWRNG so that it can be used
to feed the enthropy pool.

Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
---

This version of the patch sets the quality to 1.

---
 drivers/hid/Kconfig       |  15 ++
 drivers/hid/Makefile      |   1 +
 drivers/hid/hid-ids.h     |   1 +
 drivers/hid/hid-u2fzero.c | 371 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 388 insertions(+)
 create mode 100644 drivers/hid/hid-u2fzero.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 41e9935fc584..4f1b8939561d 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -989,6 +989,21 @@ config HID_UDRAW_PS3
 	  Say Y here if you want to use the THQ uDraw gaming tablet for
 	  the PS3.
 
+config HID_U2FZERO
+	tristate "U2F Zero LED and RNG support"
+	depends on HID
+	depends on LEDS_CLASS
+	help
+	  Support for the LED of the U2F Zero device.
+
+	  U2F Zero supports custom commands for blinking the LED
+	  and getting data from the internal hardware RNG.
+	  The internal hardware can be used to feed the enthropy pool.
+
+	  U2F Zero only supports blinking its LED, so this driver doesn't
+	  allow setting the brightness to anything but 1, which will
+	  trigger a single blink and immediately reset to back 0.
+
 config HID_WACOM
 	tristate "Wacom Intuos/Graphire tablet support (USB)"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 896a51ce7ce0..d9724ab8df5f 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -108,6 +108,7 @@ obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tmff.o
 obj-$(CONFIG_HID_TIVO)		+= hid-tivo.o
 obj-$(CONFIG_HID_TOPSEED)	+= hid-topseed.o
 obj-$(CONFIG_HID_TWINHAN)	+= hid-twinhan.o
+obj-$(CONFIG_HID_U2FZERO)	+= hid-u2fzero.o
 obj-$(CONFIG_HID_UCLOGIC)	+= hid-uclogic.o
 obj-$(CONFIG_HID_UDRAW_PS3)	+= hid-udraw-ps3.o
 obj-$(CONFIG_HID_LED)		+= hid-led.o
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 24f846d67478..36f898eab36f 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -321,6 +321,7 @@
 #define USB_DEVICE_ID_CYGNAL_RADIO_SI470X	0x818a
 #define USB_DEVICE_ID_FOCALTECH_FTXXXX_MULTITOUCH	0x81b9
 #define USB_DEVICE_ID_CYGNAL_CP2112	0xea90
+#define USB_DEVICE_ID_U2F_ZERO		0x8acf
 
 #define USB_DEVICE_ID_CYGNAL_RADIO_SI4713       0x8244
 
diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
new file mode 100644
index 000000000000..d11a5cb56a0d
--- /dev/null
+++ b/drivers/hid/hid-u2fzero.c
@@ -0,0 +1,371 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * U2F Zero LED and RNG driver
+ *
+ * Copyright 2018 Andrej Shadura <andrew@shadura.me>
+ * Loosely based on drivers/hid/hid-led.c
+ *              and drivers/usb/misc/chaoskey.c
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ */
+
+#include <linux/hid.h>
+#include <linux/hidraw.h>
+#include <linux/hw_random.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/usb.h>
+
+#include "usbhid/usbhid.h"
+#include "hid-ids.h"
+
+#define DRIVER_SHORT		"u2fzero"
+
+#define HID_REPORT_SIZE		64
+
+/* We only use broadcast (CID-less) messages */
+#define CID_BROADCAST		0xffffffff
+
+struct u2f_hid_msg {
+	u32 cid;
+	union {
+		struct {
+			u8 cmd;
+			u8 bcnth;
+			u8 bcntl;
+			u8 data[HID_REPORT_SIZE - 7];
+		} init;
+		struct {
+			u8 seq;
+			u8 data[HID_REPORT_SIZE - 5];
+		} cont;
+	};
+} __packed;
+
+struct u2f_hid_report {
+	u8 report_type;
+	struct u2f_hid_msg msg;
+} __packed;
+
+#define U2F_HID_MSG_LEN(f)	(size_t)(((f).init.bcnth << 8) + (f).init.bcntl)
+
+/* Custom extensions to the U2FHID protocol */
+#define U2F_CUSTOM_GET_RNG	0x21
+#define U2F_CUSTOM_WINK		0x24
+
+struct u2fzero_device {
+	struct hid_device	*hdev;
+	struct urb		*urb;	    /* URB for the RNG data */
+	struct led_classdev	ldev;	    /* Embedded struct for led */
+	struct hwrng		hwrng;	    /* Embedded struct for hwrng */
+	char			*led_name;
+	char			*rng_name;
+	u8			*buf_out;
+	u8			*buf_in;
+	struct mutex		lock;
+	bool			present;
+};
+
+static int u2fzero_send(struct u2fzero_device *dev, struct u2f_hid_report *req)
+{
+	int ret;
+
+	mutex_lock(&dev->lock);
+
+	memcpy(dev->buf_out, req, sizeof(struct u2f_hid_report));
+
+	ret = hid_hw_output_report(dev->hdev, dev->buf_out,
+				   sizeof(struct u2f_hid_msg));
+
+	mutex_unlock(&dev->lock);
+
+	if (ret < 0)
+		return ret;
+
+	return ret == sizeof(struct u2f_hid_msg) ? 0 : -EMSGSIZE;
+}
+
+struct u2fzero_transfer_context {
+	struct completion done;
+	int status;
+};
+
+static void u2fzero_read_callback(struct urb *urb)
+{
+	struct u2fzero_transfer_context *ctx = urb->context;
+
+	ctx->status = urb->status;
+	complete(&ctx->done);
+}
+
+static int u2fzero_recv(struct u2fzero_device *dev,
+			struct u2f_hid_report *req,
+			struct u2f_hid_msg *resp)
+{
+	int ret;
+	struct hid_device *hdev = dev->hdev;
+	struct u2fzero_transfer_context ctx;
+
+	mutex_lock(&dev->lock);
+
+	memcpy(dev->buf_out, req, sizeof(struct u2f_hid_report));
+
+	dev->urb->context = &ctx;
+	init_completion(&ctx.done);
+
+	ret = usb_submit_urb(dev->urb, GFP_NOIO);
+	if (unlikely(ret)) {
+		hid_err(hdev, "usb_submit_urb failed: %d", ret);
+		goto err;
+	}
+
+	ret = hid_hw_output_report(dev->hdev, dev->buf_out,
+				   sizeof(struct u2f_hid_msg));
+
+	if (ret < 0) {
+		hid_err(hdev, "hid_hw_output_report failed: %d", ret);
+		goto err;
+	}
+
+	ret = (wait_for_completion_timeout(
+		&ctx.done, msecs_to_jiffies(USB_CTRL_SET_TIMEOUT)));
+	if (ret < 0) {
+		usb_kill_urb(dev->urb);
+		hid_err(hdev, "urb submission timed out");
+	} else {
+		ret = dev->urb->actual_length;
+		memcpy(resp, dev->buf_in, ret);
+	}
+
+err:
+	mutex_unlock(&dev->lock);
+
+	return ret;
+}
+
+static int u2fzero_blink(struct led_classdev *ldev)
+{
+	struct u2fzero_device *dev = container_of(ldev,
+		struct u2fzero_device, ldev);
+	struct u2f_hid_report req = {
+		.report_type = 0,
+		.msg.cid = CID_BROADCAST,
+		.msg.init = {
+			.cmd = U2F_CUSTOM_WINK,
+			.bcnth = 0,
+			.bcntl = 0,
+			.data  = {0},
+		}
+	};
+	return u2fzero_send(dev, &req);
+}
+
+static int u2fzero_brightness_set(struct led_classdev *ldev,
+				  enum led_brightness brightness)
+{
+	ldev->brightness = LED_OFF;
+	if (brightness)
+		return u2fzero_blink(ldev);
+	else
+		return 0;
+}
+
+static int u2fzero_rng_read(struct hwrng *rng, void *data,
+			    size_t max, bool wait)
+{
+	struct u2fzero_device *dev = container_of(rng,
+		struct u2fzero_device, hwrng);
+	struct u2f_hid_report req = {
+		.report_type = 0,
+		.msg.cid = CID_BROADCAST,
+		.msg.init = {
+			.cmd = U2F_CUSTOM_GET_RNG,
+			.bcnth = 0,
+			.bcntl = 0,
+			.data  = {0},
+		}
+	};
+	struct u2f_hid_msg resp;
+	int ret;
+	size_t actual_length;
+
+	if (!dev->present) {
+		hid_dbg(dev->hdev, "device not present");
+		return 0;
+	}
+
+	ret = u2fzero_recv(dev, &req, &resp);
+	if (ret < 0)
+		return 0;
+
+	/* only take the minimum amount of data it is safe to take */
+	actual_length = min3((size_t)ret - offsetof(struct u2f_hid_msg,
+		init.data), U2F_HID_MSG_LEN(resp), max);
+
+	memcpy(data, resp.init.data, actual_length);
+
+	return actual_length;
+}
+
+static int u2fzero_init_led(struct u2fzero_device *dev,
+			    unsigned int minor)
+{
+	dev->led_name = devm_kasprintf(&dev->hdev->dev, GFP_KERNEL,
+		"%s%u", DRIVER_SHORT, minor);
+	if (dev->led_name == NULL)
+		return -ENOMEM;
+
+	dev->ldev.name = dev->led_name;
+	dev->ldev.max_brightness = LED_ON;
+	dev->ldev.flags = LED_HW_PLUGGABLE;
+	dev->ldev.brightness_set_blocking = u2fzero_brightness_set;
+
+	return devm_led_classdev_register(&dev->hdev->dev, &dev->ldev);
+}
+
+static int u2fzero_init_hwrng(struct u2fzero_device *dev,
+			      unsigned int minor)
+{
+	dev->rng_name = devm_kasprintf(&dev->hdev->dev, GFP_KERNEL,
+		"%s-rng%u", DRIVER_SHORT, minor);
+	if (dev->rng_name == NULL)
+		return -ENOMEM;
+
+	dev->hwrng.name = dev->rng_name;
+	dev->hwrng.read = u2fzero_rng_read;
+	dev->hwrng.quality = 1;
+
+	return devm_hwrng_register(&dev->hdev->dev, &dev->hwrng);
+}
+
+static int u2fzero_fill_in_urb(struct u2fzero_device *dev)
+{
+	struct hid_device *hdev = dev->hdev;
+	struct usb_device *udev;
+	struct usbhid_device *usbhid = hdev->driver_data;
+	unsigned int pipe_in;
+	struct usb_host_endpoint *ep;
+
+	if (dev->hdev->bus != BUS_USB)
+		return -EINVAL;
+
+	udev = hid_to_usb_dev(hdev);
+
+	if (!usbhid->urbout || !usbhid->urbin)
+		return -ENODEV;
+
+	ep = usb_pipe_endpoint(udev, usbhid->urbin->pipe);
+	if (!ep)
+		return -ENODEV;
+
+	dev->urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!dev->urb)
+		return -ENOMEM;
+
+	pipe_in = (usbhid->urbin->pipe & ~(3 << 30)) | (PIPE_INTERRUPT << 30);
+
+	usb_fill_int_urb(dev->urb,
+		udev,
+		pipe_in,
+		dev->buf_in,
+		HID_REPORT_SIZE,
+		u2fzero_read_callback,
+		NULL,
+		ep->desc.bInterval);
+
+	return 0;
+}
+
+static int u2fzero_probe(struct hid_device *hdev,
+			 const struct hid_device_id *id)
+{
+	struct u2fzero_device *dev;
+	unsigned int minor;
+	int ret;
+
+	dev = devm_kzalloc(&hdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL)
+		return -ENOMEM;
+
+	dev->buf_out = devm_kmalloc(&hdev->dev,
+		sizeof(struct u2f_hid_report), GFP_KERNEL);
+	if (dev->buf_out == NULL)
+		return -ENOMEM;
+
+	dev->buf_in = devm_kmalloc(&hdev->dev,
+		sizeof(struct u2f_hid_msg), GFP_KERNEL);
+	if (dev->buf_in == NULL)
+		return -ENOMEM;
+
+	ret = hid_parse(hdev);
+	if (ret)
+		return ret;
+
+	dev->hdev = hdev;
+	hid_set_drvdata(hdev, dev);
+	mutex_init(&dev->lock);
+
+	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	if (ret)
+		return ret;
+
+	u2fzero_fill_in_urb(dev);
+
+	dev->present = true;
+
+	minor = ((struct hidraw *) hdev->hidraw)->minor;
+
+	ret = u2fzero_init_led(dev, minor);
+	if (ret) {
+		hid_hw_stop(hdev);
+		return ret;
+	}
+
+	hid_info(hdev, "U2F Zero LED initialised\n");
+
+	ret = u2fzero_init_hwrng(dev, minor);
+	if (ret) {
+		hid_hw_stop(hdev);
+		return ret;
+	}
+
+	hid_info(hdev, "U2F Zero RNG initialised\n");
+
+	return 0;
+}
+
+static void u2fzero_remove(struct hid_device *hdev)
+{
+	struct u2fzero_device *dev = hid_get_drvdata(hdev);
+
+	mutex_lock(&dev->lock);
+	dev->present = false;
+	mutex_unlock(&dev->lock);
+
+	hid_hw_stop(hdev);
+	usb_poison_urb(dev->urb);
+	usb_free_urb(dev->urb);
+}
+
+static const struct hid_device_id u2fzero_table[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL,
+	  USB_DEVICE_ID_U2F_ZERO) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, u2fzero_table);
+
+static struct hid_driver u2fzero_driver = {
+	.name = "hid-" DRIVER_SHORT,
+	.probe = u2fzero_probe,
+	.remove = u2fzero_remove,
+	.id_table = u2fzero_table,
+};
+
+module_hid_driver(u2fzero_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Andrej Shadura <andrew@shadura.me>");
+MODULE_DESCRIPTION("U2F Zero LED and RNG driver");
-- 
2.20.1

