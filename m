Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEEE3CBE6D
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 16:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783785693; cv=none; b=PaTP+h4KEpLP8e82M2zgpYh/aYcZUNkIEC6ROjAcZg7FdcnW4f4TDHRzas5Ob+X8gR/KkzFVn/BPNPLzV93NqO/X30j8mWoazQcS1+8kIUK27BePpJGZUhyFwtYTFjmjUHwYieJXuLF4hvy9V9A7YAH3Og6tPidkpHrl2VkAuQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783785693; c=relaxed/simple;
	bh=IKmtT9Cq3h0iSyz5OU+oULBN9QjQwnAFo0SgsEd/FNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAM07vSFxcRkuiuutDei2VBaC1iI75YEsvIrrJm1gLzojPlKrsayUVpPilrnmBltoktUKiGz0Ju5wKgScbr9VcV5YhicBBRzaV6fNLqtRfBqznUTrjsgI1uPxuG8zKaUiJ+YrvGWnQK8bMpMz3zCyifbN+x3PplOrmQm7pvq+jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sU7lOGiY; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sU7lOGiY"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-848643382fcso1886969b3a.1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 09:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783785691; x=1784390491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cQmIuXUkp3rrMVH26ZTOPg/E2zd6zUa3wMeq4GmUl8U=;
        b=sU7lOGiYCEn+vZz+m7AlLz/9PaJBqIaw39uDkYdKHj91RkHMneXRw59+r5iRGlFsPC
         l3o1PkfuudH2Otilf3PzKW51gb7P+lrfpAVTYPqr9IcUC55rN+Gp/eWLX+X7JXosdGek
         rHV77NuW0lCseauKaQGnniivSHYbemtpz2c+QiknMlmY4i7iIm7pFatbCl9a35tACEm+
         rFwpxlOQ4i9qMUPDLQazWMkS+gqXwik40joCFUeP6DDxy2xgp/UzGe8mU0HqlGvzBpsv
         e43IS2IQhcSYskhHsRDBxoOZdoNF1y2dTBcnW9V3jSSbdv2meXc7wmoxa1+ILOpXZ3Cw
         cqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783785691; x=1784390491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cQmIuXUkp3rrMVH26ZTOPg/E2zd6zUa3wMeq4GmUl8U=;
        b=Ox/AM08QZyftrjc2TdcrA2kSoqXCkjaWU2rPnvRzSl0yiFviRxFXW8ohbl8G0lrDuG
         QGzOGqpXwEcpofsh+m+eBEOPu84cvWjSmZ3672S0K4SMBC87jSBfbRpHHk/7KRdeR0DY
         IDb8QGoPl8neDYUojnX4MFfFjbjDfkGQR+jSCsP7Vq3u6J+MR2DlV+LK+78Mggx8kfjS
         WoBj/DrQke51x/M/vv4DN0TU+zJXevwstSY/xeZuMgBKsAmreF/T2kNys02dGILTLtFf
         H7UfPaYld1PQ6Avm18pSyU9FDxXKwVH3GsTemNR3l7Nm8ON1Cs4zXtLO4sQ7jzJzCUDr
         JMkQ==
X-Forwarded-Encrypted: i=1; AHgh+RoCMgdy5LQjfSuLKNbqBvN/5VGYuvPPAqJy675wLv00JsEmBvTixzA7y6sLf7QbwBmMy0vJoGTxiNurnzA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiDowQg9ST7YqoOi8h6tyyd4mRe+p0es3rt7WW8DJkt14fTLrs
	bmQNmDlIXrrdDTfiJQd6GF9WkBIujsHaz2KPAUSm85BTB27SLWj4VFOw
X-Gm-Gg: AfdE7cluTenfnRHFjr69YGVIarBIK3wgWkEcfMokT4Uf9sehF3TIfkVCDLZMRkU253B
	5x26cLlaQGcQ4zMIT4juSZ8SyeT6NX7o1YxvM/iq89SY94rFRQLzVOomh0Y0bPMHXx9q0sU/12k
	0jLAg2FqODE3VwWenmvJIwoOZSFaCLZHax6vsv1bSIKdfwIHBjSk6AckUPIe1GGBaNikBLgVXt1
	b6Fs4wXvpTdOmd8pgSo0rAHkHxBVCLY8K6kIyL/DGH8WTS3IY5ztruYOit95Wkk6u/KVGdRUT0Q
	bVWWiGzBoEPNg69cqXq8wKkrbMXUl89+yjxTkY8qWcID5USJ9UT26ipvPxYCtq31lkoBP/xFYFI
	2TiMAbiIVT7LeKoZAN8RY6HooeO6POnNOzEjt9O1Usw3f7YnkGh0J7ap1LRIfXau0XLpgXM4or6
	PFNJl0Fn/DEREKQiOJe2sf
