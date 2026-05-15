Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC973EBF3B
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879670; cv=none; b=j6ogj5vCZh0roh5cT8ogJsSQJUYo/7Np46gN1bQ64rJ1h0z+SI/Zit83fVVj7xGEBQ8Xsp6Krg0bBaMz+LpRTmOF3cYeHM10UPzMO9dUZDw19rUej5upS+sY+8pQ+2+e2ZC3xaqH2zZadXEpsyeG3Nxs8kmS5VNB3u6tq+uWjTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879670; c=relaxed/simple;
	bh=iZx+Ma9ZLO27Qd1OSFPbIPI91crZcyGUmYYOTAyaGV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFuevLwwOV9EBkwVBpI1Femh7/npHrOmiK5W/nj+aYpELCE0wXyK+C/6vuZ1hEmpk/LZrGnSQ2rxmS9K6gTBrunwrrupBp13NS4g+NIvR06Omp0YXq0UOlvK/lhh3LlsgMfJ+jft3zQr3MoKI7qrI3x0r0ZbqWuIMrNMYglEzwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V+aYs+sS; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V+aYs+sS"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2bdcf5970cdso150696eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879667; x=1779484467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvhJ+ydmVFUO/FtDIG83CBk7wY0hq1hCXhxrxXZ6CzE=;
        b=V+aYs+sS8kXrENeJEYszeay1jLDUpy8kXTjVEGtORS5QflQnwyXwrVZZf6AWM3KSrH
         p3loYQh1cSwdAH/ClG38n2IltMK+e+QOktZ38/7Y61DNR3BjE4PCfA70fYeMWoObIYQK
         /p9MxXRFQJNWOpsVpYiTDEpWiImZO33lHIadpJUJZByA8Z99pwIYnt7mHy0EyH59Kk7x
         fgijEtE5LZNrecyVn1qopbBriufmCDUELfAUlJycyuOY9klZvELHtlqwnqr5gPv2clmN
         XbwhCSWJxy5i6rnS69hSWFvNrp6n+ExzeVaF9t6zyjEBan8Q0DvbKV98dDCXMuGLjW6j
         xVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879667; x=1779484467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zvhJ+ydmVFUO/FtDIG83CBk7wY0hq1hCXhxrxXZ6CzE=;
        b=LCPgA4rgJyxZJLMHr3QkveNMDl/gnY65yvOZj4XuLq8MAr/49vvznKUn1tNYUbk+OB
         UumPBPq0bXT9NnCNK66hPF3MWO3oQrvaqa9lTt6I+2peC18nnvLq2Us9chc6oX/Hhom7
         x+YQlWUVtbC0ncTCAVihfltwbcsgycMySE6lUFATUBmf3T7yH+DZYy2E2e8YXM3CfpKo
         dInUVkB0eXk48WxXISaZVrPsg50rCWB2YauDot/dmCF2+qAbcUClNyB0JAQs/z2Cv54o
         Q9If11TZnEHnU3ZSQOIqczWg0yjsYK4vS3chxF1yF07zm6FDd5txDEMhyUzCPRaMeYOM
         KH6Q==
X-Forwarded-Encrypted: i=1; AFNElJ//J9qfG+Q0fqg+khCDD5Tekk/RsW5LeBQJmlv1JZV/YnZPpr1Crcq0msPZnnZ1imFgWDHU434jhRv+kGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxuPQdFxi1FATPq7IFg/Md4c5zsHDW6VYX4aX0PgYj2EQi0QmN
	DtNXPN1AyO/TeVWKSqDRXnl5TQqEBTiJSiDW3gxTPB4b96xsRiH6+bdx
X-Gm-Gg: Acq92OH7ZvKkn6ydWWuGi6d+kZaAwzFihggiJjxlvgpLsI+CpybDb5MqMi8q6Pj9v5C
	jF4+G9EucsqyfL9NKCaCeLUmYwhWqbCWgNBoc1fOljaBmc3FXJgh+cLTRKlGsJRghF/wA5prVSJ
	A8MN5JJjC4jUP90/q1dfMTg1daxeRaXpDXTCJXKdEVOgWt0egMLSSzOq/Y3EblSEvHZwugYYxEj
	0uFA1SOI9bpTmxtG45cY8W+4voivEqovZmT6DF2EMRtr10lYqZZ+TxhoYQsCqQogJ8Kt9XgEExi
	KyJjrGyk4Mp8dRPuII3YNT7+AFlWZa9Gf10KzGx7JNplnIUSyxitiL/xAGJ8fFZHACIbAaawwaO
	BqS2Iolq/J7I4H2p4jVbsRNAuCoQpsWut67JF5iJPvSdh9hpjXhjKwmSim6Y6ElozpfB+/lFqLM
	5KS9N7vdpGj8dTYXVOzCD6Zu7Rd5dbR/6jKxA9G8bPDg==
