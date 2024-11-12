Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2943B21D22B
	for <linux-crypto@vger.kernel.org>; Tue, 12 Nov 2024 23:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731453795; cv=none; b=KDECvnObyY0QecEywGBj8dHPAmXmgHSlbDnseFLLNauUq0mUTxlt02xW1zkDErx6X1O2Dds38le+hWXaW8/lI3+2sv2mOCxvDYWIflkdCxLZOHXX3RLdhBiiCN2Ug9VWWAH/PJhHMLrB7fTFJXnlbxozuRX+iX32SKRSMOp5qE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731453795; c=relaxed/simple;
	bh=ZYnveSnHe3FkDFRVZnrqkrTHNRmt3JMbLrbNeGvJt08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hnEO4NwiCXL0BI1PkWBeMPmDgTpKZs0k1Lkf/fHi4ILPNqAvUHiHdMnkpoZRbBtJM3vMsqHQSdqWDKbJd9mBjsZLa4AkASEvAQETfZ/W/JZ1/9FyfIem35jhmsvlhbXjw+JNlHlRu0HIow8uleCfmIL3o2CMfJTaRY/eEHSdPbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1w6/qtX1; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1w6/qtX1"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-210d5ea3cf5so1241425ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 Nov 2024 15:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731453793; x=1732058593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=USTo4YL/VPH3OMlRJlDOB1h2tpzzB/FL1xLG0AeYaEg=;
        b=1w6/qtX1pcfmb4Nnjt8qDXAMfFylUXLzjyOM1+849HvIk921Vfg1hMSNN0cTJ36s5X
         RQUu2IdlHsB6wajYcmiRCwVpsSwDjRPj5/WQop22Pns9tQeXnX7PzFzqtaTZo1lWYgz6
         19Karvik0TUFkE7VJ3pHg3aoX7zNG4VYsNOFqqEYUab7jY+hXwm24km+XW5FMsFdArdM
         xCkgGehB8BGVuuW5R9sJp4PmnNrCI4EhH56JZRMgMXJ8pcIG1gxhsL5M8daUt8PIYrD7
         Ngz4BiQ4hFzJKtRHbW/RXDOduHMd84IqiRy1dpZniI2B6Z49RDagqZVVFmdZ/knv0jB/
         pniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731453793; x=1732058593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=USTo4YL/VPH3OMlRJlDOB1h2tpzzB/FL1xLG0AeYaEg=;
        b=vEQ27vaO/CgPzME5XxZFA+K6xW8imrS+dLhNRoSxuGtiCXwQixIZaE2Pl1DdMDPLMS
         ApJo6XzIVuxmU4h/JEbhPhBwq2wlrC9Pa4TAlLUZzgEbGRuwJPt5vRuNdMoKPep60Wrb
         16dtIExOFlbGNwNA2boOV8tuXiUaRFIhp7Mw1CCXwrbwMk7lmB7zf/K4bvh5gJjlUp5z
         kyPP0b6wXBohj6Y8xUWOY3sto5mn2Q/xdrkOlRVgAXgDNI7dvZlBOlfzrqUdke/2Vc2h
         kZKdmQguciTngZJlj046Cx427BWaWsSHHRJ4Y+Eb04irYM3Z+B8ZXtNYbMgfTLTdPY3z
         DjQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDENUe5cCrhHEWwAGMJbBMzQUpgRG+reCVpwnvdzp7fHvHbOd2JNFk/FjZe/dJ9jaQsiCc6hd/BUY1F/E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrL+CDZj79Nk9XPAP3E3c7adVW6y70KzUhLeYVG3GkR8s3EhU9
	Fn0/TB1u++kWl68/SbWZSsmafyEz03A035B9GdC2+5MdVYDdelOJe5yvGTA+RPqjgYva7qLaN44
	+5NMbGztw83AhVIXBWy5teA==
X-Google-Smtp-Source: AGHT+IEby86KOt7jOT5/DEApza0kwwIhq4p8JxRYX4qy2k+CNTUtIUvHeGv7sbHFOyCcpJ8TgiN/weldRpPBkDTfbw==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a17:902:e809:b0:20c:6764:6681 with
 SMTP id d9443c01a7336-211821273camr1743295ad.2.1731453793410; Tue, 12 Nov
 2024 15:23:13 -0800 (PST)
Date: Tue, 12 Nov 2024 23:22:44 +0000
In-Reply-To: <20241112232253.3379178-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112232253.3379178-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241112232253.3379178-6-dionnaglaze@google.com>
Subject: [PATCH v6 5/8] crypto: ccp: Add GCTX API to track ASID assignment
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>
Cc: linux-coco@lists.linux.dev, Dionna Glaze <dionnaglaze@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, Russ Weight <russ.weight@linux.dev>, 
	Danilo Krummrich <dakr@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Tianfei zhang <tianfei.zhang@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In preparation for SEV firmware hotloading support, introduce a new way
