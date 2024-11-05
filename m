Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AE245C18
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 01:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730768786; cv=none; b=LKqWMeRXGmlLJKv34FiKwmDatinGYECRYWqia8JElObNSKby6raYGWShl6B+2QUCV74UEv3PJoYZzRjgeS7EZu0GMhBAz5AXWtIfXGENqowTtlX/aoSnFI7uyTuZJ0wNNdnBK1RhSJD6gALLPAPx/DtU9Zt8LDOLukHG1bSMVhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730768786; c=relaxed/simple;
	bh=/IzfL9CvW4m93cDhZ5O7Hz1vXcscHLpo5soYW7LYUBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XLldQ1WulR8e3OEayVgD7cwON1BctGMMETQmq6uio7yuG6GmvCpdydZ+FnHPNjqqE40GCV8eCwYnR2qs+V8N6cSk0eocLe9+GOJzc59SoPBZpx1fVo0EhycVL8TgQZR8MX5Je1DFD5O81UPN4vRNXs8cJ13KOjCG9/3/zB7Jshs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bcVxUFe2; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bcVxUFe2"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e5a7bd897so5613562b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 04 Nov 2024 17:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730768784; x=1731373584; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iizI1BGS8jbp1EGumTWgpgpNNFPF9nVUpu4CVNWm6HI=;
        b=bcVxUFe2HfLdEGOHqNYuY+oM9EiPtZSHZCdI4yhDHlqt7Ib3S2ggOJzbvvIc5qPxDe
         l5RifmJuO1p/Xxjrv84JGyvR8QMGhcuruPJIWduetULWLLmieMREZCh1N/qgu+z42K0W
         zhTWyQO3rhjgOQVCBbux9wRfS7MLWqLeWVh38HSz19bmdfE8rSxpGMTlZZf+dc5Z6kXb
         F9MJTiQoNjIA14WiGWcj0s48yZPjm1xjYLBkaPOlxUUMh9FCbsJFpUWex8Egwnbby54H
         VG6ydXQy8tPuSu17cW8lHlIPB9X7RaoqOWoCV5cGaDHT/SBJ6W+j+CszddL2ThfvtlC+
         FWrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730768784; x=1731373584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iizI1BGS8jbp1EGumTWgpgpNNFPF9nVUpu4CVNWm6HI=;
        b=JHwMVPjbenUqQ61t6jq6oEeHb7NF0fk1eWtYxK0andnYRphW7tHcO+beauDIVJ3wCi
         55Vx+xHmpko8f6GUeQlFFf8t2ZWyUK7+54/s8UdhUuReGygH/NhFRWeYwE/42M3qLqhl
         DeUvf4OCRcHZfyJpt37+tQOiLJmy7gkheP9BzLP+fiTJ6rjKQhNdFzlXynQp/iAlCOAZ
         +U9TBjl0Z7KrR0+/zxN0xOqNlJguwXyIlrg3mKSnbp1K7u+Bn7MgF9DkGUWTj6fRmnvu
         o4H/RARVc8RdALtAr2NjYp1lm0vICPl17Yb5gWAWD7+7/mYGcgzzCU/wJ4TTWP7siuvJ
         r+Zw==
X-Forwarded-Encrypted: i=1; AJvYcCXm2FgpirI2sBHa8bRu2cpN1R3k82LvWdwhD3BM4EwtifltPamFEoDAvLnoPtjR2fe4t/L+Nk6oMblAbWw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu/5bspSvTZmXoeAGeeVSiHRDlRMAWLFtK59hsnNieEKk+vHjS
	6Tqw+rXB+0QlystduepAq0gSC5h0e9kDXA8LR+9nQeWbq6J2yydXq1QjXMeJPrQh76gy8XXdrjH
	GtJWFhchveuE0r9dRKc7/nw==
