Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00664C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 17:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE1016108F
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Oct 2021 17:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhJ1SAe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Oct 2021 14:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhJ1SAb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Oct 2021 14:00:31 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81DBC061224
        for <linux-crypto@vger.kernel.org>; Thu, 28 Oct 2021 10:58:01 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y12-20020a056a00190c00b0047e64c357b7so25824pfi.21
        for <linux-crypto@vger.kernel.org>; Thu, 28 Oct 2021 10:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uMwGS8qQV8bh+iXmPO0kZaYJgDLhXBgGYky/QNBE9s0=;
        b=ZHLOdaxHnGcG9Dp2jiwiZYLUTz9w+HVgHakD/1SWmFuDt7HWNeQeUmao6keIjDW7Fo
         2Qs88cggRqhuFdyfl2CCUwzurmFrar+my3ykOVRfHaMYDFgIwv7ozL8jqDrZtqz4RGKP
         IWYxiIYGXSVvp3U7iE6rRt1oKU01zgGoTlYg+VL35baITVZIJMW8JKq4IK3BbQvGru1m
         /DOsX1NgJ0NNiWlbAdGQ81fxH21T2EVn7RkRiu/GgxpdAbdLpAjxXNnfHKB96pv8ibqP
         sKuaAv323l1mcdR93Pf8ifMQtoJ0hQASLlcKA8RxDOQJzGH67p9Phdq1uVWxYHZsfQBh
         24vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uMwGS8qQV8bh+iXmPO0kZaYJgDLhXBgGYky/QNBE9s0=;
        b=DvJwB+X7JFYTN32hL6m0fCqvSJWlL70m86dv6MJ2omR6waufolHCingUfas6uGCJvU
         bypP6uAz12RA3+AwgPT1hIe7dejN1Fetsfy8bf/TlcisdjZIhWPzWTQSalPuh080V+u8
         q92LtLPzsMyjHdaNie+WMeZmeR/HU1rVlt0AUHmUadk1pfyAW7BIEAUOfdROdZzaV0ac
         oycTyWOu5t2CbLwyZvuAacHZdXXj+3I+1UFdi6NP0FVNmcEAQp0wX3s6fK2gPscgwNw9
         gkUbKVwW2lEjjoJZwWWFYQYxWWPMhQhKEazOK4NWhsMLs6lxgaJvNxz3oobxdXsmDn7P
         NroQ==
X-Gm-Message-State: AOAM532td9UdFwlt+i6C7SFpgsrWezMnYZLwLsue1RPoUMFBUzp0NeY3
        EwkHhTdQaLYYjxRw3fTbujyHSxPazSg=
X-Google-Smtp-Source: ABdhPJxuLMDsSPQBMiMBYrDkNEfqER8Kj2/gWQTfg9Veo3+fvZzoKAgoTSWZoOv7xn2c0jwS8D82iuEOXQs=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:41d0:ac84:3b61:5938])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:acc:b0:44b:ff29:621b with SMTP id
 c12-20020a056a000acc00b0044bff29621bmr5795851pfl.32.1635443881382; Thu, 28
 Oct 2021 10:58:01 -0700 (PDT)
Date:   Thu, 28 Oct 2021 10:57:49 -0700
In-Reply-To: <20211028175749.1219188-1-pgonda@google.com>
Message-Id: <20211028175749.1219188-5-pgonda@google.com>
Mime-Version: 1.0
References: <20211028175749.1219188-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 4/4] crypto: ccp - Add SEV_INIT_EX support
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: David Rientjes <rientjes@google.com>

Add new module parameter to allow users to use SEV_INIT_EX instead of
SEV_INIT. This helps users who lock their SPI bus to use the PSP for SEV
functionality. The 'init_ex_path' parameter defaults to NULL which means
the kernel will use SEV_INIT, if a path is specified SEV_INIT_EX will be
used with the data found at the path. On certain PSP commands this
file is written to as the PSP updates the NV memory region. Depending on
file system initialization this file open may fail during module init
but the CCP driver for SEV already has sufficient retries for platform
initialization. During normal operation of PSP system and SEV commands
if the PSP has not been initialized it is at run time.

Signed-off-by: David Rientjes <rientjes@google.com>
Co-developed-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com> (
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/ccp/sev-dev.c | 186 ++++++++++++++++++++++++++++++++---
 include/linux/psp-sev.h      |  21 ++++
 2 files changed, 192 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b568ae734857..c8718b4cbc93 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -22,6 +22,7 @@
 #include <linux/firmware.h>
 #include <linux/gfp.h>
 #include <linux/cpufeature.h>
+#include <linux/fs.h>
 
 #include <asm/smp.h>
 
@@ -43,6 +44,10 @@ static int psp_probe_timeout = 5;
 module_param(psp_probe_timeout, int, 0644);
 MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
 
+static char *init_ex_path;
+module_param(init_ex_path, charp, 0660);
+MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try INIT_EX");
+
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
@@ -58,6 +63,14 @@ static int psp_timeout;
 #define SEV_ES_TMR_SIZE		(1024 * 1024)
 static void *sev_es_tmr;
 
+/* INIT_EX NV Storage:
+ *   The NV Storage is a 32Kb area and must be 4Kb page aligned.  Use the page
+ *   allocator to allocate the memory, which will return aligned memory for the
+ *   specified allocation order.
+ */
+#define NV_LENGTH (32 << 10)
+static void *sev_init_ex_nv_address;
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -135,6 +148,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
 	case SEV_CMD_ATTESTATION_REPORT:	return sizeof(struct sev_data_attestation_report);
 	case SEV_CMD_SEND_CANCEL:			return sizeof(struct sev_data_send_cancel);
+	case SEV_CMD_INIT_EX:                   return sizeof(struct sev_data_init_ex);
 	default:				return 0;
 	}
 
