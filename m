Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BF4C282C5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 05:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5761F21872
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 05:55:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="iqkoHCb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfAXFzL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 00:55:11 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39059 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfAXFzL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 00:55:11 -0500
Received: by mail-pg1-f196.google.com with SMTP id w6so2191987pgl.6
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 21:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5WMo/K4NuXKTODlcOV8f6/OWQaH3XOAMMukaI5750UI=;
        b=iqkoHCb0D12KSX8xX/nbyXtJokbNEDfvHMY/GyHBXq81j8sSpwP3WmNyFgkBUWJBN0
         RybR4KRXBaeFG8tgnWVjaVK9MpOX/SWxYjRjdf4WsAmbyej89736nTKKEzYNZz9Y2OYq
         aLosQuHDe1C/FLERVRO3UGZSlHcVyUJ6eQyX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5WMo/K4NuXKTODlcOV8f6/OWQaH3XOAMMukaI5750UI=;
        b=ApIb9rPP2PY319luUkmtLPttnu0o4Wsg5A05dQ+sesNQDOXq0hbpL6pZopRd3Q4cmg
         fYzVMVygSquRchFirfepnE5hUwDiI4jG/PsoaCOddJK9lBfqQIxW3lzPKPbTmyBtaWuj
         qD6tgk8BNEYDXtxiM1O5OGL1QG+5ZlUrkHzZ3dumoeP54/94VNN/jNCXZ0Xu02QpGsKr
         v5g7XD8X1Po9ptKrdvwrlnj45wcrieEwbpoLmCFPv9viFfU3Ixx/82x6U7FYt1DKjzab
         uhLr2069BtZgz7nhaD8hlN8lOpCCL2Hy59C+CyvwHEnogowmjvwrCInJ86lppQifCcAt
         BMNw==
X-Gm-Message-State: AJcUukd1VxijS1L0UmRsnuZVpFLqe9JPYjsv3MHTKQwClQWaRYTlkAGo
        St7XN4OTWibUwZabW1YKvCv8DQ==
X-Google-Smtp-Source: ALg8bN4UzpPQKnYSd90nncfrWXS+730y/xQaQF3SWjT0mJ7yWDg7Cv8Nbic90i7f9Hj7MilJic3x1g==
X-Received: by 2002:a63:5621:: with SMTP id k33mr4770340pgb.395.1548309310512;
        Wed, 23 Jan 2019 21:55:10 -0800 (PST)
Received: from localhost.localdomain ([117.196.233.31])
        by smtp.gmail.com with ESMTPSA id i2sm32297287pfi.66.2019.01.23.21.55.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Jan 2019 21:55:09 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au,
        ard.biesheuvel@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com,
        michal.lkml@markovi.net, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org, Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v5 1/4] tee: add bus driver framework for TEE based devices
Date:   Thu, 24 Jan 2019 11:24:36 +0530
Message-Id: <1548309279-5281-2-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
References: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce a generic TEE bus driver concept for TEE based kernel drivers
which would like to communicate with TEE based devices/services. Also
add support in module device table for these new TEE based devices.

In this TEE bus concept, devices/services are identified via Universally
Unique Identifier (UUID) and drivers register a table of device UUIDs
which they can support.

So this TEE bus framework registers following apis:
- match(): Iterates over the driver UUID table to find a corresponding
  match for device UUID. If a match is found, then this particular device
  is probed via corresponding probe api registered by the driver. This
  process happens whenever a device or a driver is registered with TEE
  bus.
- uevent(): Notifies user-space (udev) whenever a new device is registered
  on this bus for auto-loading of out-of-tree drivers.

Also this framework allows for device enumeration to be specific to
corresponding TEE implementation like OP-TEE etc.

Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 drivers/tee/tee_core.c            | 57 ++++++++++++++++++++++++++++++++++++---
 include/linux/mod_devicetable.h   |  9 +++++++
 include/linux/tee_drv.h           | 32 +++++++++++++++++++++-
 scripts/mod/devicetable-offsets.c |  3 +++
 scripts/mod/file2alias.c          | 19 +++++++++++++
 5 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 7b2bb4c..9f4c8bc 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -15,7 +15,6 @@
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
 #include <linux/cdev.h>
-#include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/module.h>
@@ -1027,6 +1026,42 @@ int tee_client_invoke_func(struct tee_context *ctx,
 }
 EXPORT_SYMBOL_GPL(tee_client_invoke_func);
 