to create, activate, and decommission GCTX pages such that ccp is has
all GCTX pages available to update as needed.

Compliance with SEV-SNP API section 3.3 Firmware Updates and 4.1.1
Live Update: before a firmware is committed, all active GCTX pages
should be updated with SNP_GUEST_STATUS to ensure their data structure
remains consistent for the new firmware version.
There can only be CPUID 0x8000001f_EDX-1 many SEV-SNP asids in use at
one time, so this map associates asid to gctx in order to track which
addresses are active gctx pages that need updating. When an asid and
gctx page are decommissioned, the page is removed from tracking for
update-purposes.

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

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 drivers/crypto/ccp/sev-dev.c | 159 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |   4 +
 include/linux/psp-sev.h      |  55 ++++++++++++
 3 files changed, 217 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index af018afd9cd7f..d8c35b8478ff5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/file.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
@@ -109,6 +110,10 @@ static void *sev_init_ex_buffer;
  */
 static struct sev_data_range_list *snp_range_list;
 
+/* SEV ASID data tracks resources associated with an ASID to safely manage operations. */
+struct sev_asid_data *sev_asid_data;
+u32 nr_asids, sev_min_asid, sev_es_max_asid;
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1093,6 +1098,109 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
+static bool sev_check_external_user(int fd);
+void *sev_snp_create_context(int fd, int asid, int *psp_ret)
+{
+	struct sev_data_snp_addr data = {};
+	void *context;
+	int rc, error;
+
+	if (!sev_check_external_user(fd))
+		return ERR_PTR(-EBADF);
+
+	if (!sev_asid_data)
+		return ERR_PTR(-ENODEV);
+
+	if (asid < 0 || asid >= nr_asids)
+		return ERR_PTR(-EINVAL);
+
+	/* Can't create a context for a used ASID. */
+	if (WARN_ON_ONCE(sev_asid_data[asid].snp_context))
+		return ERR_PTR(-EBUSY);
+
+	/* Allocate memory for context page */
+	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return ERR_PTR(-ENOMEM);
+
+	data.address = __psp_pa(context);
+	rc = sev_do_cmd(SEV_CMD_SNP_GCTX_CREATE, &data, &error);
+	if (rc) {
+		pr_warn("Failed to create SEV-SNP context, rc=%d fw_error=0x%x",
+			rc, error);
+		if (psp_ret)
+			*psp_ret = error;
+		snp_free_firmware_page(context);
+		return ERR_PTR(-EIO);
+	}
+
+	sev_asid_data[asid].snp_context = context;
+
+	return context;
+}
+EXPORT_SYMBOL_GPL(sev_snp_create_context);
+
+int sev_snp_activate_asid(int fd, int asid, int *psp_ret)
+{
+	struct sev_data_snp_activate data = {0};
+	void *context;
+
+	if (!sev_check_external_user(fd))
+		return -EBADF;
+
+	if (!sev_asid_data)
+		return -ENODEV;
+
+	if (asid < 0 || asid >= nr_asids)
+		return -EINVAL;
+
+	context = sev_asid_data[asid].snp_context;
+	if (WARN_ON_ONCE(!context))
+		return -EINVAL;
+
+	data.gctx_paddr = __psp_pa(context);
+	data.asid = asid;
+	return sev_do_cmd(SEV_CMD_SNP_ACTIVATE, &data, psp_ret);
+}
+EXPORT_SYMBOL_GPL(sev_snp_activate_asid);
+
+int sev_snp_guest_decommission(int fd, int asid, int *psp_ret)
+{
+	struct sev_data_snp_addr addr = {};
+	struct sev_asid_data *data;
+	int ret, error;
+
+	if (!sev_check_external_user(fd))
+		return -EBADF;
+
+	if (!sev_asid_data)
+		return -ENODEV;
+
+	if (asid < 0 || asid >= nr_asids)
+		return -EINVAL;
+
+	data = &sev_asid_data[asid];
+	/* If context is not created then do nothing */
+	if (!data->snp_context)
+		return 0;
+
+	/* Do the decommission, which will unbind the ASID from the SNP context */
+	addr.address = __sme_pa(data->snp_context);
+	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &addr, &error);
+
+	if (WARN_ONCE(ret, "Failed to release guest context, rc=%d, fw_error=0x%x", ret, error)) {
+		if (psp_ret)
+			*psp_ret = error;
+		return ret;
+	}
+
+	snp_free_firmware_page(data->snp_context);
+	data->snp_context = NULL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sev_snp_guest_decommission);
+
 static int __sev_snp_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
