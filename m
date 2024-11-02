Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9671BF58
	for <linux-crypto@vger.kernel.org>; Sat,  2 Nov 2024 00:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730506118; cv=none; b=RPw7hmN6KzdghDl8Vb3VuK1MYjTRwnyjg+/Yy774ObfT+uVP+OQse8Bzav7vPx9/ZFBhICdbVgXdtcWmgbuC4yXHODB+Ag9zjMLsZw1vuuf9ctLZulokZpE7aHvJr5bty8TSIucJPpvXYu9YzIi2gOlzfRNmFCPNmvFDyIX/CI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730506118; c=relaxed/simple;
	bh=n1fLU65LsY4cG54gUhI0pTlTY7OQFXC7ZwZ9Y8HeUTw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UtnowuQU1ccO6+Zp708ioosnX/P3f/9AWiP9VcA1z8UFreffo8IlqBbv8oosyqQbQCcAXAfQDrfo7hQSy6Z1YBPYEfWz/kQvMPZ9xkZ2YlzWY8/N0PijXH6JE1Cl8nPWJVVnEzSbOQ6zA7ojZoesqen++U+ufE5eUhJtfWjAo08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uQCZWYdr; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uQCZWYdr"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e7858820eso3037196b3a.2
        for <linux-crypto@vger.kernel.org>; Fri, 01 Nov 2024 17:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730506115; x=1731110915; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2cAg2TIOmztZf4rIzo3Ks8a5SntMRhj56qb5+KV7CAo=;
        b=uQCZWYdrQ8nD9KVLCH0dm1oaXdMAw8n9aU2/P0VNmuFmb8p4aLmSFLIa+7beR1GsYI
         6GjU5A46LnZTR6Aacooey+YxnkuCbiqnKTWA6I+RIpzXflwoevhbF9XpZZ1ytz8vNtsG
         cMkcmCjOgbjPclE2StgTKce9LYIwxlihXg5hX0gfrbTf9mHeXNZOnb1w/0BOH8p6vuxa
         KvTlBmUv1UJDUotZjHohSq7ZJtawQHvC+pwT80BeX0x4NWQW8Q9je3e23xivbiS6Fbg0
         1xnqlbYk2bd/8S7fMluYp+a535A3qILs/2YiaJKkWqqOItOvuPl2ekx2E/39XHH3K2t2
         EEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730506115; x=1731110915;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2cAg2TIOmztZf4rIzo3Ks8a5SntMRhj56qb5+KV7CAo=;
        b=EuXACzoHu+cIS2xvZkiXAocNl7LvPKqyI97Is6Kkbi6jF5O+7c7ogBqc71fIhS4uYA
         JwEsCYTTbtnZroadfuZmxPSg8EnBR5Q8+y3Bhf7fMm1DRoi80p4pCEXKKfJgeRMdsx8E
         6kcFBIaJnv9DB/2tnbOXv9tElKbD8ey4dJGovt3KoztGBKrLS5vsckSvdTsSCfdBwOSM
         7w6DKbU6dOtLMLQsqlywF+4G4Zgu0WX8adN/1bDwMi47sIP06E1wczqDxw3PVuMfZJOY
         UgL/9DloB05dBewEs7CQLS8Dt20gNt7nMZJNx2nQAGzl/CkCBlromfQkDl1ji/Y0OL9A
         V6Bw==
X-Forwarded-Encrypted: i=1; AJvYcCWJ6YyWqYdJZ9cth0IYjQC5tq2v5s26RTiakmDy9XoKpvTdTx9Lo8rDKMuaWJoUp6K8TNzV0vXWvUO2bA4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yym7TzM7qhXf+81WUm3yRJS4v3IuYcqxnIaG8eNr8nXHvVU/Z80
	6CHXTyoW0FN34/BpNy1MktdXHuCK5NNkKStIv2pHolTI2Zx9ktkFgt//BLaDTkSr7mz1hK7D0Lf
	MWKah6C6SbQ26RG4n4ijHqw==
X-Google-Smtp-Source: AGHT+IGGQXmNHqS7TEy/27UvAT2AmC2OoEFgcpQ2zQzRiqM3LYhS4oJoa1GZzgf6sE26RnPq4c3JUYwQBUuINR8YoQ==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:aa7:9e92:0:b0:71e:4dce:75bf with SMTP
 id d2e1a72fcca58-720b9dc33camr26805b3a.3.1730506115129; Fri, 01 Nov 2024
 17:08:35 -0700 (PDT)
