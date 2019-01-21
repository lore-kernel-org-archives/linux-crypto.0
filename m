Return-Path: <SRS0=ru6j=P5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D209BC282F6
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 09:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A3120989
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 09:30:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="P85rzBSL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfAUJaC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:30:02 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42604 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfAUJaB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jan 2019 04:30:01 -0500
Received: by mail-pf1-f194.google.com with SMTP id 64so9853543pfr.9
        for <linux-crypto@vger.kernel.org>; Mon, 21 Jan 2019 01:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z9Rwq9XvERgXKC4dth0NtQ5GI/bk1t7E/UkygENFoiY=;
        b=P85rzBSLRM58loF2f7ry1GroGt+dGnwluFo7y3l1N+iyJf0OSFyMvevCC+1SxdCC/c
         I1IOyDUVciVyLeagtiqh9UcclqlhPhRKjbWictu8UtiJflFZ2JNNhqy0MNTXqSyfdZ45
         69lIvGfcH6eP/cNyrGwuu1EzFRpnEbIfVXp7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z9Rwq9XvERgXKC4dth0NtQ5GI/bk1t7E/UkygENFoiY=;
        b=aqmqEdMGgTP1bI7FH3vNeQtn1kSjJLn47C8uE5Yt3pVTWPM7jiCDuQhZHQpogBNTkd
         8LeO0mSUf7gbmaiHXSyBs2C4n+Y28xKeiwPVf/OKspFEFbUcqAY6uGUjQwYsFi+Minfw
         vsV8FMeaMPRdZUIc05hhJnS6vDM2dQNU3jPKWu/NiTPWROBbDmtG9ttOpb558fbIaUr0
         jD6X6XtOzjU5Fwamxm84tEf/r/arKAZcqS7FEdhO5nX53UwCLFZfYTMWbHs7q+T1fs9r
         M3jQe43ji401rNkItJBq392a03MxxgGjCK26ru1XWub5ktA4dqhAHeGNr8IbB7h/GiMf
         dgBw==
X-Gm-Message-State: AJcUukctIPQgFrpkY4//S0o4M8LmBoKN5eVzsNtjDh6h6OwsJ2QTiKFT
        gwQEUo7xJUNSAsDftROHAsUP6g==
X-Google-Smtp-Source: ALg8bN583xrLn0GqRIRvjtByRE4SLIW/2WMIeTQD2h8yErEqyUtszX4PxsFf4XOHc5hLTduKGxvhbw==
X-Received: by 2002:a63:1444:: with SMTP id 4mr27674649pgu.430.1548063001031;
        Mon, 21 Jan 2019 01:30:01 -0800 (PST)
Received: from localhost.localdomain ([117.252.65.115])
        by smtp.gmail.com with ESMTPSA id h9sm16182777pgd.53.2019.01.21.01.29.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 21 Jan 2019 01:30:00 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, ard.biesheuvel@linaro.org,
        bhsharma@redhat.com, tee-dev@lists.linaro.org,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v4 1/4] tee: add bus driver framework for TEE based devices
Date:   Mon, 21 Jan 2019 14:59:16 +0530
Message-Id: <1548062959-31860-2-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548062959-31860-1-git-send-email-sumit.garg@linaro.org>
References: <1548062959-31860-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce a generic TEE bus driver concept for TEE based kernel drivers
which would like to communicate with TEE based devices/services.

In this TEE bus concept, devices/services are identified via Universally
Unique Identifier (UUID) and drivers register a table of device UUIDs
which they can support.

So this TEE bus framework registers a match() callback function which
iterates over the driver UUID table to find a corresponding match for
device UUID. If a match is found, then this particular device is probed
via corresponding probe api registered by the driver. This process
happens whenever a device or a driver is registered with TEE bus.

Also this framework allows for device enumeration to be specific to
corresponding TEE implementation like OP-TEE etc.

Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 drivers/tee/tee_core.c  | 45 +++++++++++++++++++++++++++++++++++++++++----
 include/linux/tee_drv.h | 37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
index 7b2bb4c..55370d5 100644
--- a/drivers/tee/tee_core.c
+++ b/drivers/tee/tee_core.c
@@ -15,7 +15,6 @@
 #define pr_fmt(fmt) "%s: " fmt, __func__
 
 #include <linux/cdev.h>
-#include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/module.h>
@@ -1027,6 +1026,30 @@ int tee_client_invoke_func(struct tee_context *ctx,
 }
 EXPORT_SYMBOL_GPL(tee_client_invoke_func);
 
+static int tee_client_device_match(struct device *dev,
+				   struct device_driver *drv)
+{
+	const tee_client_device_id *id_table;
+	struct tee_client_device *tee_device;
+
+	id_table = to_tee_client_driver(drv)->id_table;
+	tee_device = to_tee_client_device(dev);
+
+	while (!uuid_is_null(id_table)) {
+		if (uuid_equal(&tee_device->id, id_table))
+			return 1;
+		id_table++;
+	}
+
+	return 0;
+}
+
+struct bus_type tee_bus_type = {
+	.name		= "tee",
+	.match		= tee_client_device_match,
+};
+EXPORT_SYMBOL_GPL(tee_bus_type);
+
 static int __init tee_init(void)
 {
 	int rc;
@@ -1040,18 +1063,32 @@ static int __init tee_init(void)
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
diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
index 6cfe058..ba985d8 100644
--- a/include/linux/tee_drv.h
+++ b/include/linux/tee_drv.h
@@ -15,11 +15,13 @@
 #ifndef __TEE_DRV_H
 #define __TEE_DRV_H
 
-#include <linux/types.h>
+#include <linux/device.h>
 #include <linux/idr.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/tee.h>
+#include <linux/types.h>
+#include <linux/uuid.h>
 
 /*
  * The file describes the API provided by the generic TEE driver to the
@@ -538,4 +540,37 @@ static inline bool tee_param_is_memref(struct tee_param *param)
 	}
 }
 
+extern struct bus_type tee_bus_type;
+
+/*
+ * For TEE based client devices we use the device uuid as the
+ * identifier.
+ */
+typedef uuid_t tee_client_device_id;
+
+/**
+ * struct tee_client_device - tee based device
+ * @id:			device identifier
+ * @dev:		device structure
+ */
+struct tee_client_device {
+	tee_client_device_id id;
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
+	const tee_client_device_id *id_table;
+	struct device_driver driver;
+};
+
+#define to_tee_client_driver(d) \
+		container_of(d, struct tee_client_driver, driver)
+
 #endif /*__TEE_DRV_H*/
-- 
2.7.4

