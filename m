Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D33C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 05:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6FEF21872
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 05:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="VaGymbJP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbfAXFz0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 00:55:26 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35988 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfAXFz0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 00:55:26 -0500
Received: by mail-pf1-f196.google.com with SMTP id b85so2462741pfc.3
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jan 2019 21:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dnEldj1krFnyBcZ28g4diO0QN2WcNK+iA+Bx1sW0hq8=;
        b=VaGymbJPULjIim8SHv3rYB5raJQI/ankG2MB+Z7UNr0gHpjpTbp+katTbn4guhBP2O
         w86v0JqQOxa7jMMgQcQnp7zlVnm7+aKit6PMhSyCAV7l93/CKh8agoaN8cc4SdxnpU61
         MkVrGEIEB5eG9bqDZ9a8GxK06KUTXBRMQNqFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dnEldj1krFnyBcZ28g4diO0QN2WcNK+iA+Bx1sW0hq8=;
        b=udU0yI9fvJQNuHv+qnqFNBm95HgQG6wmVmKXxHpJvnoY6LqPZj4IzSvd44d/CA8KdX
         Pr66Jvb1UAMcvvdW4rtVkDTy1wpOwZBox/8wx5UffcEN9NtgOIv6vDatXSWia99T/S2L
         I8tL/mPCFvwkYV2DaXWUfvelV35E3qpli0GQ7510EdkRW5GlYo3+P/6GKcltM9YPnyI4
         67HqaP6VvDF7xsYruL7Ze4YCT6JhockhGtnjCQiFH6ovaaxt+HMWDilr/GrJgnBAIEMz
         UDjQUg3CrLhnLVPGqfyz7S2FdcFxG6n0GHT98UWB+UKBe00YFIWeiVotZX0I9qV+h1+t
         tdmQ==
X-Gm-Message-State: AJcUukdo6ajGOp1lR+vnUH5GgF0czBg/a0/qXe+EMFXY6nzCXuqKFz+Y
        X0Sy0pjoQj/4m/eDdffWQP81dQ==
X-Google-Smtp-Source: ALg8bN7MnZUJeh9uf3S2Eh4rY+Qbjwlk7uwegbubjBAYH4vlxrhZGAM6+Y146Uo2iy1PiXojr0vWWw==
X-Received: by 2002:a62:68c5:: with SMTP id d188mr5294359pfc.194.1548309325096;
        Wed, 23 Jan 2019 21:55:25 -0800 (PST)
Received: from localhost.localdomain ([117.196.233.31])
        by smtp.gmail.com with ESMTPSA id i2sm32297287pfi.66.2019.01.23.21.55.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Jan 2019 21:55:24 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au,
        ard.biesheuvel@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com,
        michal.lkml@markovi.net, mpm@selenic.com, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        daniel.thompson@linaro.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org, Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v5 3/4] tee: optee: add TEE bus device enumeration support
Date:   Thu, 24 Jan 2019 11:24:38 +0530
Message-Id: <1548309279-5281-4-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
References: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

OP-TEE provides a pseudo TA to enumerate TAs which can act as devices/
services for TEE bus. So implement device enumeration using invoke
function: PTA_CMD_GET_DEVICES provided by pseudo TA to fetch array of
device UUIDs. Also register these enumerated devices with TEE bus as
"optee-clntX" device.

Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 drivers/tee/optee/Makefile        |   1 +
 drivers/tee/optee/core.c          |   4 +
 drivers/tee/optee/device.c        | 153 ++++++++++++++++++++++++++++++++++++++
 drivers/tee/optee/optee_private.h |   3 +
 4 files changed, 161 insertions(+)
 create mode 100644 drivers/tee/optee/device.c

diff --git a/drivers/tee/optee/Makefile b/drivers/tee/optee/Makefile
index 48d262a..56263ae 100644
--- a/drivers/tee/optee/Makefile
+++ b/drivers/tee/optee/Makefile
@@ -5,3 +5,4 @@ optee-objs += call.o
 optee-objs += rpc.o
 optee-objs += supp.o
 optee-objs += shm_pool.o
+optee-objs += device.o
diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index e5efce3..ac59c77 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -634,6 +634,10 @@ static struct optee *optee_probe(struct device_node *np)
 	if (optee->sec_caps & OPTEE_SMC_SEC_CAP_DYNAMIC_SHM)
 		pr_info("dynamic shared memory is enabled\n");
 
+	rc = optee_enumerate_devices();
+	if (rc)
+		goto err;
+
 	pr_info("initialized driver\n");
 	return optee;
 err:
diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
new file mode 100644
index 0000000..987e552
--- /dev/null
+++ b/drivers/tee/optee/device.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/tee_drv.h>
+#include <linux/uuid.h>
+#include "optee_private.h"
+
+/*
+ * Get device UUIDs
+ *
+ * [out]     memref[0]        Array of device UUIDs
+ *
+ * Return codes:
+ * TEE_SUCCESS - Invoke command success
+ * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
+ * TEE_ERROR_SHORT_BUFFER - Output buffer size less than required
+ */
+#define PTA_CMD_GET_DEVICES		0x0
+
+static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
+{
+	if (ver->impl_id == TEE_IMPL_ID_OPTEE)
+		return 1;
+	else
+		return 0;
+}
+
+static int get_devices(struct tee_context *ctx, u32 session,
+		       struct tee_shm *device_shm, u32 *shm_size)
+{
+	u32 ret = 0;
+	struct tee_ioctl_invoke_arg inv_arg = {0};
+	struct tee_param param[4] = {0};
+
+	/* Invoke PTA_CMD_GET_DEVICES function */
+	inv_arg.func = PTA_CMD_GET_DEVICES;
+	inv_arg.session = session;
+	inv_arg.num_params = 4;
+
+	/* Fill invoke cmd params */
+	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT;
+	param[0].u.memref.shm = device_shm;
+	param[0].u.memref.size = *shm_size;
+	param[0].u.memref.shm_offs = 0;
+
+	ret = tee_client_invoke_func(ctx, &inv_arg, param);
+	if ((ret < 0) || ((inv_arg.ret != TEEC_SUCCESS) &&
+			  (inv_arg.ret != TEEC_ERROR_SHORT_BUFFER))) {
+		pr_err("PTA_CMD_GET_DEVICES invoke function err: %x\n",
+		       inv_arg.ret);
+		return -EINVAL;
+	}
+
+	*shm_size = param[0].u.memref.size;
+
+	return 0;
+}
+
+static int optee_register_device(const uuid_t *device_uuid, u32 device_id)
+{
+	struct tee_client_device *optee_device = NULL;
+	int rc;
+
+	optee_device = kzalloc(sizeof(*optee_device), GFP_KERNEL);
+	if (!optee_device)
+		return -ENOMEM;
+
+	optee_device->dev.bus = &tee_bus_type;
+	dev_set_name(&optee_device->dev, "optee-clnt%u", device_id);
+	uuid_copy(&optee_device->id.uuid, device_uuid);
+
+	rc = device_register(&optee_device->dev);
+	if (rc) {
+		pr_err("device registration failed, err: %d\n", rc);
+		kfree(optee_device);
+	}
+
+	return rc;
+}
+
+int optee_enumerate_devices(void)
+{
+	const uuid_t pta_uuid =
+		UUID_INIT(0x7011a688, 0xddde, 0x4053,
+			  0xa5, 0xa9, 0x7b, 0x3c, 0x4d, 0xdf, 0x13, 0xb8);
+	struct tee_ioctl_open_session_arg sess_arg = {0};
+	struct tee_shm *device_shm = NULL;
+	const uuid_t *device_uuid = NULL;
+	struct tee_context *ctx = NULL;
+	u32 shm_size = 0, idx, num_devices = 0;
+	int rc;
+
+	/* Open context with OP-TEE driver */
+	ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
+	if (IS_ERR(ctx))
+		return -ENODEV;
+
+	/* Open session with device enumeration pseudo TA */
+	memcpy(sess_arg.uuid, pta_uuid.b, TEE_IOCTL_UUID_LEN);
+	sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
+	sess_arg.num_params = 0;
+
+	rc = tee_client_open_session(ctx, &sess_arg, NULL);
+	if ((rc < 0) || (sess_arg.ret != TEEC_SUCCESS)) {
+		/* Device enumeration pseudo TA not found */
+		rc = 0;
+		goto out_ctx;
+	}
+
+	rc = get_devices(ctx, sess_arg.session, NULL, &shm_size);
+	if (rc < 0)
+		goto out_sess;
+
+	device_shm = tee_shm_alloc(ctx, shm_size,
+				   TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
+	if (IS_ERR(device_shm)) {
+		pr_err("tee_shm_alloc failed\n");
+		rc = PTR_ERR(device_shm);
+		goto out_sess;
+	}
+
+	rc = get_devices(ctx, sess_arg.session, device_shm, &shm_size);
+	if (rc < 0)
+		goto out_shm;
+
+	device_uuid = tee_shm_get_va(device_shm, 0);
+	if (IS_ERR(device_uuid)) {
+		pr_err("tee_shm_get_va failed\n");
+		rc = PTR_ERR(device_uuid);
+		goto out_shm;
+	}
+
+	num_devices = shm_size / sizeof(uuid_t);
+
+	for (idx = 0; idx < num_devices; idx++) {
+		rc = optee_register_device(&device_uuid[idx], idx);
+		if (rc)
+			goto out_shm;
+	}
+
+out_shm:
+	tee_shm_free(device_shm);
+out_sess:
+	tee_client_close_session(ctx, sess_arg.session);
+out_ctx:
+	tee_client_close_context(ctx);
+
+	return rc;
+}
diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
index 35e7938..a5e84af 100644
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -28,6 +28,7 @@
 #define TEEC_ERROR_BAD_PARAMETERS	0xFFFF0006
 #define TEEC_ERROR_COMMUNICATION	0xFFFF000E
 #define TEEC_ERROR_OUT_OF_MEMORY	0xFFFF000C
+#define TEEC_ERROR_SHORT_BUFFER		0xFFFF0010
 
 #define TEEC_ORIGIN_COMMS		0x00000002
 
@@ -181,6 +182,8 @@ void optee_free_pages_list(void *array, size_t num_entries);
 void optee_fill_pages_list(u64 *dst, struct page **pages, int num_pages,
 			   size_t page_offset);
 
+int optee_enumerate_devices(void);
+
 /*
  * Small helpers
  */
-- 
2.7.4