@@ -156,6 +170,89 @@ static void *sev_fw_alloc(unsigned long len)
 	return page_address(page);
 }
 
+static int sev_read_nv_memory(void)
+{
+	struct file *fp;
+	ssize_t nread;
+
+	if (!sev_init_ex_nv_address)
+		return -EOPNOTSUPP;
+
+	fp = filp_open(init_ex_path, O_RDONLY, 0);
+	if (IS_ERR(fp)) {
+		dev_err(psp_master->dev, "sev could not open file for read\n");
+		return PTR_ERR(fp);
+	}
+
+	nread = kernel_read(fp, sev_init_ex_nv_address, NV_LENGTH, 0);
+	dev_dbg(psp_master->dev, "sev NV read %d bytes\n", nread);
+	filp_close(fp, NULL);
+	return 0;
+}
+
+static int sev_write_nv_memory(void)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct file *fp;
+	loff_t offset = 0;
+	int ret;
+
+	if (!sev_init_ex_nv_address)
+		return -EOPNOTSUPP;
+
+	fp = filp_open(init_ex_path, O_CREAT | O_WRONLY, 0600);
+	if (IS_ERR(fp)) {
+		dev_err(sev->dev, "sev NV data could not be created\n");
+		return PTR_ERR(fp);
+	}
+	ret = kernel_write(fp, sev_init_ex_nv_address, NV_LENGTH, &offset);
+	vfs_fsync(fp, 0);
+	filp_close(fp, NULL);
+
+	if (ret != NV_LENGTH) {
+		dev_err(sev->dev,
+			"failed to write %d bytes to non volatile memory area, ret=%lu\n",
+			NV_LENGTH, ret);
+		if (ret >= 0)
+			return -EIO;
+		return ret;
+	}
+
+	dev_dbg(sev->dev, "wrote to non volatile memory area\n");
+	return 0;
+}
+
+static void sev_write_nv_memory_if_required(int cmd_id)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	int ret;
+
+	if (!sev_init_ex_nv_address)
+		return;
+
+	/*
+	 * Only a few platform commands modify the SPI/NV area,
+	 * but none of the non-platform commands do. Only INIT,
+	 * PLATFORM_RESET, PEK_GEN, PEK_CERT_IMPORT, and
+	 * PDH_GEN do.
+	 */
+	switch (cmd_id) {
+	case SEV_CMD_FACTORY_RESET:
+	case SEV_CMD_INIT_EX:
+	case SEV_CMD_PDH_GEN:
+	case SEV_CMD_PEK_CERT_IMPORT:
+	case SEV_CMD_PEK_GEN:
+	case SEV_CMD_SHUTDOWN:
+		break;
+	default:
+		return;
+	};
+
+	ret = sev_write_nv_memory();
+	if (ret)
+		dev_err(sev->dev, "sev NV write failed %d\n", ret);
+}
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp = psp_master;
@@ -225,6 +322,8 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 		dev_dbg(sev->dev, "sev command %#x failed (%#010x)\n",
 			cmd, reg & PSP_CMDRESP_ERR_MASK);
 		ret = -EIO;
+	} else {
+		sev_write_nv_memory_if_required(cmd);
 	}
 
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
@@ -251,22 +350,42 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 	return rc;
 }
 