Date: Sat,  2 Nov 2024 00:08:13 +0000
In-Reply-To: <20241102000818.2512612-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241102000818.2512612-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241102000818.2512612-4-dionnaglaze@google.com>
Subject: [PATCH v3 3/4] crypto: ccp: Add SNP firmware hotload support
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Ashish Kalra <ashish.kalra@amd.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

uapi changes: The status values added are defined in AMD's SEV-SNP API
documentation as new error modes for the DOWNLOAD_FIRMWARE_EX command.

On init, the ccp device will make /sys/class/firmware/amd/loading etc
firmware upload API attributes available to late-load a SEV-SNP firmware
binary.

The firmware upload api errors reported are actionable in the following
ways:
* FW_UPLOAD_ERR_HW_ERROR: the machine is in an unstable state and must
  be reset.
* FW_UPLOAD_ERR_RW_ERROR: the firmware update went bad but can be
  recovered by hotloading the previous firmware version.
  Also used in the case that the kernel used the API wrong (bug).
* FW_UPLOAD_ERR_FW_INVALID: user error with the data provided, but no
  instability is expected and no recovery actions are needed.
* FW_UPLOAD_ERR_BUSY: upload attempted at a bad time either due to
  overload or the machine is in the wrong platform state.

snp_asid_to_gctx_page_map:
Compliance with SEV-SNP API section 3.3 Firmware Updates and 4.1.1
Live Update: before a firmware is committed, all active GCTX pages
should be updated with SNP_GUEST_STATUS to ensure their data structure
remains consistent for the new firmware version.
There can only be cpuid_edx(0x8000001f)-1 many SEV-SNP asids in use at
one time, so this map associates asid to gctx in order to track which
addresses are active gctx pages that need updating. When an asid and
gctx page are decommissioned, the page is removed from tracking for
update-purposes.
Given that GCTX page creation and binding through the SNP_ACTIVATE
command are separate, the creation operation also tracks pages that are
yet to be bound to an asid.

synthetic_restore_required:
Instead of tracking the status of whether an individual GCTX is safe for
use in a firmware command, force all following commands to fail with an
error that is indicative of needing a firmware rollback.

According to SEV-SNP API section 3.3 Firmware Updates, the
DOWNLOAD_FIRMWARE_EX command is usable when the SNP firmware is in
either UNINIT or INIT states, but SEV-legacy firmware must be in the
UNINIT state. A sev_platform_init call when only SEV-SNP VMs are
expected should set supports_download_firmware_ex to delay legacy
initialization actions.
The firmware can only be hotloaded for SEV VMs when legacy
initialization has not happened.

To test:
1. Build the kernel enabling SEV-SNP as normal and add CONFIG_FW_UPLOAD=y.
2. Add the following to your kernel_cmdline: ccp.psp_init_on_probe=0.
3.Get an AMD SEV-SNP firmware sbin appropriate to your Epyc chip model at
https://www.amd.com/en/developer/sev.html and extract to get a .sbin
file.
4. Run the following with your sbinfile in FW:

echo 1 > /sys/class/firmware/snp_dlfw_ex/loading
cat "${FW?}" > /sys/class/firmware/snp_dlfw_ex/data
echo 0 > /sys/class/firmware/snp_dlfw_ex/loading

5. Verify the firmware update message in dmesg.

CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Ashish Kalra <ashish.kalra@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: John Allen <john.allen@amd.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Michael Roth <michael.roth@amd.com>
CC: Luis Chamberlain <mcgrof@kernel.org>
CC: Russ Weight <russ.weight@linux.dev>
CC: Danilo Krummrich <dakr@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Rafael J. Wysocki" <rafael@kernel.org>
CC: Tianfei zhang <tianfei.zhang@intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 drivers/crypto/ccp/Kconfig   |   2 +
 drivers/crypto/ccp/sev-dev.c | 399 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |  14 ++
 include/linux/psp-sev.h      |  29 +++
 include/uapi/linux/psp-sev.h |   5 +
 5 files changed, 441 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index f394e45e11ab4..cd9b667640e7c 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -39,6 +39,8 @@ config CRYPTO_DEV_SP_PSP
 	bool "Platform Security Processor (PSP) device"
 	default y
 	depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