@@ -1306,6 +1414,27 @@ static int __sev_platform_init_locked(int *error)
 	return 0;
 }
 
+static int sev_asid_data_init(void)
+{
+	u32 eax, ebx, ecx;
+
+	if (sev_asid_data)
+		return 0;
+
+	cpuid(0x8000001f, &eax, &ebx, &ecx, &sev_min_asid);
+	if (!ecx)
+		return -ENODEV;
+
+	nr_asids = ecx + 1;
+	sev_es_max_asid = sev_min_asid - 1;
+
+	sev_asid_data = kcalloc(nr_asids, sizeof(*sev_asid_data), GFP_KERNEL);
+	if (!sev_asid_data)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 {
 	struct sev_device *sev;
@@ -1319,6 +1448,10 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
+	rc = sev_asid_data_init();
+	if (rc)
+		return rc;
+
 	/*
 	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
 	 * so perform SEV-SNP initialization at probe time.
@@ -2329,6 +2462,9 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 		snp_range_list = NULL;
 	}
 
+	kfree(sev_asid_data);
+	sev_asid_data = NULL;
+
 	__sev_snp_shutdown_locked(&error, panic);
 }
 
@@ -2377,10 +2513,31 @@ static struct notifier_block snp_panic_notifier = {
 	.notifier_call = snp_shutdown_on_panic,
 };
 
+static bool file_is_sev(struct file *filep)
+{
+	return filep && filep->f_op == &sev_fops;
+}
+
+static bool sev_check_external_user(int fd)
+{
+	struct fd f;
+	bool ret = true;
+
+	f = fdget(fd);
+	if (!fd_file(f))
+		return false;
+
+	if (!file_is_sev(fd_file(f)))
+		ret = false;
+
+	fdput(f);
+	return ret;
+}
+
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
-	if (!filep || filep->f_op != &sev_fops)
+	if (!file_is_sev(filep))
 		return -EBADF;
 
 	return sev_do_cmd(cmd, data, error);
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a3..ccf3ba78d8332 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -65,4 +65,8 @@ void sev_dev_destroy(struct psp_device *psp);
 void sev_pci_init(void);
 void sev_pci_exit(void);
 
+struct sev_asid_data {
+	void *snp_context;
+};
+
 #endif /* __SEV_DEV_H */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea85850..0b3b7707ccb21 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -942,6 +942,61 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
  */
 int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
+/**
+ * sev_snp_create_context - allocates an SNP context firmware page
+ *
+ * Associates the created context with the ASID that an activation
+ * call after SNP_LAUNCH_START will commit. The association is needed
+ * to track active guest context pages to refresh during firmware hotload.
+ *
+ * @fd:      A file descriptor for the SEV device
+ * @asid:    The ASID allocated to the caller that will be used in a subsequent SNP_ACTIVATE.
+ * @psp_ret: sev command return code.
+ *
+ * Returns:
+ * A pointer to the SNP context page, or an ERR_PTR of
+ * -%ENODEV    if the PSP device is not available
+ * -%ENOTSUPP  if PSP device does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if PSP device returned a non-zero return code
+ */
+void *sev_snp_create_context(int fd, int asid, int *psp_ret);
+
+/**
+ * sev_snp_activate_asid - issues SNP_ACTIVATE for the ASID and associated guest context page.
+ *
+ * @fd:      A file descriptor for the SEV device
+ * @asid:    The ASID to activate.
+ * @psp_ret: sev command return code.
+ *
+ * Returns:
+ * 0 if the SEV device successfully processed the command
+ * -%ENODEV    if the PSP device is not available
+ * -%ENOTSUPP  if PSP device does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if PSP device returned a non-zero return code
+ */
+int sev_snp_activate_asid(int fd, int asid, int *psp_ret);
+
+/**
+ * sev_snp_guest_decommission - issues SNP_DECOMMISSION for an ASID's guest context page, and frees
+ * it.
+ *
+ * The caller must ensure mutual exclusion with any process that may deactivate ASIDs.
+ *
+ * @fd:      A file descriptor for the SEV device
+ * @asid:    The ASID to activate.
+ * @psp_ret: sev command return code.
+ *
+ * Returns:
+ * 0 if the SEV device successfully processed the command
+ * -%ENODEV    if the PSP device is not available
+ * -%ENOTSUPP  if PSP device does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if PSP device returned a non-zero return code
+ */
+int sev_snp_guest_decommission(int fd, int asid, int *psp_ret);
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
-- 
2.47.0.277.g8800431eea-goog

