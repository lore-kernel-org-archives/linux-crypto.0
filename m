Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805D73C8732
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783785709; cv=none; b=lRZqmibf9UT37Ma0jR8qMRgH2GRthSW/ZGi03HGUsHBvYls+NZzru3hpPs/xIi8Clr0R3v3gr2sQQ/o4fAekZd9MeO2wHI9vsNN4fZE/+zMe1oIQdHNOy8U235SwTlD9DDNw8WqLB0Zx0qiFWNOa6pfnGL53grdSk2HIywzzCLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783785709; c=relaxed/simple;
	bh=mmmPhL/ghHf8mTlJKqyHo4h/T0ggIZB9mghCUZZIJHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZ07GHKty17mGvIFko/DZ2pQBqz0qIXoz1kOT37hv2ic8mk3zStbmSmYAgar+7NRo4lDB4xery0I+ORk26C1zVOHsKMZvcSFwPBQUHTjTKSM/wxKRWmtHNC8XNW/J2CnAx5GufiNNFu0dWypgbTStacte6wtMEMwKlTaJU4sb08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iT6fCAG2; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iT6fCAG2"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ca70925c25so25155055ad.1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783785707; x=1784390507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O3xupweIjZun88NywNw0fLBjpCQuWDRT98MUrOXcsbg=;
        b=iT6fCAG2Jd3dSOYBchOLSK/BQ9vx9aWtc1KVgu4SOG/c2Gb7VKJdJ4vTizFIO91aoS
         IRAIyhoZzYx6BVN1A0kEQBL2/8XVEfZtiZfDPGfE1zssb/XDBpB5Eya2J4rQAfU23xox
         8X1aA/FF30m6mUiWrTmUtMrt1ZuyCgOzunjMy5Xs+pm5jxT0X+wNS6PpnuNdl3mDXZBP
         Yp7RN24Y049nVyWV1PY9rUOmwmwWuFQ9rn9AtKN3t84jG4L2AgIktsLeErpmyG3prNmd
         +4hlPR5w3dPVCwPHX9+Hl+FDM9nQWUEXc+5WB9xWcXgKPTt8laSU5PrpQIOPVTmkiGUI
         gQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783785707; x=1784390507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O3xupweIjZun88NywNw0fLBjpCQuWDRT98MUrOXcsbg=;
        b=PdZCM5ZHslOOPpPUUNebG0k4glcsCYvVEZdbSnFBPHZIqBeljJM7OP3kFNjAoj/OSe
         c0yTDCnukRDLN1+r54eJ4OoCnUhmo1jfsUgz620V+kX7v1AAuhp49CoTSnZSxa9zlDk0
         a5/atZBYceq+ipzDHGPAb6QxXXvR3EHbhpNI2+wyU0xM0sKlyoUVArP/9PBe0lj83YJB
         03XS3zrER82mAgDIh8FfXT/ZDzmhTkAACE5G/rq7uLI605o9dxnOokWrH+reF+iBmO6O
         FSKBw+1idMm1KR2h0YZKFjOeIL9U7+ia4z7H9cVcv5qhOhNvmKxeBbVyHo+q8Fk3BObO
         gpPA==
X-Forwarded-Encrypted: i=1; AHgh+Rponcj2wYxQ0IeTJQBb5T8in6kWfCXUzLo1IxC/kDs2xXQRoRvv/J/Lda+oc9Z+cfwlHZObmETE3mpcpz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyABNa32yCTVF1DISI5Q8zRhPqUBbrmN/s/2ZHU7gzyoq8hDlAB
	lVzLuR3u22uOaCVEuBQdf/nE2j7pMxCP3YLH5NcA79jPCtEBPoTIqZi3
X-Gm-Gg: AfdE7cnQmVFD14PbEMukcIDurMuT6O2mkD1vsnj0+vBmqy6VJUksACIl5JAZAwHIIFy
	ZeYtjTicfk1+B8Qv2LsGckCdT9qtMTEq4thBS2NhysCDQB1F1Ci0tauuxlfFQxuCXxhgJD1/DDQ
	A2nqVheJIhlKXbwoOMTnTrusPCOmWzNkSnKnSmL64UpCafXN7FB40vvC4EeXzcR7+8O7LxO3vwW
	pAOjYnKS5UvM776OkM3n9d2Co0a03PZW1ElFwWSM3NSuNG/gxOFBBiMjQEoLtll+qaYx5HZqHa8
	XwHr9qohWkP58W6qsrdXK/q1rw4M170XIfaPIqSOko+aDGb9MBMkHoC+lQMRJVT5mDLNkrN9T/6
	tG48jG8cDIZsokqcvGKF6yz+VfVF4QMBtUDDnp1pOMXs+hypLQz8rssNTIplvFG5bu3hI0ImLja
	DGrKDqZyMw7oVrTsEyqoJE
X-Received: by 2002:a17:90a:c106:b0:381:20b:a9ee with SMTP id 98e67ed59e1d1-38dc74cf96amr3305712a91.14.1783785706827;
        Sat, 11 Jul 2026 09:01:46 -0700 (PDT)