X-Google-Smtp-Source: AGHT+IFY2IGtbWSAXPxiT/z81FLwvgT0S7GolQL51U68PSsc6CXYDnyycDaDfVb/TTWsrHfpiQKoTO7SLj2Dthj4+A==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a05:6a00:62c6:b0:720:b04d:8fcb with
 SMTP id d2e1a72fcca58-720b9b5c762mr34056b3a.1.1730768782716; Mon, 04 Nov 2024
 17:06:22 -0800 (PST)
Date: Tue,  5 Nov 2024 01:05:52 +0000
In-Reply-To: <20241105010558.1266699-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105010558.1266699-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105010558.1266699-6-dionnaglaze@google.com>
Subject: [PATCH v4 5/6] crypto: ccp: Use firmware_upload API for SNP firmware
From: Dionna Glaze <dionnaglaze@google.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Ashish Kalra <ashish.kalra@amd.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

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

synthetic_restore_required:
Instead of tracking the status of whether an individual GCTX is safe for
use in a firmware command, force all following commands to fail with an
error that is indicative of needing a firmware rollback.

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

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Tested-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 drivers/crypto/ccp/Kconfig   |   2 +
 drivers/crypto/ccp/sev-dev.c |  12 +-
 drivers/crypto/ccp/sev-dev.h |  16 +++
 drivers/crypto/ccp/sev-fw.c  | 213 +++++++++++++++++++++++++++++++++++
 4 files changed, 241 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index f394e45e11ab4..520b1c84d11f4 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -39,6 +39,8 @@ config CRYPTO_DEV_SP_PSP
 	bool "Platform Security Processor (PSP) device"
 	default y
 	depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
+	select FW_LOADER
+	select FW_UPLOAD
 	help
 	 Provide support for the AMD Platform Security Processor (PSP).
 	 The PSP is a dedicated processor that provides support for key
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 32f7b6147905e..8c73f023b6420 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -485,7 +485,7 @@ void snp_free_firmware_page(void *addr)
 }
 EXPORT_SYMBOL_GPL(snp_free_firmware_page);
 
-static void *sev_fw_alloc(unsigned long len)
+void *sev_fw_alloc(unsigned long len)
 {
 	struct page *page;
 
@@ -853,6 +853,10 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	if (WARN_ON_ONCE(!data != !buf_len))
 		return -EINVAL;
 
+	ret = sev_snp_synthetic_error(sev, psp_ret);
+	if (ret)
+		return ret;
+
 	/*
 	 * Copy the incoming data to driver's scratch buffer as __pa() will not
 	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
@@ -1523,7 +1527,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len)
 }
 EXPORT_SYMBOL_GPL(psp_copy_user_blob);
 
-static int sev_get_api_version(void)
+int sev_get_api_version(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_status status;
@@ -2320,6 +2324,8 @@ int sev_dev_init(struct psp_device *psp)
 	if (ret)
 		goto e_irq;
 
+	sev_snp_dev_init_firmware_upload(sev);
+
 	dev_notice(dev, "sev enabled\n");
 
 	return 0;
@@ -2398,6 +2404,8 @@ void sev_dev_destroy(struct psp_device *psp)
 		kref_put(&misc_dev->refcount, sev_exit);
 
 	psp_clear_sev_irq_handler(psp);
+
+	sev_snp_dev_init_firmware_upload(sev);
 }
 
 static int snp_shutdown_on_panic(struct notifier_block *nb,
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 28add34484ed1..52a423e7df84f 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -59,7 +59,13 @@ struct sev_device {
 	bool snp_initialized;
 
 #ifdef CONFIG_FW_UPLOAD
+	/* Lock to protect fw_cancel */
+	struct mutex fw_lock;
+	struct fw_upload *fwl;
+	bool fw_cancel;
+
 	u32 last_snp_asid;
+	bool synthetic_restore_required;
 	u64 *snp_asid_to_gctx_pages_map;
 	u64 *snp_unbound_gctx_pages;
 	u32 snp_unbound_gctx_end;
@@ -72,12 +78,22 @@ void sev_dev_destroy(struct psp_device *psp);
 void sev_pci_init(void);
 void sev_pci_exit(void);
 
+void *sev_fw_alloc(unsigned long len);
+int sev_get_api_version(void);
+int sev_snp_download_firmware_ex(struct sev_device *sev, const u8 *data, u32 size, int *error);
+
 #ifdef CONFIG_FW_UPLOAD
 void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data);
 int sev_snp_platform_init_firmware_upload(struct sev_device *sev);
