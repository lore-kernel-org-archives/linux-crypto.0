Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24A721B441
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 23:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731022135; cv=none; b=cFAgme7iUuVsxBDaHiWnKMXxftNrzHwsEpj503//EfWhwOL28vMYNWZHaQEvizusGzvwbfrWa19co0Z5swIYsT4QpAthEGUZ/p0JDfhR1+QCc2bF+CRBW/JPQRUz7xVKa4ZReUgxCeI/z1ZcjRHgDy4DFrXkzfxEGYOxrRzNNio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731022135; c=relaxed/simple;
	bh=K+mz91F1yF96twer+mf0GLIIgXZi2rB7gU/fVt6MfUs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FOoPMFZOpqZm+qifIjoK92xhR7sQIMG6RdTFPrHfGeQZ44F2do1KA2c7t7D9uiAUOxN7ND0k3SYsbpixfI45fvWhVH5ZLozmbdaDKPq9/BL9z9NgbsVa7JBo6BLvp4mF/IH20PczHfM0eREhGuUy6IHBK0+PVRYs6810gxHCjSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u/47isQX; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u/47isQX"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6ea8a5e862eso19841647b3.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2024 15:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731022133; x=1731626933; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LBA3fBcXFp9Bsca4pv6+EzGK6gmROtQOBEHvya8zy9o=;
        b=u/47isQXqOUsK9ybbtanXkP07ZVslOAEDcN7SVS17KwdDwOSQRyDpLHlKCopIehPNm
         1CBQnDIovfaklREEhVIGtgROeJ4HfHhQGI1cNfAtx/U+2ao9igMEiUqi+eV0wAyqQlkf
         v1tCa1MPnzGzfuG5+/yfmlkUxeenBW26q9CtbvT5FvDkvLXz0oU24TtpwZUIrK3w8Hz3
         P465GbvDPc04FLMFaLv7/yCIeBXClSPr81ZtbVBrDNLyGbL/cC7VYj6eWxPqn718xeBs
         NDLOizTXYdEDCoBG4u0QXxOlBB3bixSbJp5woOGj7M1W1W4k6Zi0FGc9Qi7KR6VAdX8u
         8JSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731022133; x=1731626933;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LBA3fBcXFp9Bsca4pv6+EzGK6gmROtQOBEHvya8zy9o=;
        b=rU7tLydJDoBbcZo2u83B+UQocw7RxtP25qzwAMUEWyJzk3W1MZ36mNyH0wQjZZXcce
         /P+yW5mrwZT/SOZxQvlm7ym7WDlPNqD9CkZSA4Wn/dMpGG8j9cqcdTcfrO8EQGsZtL5O
         BMeSGHhmrln7ASifItnx1E48FlJ+k6MibWUBsrt5tXG1fGZMSCLp4hKYJpa3zXDv1nki
         isQhITbAYcle+kAhIe0dHjMrJbQpIWEsWAw06otm8cSsZS4jAxyvWJ1QgNKuobwV5Yan
         YUH5awMf8iNp5aDWBcmjCXyQqeGkTWS/UYVN0zkoUIxP0uTsKdldbsyxR/cMsGtpiLhm
         iAtg==
X-Forwarded-Encrypted: i=1; AJvYcCX9GFchRimpQOFobvxhfwwE5F4VDy0gm0nISbN6QCNn+LdRDX6V4J1uuqwwZcrry5o7h4YIXaU5RmIBQYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSF7yw4BvFOvbOvLJj+5NF/WoYUHgWdSsI8ws9yicfGmKIPQbj
	8pWa/cju7nkhcUdZDUjSiwmU8wNcQv0ylLtNzeAX4Z4l3+5MUywGGx5L3grcKs0KHyM3z2HDotv
	W6H/srB6AQm4vQ4Fd5siszA==
X-Google-Smtp-Source: AGHT+IFNyqKSoQsSCoYlJkBSKnmw23KoFCIBF0JCUO1nRJPI9ElZHcKVMfkjhcgPc9HIK87jTLhabc6SLTCBBfd2aA==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a05:690c:316:b0:620:32ea:e1d4 with
 SMTP id 00721157ae682-6eade0af8bbmr127717b3.0.1731022132776; Thu, 07 Nov 2024
 15:28:52 -0800 (PST)
Date: Thu,  7 Nov 2024 23:24:45 +0000
In-Reply-To: <20241107232457.4059785-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107232457.4059785-6-dionnaglaze@google.com>
Subject: [PATCH v5 05/10] crypto: ccp: Add GCTX API to track ASID assignment
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
 drivers/crypto/ccp/sev-dev.c | 107 +++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |   8 +++
 include/linux/psp-sev.h      |  52 +++++++++++++++++
 3 files changed, 167 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index af018afd9cd7f..036e8d5054fcc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -109,6 +109,10 @@ static void *sev_init_ex_buffer;
  */
 static struct sev_data_range_list *snp_range_list;
 
