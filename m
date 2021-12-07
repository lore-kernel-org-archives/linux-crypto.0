Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C82C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Dec 2021 23:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbhLGXg4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Dec 2021 18:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242630AbhLGXgw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Dec 2021 18:36:52 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0437CC0617A2
        for <linux-crypto@vger.kernel.org>; Tue,  7 Dec 2021 15:33:22 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id c131-20020a621c89000000b004a343484969so526500pfc.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 Dec 2021 15:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YIj1cidfuFKi9+VTkRnK1kssvs8JEEsHVfevz0HcqHw=;
        b=lmls6H6UEOTGDi4KFaMoCghNFIqRJDdn9IwpXTI63xF4owZob4k6u2tYkaH7jO7Eq2
         MN1bI1vx5UWl/Z+SNpq78AbOzd6nvOMSdckqIz6P12vZKu0kVTvK+m/RO7JtNG6sTkKy
         EdTn8VEMGPPBocxfBEnlLkgVtebrhSka1otiU12rE7ZK4l6D4kBbQD+tAm1c3hrDirjF
         N4X5lYO/MBgA702sJuBzDSw7LDI/+6P9/SVVD1SOSnivwUUj+PS9kJGQPvfFCKHQZd2v
         5a4MM4+l2SXMmyHctiQ9J7t1nPpZCLaFVGqRRGsY1fRWbtIHJH5ohhdQzc5SCPcxbtPN
         g3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YIj1cidfuFKi9+VTkRnK1kssvs8JEEsHVfevz0HcqHw=;
        b=bbx9S9FZp65n9WT1QkUmI8k4yRknnETr/wwub0XO/S+UQ8756CyvDD58M19yO34eQ5
         i1zvqtXtKKxYBOTQm9aFWIDiT0l8hI7EGVaIxLFRR6REdLcwwi6weJ0CpHH3N+KufWoA
         JIF7opCFEvlq5dA96v/pF63JLDFO1W7mU63t32l3cDTF5npmRlTuP13/gTkh3FrwXh2E
         Fp1/vnJwPzzH5Jeykack6iuZZ2zlHvAahJd3JD82AX3tUPfg9dXzQbW7/BwH8ydLZHeC
         1uSTKlI88SUemszFN2yfacQIRdQ5O8FnmvYAbKBtwtyrJfsNW9TwaKqsGxOPfxpCqcMv
         eDeA==
X-Gm-Message-State: AOAM532Ch0O2qH6G2mCVRN4w/uyM1rUzOgmabqA5lXsEZJVx4IikXcEW
        ed7+GrpMIgENIbuWLerIw0N31rtlqYA=
X-Google-Smtp-Source: ABdhPJyCztZjwm+aKSJFyiK5PUpWL3iW4VLmzYEuQpRykV0srOQFpiyqS7SZUSkNOJGCYffG9u3WlqiIIvQ=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:46ed:9c47:8229:475d])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:10cf:b0:4a3:124d:bb81 with SMTP id
 d15-20020a056a0010cf00b004a3124dbb81mr2324774pfu.75.1638920001450; Tue, 07
 Dec 2021 15:33:21 -0800 (PST)
Date:   Tue,  7 Dec 2021 15:33:06 -0800
In-Reply-To: <20211207233306.2200118-1-pgonda@google.com>
Message-Id: <20211207233306.2200118-6-pgonda@google.com>
Mime-Version: 1.0
References: <20211207233306.2200118-1-pgonda@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH V6 5/5] crypto: ccp - Add SEV_INIT_EX support
From:   Peter Gonda <pgonda@google.com>
To:     thomas.lendacky@amd.com
Cc:     David Rientjes <rientjes@google.com>,
        Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        kernel test robot <lkp@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
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
if the PSP has not been initialized it is at run time. If the file at
'init_ex_path' does not exist the PSP will not be initialized. The user
must create the file prior to use with 32Kb of 0xFFs per spec.

Signed-off-by: David Rientjes <rientjes@google.com>
Co-developed-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../virt/kvm/amd-memory-encryption.rst        |   6 +
 drivers/crypto/ccp/sev-dev.c                  | 193 ++++++++++++++++--
 include/linux/psp-sev.h                       |  21 ++
 3 files changed, 205 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 5c081c8c7164..1c6847fff304 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -85,6 +85,12 @@ guests, such as launching, running, snapshotting, migrating and decommissioning.
 The KVM_SEV_INIT command is used by the hypervisor to initialize the SEV platform
 context. In a typical workflow, this command should be the first command issued.
 