Received: from titan.lan ([2603:8000:df01:38f7:255c:dd03:30a6:e57b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3120c8e41fcsm20955490eec.15.2026.07.11.09.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 09:01:46 -0700 (PDT)
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
Subject: [PATCH v2 10/10] tpm-buf: Add TPM buffer support header for standalone reuse
Date: Sat, 11 Jul 2026 09:01:10 -0700
Message-ID: <20260711160110.267780-11-ross.philipson@gmail.com>
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

Extract all the functions and definitions for TPM buffer handling
and separate them into their own header.

Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm-buf.c |  3 +-
 include/linux/tpm.h        | 34 +--------------------
 include/linux/tpm_buf.h    | 60 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 34 deletions(-)
 create mode 100644 include/linux/tpm_buf.h

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index 1e5c11c312a8..233e81d3f149 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -4,7 +4,8 @@
  */
 
 #include <linux/module.h>
-#include <linux/tpm.h>
+#include <linux/tpm_command.h>
+#include <linux/tpm_buf.h>
 
 static void __tpm_buf_size_invariant(struct tpm_buf *buf, u16 buf_size)
 {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 598dd53a10d8..0db277af45c3 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -26,6 +26,7 @@
 #include <crypto/aes.h>
 
 #include <linux/tpm_command.h>
+#include <linux/tpm_buf.h>
 
 struct tpm_chip;
 struct trusted_key_payload;
@@ -200,44 +201,11 @@ enum tpm_chip_flags {
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
 
-enum tpm_buf_flags {
-	/* TPM2B format: */
-	TPM_BUF_TPM2B		= BIT(0),
-	/* The buffer is in invalid and unusable state: */
-	TPM_BUF_INVALID		= BIT(1),
-};
-
-/*
- * A buffer for constructing and parsing TPM commands, responses and sized
- * (TPM2B) buffers.
- */
-struct tpm_buf {
-	u8 flags;
-	u16 length;
-	u16 capacity;
-	u8 handles;
-	u8 data[];
-};
-
 struct tpm2_hash {
 	unsigned int crypto_id;
 	unsigned int tpm_id;
 };
 
-void tpm_buf_init(struct tpm_buf *buf, u16 buf_size);
-void tpm_buf_init_sized(struct tpm_buf *buf, u16 buf_size);
-void tpm_buf_reset(struct tpm_buf *buf, u16 tag, u32 ordinal);
-void tpm_buf_reset_sized(struct tpm_buf *buf);
-u16 tpm_buf_length(struct tpm_buf *buf);
-void tpm_buf_append(struct tpm_buf *buf, const u8 *new_data, u16 new_length);
-void tpm_buf_append_u8(struct tpm_buf *buf, const u8 value);
-void tpm_buf_append_u16(struct tpm_buf *buf, const u16 value);
-void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value);
-u8 tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset);
-u16 tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset);
-u32 tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset);
-void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle);
-
 /*
  * Check if TPM device is in the firmware upgrade mode.
  */
diff --git a/include/linux/tpm_buf.h b/include/linux/tpm_buf.h
new file mode 100644
index 000000000000..f8c105d8b8bf
--- /dev/null
+++ b/include/linux/tpm_buf.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Following copyright information was take from the original file
+ * <include/linux/tpm.h> where the definitions were moved from:
+ *
+ * Copyright (C) 2004,2007,2008 IBM Corporation
+ *
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ * Debora Velarde <dvelarde@us.ibm.com>
+ *
+ * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ */
+
+#ifndef __LINUX_TPM_BUF_H__
+#define __LINUX_TPM_BUF_H__
+
+#include <linux/types.h>
+#include <linux/bits.h>
+
+enum tpm_buf_flags {
+	/* TPM2B format: */
+	TPM_BUF_TPM2B		= BIT(0),
+	/* The buffer is in invalid and unusable state: */
+	TPM_BUF_INVALID		= BIT(1),
+};
+
+/*
+ * A buffer for constructing and parsing TPM commands, responses and sized
+ * (TPM2B) buffers.
+ */
+struct tpm_buf {
+	u8 flags;
+	u8 handles;
+	u16 length;
+	u16 capacity;
+	u8 data[];
+};
+
+void tpm_buf_init(struct tpm_buf *buf, u16 buf_size);
+void tpm_buf_init_sized(struct tpm_buf *buf, u16 buf_size);
+void tpm_buf_reset(struct tpm_buf *buf, u16 tag, u32 ordinal);
+void tpm_buf_reset_sized(struct tpm_buf *buf);
+u16 tpm_buf_length(struct tpm_buf *buf);
+void tpm_buf_append(struct tpm_buf *buf, const u8 *new_data, u16 new_length);
+void tpm_buf_append_u8(struct tpm_buf *buf, const u8 value);
+void tpm_buf_append_u16(struct tpm_buf *buf, const u16 value);
+void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value);
+u8 tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset);
+u16 tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset);
+u32 tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset);
+void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle);
+
+#endif
-- 
2.55.0