+	select FW_LOADER
+        select FW_UPLOAD
 	help
 	 Provide support for the AMD Platform Security Processor (PSP).
 	 The PSP is a dedicated processor that provides support for key
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9810edbb272d2..1da183e8a9ebc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
+	case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:	return sizeof(struct sev_data_download_firmware_ex);
 	default:				return 0;
 	}
 
@@ -829,6 +830,7 @@ static int snp_reclaim_cmd_buf(int cmd, void *cmd_buf)
 	return 0;
 }
 
+static void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data);
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct cmd_buf_desc desc_list[CMD_BUF_DESC_MAX] = {0};
@@ -852,6 +854,15 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	if (WARN_ON_ONCE(!data != !buf_len))
 		return -EINVAL;
 
+	/* The firmware does not coordinate all GCTX page updates. Force an
+	 * error to ensure that no new VM can be started and no active VM makes
+	 * progress on guest requests until the firmware is rolled back.
+	 */
+	if (sev->synthetic_restore_required) {
+		*psp_ret = SEV_RET_RESTORE_REQUIRED;
+		return -EBUSY;
+	}
+
 	/*
 	 * Copy the incoming data to driver's scratch buffer as __pa() will not
 	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
@@ -982,6 +993,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
 			     buf_len, false);
 
+	if (!ret)
+		snp_cmd_bookkeeping_locked(cmd, sev, data);
+
 	return ret;
 }
 
@@ -1082,6 +1096,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
+static int sev_snp_platform_init_firmware_upload(struct sev_device *sev);
 static int __sev_snp_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
@@ -1179,6 +1194,8 @@ static int __sev_snp_init_locked(int *error)
 
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
+	rc = sev_snp_platform_init_firmware_upload(sev);
+
 	return rc;
 }
 
@@ -1326,6 +1343,13 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (args->probe && !psp_init_on_probe)
 		return 0;
 
+	/*
+	 * Defer legacy SEV/SEV-ES support if legacy VMs are not being launched
+	 * and module psp_init_on_probe parameter is false.
+	 */
+	if (args->supports_download_firmware_ex && !psp_init_on_probe)
+		return 0;
+
 	return __sev_platform_init_locked(&args->error);
 }
 
@@ -1592,14 +1616,8 @@ static int sev_update_firmware(struct device *dev)
 		return -1;
 	}
 
-	/*
-	 * SEV FW expects the physical address given to it to be 32
-	 * byte aligned. Memory allocated has structure placed at the
-	 * beginning followed by the firmware being passed to the SEV
-	 * FW. Allocate enough memory for data structure + alignment
-	 * padding + SEV FW.
-	 */
-	data_size = ALIGN(sizeof(struct sev_data_download_firmware), 32);
+	data_size = ALIGN(sizeof(struct sev_data_download_firmware),
+			  SEV_FW_ALIGNMENT);
 
 	order = get_order(firmware->size + data_size);
 	p = alloc_pages(GFP_KERNEL, order);
@@ -2224,6 +2242,367 @@ static int sev_misc_init(struct sev_device *sev)
 	return 0;
 }
 