X-Received: by 2002:a05:6a20:1f28:b0:3bf:b182:94e with SMTP id adf61e73a8af0-3c110a12782mr3463511637.5.1783785690620;
        Sat, 11 Jul 2026 09:01:30 -0700 (PDT)
Received: from titan.lan ([2603:8000:df01:38f7:255c:dd03:30a6:e57b])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b8deb2a21sm7919739c88.3.2026.07.11.09.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 09:01:29 -0700 (PDT)
From: Ross Philipson <ross.philipson@gmail.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-integrity@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-efi@vger.kernel.org
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
	luto@amacapital.net,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	corbet@lwn.net,
	kanth.ghatraju@oracle.com,
	daniel.kiper@oracle.com,
	andrew.cooper3@citrix.com,
	trenchboot-devel@googlegroups.com
Subject: [PATCH v2 05/10] tpm: Move platform specific definitions to the new PTP header
Date: Sat, 11 Jul 2026 09:01:05 -0700
Message-ID: <20260711160110.267780-6-ross.philipson@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260711160110.267780-1-ross.philipson@gmail.com>
References: <20260711160110.267780-1-ross.philipson@gmail.com>
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
 drivers/char/tpm/tpm_tis_core.h |  64 +--------------
 include/linux/tpm_ptp.h         | 133 ++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 63 deletions(-)
 create mode 100644 include/linux/tpm_ptp.h

diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index aa6d78898ef3..d737b3d67411 100644
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
index 000000000000..e80ed810a269
--- /dev/null
+++ b/include/linux/tpm_ptp.h
@@ -0,0 +1,133 @@
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
+#define TIS_MEM_X86_LPC_BASE		0xFED40000
+#define INTEL_LEGACY_BLK_BASE_ADDR	0xFED08000
+
+enum tis_x86_defaults {
+	TIS_MEM_X86_LEN			= 0x5000,
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
+#define TPM_TIS_INTF_ACTIVE		0x00
+#define TPM_CRB_INTF_ACTIVE		0x01
+
+#define TPM_INTID_INTERFACE_TYPE	GENMASK(3, 0)
+#define TPM_INTID_INTERFACE_VERSION	GENMASK(7, 4)
+#define TPM_INTID_CAP_LOCALITY		BIT(8)
+#define TPM_INTID_CAP_TIS		BIT(13)
+#define TPM_INTID_CAP_CRB		BIT(14)
+#define TPM_INTID_CAP_IF_RES		GENMASK(16, 15)
+#define TPM_INTID_INTERFACE_SELECTOR	GENMASK(18, 17)
+#define TPM_INTID_INTF_SEL_LOCK		BIT(19)
+
+#define TPM_TIS_INTF_12			0x00
+#define TPM_TIS_INTF_13			0x02
+#define TPM2_TIS_INTF_13		0x03
+
+#define TPM_INTF_DATA_AVAIL_INT_SUPPORT		BIT(0)
+#define TPM_INTF_STS_VALID_INT_SUPPORT		BIT(1)
+#define TPM_INTF_LOCALITY_CHANGE_INT_SUPPORT	BIT(2)
+#define TPM_INTF_INTERRUPT_LEVEL_HIGH		BIT(3)
+#define TPM_INTF_INTERRUPT_LEVEL_LOW		BIT(4)
+#define TPM_INTF_INTERRUPT_EDGE_RISING		BIT(5)
+#define TPM_INTF_INTERRUPT_EDGE_FALLING		BIT(6)
+#define TPM_INTF_COMMAND_READY_INT_SUPPORT	BIT(7)
+#define TPM_INTF_BURST_COUNT_STATIC		BIT(8)
+#define TPM_INTF_DATA_TRANSFER_SIZE_SUPPORT	GENMASK(10, 9)
+#define TPM_INTF_INTERFACE_VERSION		GENMASK(30, 28)
+
+#endif
-- 
2.55.0