+void sev_snp_dev_init_firmware_upload(struct sev_device *sev);
+void sev_snp_destroy_firmware_upload(struct sev_device *sev);
+int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret);
 #else
 static inline void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data) { }
 static inline int sev_snp_platform_init_firmware_upload(struct sev_device *sev) { return 0; }
+static inline void sev_snp_dev_init_firmware_upload(struct sev_device *sev) { }
+static inline void sev_snp_destroy_firmware_upload(struct sev_device *sev) { }
+static inline int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret) { return 0; }
 #endif /* CONFIG_FW_UPLOAD */
 
 #endif /* __SEV_DEV_H */
diff --git a/drivers/crypto/ccp/sev-fw.c b/drivers/crypto/ccp/sev-fw.c
index 55a5a572da8f1..97ce90f2af29a 100644
--- a/drivers/crypto/ccp/sev-fw.c
+++ b/drivers/crypto/ccp/sev-fw.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/firmware.h>
+#include <linux/psp.h>
 #include <linux/psp-sev.h>
 
 #include <asm/sev.h>
@@ -115,3 +116,215 @@ int sev_snp_platform_init_firmware_upload(struct sev_device *sev)
 	}
 	return 0;
 }
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
+	struct sev_device *sev = fw_upload->dd_handle;
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
+static enum fw_upload_err snp_update_guest_statuses(struct sev_device *sev)
+{
+	struct sev_data_snp_guest_status status_data;
+	void *snp_guest_status;
+	enum fw_upload_err ret;
+	int error;
+
+	/*
+	 * Force an update of guest context pages after SEV firmware
+	 * live update by issuing SNP_GUEST_STATUS on all guest
+	 * context pages.
+	 */
+	snp_guest_status = sev_fw_alloc(PAGE_SIZE);
+	if (!snp_guest_status)
+		return FW_UPLOAD_ERR_INVALID_SIZE;
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
+fw_err:
+	snp_free_firmware_page(snp_guest_status);
+	return ret;
+}
+
+static enum fw_upload_err snp_dlfw_ex_write(struct fw_upload *fwl, const u8 *data,
+					    u32 offset, u32 size, u32 *written)
+{
+	struct sev_device *sev = fwl->dd_handle;
+	u8 api_major, api_minor, build;
+	int ret, error;
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
+	ret = sev_snp_download_firmware_ex(sev, data, size, &error);
+	if (ret)
+		return snp_dlfw_ex_err_translate(sev, error);
+
+	ret = snp_update_guest_statuses(sev);
+	if (ret)
+		return ret;
+
+	sev_get_api_version();
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
+}
+
+static const struct fw_upload_ops snp_dlfw_ex_ops = {
+	.prepare = snp_dlfw_ex_prepare,
+	.write = snp_dlfw_ex_write,
+	.poll_complete = snp_dlfw_ex_poll_complete,
+	.cancel = snp_dlfw_ex_cancel,
+};
+
+void sev_snp_dev_init_firmware_upload(struct sev_device *sev)
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
+void sev_snp_destroy_firmware_upload(struct sev_device *sev)
+{
+	firmware_upload_unregister(sev->fwl);
+}
+
+int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret)
+{
+	if (sev->synthetic_restore_required) {
+		*psp_ret = SEV_RET_RESTORE_REQUIRED;
+		return -EIO;
+	}
+	return 0;
+}
-- 
2.47.0.199.ga7371fff76-goog

