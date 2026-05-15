Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD5635E1C9
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879658; cv=none; b=jwtFImhQxD8UKB7gG8JG4h93pFuAY3/X45hL2AJzkgs7JTNgVQTS5NGLBpfaZow1Ccl5a2ODvrqg85t+2txd7mhNSBuIfFWNEPlPGjQfYbzvL3uKzjmWF7Dy7X+ypPuWoX/zIxR4JSAtj+yNf77XN1wci8DQOk2upb1ZtbtdEmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879658; c=relaxed/simple;
	bh=JgJyVLfDqMQljVqRU1MTHdSlUCVaSc0hfEkcczuhqcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8Edk09MuIPk7hhybGwpfBhEyMEP92yp0Gjp0W/VIxuhToZsv26Gp63XAPs74N30IzTB0kBM6xpsuK9ktiQ47DqFX9HdWDh5cPno4MFO2wtv6ioZ1fJarQHxtu97IwN89w0IrKCIrdqIodLuhSw5zuakIpfVaSOB0PFZHsAi3mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VtfgL7d7; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VtfgL7d7"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2b4520f6b32so434593eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879655; x=1779484455; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rg1O72SYx+Mww3ZjC2LhL3IwBU8aOcEM6iuwyJssfKc=;
        b=VtfgL7d7KSiuzNG5iroeCd6PGRFsxK0zNEtY8VbbevY++FbZegbne6D+xeV/Yg8VPu
         0YkrmF92wtCJFFViCyPILayp3jMOl2/0IB8Qmo5NRMZKIWOw+5qQa5+J3TKDpHh24F+N
         +BmMea9opbRfHaopvH/yYiOnULGA1qpdso2BgEhyZ5tngPmmQL7NuKuBp7U+FrAb4UCZ
         UV2p3OqvzcW/dtwIgEWg2mnMizv71blKbRo8N2n/w+VkhNLiyxGDLZyMes3DnIZskMXK
         5uFoPzGhxR9XjbFxeImU3YCkrV8DkV/9OqBXQhSEkAydAnCDQA6vBEanT1VLiENLB1AR
         GkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879655; x=1779484455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rg1O72SYx+Mww3ZjC2LhL3IwBU8aOcEM6iuwyJssfKc=;
        b=C5f+g8aSSFgdBEYklQQvWvE/mC9OH/tQZTKeW3YSEeB1WxhzQsbLjIRAUO5i+s/dMi
         ZrF5BPUVuCeeY5MXXu70OVkFwHPm/u8NMWwxqZXOqZIssQvwoKzVvUdrX9luOv3dWjUB
         Hk8d5bcyGzO5BOOlCkiAle3/baB0jrt1dk5TjZQ59eGHvzcx1MKuae0dxRx5ixx8654A
         OXBp//5tqgtsK6lyMcx5x6CoCl6L8UBWjWDaNA399izrPjaARrOQgyhK6pd7/a/t5DS0
         3uoCw/uyviPSpgRNO0M5pHAr6/ok9vUuYlU60znU0ct5YZKOcwOWva/s/zlMNjyxcuie
         wKKQ==
X-Forwarded-Encrypted: i=1; AFNElJ/BaNAhYmXj74DX/dLLy5awWuuGIwxys/vEOvIU43SwnPj8N5AlAVWRFpP6KdSV5ftkUd+iVL1KzK4fOww=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgzRb3diTOdSrxEnlZN9c2OhBcwcnRdvFHcphdiQE4MhIaG8A+
	c4IVgx9pTcfZbCYfMQoEMC6nkdyzAQ7HiuGrbpNMqwzOsqrM//a8B7Sw
X-Gm-Gg: Acq92OFiXoTLzvxBlH6UtKvQi3hX3Bx7oWyUS4EXV2oTGnaEJfc8k1uQ6GLMReErjMF
	WeF2l+blOVlqJgcAjZlXosiiwtJjePGj68YlZVCPh24qfTsktI1a79qbwuQzXpheXweU891cqQ4
	QMKcagxfCVCgf41mH1MEqntEI1O7b4JtcUu8sdC7WqgnHIsYW1q7vDrhhUxojXJysFvUsEWODio
	+7iNS6J8sJPm9LoOFDPmayl9UdDTozwlOuPTkm/edTdN+QMKyzVQuzHeVg0oi8FfGD1yCiSkjgo
	YlMT8M2Ffmg4xUSkQlH2qub1RwX8vkUmPRMmsZaepmDDdyDHL6OvryowOcuLegyfwt4UbXwslWm
	HkAOsA4PqT7iYXVuKqHafE3yVMdLKoFLQ00DLc6sfPnN3CVCXp2TopfuQxPNZHyuhuANE22vg7U
	LzYlfA3vWh3srcWx8wK8ujI5maivWRZ4A=
