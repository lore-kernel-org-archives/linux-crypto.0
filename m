Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78982D05D
	for <linux-crypto@vger.kernel.org>; Tue,  5 Nov 2024 01:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730768781; cv=none; b=LccghNwQUZpQgJISUVz8mDpGmWOcZImKwKySfAsfEFi+nVWj47B+9X1cU+FCVaKZlcPY8Q3/4RB0bLPwP7NniSbp1EQmad2FDW+0mwA2saPrbg6vnog14XkgZIP5Z9Xch55mOW3d7h3mq2sz14XaRRQXhXGqBUd5kiRxZInDrUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730768781; c=relaxed/simple;
	bh=GkUnsi5SarheVW9NGjkSX5hkjknfFVi+MWiKDvinNVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n9H1B8X47XHqUCn31nUO1Hdt5GglVU0dsEDqk/5f7pWf2ILjgX459ITKXO6mHN25mcXAtJRvRh56BlqulB5KSgFlJdZ57l983kEHgh+mhEWBc9VPy176IlMDeY+er/azIfIVIgH7ujx/SvhK+lEbpbL2DcjTvUr/4/sJi3zNrkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d5sOicwM; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d5sOicwM"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea82a5480fso48081797b3.0
        for <linux-crypto@vger.kernel.org>; Mon, 04 Nov 2024 17:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730768778; x=1731373578; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3V3K/d14Fu8pd45Sc4muOCF75vsjk11/XwXzZj5XgyI=;
        b=d5sOicwMmIQZPJfbjIukH4QmirLqDcH0ycFeyylaOTMK38kp2qCKE27l9weJRmQxml
         Gzv5XpoYqliLfXxA+F12NEpLNlE6ETfKEE8wUTtymExKqgeITO/luGTeyQ7AMtnhvlKy
         IApL2i4wjyPeANwuXmFxi0OtGfBSk2YpzuFrA/qsGnyIEtv7ffJ9n8hCKbEqj4Pu7qPo
         Z67ztKw1KKfI4o9fRPtCaubDyFBDeAh9j3sZ/imfDXyuHTqg6qxe+iBSQwBt0cV8jUTX
         /AopLBXIvbdf+zblw8VUvUYPgPj5b7dQu2FpCg8kmL8vo5jSCRFimKnmcdwsPYHJ/RMq
         V32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730768778; x=1731373578;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3V3K/d14Fu8pd45Sc4muOCF75vsjk11/XwXzZj5XgyI=;
        b=h0TwnQQ+qZeiqL+zhZFuXouki6stvGtkAHDKZnUpTAYeuMTW/1Bem8nM1IA3uKW0Ey
         Qj4OZ9tiF8WUpx8uTk4yEH1WFAkMUlYwWGWnQnQ7mnHOKabkkO+Rv6dbni3FaXjugaL0
         SkN3IPTswlTZK/bRbDBUtK6fGVFNGyEum+Sf50wt4ywQ0iecAA1ExAkr2/W3TBh9zo6z
         T3TtDpQc0YjLIKv08zNhMay1bCKyRUYYcCXZr+H3/NSNK4kBZVrqJ+/0ravpZPenRJT7
         KD8HrKJSzqolLW0sLdojQSQWZKA0sQcfGlmOroF/MaJtVEGL0RM6jigVe9UK4sg/iKzv
         a7bw==
X-Forwarded-Encrypted: i=1; AJvYcCWNGxZ/NbNIHe5aYhC9V7j5mbjSJGuA4C2kJ1XZckCJUQ1vAMi0PBmb0HYCVaqvoqS45sRCHTnmy3RgYz8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7nstlQvUEkdaliNw8/bcCziU47Uq9ctn2g/lRQ+6rENEiZXEb
	Rj8wWKCbt+3WcC6e+AVBX5IQdbcdGdSkORZ+U9RcuxjlLXCSHns3plIw5lt8YKjUfmyhpPSUEh6
	WIAVhhl5bXopyYRKubDmU2Q==