+The firmware can be initialized either by using its own non-volatile storage or
+the OS can manage the NV storage for the firmware using the module parameter
+``init_ex_path``. The file specified by ``init_ex_path`` must exist. To create
+a new NV storage file allocate the file with 32KB bytes of 0xFF as required by
+the SEV spec.
+
 Returns: 0 on success, -negative on error
 
 2. KVM_SEV_LAUNCH_START
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 686b16e69de7..991cc5aaaa0f 100644
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
+module_param(init_ex_path, charp, 0444);
+MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try INIT_EX");
+
 static bool psp_init_on_probe = true;
 module_param(psp_init_on_probe, bool, 0444);
 MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
@@ -62,6 +67,14 @@ static int psp_timeout;
 #define SEV_ES_TMR_SIZE		(1024 * 1024)
 static void *sev_es_tmr;
 
+/* INIT_EX NV Storage:
+ *   The NV Storage is a 32Kb area and must be 4Kb page aligned.  Use the page
+ *   allocator to allocate the memory, which will return aligned memory for the
+ *   specified allocation order.
+ */
+#define NV_LENGTH (32 * 1024)
+static void *sev_init_ex_buffer;
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -111,6 +124,7 @@ static int sev_cmd_buffer_len(int cmd)
 {
 	switch (cmd) {
 	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
+	case SEV_CMD_INIT_EX:                   return sizeof(struct sev_data_init_ex);
 	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_user_data_status);
 	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
 	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_import);
@@ -156,6 +170,101 @@ static void *sev_fw_alloc(unsigned long len)
 	return page_address(page);
 }
 
+static int sev_read_init_ex_file(void)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct file *fp;
+	ssize_t nread;
+
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	if (!sev_init_ex_buffer)
+		return -EOPNOTSUPP;
+
+	fp = filp_open(init_ex_path, O_RDONLY, 0);
+	if (IS_ERR(fp)) {
+		int ret = PTR_ERR(fp);
+
+		dev_err(sev->dev,
+			"SEV: could not open %s for read, error %d\n",
+			init_ex_path, ret);
+		return ret;
+	}
+
+	nread = kernel_read(fp, sev_init_ex_buffer, NV_LENGTH, NULL);
+	if (nread != NV_LENGTH) {
+		dev_err(sev->dev,
+			"SEV: failed to read %u bytes to non volatile memory area, ret %ld\n",
+			NV_LENGTH, nread);
+		return -EIO;
+	}
+
+	dev_dbg(sev->dev, "SEV: read %ld bytes from NV file\n", nread);
+	filp_close(fp, NULL);
+
+	return 0;
+}
+
+static void sev_write_init_ex_file(void)
+{
+	struct sev_device *sev = psp_master->sev_data;
+	struct file *fp;
+	loff_t offset = 0;
+	ssize_t nwrite;
+
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	if (!sev_init_ex_buffer)
+		return;
+
+	fp = filp_open(init_ex_path, O_CREAT | O_WRONLY, 0600);
+	if (IS_ERR(fp)) {
+		dev_err(sev->dev,
+			"SEV: could not open file for write, error %ld\n",
+			PTR_ERR(fp));
+		return;
+	}
+
+	nwrite = kernel_write(fp, sev_init_ex_buffer, NV_LENGTH, &offset);
+	vfs_fsync(fp, 0);
+	filp_close(fp, NULL);
+
+	if (nwrite != NV_LENGTH) {
+		dev_err(sev->dev,
+			"SEV: failed to write %u bytes to non volatile memory area, ret %ld\n",
+			NV_LENGTH, nwrite);
+		return;
+	}
+
+	dev_dbg(sev->dev, "SEV: write successful to NV file\n");
+}
+
+static void sev_write_init_ex_file_if_required(int cmd_id)
+{
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	if (!sev_init_ex_buffer)
+		return;
+
+	/*
+	 * Only a few platform commands modify the SPI/NV area, but none of the
+	 * non-platform commands do. Only INIT(_EX), PLATFORM_RESET, PEK_GEN,
+	 * PEK_CERT_IMPORT, and PDH_GEN do.
+	 */
+	switch (cmd_id) {
+	case SEV_CMD_FACTORY_RESET:
+	case SEV_CMD_INIT_EX:
+	case SEV_CMD_PDH_GEN:
+	case SEV_CMD_PEK_CERT_IMPORT:
+	case SEV_CMD_PEK_GEN:
+		break;
+	default:
+		return;
+	};
+
+	sev_write_init_ex_file();
+}
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp = psp_master;
@@ -225,6 +334,8 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 		dev_dbg(sev->dev, "sev command %#x failed (%#010x)\n",
 			cmd, reg & PSP_CMDRESP_ERR_MASK);
 		ret = -EIO;