+/* SEV ASID data tracks resources associated with an ASID to safely manage operations. */
+struct sev_asid_data *sev_asid_data;
+u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1093,6 +1097,81 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
+void *sev_snp_create_context(int asid, int *psp_ret)
+{
+	struct sev_data_snp_addr data = {};
+	void *context;
+	int rc;
+
+	if (!sev_asid_data)
+		return ERR_PTR(-ENODEV);
+
+	/* Can't create a context for a used ASID. */
+	if (sev_asid_data[asid].snp_context)
+		return ERR_PTR(-EBUSY);
+
+	/* Allocate memory for context page */
+	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return ERR_PTR(-ENOMEM);
+
+	data.address = __psp_pa(context);
+	rc = sev_do_cmd(SEV_CMD_SNP_GCTX_CREATE, &data, psp_ret);
+	if (rc) {
+		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
+			rc, *psp_ret);
+		snp_free_firmware_page(context);
+		return ERR_PTR(-EIO);
+	}
+
+	sev_asid_data[asid].snp_context = context;
+
+	return context;
+}
+
+int sev_snp_activate_asid(int asid, int *psp_ret)
+{
+	struct sev_data_snp_activate data = {0};
+	void *context;
+
+	if (!sev_asid_data)
+		return -ENODEV;
+
+	context = sev_asid_data[asid].snp_context;
+	if (!context)
+		return -EINVAL;
+
+	data.gctx_paddr = __psp_pa(context);
+	data.asid = asid;
+	return sev_do_cmd(SEV_CMD_SNP_ACTIVATE, &data, psp_ret);
+}
+
+int sev_snp_guest_decommission(int asid, int *psp_ret)
+{
+	struct sev_data_snp_addr addr = {};
+	struct sev_asid_data *data = &sev_asid_data[asid];
+	int ret;
+
+	if (!sev_asid_data)
+		return -ENODEV;
+
+	/* If context is not created then do nothing */
+	if (!data->snp_context)
+		return 0;
+
+	/* Do the decommision, which will unbind the ASID from the SNP context */
+	addr.address = __sme_pa(data->snp_context);
+	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &addr, NULL);
+
+	if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret))
+		return ret;
+
+	snp_free_firmware_page(data->snp_context);
+	data->snp_context = NULL;
+
+	return 0;
+}
+
 static int __sev_snp_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
@@ -1306,6 +1385,27 @@ static int __sev_platform_init_locked(int *error)
 	return 0;
 }
 
+static int __sev_asid_data_init(void)
+{
+	u32 eax, ebx;
+
+	if (sev_asid_data)
+		return 0;
+
+	cpuid(0x8000001f, &eax, &ebx, &sev_max_asid, &sev_min_asid);
+	if (!sev_max_asid)
+		return -ENODEV;
+
+	nr_asids = sev_max_asid + 1;
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
@@ -1319,6 +1419,10 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
+	rc = __sev_asid_data_init();
+	if (rc)
+		return rc;
+
 	/*
 	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
 	 * so perform SEV-SNP initialization at probe time.
@@ -2329,6 +2433,9 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 		snp_range_list = NULL;
 	}
 
+	kfree(sev_asid_data);
+	sev_asid_data = NULL;
+
 	__sev_snp_shutdown_locked(&error, panic);
 }
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a3..7d0fdfdda30b6 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -65,4 +65,12 @@ void sev_dev_destroy(struct psp_device *psp);
 void sev_pci_init(void);
 void sev_pci_exit(void);
 
+struct sev_asid_data {
+	void *snp_context;
+};
+
+/* Extern to be shared with firmware_upload API implementation if configured. */
+extern struct sev_asid_data *sev_asid_data;
+extern u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
+
 #endif /* __SEV_DEV_H */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea85850..ac36b5ddf717d 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -942,6 +942,58 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
  */
 int sev_do_cmd(int cmd, void *data, int *psp_ret);
 
+/**
+ * sev_snp_create_context - allocates an SNP context firmware page
+ *
+ * Associates the created context with the ASID that an activation
+ * call after SNP_LAUNCH_START will commit. The association is needed
+ * to track active guest context pages to refresh during firmware hotload.
+ *
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
+void *sev_snp_create_context(int asid, int *psp_ret);
+
+/**
+ * sev_snp_activate_asid - issues SNP_ACTIVATE for the ASID and associated guest context page.
+ *
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
+int sev_snp_activate_asid(int asid, int *psp_ret);
+
+/**
+ * sev_snp_guest_decommission - issues SNP_DECOMMISSION for an ASID's guest context page, and frees
+ * it.
+ *
+ * The caller must ensure mutual exclusion with any process that may deactivate ASIDs.
+ *
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
+int sev_snp_guest_decommission(int asid, int *psp_ret);
+
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
-- 
2.47.0.277.g8800431eea-goog

