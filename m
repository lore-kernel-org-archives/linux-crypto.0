Return-Path: <SRS0=t27p=PE=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33298 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730453AbeL0LIT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Dec 2018 06:08:19 -0500
Received: by mail-pl1-f195.google.com with SMTP id z23so8670295plo.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Dec 2018 03:08:18 -0800 (PST)
From: Sumit Garg <sumit.garg@linaro.org>
To: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        jens.wiklander@linaro.org, daniel.thompson@linaro.org,
        ard.biesheuvel@linaro.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org, Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH v1 2/2] hwrng: add OP-TEE based rng driver
Date: Thu, 27 Dec 2018 16:37:11 +0530
Message-Id: <1545908831-25910-3-git-send-email-sumit.garg@linaro.org>
In-Reply-To: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On ARM SoC's with TrustZone enabled, peripherals like entropy sources
might not be accessible to normal world (linux in this case) and rather
accessible to secure world (OP-TEE in this case) only. So this driver
aims to provides a generic interface to OP-TEE based random number
generator service.

Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 MAINTAINERS                        |   5 +
 drivers/char/hw_random/Kconfig     |  15 ++
 drivers/char/hw_random/Makefile    |   1 +
 drivers/char/hw_random/optee-rng.c | 273 +++++++++++++++++++++++++++++++++++++
 4 files changed, 294 insertions(+)
 create mode 100644 drivers/char/hw_random/optee-rng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 0767f1d..fe0fb74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11100,6 +11100,11 @@ M:	Jens Wiklander <jens.wiklander@linaro.org>
 S:	Maintained
 F:	drivers/tee/optee/
 
+OP-TEE RANDOM NUMBER GENERATOR (RNG) DRIVER
+M:	Sumit Garg <sumit.garg@linaro.org>
+S:	Maintained
+F:	drivers/char/hw_random/optee-rng.c
+
 OPA-VNIC DRIVER
 M:	Dennis Dalessandro <dennis.dalessandro@intel.com>
 M:	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index dac895d..25a7d8f 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -424,6 +424,21 @@ config HW_RANDOM_EXYNOS
 	  will be called exynos-trng.
 
 	  If unsure, say Y.
+
+config HW_RANDOM_OPTEE
+	tristate "OP-TEE based Random Number Generator support"
+	depends on OPTEE
+	default HW_RANDOM
+	help
+	  This  driver provides support for OP-TEE based Random Number
+	  Generator on ARM SoCs where hardware entropy sources are not
+	  accessible to normal world (Linux).
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called optee-rng.
+
+	  If unsure, say Y.
+
 endif # HW_RANDOM
 
 config UML_RANDOM
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index e35ec3c..7c9ef4a 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -38,3 +38,4 @@ obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
 obj-$(CONFIG_HW_RANDOM_MTK)	+= mtk-rng.o
 obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
 obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
+obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
new file mode 100644
index 0000000..8c63730
--- /dev/null
+++ b/drivers/char/hw_random/optee-rng.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018 Linaro Ltd.
+ */
+
+#include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/hw_random.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/tee_drv.h>
+#include <linux/uuid.h>
+
+#define TEE_ERROR_HEALTH_TEST_FAIL	0x00000001
+
+/*
+ * TA_CMD_GET_ENTROPY - Get Entropy from RNG
+ *
+ * param[0] (inout memref) - Entropy buffer memory reference
+ * param[1] unused
+ * param[2] unused
+ * param[3] unused
+ *
+ * Result:
+ * TEE_SUCCESS - Invoke command success
+ * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
+ * TEE_ERROR_NOT_SUPPORTED - Requested entropy size greater than size of pool
+ * TEE_ERROR_HEALTH_TEST_FAIL - Continuous health testing failed
+ */
+#define TA_CMD_GET_ENTROPY		0x0
+
+/*
+ * TA_CMD_GET_RNG_INFO - Get RNG information
+ *
+ * param[0] (out value) - value.a: RNG data-rate in bytes per second
+ *                        value.b: Quality/Entropy per 1024 bit of data
+ * param[1] unused
+ * param[2] unused
+ * param[3] unused
+ *
+ * Result:
+ * TEE_SUCCESS - Invoke command success
+ * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
+ */
+#define TA_CMD_GET_RNG_INFO		0x1
+
+#define MAX_ENTROPY_REQ_SZ		(4 * 1024)
+
+static struct tee_context *ctx;
+static struct tee_shm *entropy_shm_pool;
+static u32 ta_rng_data_rate;
+static u32 ta_rng_seesion_id;
+
+static size_t get_optee_rng_data(void *buf, size_t req_size)
+{
+	u32 ret = 0;
+	u8 *rng_data = NULL;
+	size_t rng_size = 0;
+	struct tee_ioctl_invoke_arg inv_arg = {0};
+	struct tee_param param[4] = {0};
+
+	/* Invoke TA_CMD_GET_RNG function of Trusted App */
+	inv_arg.func = TA_CMD_GET_ENTROPY;
+	inv_arg.session = ta_rng_seesion_id;
+	inv_arg.num_params = 4;
+
+	/* Fill invoke cmd params */
+	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT;
+	param[0].u.memref.shm = entropy_shm_pool;
+	param[0].u.memref.size = req_size;
+	param[0].u.memref.shm_offs = 0;
+
+	ret = tee_client_invoke_func(ctx, &inv_arg, param);
+	if ((ret < 0) || (inv_arg.ret != 0)) {
+		pr_err("TA_CMD_GET_ENTROPY invoke function error: %x\n",
+		       inv_arg.ret);
+		return 0;
+	}
+
+	rng_data = tee_shm_get_va(entropy_shm_pool, 0);
+	if (IS_ERR(rng_data)) {
+		pr_err("tee_shm_get_va failed\n");
+		return 0;
+	}
+
+	rng_size = param[0].u.memref.size;
+	memcpy(buf, rng_data, rng_size);
+
+	return rng_size;
+}
+
+static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
+{
+	u8 *data = buf;
+	size_t read = 0, rng_size = 0;
+	int timeout = 1;
+
+	if (max > MAX_ENTROPY_REQ_SZ)
+		max = MAX_ENTROPY_REQ_SZ;
+
+	while (read == 0) {
+		rng_size = get_optee_rng_data(data, (max - read));
+
+		data += rng_size;
+		read += rng_size;
+
+		if (wait) {
+			if (timeout-- == 0)
+				return read;
+			msleep((1000 * (max - read)) / ta_rng_data_rate);
+		} else {
+			return read;
+		}
+	}
+
+	return read;
+}
+
+static int optee_rng_init(struct hwrng *rng)
+{
+	entropy_shm_pool = tee_shm_alloc(ctx, MAX_ENTROPY_REQ_SZ,
+					 TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
+	if (IS_ERR(entropy_shm_pool)) {
+		pr_err("tee_shm_alloc failed\n");
+		return PTR_ERR(entropy_shm_pool);
+	}
+
+	return 0;
+}
+
+static void optee_rng_cleanup(struct hwrng *rng)
+{
+	tee_shm_free(entropy_shm_pool);
+}
+
+static struct hwrng optee_rng = {
+	.name		= "optee-rng",
+	.init		= optee_rng_init,
+	.cleanup	= optee_rng_cleanup,
+	.read		= optee_rng_read,
+};
+
+static const struct of_device_id optee_match[] = {
+	{ .compatible = "linaro,optee-tz" },
+	{},
+};
+
+static int get_optee_rng_uuid(uuid_t *ta_rng_uuid)
+{
+	struct device_node *fw_np;
+	struct device_node *np;
+	const char *uuid;
+
+	/* Node is supposed to be below /firmware */
+	fw_np = of_find_node_by_name(NULL, "firmware");
+	if (!fw_np)
+		return -ENODEV;
+
+	np = of_find_matching_node(fw_np, optee_match);
+	if (!np || !of_device_is_available(np))
+		return -ENODEV;
+
+	if (of_property_read_string(np, "rng-uuid", &uuid)) {
+		pr_warn("missing \"uuid\" property\n");
+		return -ENXIO;
+	}
+
+	if (uuid_parse(uuid, ta_rng_uuid)) {
+		pr_warn("incorrect rng ta uuid\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int get_optee_rng_info(void)
+{
+	u32 ret = 0;
+	struct tee_ioctl_invoke_arg inv_arg = {0};
+	struct tee_param param[4] = {0};
+
+	/* Invoke TA_CMD_GET_RNG function of Trusted App */
+	inv_arg.func = TA_CMD_GET_RNG_INFO;
+	inv_arg.session = ta_rng_seesion_id;
+	inv_arg.num_params = 4;
+
+	/* Fill invoke cmd params */
+	param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_OUTPUT;
+
+	ret = tee_client_invoke_func(ctx, &inv_arg, param);
+	if ((ret < 0) || (inv_arg.ret != 0)) {
+		pr_err("TA_CMD_GET_RNG_INFO invoke function error: %x\n",
+		       inv_arg.ret);
+		return -EINVAL;
+	}
+
+	ta_rng_data_rate = param[0].u.value.a;
+	optee_rng.quality = param[0].u.value.b;
+
+	return 0;
+}
+
+static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
+{
+	if (ver->impl_id == TEE_IMPL_ID_OPTEE)
+		return 1;
+	else
+		return 0;
+}
+
+static int __init mod_init(void)
+{
+	int ret = 0, err = -ENODEV;
+	struct tee_ioctl_open_session_arg sess_arg = {0};
+	uuid_t ta_rng_uuid = {0};
+
+	err = get_optee_rng_uuid(&ta_rng_uuid);
+	if (err)
+		return err;
+
+	/* Open context with TEE driver */
+	ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
+	if (IS_ERR(ctx))
+		return -ENODEV;
+
+	/* Open session with hwrng Trusted App */
+	memcpy(sess_arg.uuid, ta_rng_uuid.b, TEE_IOCTL_UUID_LEN);
+	sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
+	sess_arg.num_params = 0;
+
+	ret = tee_client_open_session(ctx, &sess_arg, NULL);
+	if ((ret < 0) || (sess_arg.ret != 0)) {
+		pr_err("tee_client_open_session failed, error: %x\n",
+		       sess_arg.ret);
+		err = -EINVAL;
+		goto out_ctx;
+	}
+	ta_rng_seesion_id = sess_arg.session;
+
+	err = get_optee_rng_info();
+	if (err)
+		goto out_sess;
+
+	err = hwrng_register(&optee_rng);
+	if (err) {
+		pr_err("registering failed (%d)\n", err);
+		goto out_sess;
+	}
+
+	return 0;
+
+out_sess:
+	tee_client_close_session(ctx, ta_rng_seesion_id);
+out_ctx:
+	tee_client_close_context(ctx);
+
+	return err;
+}
+
+static void __exit mod_exit(void)
+{
+	tee_client_close_session(ctx, ta_rng_seesion_id);
+	tee_client_close_context(ctx);
+	hwrng_unregister(&optee_rng);
+}
+
+module_init(mod_init);
+module_exit(mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sumit Garg <sumit.garg@linaro.org>");
+MODULE_DESCRIPTION("OP-TEE based random number generator driver");
+MODULE_SOFTDEP("pre: optee");
-- 
2.7.4