X-Received: by 2002:a05:7300:6c05:b0:2d8:df01:d9f6 with SMTP id 5a478bee46e88-3039864d5c1mr2737865eec.23.1778879655311;
        Fri, 15 May 2026 14:14:15 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-302947e917dsm8003313eec.12.2026.05.15.14.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:14 -0700 (PDT)
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
Subject: [PATCH v16 01/38] tpm: Initial step to reorganize TPM public headers
Date: Fri, 15 May 2026 14:13:33 -0700
Message-ID: <20260515211410.31440-2-ross.philipson@gmail.com>
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

Consolidate TPM1 constants in tpm_command.h and remove duplicate
constants from tpm1-cmd.c.

Co-developed-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Signed-off-by: Daniel P. Smith <dpsmith@apertussolutions.com>
Co-developed-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Alec Brown <alec.r.brown@oracle.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm-buf.c                |  1 -
 drivers/char/tpm/tpm1-cmd.c               | 14 +-------
 include/keys/trusted_tpm.h                |  1 -
 include/linux/tpm.h                       |  2 ++
 include/linux/tpm_command.h               | 41 ++++++++++++++++-------
 security/keys/trusted-keys/trusted_tpm1.c |  1 -
 security/keys/trusted-keys/trusted_tpm2.c |  1 -
 7 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index dc882fc9fa9e..4c4f450630df 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -3,7 +3,6 @@
  * Handling of TPM command and other buffers.
  */
 
-#include <linux/tpm_command.h>
 #include <linux/module.h>
 #include <linux/tpm.h>
 
diff --git a/drivers/char/tpm/tpm1-cmd.c b/drivers/char/tpm/tpm1-cmd.c
index b49a790f1bd5..664ca1fff2e8 100644
--- a/drivers/char/tpm/tpm1-cmd.c
+++ b/drivers/char/tpm/tpm1-cmd.c
@@ -22,8 +22,6 @@
 
 #include "tpm.h"
 
-#define TPM_MAX_ORDINAL 243
-
 /*
  * Array with one entry per ordinal defining the maximum amount
  * of time the chip could take to return the result.  The ordinal
@@ -308,9 +306,6 @@ unsigned long tpm1_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
 		return duration;
 }
 
-#define TPM_ORD_STARTUP 153
-#define TPM_ST_CLEAR 1
-
 /**
  * tpm1_startup() - turn on the TPM
  * @chip: TPM chip to use
@@ -459,7 +454,6 @@ int tpm1_get_timeouts(struct tpm_chip *chip)
 	return 0;
 }
 
-#define TPM_ORD_PCR_EXTEND 20
 int tpm1_pcr_extend(struct tpm_chip *chip, u32 pcr_idx, const u8 *hash,
 		    const char *log_msg)
 {
@@ -478,7 +472,6 @@ int tpm1_pcr_extend(struct tpm_chip *chip, u32 pcr_idx, const u8 *hash,
 	return rc;
 }
 
-#define TPM_ORD_GET_CAP 101
 ssize_t tpm1_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 		    const char *desc, size_t min_cap_length)
 {
@@ -511,7 +504,6 @@ ssize_t tpm1_getcap(struct tpm_chip *chip, u32 subcap_id, cap_t *cap,
 }
 EXPORT_SYMBOL_GPL(tpm1_getcap);
 
-#define TPM_ORD_GET_RANDOM 70
 struct tpm1_get_random_out {
 	__be32 rng_data_len;
 	u8 rng_data[TPM_MAX_RNG_DATA];
@@ -580,13 +572,12 @@ int tpm1_get_random(struct tpm_chip *chip, u8 *dest, size_t max)
 	return rc;
 }
 
-#define TPM_ORD_PCRREAD 21
 int tpm1_pcr_read(struct tpm_chip *chip, u32 pcr_idx, u8 *res_buf)
 {
 	struct tpm_buf buf;
 	int rc;
 
-	rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND, TPM_ORD_PCRREAD);
+	rc = tpm_buf_init(&buf, TPM_TAG_RQU_COMMAND, TPM_ORD_PCR_READ);
 	if (rc)
 		return rc;
 
@@ -609,7 +600,6 @@ int tpm1_pcr_read(struct tpm_chip *chip, u32 pcr_idx, u8 *res_buf)
 	return rc;
 }
 
-#define TPM_ORD_CONTINUE_SELFTEST 83
 /**
  * tpm1_continue_selftest() - run TPM's selftest
  * @chip: TPM chip to use
@@ -726,8 +716,6 @@ int tpm1_auto_startup(struct tpm_chip *chip)
 	return rc;
 }
 
-#define TPM_ORD_SAVESTATE 152
-
 /**
  * tpm1_pm_suspend() - pm suspend handler
  * @chip: TPM chip to use.
diff --git a/include/keys/trusted_tpm.h b/include/keys/trusted_tpm.h
index 0fadc6a4f166..3a0fa3bc8454 100644
--- a/include/keys/trusted_tpm.h
+++ b/include/keys/trusted_tpm.h
@@ -3,7 +3,6 @@
 #define __TRUSTED_TPM_H
 
 #include <keys/trusted-type.h>
-#include <linux/tpm_command.h>
 
 extern struct trusted_key_ops trusted_key_tpm_ops;
 
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 202da079d500..1846d5485a2c 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -25,6 +25,8 @@
 #include <crypto/hash_info.h>
 #include <crypto/aes.h>
 
+#include <linux/tpm_command.h>
+
 #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
 
 #define TPM2_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
diff --git a/include/linux/tpm_command.h b/include/linux/tpm_command.h
index f5c03e9c3913..174b043d8bbc 100644
--- a/include/linux/tpm_command.h
+++ b/include/linux/tpm_command.h
@@ -3,27 +3,42 @@
 #define __LINUX_TPM_COMMAND_H__
 
 /*
- * TPM Command constants from specifications at
- * http://www.trustedcomputinggroup.org
+ * == TPM 1 Family Chips ==
+ *
+ * TPM 1.2 Main Specification:
+ * https://trustedcomputinggroup.org/resource/tpm-main-specification/
  */
 