+	} else {
+		sev_write_init_ex_file_if_required(cmd);
 	}
 
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
@@ -251,37 +362,71 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 	return rc;
 }
 
-static int __sev_platform_init_locked(int *error)
+static int __sev_init_locked(int *error)
 {
-	struct psp_device *psp = psp_master;
 	struct sev_data_init data;
-	struct sev_device *sev;
-	int psp_ret, rc = 0;
 
-	if (!psp || !psp->sev_data)
-		return -ENODEV;
+	memset(&data, 0, sizeof(data));
+	if (sev_es_tmr) {
+		/*
+		 * Do not include the encryption mask on the physical
+		 * address of the TMR (firmware should clear it anyway).
+		 */
+		data.tmr_address = __pa(sev_es_tmr);
 
-	sev = psp->sev_data;
+		data.flags |= SEV_INIT_FLAGS_SEV_ES;
+		data.tmr_len = SEV_ES_TMR_SIZE;
+	}
 
-	if (sev->state == SEV_STATE_INIT)
-		return 0;
+	return __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+}
+
+static int __sev_init_ex_locked(int *error)
+{
+	struct sev_data_init_ex data;
+	int ret;
 
 	memset(&data, 0, sizeof(data));
-	if (sev_es_tmr) {
-		u64 tmr_pa;
+	data.length = sizeof(data);
+	data.nv_address = __psp_pa(sev_init_ex_buffer);
+	data.nv_len = NV_LENGTH;
+
+	ret = sev_read_init_ex_file();
+	if (ret)
+		return ret;
 
+	if (sev_es_tmr) {
 		/*
 		 * Do not include the encryption mask on the physical
 		 * address of the TMR (firmware should clear it anyway).
 		 */
-		tmr_pa = __pa(sev_es_tmr);
+		data.tmr_address = __pa(sev_es_tmr);
 
 		data.flags |= SEV_INIT_FLAGS_SEV_ES;
-		data.tmr_address = tmr_pa;
 		data.tmr_len = SEV_ES_TMR_SIZE;
 	}
 
-	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, &psp_ret);
+	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
+}
+
+static int __sev_platform_init_locked(int *error)
+{
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
+	int rc, psp_ret;
+	int (*init_function)(int *error);
+
+	if (!psp || !psp->sev_data)
+		return -ENODEV;
+
+	sev = psp->sev_data;
+
+	if (sev->state == SEV_STATE_INIT)
+		return 0;
+
+	init_function = sev_init_ex_buffer ? __sev_init_ex_locked :
+			__sev_init_locked;
+	rc = init_function(&psp_ret);
 	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
 		/*
 		 * Initialization command returned an integrity check failure
@@ -291,7 +436,7 @@ static int __sev_platform_init_locked(int *error)
 		 * with a reset state.
 		 */
 		dev_dbg(sev->dev, "SEV: retrying INIT command");
-		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, &psp_ret);
+		rc = init_function(&psp_ret);
 	}
 	if (error)
 		*error = psp_ret;
@@ -1066,6 +1211,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 			   get_order(SEV_ES_TMR_SIZE));
 		sev_es_tmr = NULL;
 	}
+
+	if (sev_init_ex_buffer) {
+		free_pages((unsigned long)sev_init_ex_buffer,
+			   get_order(NV_LENGTH));
+		sev_init_ex_buffer = NULL;
+	}
 }
 
 void sev_dev_destroy(struct psp_device *psp)
@@ -1110,6 +1261,18 @@ void sev_pci_init(void)
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
 
+	/* If an init_ex_path is provided rely on INIT_EX for PSP initialization
+	 * instead of INIT.
+	 */
+	if (init_ex_path) {
+		sev_init_ex_buffer = sev_fw_alloc(NV_LENGTH);
+		if (!sev_init_ex_buffer) {
+			dev_err(sev->dev,
+				"SEV: INIT_EX NV memory allocation failed\n");
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
2.34.1.400.ga245620fadb-goog