-static int __sev_platform_init_locked(int *error)
+static int __sev_init_locked(int *error)
 {
-	struct psp_device *psp = psp_master;
 	struct sev_data_init data;
-	struct sev_device *sev;
-	int rc = 0;
 
-	if (!psp || !psp->sev_data)
-		return -ENODEV;
+	memset(&data, 0, sizeof(data));
+	if (sev_es_tmr) {
+		u64 tmr_pa;
 
-	sev = psp->sev_data;
+		/*
+		 * Do not include the encryption mask on the physical
+		 * address of the TMR (firmware should clear it anyway).
+		 */
+		tmr_pa = __pa(sev_es_tmr);
 
-	if (sev->state == SEV_STATE_INIT)
-		return 0;
+		data.flags |= SEV_INIT_FLAGS_SEV_ES;
+		data.tmr_address = tmr_pa;
+		data.tmr_len = SEV_ES_TMR_SIZE;
+	}
+
+	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+}
+
+static int __sev_init_ex_locked(int *error)
+{
+	struct sev_data_init_ex data;
+	int ret;
 
 	memset(&data, 0, sizeof(data));
+	data.length = sizeof(data);
+	data.nv_address = __psp_pa(sev_init_ex_nv_address);
+	data.nv_len = NV_LENGTH;
+
+	ret = sev_read_nv_memory();
+	if (ret)
+		return ret;
+
 	if (sev_es_tmr) {
 		u64 tmr_pa;
 
@@ -276,12 +395,30 @@ static int __sev_platform_init_locked(int *error)
 		 */
 		tmr_pa = __pa(sev_es_tmr);
 
-		data.flags |= SEV_INIT_FLAGS_SEV_ES;
 		data.tmr_address = tmr_pa;
 		data.tmr_len = SEV_ES_TMR_SIZE;
 	}
+	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
+}
+
+static int __sev_platform_init_locked(int *error)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+	int rc;
+	int (*init_function)(int *error) = sev_init_ex_nv_address ?
+			__sev_init_ex_locked :
+			__sev_init_locked;
+
+	if (!psp || !psp->sev_data)
+		return -ENODEV;
+
+	sev = psp->sev_data;
 
-	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+	if (sev->state == SEV_STATE_INIT)
+		return 0;
+
+	rc = init_function(error);
 	if (rc && *error == SEV_RET_SECURE_DATA_INVALID) {
 		/*
 		 * INIT command returned an integrity check failure
@@ -290,8 +427,8 @@ static int __sev_platform_init_locked(int *error)
 		 * failed and persistent state has been erased.
 		 * Retrying INIT command here should succeed.
 		 */
-		dev_dbg(sev->dev, "SEV: retrying INIT command");
-		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+		dev_err(sev->dev, "SEV: retrying INIT command");
+		rc = init_function(error);
 	}
 
 	if (rc)
@@ -307,7 +444,7 @@ static int __sev_platform_init_locked(int *error)
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
-	return rc;
+	return 0;
 }
 
 int sev_platform_init(int *error)
@@ -987,7 +1124,7 @@ static int sev_misc_init(struct sev_device *sev)
 
 	init_waitqueue_head(&sev->int_queue);
 	sev->misc = misc_dev;
-	dev_dbg(dev, "registered SEV device\n");
+	dev_err(dev, "registered SEV device\n");
 
 	return 0;
 }
@@ -1061,6 +1198,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 			   get_order(SEV_ES_TMR_SIZE));
 		sev_es_tmr = NULL;
 	}
+
+	if (sev_init_ex_nv_address) {
+		free_pages((unsigned long)sev_init_ex_nv_address,
+			   get_order(NV_LENGTH));
+		sev_init_ex_nv_address = NULL;
+	}
 }
 
 void sev_dev_destroy(struct psp_device *psp)
@@ -1105,6 +1248,19 @@ void sev_pci_init(void)
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
+	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
+	 * instead of INIT.
+	 */
+	if (init_ex_path) {
+		sev_init_ex_nv_address = sev_fw_alloc(NV_LENGTH);
+		if (!sev_init_ex_nv_address) {
+			dev_warn(
+				sev->dev,
+				"SEV: INIT_EX NV storage allocation failed, INIT-EX support unavailable\n");
+			goto err;
+		}
+	}
+
 	/* Obtain the TMR memory area for SEV-ES use */
 	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
 	if (!sev_es_tmr)
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d48a7192e881..1595088c428b 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -52,6 +52,7 @@ enum sev_cmd {
 	SEV_CMD_DF_FLUSH		= 0x00A,
 	SEV_CMD_DOWNLOAD_FIRMWARE	= 0x00B,
 	SEV_CMD_GET_ID			= 0x00C,
+	SEV_CMD_INIT_EX                 = 0x00D,
 
 	/* Guest commands */
 	SEV_CMD_DECOMMISSION		= 0x020,
@@ -102,6 +103,26 @@ struct sev_data_init {
 	u32 tmr_len;			/* In */
 } __packed;
 
+/**
+ * struct sev_data_init_ex - INIT_EX command parameters
+ *
+ * @length: len of the command buffer read by the PSP
+ * @flags: processing flags
+ * @tmr_address: system physical address used for SEV-ES
+ * @tmr_len: len of tmr_address
+ * @nv_address: system physical address used for PSP NV storage
+ * @nv_len: len of nv_address
+ */
+struct sev_data_init_ex {
+	u32 length;                     /* In */
+	u32 flags;                      /* In */
+	u64 tmr_address;                /* In */
+	u32 tmr_len;                    /* In */
+	u32 reserved;                   /* In */
+	u64 nv_address;                 /* In/Out */
+	u32 nv_len;                     /* In */
+} __packed;
+
 #define SEV_INIT_FLAGS_SEV_ES	0x01
 
 /**
-- 
2.33.1.1089.g2158813163f-goog