+#define TPM_MAX_ORDINAL	243
+
 /* Command TAGS */
-#define TPM_TAG_RQU_COMMAND             193
-#define TPM_TAG_RQU_AUTH1_COMMAND       194
-#define TPM_TAG_RQU_AUTH2_COMMAND       195
-#define TPM_TAG_RSP_COMMAND             196
-#define TPM_TAG_RSP_AUTH1_COMMAND       197
-#define TPM_TAG_RSP_AUTH2_COMMAND       198
+enum tpm_command_tags {
+	TPM_TAG_RQU_COMMAND		= 193,
+	TPM_TAG_RQU_AUTH1_COMMAND	= 194,
+	TPM_TAG_RQU_AUTH2_COMMAND	= 195,
+	TPM_TAG_RSP_COMMAND		= 196,
+	TPM_TAG_RSP_AUTH1_COMMAND	= 197,
+	TPM_TAG_RSP_AUTH2_COMMAND	= 198,
+};
 
 /* Command Ordinals */
-#define TPM_ORD_GETRANDOM               70
-#define TPM_ORD_OSAP                    11
-#define TPM_ORD_OIAP                    10
-#define TPM_ORD_SEAL                    23
-#define TPM_ORD_UNSEAL                  24
+enum tpm_command_ordinals {
+	TPM_ORD_CONTINUE_SELFTEST	= 83,
+	TPM_ORD_GET_CAP			= 101,
+	TPM_ORD_GET_RANDOM		= 70,
+	TPM_ORD_PCR_EXTEND		= 20,
+	TPM_ORD_PCR_READ		= 21,
+	TPM_ORD_OSAP			= 11,
+	TPM_ORD_OIAP			= 10,
+	TPM_ORD_SAVESTATE		= 152,
+	TPM_ORD_SEAL			= 23,
+	TPM_ORD_STARTUP			= 153,
+	TPM_ORD_UNSEAL			= 24,
+};
 
 /* Other constants */
 #define SRKHANDLE                       0x40000000
 #define TPM_NONCE_SIZE                  20
+#define TPM_ST_CLEAR			1
 
 #endif
diff --git a/security/keys/trusted-keys/trusted_tpm1.c b/security/keys/trusted-keys/trusted_tpm1.c
index 6ea728f1eae6..0d3244af8de3 100644
--- a/security/keys/trusted-keys/trusted_tpm1.c
+++ b/security/keys/trusted-keys/trusted_tpm1.c
@@ -18,7 +18,6 @@
 #include <keys/trusted-type.h>
 #include <linux/key-type.h>
 #include <linux/tpm.h>
-#include <linux/tpm_command.h>
 
 #include <keys/trusted_tpm.h>
 
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 6340823f8b53..29d79c05ed6b 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -9,7 +9,6 @@
 #include <linux/string.h>
 #include <linux/err.h>
 #include <linux/tpm.h>
-#include <linux/tpm_command.h>
 
 #include <keys/trusted-type.h>
 #include <keys/trusted_tpm.h>
-- 
2.47.3