+static int tee_client_device_match(struct device *dev,
+				   struct device_driver *drv)
+{
+	const struct tee_client_device_id *id_table;
+	struct tee_client_device *tee_device;
+
+	id_table = to_tee_client_driver(drv)->id_table;
+	tee_device = to_tee_client_device(dev);
+
+	while (!uuid_is_null(&id_table->uuid)) {
+		if (uuid_equal(&tee_device->id.uuid, &id_table->uuid))
+			return 1;
+		id_table++;
+	}
+
+	return 0;
+}
+
+static int tee_client_device_uevent(struct device *dev,
+				    struct kobj_uevent_env *env)
+{
+	uuid_t *dev_id = &to_tee_client_device(dev)->id.uuid;
+
+	if (add_uevent_var(env, "MODALIAS=tee:%pUb", dev_id))
+		return -ENOMEM;
+
+	return 0;
+}
+
+struct bus_type tee_bus_type = {
+	.name		= "tee",
+	.match		= tee_client_device_match,
+	.uevent		= tee_client_device_uevent,
+};
+EXPORT_SYMBOL_GPL(tee_bus_type);
+
 static int __init tee_init(void)
 {
 	int rc;
@@ -1040,18 +1075,32 @@ static int __init tee_init(void)
 	rc = alloc_chrdev_region(&tee_devt, 0, TEE_NUM_DEVICES, "tee");
 	if (rc) {
 		pr_err("failed to allocate char dev region\n");
-		class_destroy(tee_class);
-		tee_class = NULL;
+		goto out_unreg_class;
 	}
 
+	rc = bus_register(&tee_bus_type);
+	if (rc) {
+		pr_err("failed to register tee bus\n");
+		goto out_unreg_chrdev;
+	}
+
+	return 0;
+
+out_unreg_chrdev:
+	unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
+out_unreg_class:
+	class_destroy(tee_class);
+	tee_class = NULL;
+
 	return rc;
 }
 
 static void __exit tee_exit(void)
 {
+	bus_unregister(&tee_bus_type);
+	unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
 	class_destroy(tee_class);
 	tee_class = NULL;
-	unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
 }
 
 subsys_initcall(tee_init);
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index f9bd2f3..14eaeeb 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -779,4 +779,13 @@ struct typec_device_id {
 	kernel_ulong_t driver_data;
 };
 
+/**
+ * struct tee_client_device_id - tee based device identifier
+ * @uuid: For TEE based client devices we use the device uuid as
+ *        the identifier.
+ */
+struct tee_client_device_id {
+	uuid_t uuid;
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
index 6cfe058..ce957ce 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -15,11 +15,14 @@
 #ifndef __TEE_DRV_H
 #define __TEE_DRV_H
 
-#include <linux/types.h>
+#include <linux/device.h>
 #include <linux/idr.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/mod_devicetable.h>
 #include <linux/tee.h>
+#include <linux/types.h>
+#include <linux/uuid.h>
 
 /*
  * The file describes the API provided by the generic TEE driver to the
@@ -538,4 +541,31 @@ static inline bool tee_param_is_memref(struct tee_param *param)
 	}
 }
 
+extern struct bus_type tee_bus_type;
+
+/**
+ * struct tee_client_device - tee based device
+ * @id:			device identifier
+ * @dev:		device structure
+ */
+struct tee_client_device {
+	struct tee_client_device_id id;
+	struct device dev;
+};
+
+#define to_tee_client_device(d) container_of(d, struct tee_client_device, dev)
+
+/**
+ * struct tee_client_driver - tee client driver
+ * @id_table:		device id table supported by this driver
+ * @driver:		driver structure
+ */
+struct tee_client_driver {
+	const struct tee_client_device_id *id_table;
+	struct device_driver driver;
+};
+
+#define to_tee_client_driver(d) \
+		container_of(d, struct tee_client_driver, driver)
+
 #endif /*__TEE_DRV_H*/
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index 2930044..1607183 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -225,5 +225,8 @@ int main(void)
 	DEVID_FIELD(typec_device_id, svid);
 	DEVID_FIELD(typec_device_id, mode);
 
+	DEVID(tee_client_device_id);
+	DEVID_FIELD(tee_client_device_id, uuid);
+
 	return 0;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index a37af7d..d0e4172 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -37,6 +37,9 @@ typedef unsigned char	__u8;
 typedef struct {
 	__u8 b[16];
 } uuid_le;
+typedef struct {
+	__u8 b[16];
+} uuid_t;
 
 /* Big exception to the "don't include kernel headers into userspace, which
  * even potentially has different endianness and word sizes, since
@@ -1287,6 +1290,21 @@ static int do_typec_entry(const char *filename, void *symval, char *alias)
 	return 1;
 }
 
+/* Looks like: tee:uuid */
+static int do_tee_entry(const char *filename, void *symval, char *alias)
+{
+	DEF_FIELD(symval, tee_client_device_id, uuid);
+
+	sprintf(alias, "tee:%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
+		uuid.b[0], uuid.b[1], uuid.b[2], uuid.b[3], uuid.b[4],
+		uuid.b[5], uuid.b[6], uuid.b[7], uuid.b[8], uuid.b[9],
+		uuid.b[10], uuid.b[11], uuid.b[12], uuid.b[13], uuid.b[14],
+		uuid.b[15]);
+
+	add_wildcard(alias);
+	return 1;
+}
+
 /* Does namelen bytes of name exactly match the symbol? */
 static bool sym_is(const char *name, unsigned namelen, const char *symbol)
 {
@@ -1357,6 +1375,7 @@ static const struct devtable devtable[] = {
 	{"fslmc", SIZE_fsl_mc_device_id, do_fsl_mc_entry},
 	{"tbsvc", SIZE_tb_service_id, do_tbsvc_entry},
 	{"typec", SIZE_typec_device_id, do_typec_entry},
+	{"tee", SIZE_tee_client_device_id, do_tee_entry},
 };
 
 /* Create MODULE_ALIAS() statements.
-- 
2.7.4

