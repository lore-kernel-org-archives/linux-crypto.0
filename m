Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF883CEB99
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783785699; cv=none; b=j4wG8idvm8n6awUB7j2IPxH/cvkZJfu7A50WO3ayxAMBCl4Mam2wxLaXuVVy99rnbKh6JCqY9XO/ZkMYpWv/YGdaOsFBFwxzwoWgpxk3cmtSsOpV811EXZVph3Y85gUVYsZxuPiCRjLvjJOCJqKlYgy3qva52O2MZ4xinkPY6aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783785699; c=relaxed/simple;
	bh=1PD25Skogk+2yRj9Uzijb04l6UX9XacubnQOr/KgGiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxqM/p4rRgMew2JbFsyJpdFqnGNTsXgnttUU+fy/IedU4LXmgFAiWcaToiN5qU+nSm0xhtCjX3EgkYGAbGfWYUnAaLFREnGyqXPDXLf0N8UmnZtzgdYVup+jLpRi80S2wzY8MmWnkRf6a/rHhYMOkEQI5MhpodXYFUB8wV+BXXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bb3GS/A3; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bb3GS/A3"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c96bfabc8d4so1219462a12.3
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 09:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783785697; x=1784390497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6itu2RYS2dJ1iEvAxavewh2t/11TJ7k1bnRtobjHT0c=;
        b=bb3GS/A3GnSbGCXN/qyC40OpAChEnckcB+Lud+A/ZDBdHUKfvy9/+Z1NWmZMBLtg5B
         aUOwPN9MU5tZyqRYPdjZG4z8Qa3GX8gEKhM4S73y7Pgrw+XWn0G5B4mI48JcY+rXAI4t
         18x9QcgFKUdXcyaMtGSJfj9sc165iDqBjv41mB/Wl3otqOgZ/wYo2h60oecP60OO5Op1
         aV82e8iUENIJNDeesrxrtqLfs0OudXiWncIUn1Bav5F32kMO6mvL323vA5MdZe6FGijY
         yQBBRPXIMdCOFbTjmDp2hZTDLqA1Tjgm4tysswDkJ6s4eoBdDxmCB+R9HEdZbIm3YSat
         Xfyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783785697; x=1784390497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6itu2RYS2dJ1iEvAxavewh2t/11TJ7k1bnRtobjHT0c=;
        b=Y2fzavddxq5VzJDbkOqOpHBIHaRMWP4ki1Pia2vlwYm2t+bfa9rUDZn2wKT2SN5Udz
         nHsH6cbawVHkbFUUhm4zvdHzoMazcq4o4YgFKVTHnmla7jaxMCxU/dnimWXAIpBm0fUY
         xzrYOGoFzuQJSIfNQa+pkxspUEnEADUUCmyXAmmJkSzHrTfZEQyGIRZR4uhSJlpZduZd
         ZzN3G6RYoLvZADDZzN1PmtVOm9wDWb+0R2CzDbhphB1vR7VvRphqrLxNigZV81yHbx3M
         dIiceE6+HRfYaxzphH7CBC0NWZcmy78Jf1ZYR7Cm4lQbz0yR6N/Ra+J7heg3yBC5YspO
         gYGg==
X-Forwarded-Encrypted: i=1; AHgh+RplAftAutPBW3QICMeQegE7SMdgHXsN/fUnXc3h9x5N1Ofqx18YqF8iGjDcLqg6nP5487mAOOLPlfui+FE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMqTBL1OsBKhOns56EU2yGc1nr18fNsOZc1wUcOThiXoFuatZf
	k0dWIudkj4kOTHy/jAWtll77qLBR8mJiZNntCW1WYeMm/YTR+KKpl2VHNXhokYeu
X-Gm-Gg: AfdE7cnuYYdlEHo74Th/4H+Jx1OB5ib7rkChTJz9RfMALpW0/0Ou9tDZTfuQim0tOnG
	o1By/UJu+1QnusekGPkibVGDQpsM7tuAXLkQvu5fJZeAtNYuoo1U5sci9oIlOqdZ6+RMN3GytTk
	fKumhuRcWHp8Pm/XKC/YkM54HS/EYrQmGyIU1yNAUStSKsYdJ9ZsZUjeed1Dv6HMFGeEU8s1Hy3
	woXWdAjNNDUWETlpKkPpGsshqTZcBeOGqzBysPf6W7sFRCLBUsm5E+QtU9pXm/fAQGJZFF1n/Ax
	S9eP4fYkDCMaHaNcUPGTIUxBtW+uJiLxDwCEuqhq0wqgX7YzV8C9xq2mKUHRZXcCRvwZvBUkdH/
	noSnGKNgk+ZKIZNgDumWAzzRxF6gj1i+Y7GBnfASy2t3nWOh76aiS7qsW5qgUi/QDdnVxx6Ffp5
	brMwjO2zlOyNMqaI8O7ABJ