X-Received: by 2002:a05:7301:2a02:b0:2c1:67e1:61a9 with SMTP id 5a478bee46e88-303979af82emr2367379eec.13.1778879666828;
        Fri, 15 May 2026 14:14:26 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30296dcb6f6sm9726668eec.17.2026.05.15.14.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:26 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-efi@vger.kernel.org,
	iommu@lists.linux.dev
Cc: ross.philipson@gmail.com,
	dpsmith@apertussolutions.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	dave.hansen@linux.intel.com,
	ardb@kernel.org,
	mjg59@srcf.ucam.org,
	James.Bottomley@hansenpartnership.com,
	peterhuewe@gmx.de,
	jarkko@kernel.org,
	jgg@ziepe.ca,
	luto@amacapital.net,
	nivedita@alum.mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	ebiederm@xmission.com,
	dwmw2@infradead.org,
	baolu.lu@linux.intel.com,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v16 05/38] tpm: Move platform specific definitions to the new PTP header
Date: Fri, 15 May 2026 14:13:37 -0700
Message-ID: <20260515211410.31440-6-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515211410.31440-1-ross.philipson@gmail.com>
References: <20260515211410.31440-1-ross.philipson@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are definitions for TPM 2.0 interface and interactions with
the platform as defined in the TCG specification:

These definitions are located here in a separate file to avoid conflicts
with vendor specific TIS/FIFO definition (e.g. STMicroelectronics,
Infineon Technologies, etc). This allows the TCG defined TIS/FIFO
interface to be in a public header while the former chip specific
implementations contain their own definitions. TPM 1.x family chips
that adhere to the TCG specifications use the TIS/FIFO interface as
defined here.

TCG PC Client Platform TPM Profile (PTP) Specification
 - https://trustedcomputinggroup.org/resource/pc-client-platform-tpm-profile-ptp-specification/

Co-developed-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Co-developed-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm_tis_core.h |  64 +-------------
 include/linux/tpm_ptp.h         | 151 ++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+), 63 deletions(-)
 create mode 100644 include/linux/tpm_ptp.h

diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 6c3aa480396b..be68883ed399 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -19,71 +19,9 @@
 #ifndef __TPM_TIS_CORE_H__
 #define __TPM_TIS_CORE_H__
 
+#include <linux/tpm_ptp.h>
 #include "tpm.h"
 