X-Google-Smtp-Source: AGHT+IHsLGyWDHrXMF2JjSPjIYZ9KRAAjrZkeHUwJIZPYcfCTcUd6Uk6PWcg8l14OxMBiyYtA9ISpQvgEk2QR/J7IQ==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a05:690c:4510:b0:6e2:1ab6:699a with
 SMTP id 00721157ae682-6ea64beda72mr987937b3.7.1730768777924; Mon, 04 Nov 2024
 17:06:17 -0800 (PST)
Date: Tue,  5 Nov 2024 01:05:50 +0000
In-Reply-To: <20241105010558.1266699-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105010558.1266699-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105010558.1266699-4-dionnaglaze@google.com>
Subject: [PATCH v4 3/6] crypto: ccp: Track GCTX through sev commands
From: Dionna Glaze <dionnaglaze@google.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Ashish Kalra <ashish.kalra@amd.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In preparation for SEV firmware hotloading support, add bookkeeping
structures for GCTX pages that are in use.

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

The hotloading support depends on FW_UPLOAD, so the new functions are
added in a new file whose object file is conditionally included in the
module build.

Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 drivers/crypto/ccp/Makefile  |   1 +
 drivers/crypto/ccp/sev-dev.c |   5 ++
 drivers/crypto/ccp/sev-dev.h |  15 +++++
 drivers/crypto/ccp/sev-fw.c  | 117 +++++++++++++++++++++++++++++++++++
 4 files changed, 138 insertions(+)
 create mode 100644 drivers/crypto/ccp/sev-fw.c

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 394484929dae3..b8b5102cc7973 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -14,6 +14,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
                                    platform-access.o \
                                    dbc.o \
                                    hsti.o
+ccp-$(CONFIG_FW_UPLOAD) += sev-fw.o
 
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9810edbb272d2..9265b6d534bbe 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -982,6 +982,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
 			     buf_len, false);
 
+	if (!ret)
+		snp_cmd_bookkeeping_locked(cmd, sev, data);
+
 	return ret;
 }
 
@@ -1179,6 +1182,8 @@ static int __sev_snp_init_locked(int *error)
 
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
+	rc = sev_snp_platform_init_firmware_upload(sev);
+
 	return rc;
 }
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 3e4e5574e88a3..28add34484ed1 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -57,6 +57,13 @@ struct sev_device {
 	bool cmd_buf_backup_active;
 
 	bool snp_initialized;
+
+#ifdef CONFIG_FW_UPLOAD
+	u32 last_snp_asid;
+	u64 *snp_asid_to_gctx_pages_map;
+	u64 *snp_unbound_gctx_pages;
+	u32 snp_unbound_gctx_end;
+#endif /* CONFIG_FW_UPLOAD */
 };
 
 int sev_dev_init(struct psp_device *psp);
@@ -65,4 +72,12 @@ void sev_dev_destroy(struct psp_device *psp);
 void sev_pci_init(void);
 void sev_pci_exit(void);
 
+#ifdef CONFIG_FW_UPLOAD
+void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data);
+int sev_snp_platform_init_firmware_upload(struct sev_device *sev);
+#else
+static inline void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data) { }
+static inline int sev_snp_platform_init_firmware_upload(struct sev_device *sev) { return 0; }
+#endif /* CONFIG_FW_UPLOAD */
+
 #endif /* __SEV_DEV_H */
diff --git a/drivers/crypto/ccp/sev-fw.c b/drivers/crypto/ccp/sev-fw.c
new file mode 100644
index 0000000000000..55a5a572da8f1
--- /dev/null
+++ b/drivers/crypto/ccp/sev-fw.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Secure Encrypted Virtualization (SEV) firmware upload API
+ */
+
+#include <linux/firmware.h>
+#include <linux/psp-sev.h>
+
+#include <asm/sev.h>
+
+#include "sev-dev.h"
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
+void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data)
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
+int sev_snp_platform_init_firmware_upload(struct sev_device *sev)
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
+			dev_err(sev->dev,
+				"SEV-SNP: snp_asid_to_gctx_pages_map memory allocation failed\n");
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
-- 
2.47.0.199.ga7371fff76-goog