X-Received: by 2002:a05:6a21:398d:b0:3c0:b3f7:e5dd with SMTP id adf61e73a8af0-3c110a74439mr3515794637.42.1783785697121;
        Sat, 11 Jul 2026 09:01:37 -0700 (PDT)
Received: from titan.lan ([2603:8000:df01:38f7:255c:dd03:30a6:e57b])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659d8da9sm92579946c88.14.2026.07.11.09.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 09:01:36 -0700 (PDT)
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
Subject: [PATCH v2 07/10] tpm-buf: Merge TPM_BUF_BOUNDARY_ERROR and TPM_BUF_OVERFLOW
Date: Sat, 11 Jul 2026 09:01:07 -0700
Message-ID: <20260711160110.267780-8-ross.philipson@gmail.com>
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

From: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>

Merge TPM_BUF_BOUNDARY_ERROR and TPM_BUF_OVERFLOW flags into
the TPM_BUF_INVALID flag, as their behavior is identical (the only
difference being the associated log messages).

Message-ID: <20260125192526.782202-11-jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
Reviewed-by: Jonathan McDowell <noodles@meta.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm-buf.c                | 10 ++++------
 include/linux/tpm.h                       |  8 +++-----
 security/keys/trusted-keys/trusted_tpm2.c |  6 +++---
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index 4c4f450630df..61833b4d81f0 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -103,13 +103,12 @@ EXPORT_SYMBOL_GPL(tpm_buf_length);
  */
 void tpm_buf_append(struct tpm_buf *buf, const u8 *new_data, u16 new_length)
 {
-	/* Return silently if overflow has already happened. */
-	if (buf->flags & TPM_BUF_OVERFLOW)
+	if (buf->flags & TPM_BUF_INVALID)
 		return;
 
 	if ((buf->length + new_length) > PAGE_SIZE) {
 		WARN(1, "tpm_buf: write overflow\n");
-		buf->flags |= TPM_BUF_OVERFLOW;
+		buf->flags |= TPM_BUF_INVALID;
 		return;
 	}
 
@@ -176,14 +175,13 @@ static void tpm_buf_read(struct tpm_buf *buf, off_t *offset, size_t count, void
 {
 	off_t next_offset;
 
-	/* Return silently if overflow has already happened. */
-	if (buf->flags & TPM_BUF_BOUNDARY_ERROR)
+	if (buf->flags & TPM_BUF_INVALID)
 		return;
 
 	next_offset = *offset + count;
 	if (next_offset > buf->length) {
 		WARN(1, "tpm_buf: read out of boundary\n");
-		buf->flags |= TPM_BUF_BOUNDARY_ERROR;
+		buf->flags |= TPM_BUF_INVALID;
 		return;
 	}
 
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 3630b2ea6aef..3c6a5bcc138a 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -201,12 +201,10 @@ enum tpm_chip_flags {
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
 
 enum tpm_buf_flags {
-	/* the capacity exceeded: */
-	TPM_BUF_OVERFLOW	= BIT(0),
 	/* TPM2B format: */
-	TPM_BUF_TPM2B		= BIT(1),
-	/* read out of boundary: */
-	TPM_BUF_BOUNDARY_ERROR	= BIT(2),
+	TPM_BUF_TPM2B		= BIT(0),
+	/* The buffer is in invalid and unusable state: */
+	TPM_BUF_INVALID		= BIT(1),
 };
 
 /*
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 29d79c05ed6b..779a2e66ac20 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -312,7 +312,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	/* creation PCR */
 	tpm_buf_append_u32(&buf, 0);
 
-	if (buf.flags & TPM_BUF_OVERFLOW) {
+	if (buf.flags & TPM_BUF_INVALID) {
 		rc = -E2BIG;
 		tpm2_end_auth_session(chip);
 		goto out;
@@ -328,7 +328,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 		goto out;
 
 	blob_len = tpm_buf_read_u32(&buf, &offset);
-	if (blob_len > MAX_BLOB_SIZE || buf.flags & TPM_BUF_BOUNDARY_ERROR) {
+	if (blob_len > MAX_BLOB_SIZE || buf.flags & TPM_BUF_INVALID) {
 		rc = -E2BIG;
 		goto out;
 	}
@@ -441,7 +441,7 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
 
 	tpm_buf_append(&buf, blob, blob_len);
 
-	if (buf.flags & TPM_BUF_OVERFLOW) {
+	if (buf.flags & TPM_BUF_INVALID) {
 		rc = -E2BIG;
 		tpm2_end_auth_session(chip);
 		goto out;
-- 
2.55.0