-enum tis_access {
-	TPM_ACCESS_VALID = 0x80,
-	TPM_ACCESS_ACTIVE_LOCALITY = 0x20,
-	TPM_ACCESS_REQUEST_PENDING = 0x04,
-	TPM_ACCESS_REQUEST_USE = 0x02,
-};
-
-enum tis_status {
-	TPM_STS_VALID = 0x80,
-	TPM_STS_COMMAND_READY = 0x40,
-	TPM_STS_GO = 0x20,
-	TPM_STS_DATA_AVAIL = 0x10,
-	TPM_STS_DATA_EXPECT = 0x08,
-	TPM_STS_RESPONSE_RETRY = 0x02,
-	TPM_STS_READ_ZERO = 0x23, /* bits that must be zero on read */
-};
-
-enum tis_int_flags {
-	TPM_GLOBAL_INT_ENABLE = 0x80000000,
-	TPM_INTF_BURST_COUNT_STATIC = 0x100,
-	TPM_INTF_CMD_READY_INT = 0x080,
-	TPM_INTF_INT_EDGE_FALLING = 0x040,
-	TPM_INTF_INT_EDGE_RISING = 0x020,
-	TPM_INTF_INT_LEVEL_LOW = 0x010,
-	TPM_INTF_INT_LEVEL_HIGH = 0x008,
-	TPM_INTF_LOCALITY_CHANGE_INT = 0x004,
-	TPM_INTF_STS_VALID_INT = 0x002,
-	TPM_INTF_DATA_AVAIL_INT = 0x001,
-};
-
-enum tis_defaults {
-	TIS_MEM_LEN = 0x5000,
-	TIS_SHORT_TIMEOUT = 750,	/* ms */
-	TIS_LONG_TIMEOUT = 4000,	/* 4 secs */
-	TIS_TIMEOUT_MIN_ATML = 14700,	/* usecs */
-	TIS_TIMEOUT_MAX_ATML = 15000,	/* usecs */
-};
-
-/* Some timeout values are needed before it is known whether the chip is
- * TPM 1.0 or TPM 2.0.
- */
-#define TIS_TIMEOUT_A_MAX	max_t(int, TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_A)
-#define TIS_TIMEOUT_B_MAX	max_t(int, TIS_LONG_TIMEOUT, TPM2_TIMEOUT_B)
-#define TIS_TIMEOUT_C_MAX	max_t(int, TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_C)
-#define TIS_TIMEOUT_D_MAX	max_t(int, TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_D)
-
-#define	TPM_ACCESS(l)			(0x0000 | ((l) << 12))
-#define	TPM_INT_ENABLE(l)		(0x0008 | ((l) << 12))
-#define	TPM_INT_VECTOR(l)		(0x000C | ((l) << 12))
-#define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
-#define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
-#define	TPM_STS(l)			(0x0018 | ((l) << 12))
-#define	TPM_STS3(l)			(0x001b | ((l) << 12))
-#define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
-
-#define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
-#define	TPM_RID(l)			(0x0F04 | ((l) << 12))
-
-#define LPC_CNTRL_OFFSET		0x84
-#define LPC_CLKRUN_EN			(1 << 2)
-#define INTEL_LEGACY_BLK_BASE_ADDR	0xFED08000
-#define ILB_REMAP_SIZE			0x100
-
 enum tpm_tis_flags {
 	TPM_TIS_ITPM_WORKAROUND		= 0,
 	TPM_TIS_INVALID_STATUS		= 1,
diff --git a/include/linux/tpm_ptp.h b/include/linux/tpm_ptp.h
new file mode 100644
index 000000000000..143e887599bb
--- /dev/null
+++ b/include/linux/tpm_ptp.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Following copyright information was take from the original file
+ * <drivers/char/tpm/tpm_tis_core.h> where the definitions were moved
+ * from:
+ *
+ * Copyright (C) 2005, 2006 IBM Corporation
+ * Copyright (C) 2014, 2015 Intel Corporation
+ *
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * This device driver implements the TPM interface as defined in
+ * the TCG TPM Interface Spec version 1.2, revision 1.0.
+ */
+
+#ifndef __LINUX_TPM_PTP_H__
+#define __LINUX_TPM_PTP_H__
+
+/*
+ * TCG PC Client Platform TPM Profile (PTP) Specification
+ * https://trustedcomputinggroup.org/resource/pc-client-platform-tpm-profile-ptp-specification/
+ */
+
+/* TIS/FIFO macros and definitions */
+
+enum tis_access {
+	TPM_ACCESS_VALID		= 0x80,
+	TPM_ACCESS_ACTIVE_LOCALITY	= 0x20,	/* (R) */
+	TPM_ACCESS_RELINQUISH_LOCALITY	= 0x20, /* (W) */
+	TPM_ACCESS_REQUEST_PENDING	= 0x04,	/* (W) */
+	TPM_ACCESS_REQUEST_USE		= 0x02,	/* (W) */
+};
+
+enum tis_status {
+	TPM_STS_VALID		= 0x80, /* (R) */
+	TPM_STS_COMMAND_READY	= 0x40, /* (R) */
+	TPM_STS_DATA_AVAIL	= 0x10, /* (R) */
+	TPM_STS_DATA_EXPECT	= 0x08, /* (R) */
+	TPM_STS_GO		= 0x20, /* (W) */
+	TPM_STS_RESPONSE_RETRY	= 0x02, /* (R) */
+	TPM_STS_READ_ZERO	= 0x23, /* bits that must be zero on read */
+};
+
+enum tis_int_flags {
+	TPM_GLOBAL_INT_ENABLE		= 0x80000000,
+	TPM_INTF_BURST_COUNT_STATIC	= 0x100,
+	TPM_INTF_CMD_READY_INT		= 0x080,
+	TPM_INTF_INT_EDGE_FALLING	= 0x040,
+	TPM_INTF_INT_EDGE_RISING	= 0x020,
+	TPM_INTF_INT_LEVEL_LOW		= 0x010,
+	TPM_INTF_INT_LEVEL_HIGH		= 0x008,
+	TPM_INTF_LOCALITY_CHANGE_INT	= 0x004,
+	TPM_INTF_STS_VALID_INT		= 0x002,
+	TPM_INTF_DATA_AVAIL_INT		= 0x001,
+};
+
+enum tis_defaults {
+	TIS_MEM_LEN		= 0x5000,
+	TIS_SHORT_TIMEOUT	= 750,   /* ms */
+	TIS_LONG_TIMEOUT	= 4000,  /* 4 secs */
+	TIS_TIMEOUT_MIN_ATML	= 14700, /* usecs */
+	TIS_TIMEOUT_MAX_ATML	= 15000, /* usecs */
+};
+
+enum tis_x86_defaults {
+	TIS_MEM_X86_LPC_BASE		= 0xFED40000,
+	TIS_MEM_X86_LEN			= 0x5000,
+	INTEL_LEGACY_BLK_BASE_ADDR	= 0xFED08000,
+	ILB_REMAP_SIZE			= 0x100,
+	LPC_CNTRL_OFFSET		= 0x84,
+	LPC_CLKRUN_EN			= (1 << 2),
+};
+
+/*
+ * Some timeout values are needed before it is known whether the chip is
+ * TPM 1.0 or TPM 2.0.
+ */
+#define TIS_TIMEOUT_A_MAX	max_t(int, TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_A)
+#define TIS_TIMEOUT_B_MAX	max_t(int, TIS_LONG_TIMEOUT, TPM2_TIMEOUT_B)
+#define TIS_TIMEOUT_C_MAX	max_t(int, TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_C)
+#define TIS_TIMEOUT_D_MAX	max_t(int, TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_D)
+
+#define	TPM_ACCESS(l)			(0x0000 | ((l) << 12))
+#define	TPM_INT_ENABLE(l)		(0x0008 | ((l) << 12))
+#define	TPM_INT_VECTOR(l)		(0x000C | ((l) << 12))
+#define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
+#define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
+#define	TPM_STS(l)			(0x0018 | ((l) << 12))
+#define	TPM_STS3(l)			(0x001b | ((l) << 12))
+#define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
+#define	TPM_INTF_ID(l)			(0x0030 | ((l) << 12))
+
+#define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
+#define	TPM_RID(l)			(0x0F04 | ((l) << 12))
+
+/* TPM HW Interface and Capabilities */
+#define TPM_TIS_INTF_ACTIVE	0x00
+#define TPM_CRB_INTF_ACTIVE	0x01
+
+struct tpm_interface_id {
+	union {
+		u32 val;
+		struct {
+			u32 interface_type:4;
+			u32 interface_version:4;
+			u32 cap_locality:1;
+			u32 reserved1:4;
+			u32 cap_tis:1;
+			u32 cap_crb:1;
+			u32 cap_if_res:2;
+			u32 interface_selector:2;
+			u32 intf_sel_lock:1;
+			u32 reserved2:4;
+			u32 reserved3:8;
+		};
+	};
+} __packed;
+
+#define TPM_TIS_INTF_12		0x00
+#define TPM_TIS_INTF_13		0x02
+#define TPM2_TIS_INTF_13	0x03
+
+struct tpm_intf_capability {
+	union {
+		u32 val;
+		struct {
+			u32 data_avail_int_support:1;
+			u32 sts_valid_int_support:1;
+			u32 locality_change_int_support:1;
+			u32 interrupt_level_high:1;
+			u32 interrupt_level_low:1;
+			u32 interrupt_edge_rising:1;
+			u32 interrupt_edge_falling:1;
+			u32 command_ready_int_support:1;
+			u32 burst_count_static:1;
+			u32 data_transfer_size_support:2;
+			u32 reserved1:17;
+			u32 interface_version:3;
+			u32 reserved2:1;
+		};
+	};
+} __packed;
+
+#endif
-- 
2.47.3