+#ifdef CONFIG_FW_UPLOAD
+
+static enum fw_upload_err snp_dlfw_ex_prepare(struct fw_upload *fw_upload,
+					      const u8 *data, u32 size)
+{
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static enum fw_upload_err snp_dlfw_ex_poll_complete(struct fw_upload *fw_upload)
+{
+	return FW_UPLOAD_ERR_NONE;
+}
+
+/*
+ * This may be called asynchronously with an on-going update.  All other
+ * functions are called sequentially in a single thread. To avoid contention on
+ * register accesses, only update the cancel_request flag. Other functions will
+ * check this flag and handle the cancel request synchronously.
+ */
+static void snp_dlfw_ex_cancel(struct fw_upload *fw_upload)
+{
+	struct sev_device *sev = psp_master->sev_data;
+
+	mutex_lock(&sev->fw_lock);
+	sev->fw_cancel = true;
+	mutex_unlock(&sev->fw_lock);
+}
+
+static enum fw_upload_err snp_dlfw_ex_err_translate(struct sev_device *sev, int psp_ret)
+{
+	dev_dbg(sev->dev, "Failed to update SEV firmware: %#x\n", psp_ret);
+	/*
+	 * Operation error:
+	 *   HW_ERROR: Critical error. Machine needs repairs now.
+	 *   RW_ERROR: Severe error. Roll back to the prior version to recover.
+	 * User error:
+	 *   FW_INVALID: Bad input for this interface.
+	 *   BUSY: Wrong machine state to run download_firmware_ex.
+	 */
+	switch (psp_ret) {
+	case SEV_RET_RESTORE_REQUIRED:
+		dev_warn(sev->dev, "Firmware updated but unusable\n");
+		dev_warn(sev->dev, "Need to do manual firmware rollback!!!\n");
+		return FW_UPLOAD_ERR_RW_ERROR;
+	case SEV_RET_SHUTDOWN_REQUIRED:
+		/* No state changes made. Not a hardware error. */
+		dev_warn(sev->dev, "Firmware image cannot be live updated\n");
+		return FW_UPLOAD_ERR_FW_INVALID;
+	case SEV_RET_BAD_VERSION:
+		/* No state changes made. Not a hardware error. */
+		dev_warn(sev->dev, "Firmware image is not well formed\n");
+		return FW_UPLOAD_ERR_FW_INVALID;
+		/* SEV-specific errors that can still happen. */
+	case SEV_RET_BAD_SIGNATURE:
+		/* No state changes made. Not a hardware error. */
+		dev_warn(sev->dev, "Firmware image signature is bad\n");
+		return FW_UPLOAD_ERR_FW_INVALID;
+	case SEV_RET_INVALID_PLATFORM_STATE:
+		/* Calling at the wrong time. Not a hardware error. */
+		dev_warn(sev->dev, "Firmware not updated as SEV in INIT state\n");
+		return FW_UPLOAD_ERR_BUSY;
+	case SEV_RET_HWSEV_RET_UNSAFE:
+		dev_err(sev->dev, "Firmware is unstable. Reset your machine!!!\n");
+		return FW_UPLOAD_ERR_HW_ERROR;
+		/* Kernel bug cases. */
+	case SEV_RET_INVALID_PARAM:
+		dev_err(sev->dev, "Download-firmware-EX invalid parameter\n");
+		return FW_UPLOAD_ERR_RW_ERROR;
+	case SEV_RET_INVALID_ADDRESS:
+		dev_err(sev->dev, "Download-firmware-EX invalid address\n");
+		return FW_UPLOAD_ERR_RW_ERROR;
+	default:
+		dev_err(sev->dev, "Unhandled download_firmware_ex err %d\n", psp_ret);
+		return FW_UPLOAD_ERR_HW_ERROR;
+	}
+}
+
+static enum fw_upload_err snp_dlfw_ex_write(struct fw_upload *fwl, const u8 *data,
+					    u32 offset, u32 size, u32 *written)
+{
+	struct sev_data_download_firmware_ex *data_ex;
+	struct sev_data_snp_guest_status status_data;
+	struct sev_device *sev = fwl->dd_handle;
+	void *snp_guest_status, *fw_dest;
+	u8 api_major, api_minor, build;
+	int ret, error, order;
+	struct page *p;
+	u64 data_size;
+	bool cancel;
+
+	if (!sev)
+		return FW_UPLOAD_ERR_HW_ERROR;
+
+	mutex_lock(&sev->fw_lock);
+	cancel = sev->fw_cancel;
+	mutex_unlock(&sev->fw_lock);
+
+	if (cancel)
+		return FW_UPLOAD_ERR_CANCELED;
+
+	/*
+	 * SEV firmware update is a one-shot update operation, the write()
+	 * callback to be invoked multiple times for the same update is
+	 * unexpected.
+	 */
+	if (offset)
+		return FW_UPLOAD_ERR_INVALID_SIZE;
+
+	if (sev_get_api_version())
+		return FW_UPLOAD_ERR_HW_ERROR;
+
+	api_major = sev->api_major;
+	api_minor = sev->api_minor;
+	build     = sev->build;
+
+	data_size = ALIGN(sizeof(struct sev_data_download_firmware_ex),
+			  SEV_FW_ALIGNMENT);
+
+	order = get_order(size + data_size);
+	p = alloc_pages(GFP_KERNEL, order);
+	if (!p) {
+		ret = FW_UPLOAD_ERR_INVALID_SIZE;
+		goto fw_err;
+	}
+
+	/*
+	 * Copy firmware data to a kernel allocated contiguous
+	 * memory region.
+	 */
+	data_ex = page_address(p);
+	fw_dest = page_address(p) + data_size;
+	memset(data_ex, 0, data_size);
+	memcpy(fw_dest, data, size);
+
+	data_ex->address = __psp_pa(fw_dest);
+	data_ex->len = size;
+	data_ex->cmdlen = sizeof(struct sev_data_download_firmware_ex);
+
+	/*
+	 * SNP_COMMIT should be issued explicitly to commit the updated
+	 * firmware after guest context pages have been updated.
+	 */
+
+	ret = sev_do_cmd(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, data_ex, &error);
+
+	if (ret) {
+		ret = snp_dlfw_ex_err_translate(sev, error);
+		goto free_err;
+	}
+
+	__free_pages(p, order);
+
+	/* Need to do a DF_FLUSH after live firmware update */
+	wbinvd_on_all_cpus();
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
+	if (ret) {
+		dev_dbg(sev->dev, "DF_FLUSH error %d\n", error);
+		ret = FW_UPLOAD_ERR_HW_ERROR;
+		goto fw_err;
+	}
+
+	sev_get_api_version();
+
+	/*
+	 * Force an update of guest context pages after SEV firmware
+	 * live update by issuing SNP_GUEST_STATUS on all guest
+	 * context pages.
+	 */
+	snp_guest_status = sev_fw_alloc(PAGE_SIZE);
+	if (!snp_guest_status) {
+		ret = FW_UPLOAD_ERR_INVALID_SIZE;
+		goto fw_err;
+	}
+
+	/*
+	 * After the last bound asid-to-gctx page is snp_unbound_gctx_end-many
+	 * unbound gctx pages that also need updating.
+	 */
+	for (int i = 1; i <= sev->last_snp_asid + sev->snp_unbound_gctx_end; i++) {
+		if (sev->snp_asid_to_gctx_pages_map[i]) {
+			status_data.gctx_paddr = sev->snp_asid_to_gctx_pages_map[i];
+			status_data.address = __psp_pa(snp_guest_status);
+			ret = sev_do_cmd(SEV_CMD_SNP_GUEST_STATUS, &status_data, &error);
+			if (ret) {
+				/*
+				 * Handle race with SNP VM being destroyed/decommissoned,
+				 * if guest context page invalid error is returned,
+				 * assume guest has been destroyed.
+				 */
+				if (error == SEV_RET_INVALID_GUEST)
+					continue;
+				sev->synthetic_restore_required = true;
+				dev_err(sev->dev, "SNP GCTX update error: %#x\n", error);
+				dev_err(sev->dev, "Roll back SNP firmware!\n");
+				snp_free_firmware_page(snp_guest_status);
+				ret = FW_UPLOAD_ERR_RW_ERROR;
+				goto fw_err;
+			}
+		}
+	}
+	snp_free_firmware_page(snp_guest_status);
+
+	if (api_major != sev->api_major || api_minor != sev->api_minor ||
+	    build != sev->build) {
+		dev_info(sev->dev, "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
+			 api_major, api_minor, build,
+			 sev->api_major, sev->api_minor, sev->build);
+	} else {
+		dev_info(sev->dev, "SEV firmware same as old %d.%d.%d\n",
+			 api_major, api_minor, build);
+	}
+
+	*written = size;
+	return FW_UPLOAD_ERR_NONE;
+
+free_err:
+	__free_pages(p, order);
+fw_err:
+	return ret;
+}
+
+static const struct fw_upload_ops snp_dlfw_ex_ops = {
+	.prepare = snp_dlfw_ex_prepare,
+	.write = snp_dlfw_ex_write,
+	.poll_complete = snp_dlfw_ex_poll_complete,
+	.cancel = snp_dlfw_ex_cancel,
+};
+
+static void sev_snp_dev_init_firmware_upload(struct sev_device *sev)
+{
+	struct fw_upload *fwl;
+
+	fwl = firmware_upload_register(THIS_MODULE, sev->dev, "snp_dlfw_ex", &snp_dlfw_ex_ops, sev);
+
+	if (IS_ERR(fwl))
+		dev_err(sev->dev, "SEV firmware upload initialization error %ld\n", PTR_ERR(fwl));
+
+	sev->fwl = fwl;
+	mutex_init(&sev->fw_lock);
+}
+
+static void sev_snp_destroy_firmware_upload(struct sev_device *sev)
+{
+	firmware_upload_unregister(sev->fwl);
+}
+
+/*
+ * After a gctx is created, it is used by snp_launch_start before getting
+ * bound to an asid. The launch protocol allocates an asid before creating a
+ * matching gctx page, so there should never be more unbound gctx pages than
+ * there are possible SNP asids.
+ *
+ * The unbound gctx pages must be updated after executing DOWNLOAD_FIRMWARE_EX
+ * and before committing the firmware.
+ */
+static void snp_gctx_create_track_locked(struct sev_device *sev, void *data)
+{
+	struct sev_data_snp_addr *gctx_create = data;
+
+	/* This condition should never happen, but is needed for memory safety. */
+	if (sev->snp_unbound_gctx_end >= sev->last_snp_asid) {
+		dev_warn(sev->dev, "Too many unbound SNP GCTX pages to track\n");
+		return;
+	}
+
+	sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end] = gctx_create->address;
+	sev->snp_unbound_gctx_end++;
+}
+
+/*
+ * PREREQUISITE: The snp_activate command was successful, meaning the asid
+ * is in the acceptable range 1..sev->last_snp_asid.
+ *
+ * The gctx_paddr must be in the unbound gctx buffer.
+ */
+static void snp_activate_track_locked(struct sev_device *sev, void *data)
+{
+	struct sev_data_snp_activate *data_activate = data;
+
+	sev->snp_asid_to_gctx_pages_map[data_activate->asid] = data_activate->gctx_paddr;
+
+	for (int i = 0; i < sev->snp_unbound_gctx_end; i++) {
+		if (sev->snp_unbound_gctx_pages[i] == data_activate->gctx_paddr) {
+			/*
+			 * Swap the last unbound gctx page with the now-bound
+			 * gctx page to shrink the buffer.
+			 */
+			sev->snp_unbound_gctx_end--;
+			sev->snp_unbound_gctx_pages[i] =
+				sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end];
+			sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end] = 0;
+			break;
+		}
+	}
+}
+
+static void snp_decommission_track_locked(struct sev_device *sev, void *data)
+{
+	struct sev_data_snp_addr *data_decommission = data;
+
+	for (int i = 1; i <= sev->last_snp_asid; i++) {
+		if (sev->snp_asid_to_gctx_pages_map[i] == data_decommission->address) {
+			sev->snp_asid_to_gctx_pages_map[i] = 0;
+			break;
+		}
+	}
+}
+
+static void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data)
+{
+	if (!sev->snp_asid_to_gctx_pages_map)
+		return;
+
+	switch (cmd) {
+	case SEV_CMD_SNP_GCTX_CREATE:
+		snp_gctx_create_track_locked(sev, data);
+		break;
+	case SEV_CMD_SNP_ACTIVATE:
+		snp_activate_track_locked(sev, data);
+		break;
+	case SEV_CMD_SNP_DECOMMISSION:
+		snp_decommission_track_locked(sev, data);
+		break;
+	default:
+		break;
+	}
+}
+
+static int sev_snp_platform_init_firmware_upload(struct sev_device *sev)
+{
+	u32 max_snp_asid;
+
+	/*
+	 * cpuid_edx(0x8000001f) is the minimum SEV ASID, hence the exclusive
+	 * maximum SEV-SNP ASID. Save the inclusive maximum to avoid confusing
+	 * logic elsewhere.
+	 */
+	max_snp_asid = cpuid_edx(0x8000001f);
+	sev->last_snp_asid = max_snp_asid - 1;
+	if (sev->last_snp_asid) {
+		sev->snp_asid_to_gctx_pages_map = devm_kmalloc_array(
+			sev->dev, max_snp_asid * 2, sizeof(u64), GFP_KERNEL | __GFP_ZERO);
+		sev->snp_unbound_gctx_pages = &sev->snp_asid_to_gctx_pages_map[max_snp_asid];
+		if (!sev->snp_asid_to_gctx_pages_map) {
+			kfree(snp_range_list);
+			dev_err(sev->dev,
+				"SEV-SNP: snp_asid_to_gctx_pages_map memory allocation failed\n");
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+#else
+
+static int sev_snp_platform_init_firmware_upload(struct sev_device *sev) { return 0; }
+static void sev_snp_dev_init_firmware_upload(struct sev_device *sev) { }
+static void sev_snp_destroy_firmware_upload(struct sev_device *sev) { }
+static void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data) { }
+#endif
+
 int sev_dev_init(struct psp_device *psp)
 {
 	struct device *dev = psp->dev;
@@ -2265,6 +2644,8 @@ int sev_dev_init(struct psp_device *psp)
 	if (ret)
 		goto e_irq;
 
+	sev_snp_dev_init_firmware_upload(sev);
+
 	dev_notice(dev, "sev enabled\n");
 
 	return 0;
@@ -2343,6 +2724,8 @@ void sev_dev_destroy(struct psp_device *psp)
 		kref_put(&misc_dev->refcount, sev_exit);
 
 	psp_clear_sev_irq_handler(psp);
+
+	sev_snp_destroy_firmware_upload(sev);
 }
 
 static int snp_shutdown_on_panic(struct notifier_block *nb,
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a3..d6280688675d9 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -57,6 +57,20 @@ struct sev_device {
 	bool cmd_buf_backup_active;
 
 	bool snp_initialized;
+
+#ifdef CONFIG_FW_UPLOAD
+	/* Lock to protect fw_cancel */
+	struct mutex fw_lock;
+	struct fw_upload *fwl;
+	bool fw_cancel;
+
+	/* Firmware update management. */
+	u32 last_snp_asid;
+	bool synthetic_restore_required;
+	u64 *snp_asid_to_gctx_pages_map;
+	u64 *snp_unbound_gctx_pages;
+	u32 snp_unbound_gctx_end;
+#endif /* CONFIG_FW_UPLOAD */
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea85850..ff7f9e33f3335 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -16,6 +16,15 @@
 
 #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
 
+/*
+ * SEV FW expects the physical address given to it to be 32
+ * byte aligned. Memory allocated has structure placed at the
+ * beginning followed by the firmware being passed to the SEV
+ * FW. Allocate enough memory for data structure + alignment
+ * padding + SEV FW.
+ */
+#define SEV_FW_ALIGNMENT	32
+
 /**
  * SEV platform state
  */
@@ -185,6 +194,23 @@ struct sev_data_download_firmware {
 	u32 len;				/* In */
 } __packed;
 
+/**
+ * struct sev_data_download_firmware_ex - DOWNLOAD_FIRMWARE_EX command parameters
+ *
+ * @length: length of this command buffer
+ * @address: physical address of firmware image
+ * @len: len of the firmware image
+ * @commit: automatically commit the newly installed image
+ */
+struct sev_data_download_firmware_ex {
+	u32 cmdlen;				/* In */
+	u32 reserved;				/* in */
+	u64 address;				/* In */
+	u32 len;				/* In */
+	u32 commit:1;				/* In */
+	u32 reserved2:31;			/* In */
+} __packed;
+
 /**
  * struct sev_data_get_id - GET_ID command parameters
  *
@@ -797,10 +823,13 @@ struct sev_data_snp_shutdown_ex {
  * @probe: True if this is being called as part of CCP module probe, which
  *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
  *  unless psp_init_on_probe module param is set
+ * @supports_download_firmware_ex: True if legacy SEV/SEV-ES guests are not
+ *  being launched via KVM
  */
 struct sev_platform_init_args {
 	int error;
 	bool probe;
+	bool supports_download_firmware_ex;
 };
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 832c15d9155bd..936464d4f282a 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -80,6 +80,11 @@ typedef enum {
 	SEV_RET_INVALID_PAGE_OWNER,
 	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
 	SEV_RET_RMP_INIT_REQUIRED,
+	SEV_RET_BAD_SVN,
+	SEV_RET_BAD_VERSION,
+	SEV_RET_SHUTDOWN_REQUIRED,
+	SEV_RET_UPDATE_FAILED,
+	SEV_RET_RESTORE_REQUIRED,
 	SEV_RET_MAX,
 } sev_ret_code;
 
-- 
2.47.0.163.g1226f6d8fa-goog

