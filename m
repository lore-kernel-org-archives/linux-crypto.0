Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085A83C872A
	for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783785703; cv=none; b=gbnLNApi6jnQga3nEdYkAQaXq7AuO2c1jKmHLL7eBcovsRk/fJ6wSL0/cLFx8CSV1b91AeQWWrwd3b453jlirdnhYUBZ8Qdzw6vGF/f1KRa1yV5T0MJ1OBMFHUg/JSZ5Tllo9oKWEwBl9PmkL8pinxEkFSq8DFkDrnvXBmwCR0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783785703; c=relaxed/simple;
	bh=OhR3jksgiJE0o7foAJ3ocqiSNmyJW9mbxX+rNOXqb98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgmoxI8FpqRyGWWmIY00oyKoDdQ7TESgibg7NUZ2AygL3bcEVHEwPZD087isbyMdcjAMNqwGkksZarhl1ZWr+WyJHLHgtDoFfPLkW0QfYatMtMTAobKvMlxztx59CG42pX3HykYKT1M6kGQ1W3xoGHtwnIvkK4k9lnCJ/rpvbrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c9cXs2Tp; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9cXs2Tp"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so790836a91.0
        for <linux-crypto@vger.kernel.org>; Sat, 11 Jul 2026 09:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783785700; x=1784390500; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5tpVMPDTFvUicz2+KLP8Hde8q3QB+Jxc+FUe7rT1AhQ=;
        b=c9cXs2TpEjXm1a4uDiNX96FO7aegjxbngYacQH1eKdK3vtFtIYb42DaRy0EmNWa7cR
         3U5j4lUU8MkGX3rFOJw01ZH5wecRSS1dxB6kybij/bR413DgR8TbFmO09Vc1SUM1areP
         G7bszIDezITBC9Ql6csioBDePNHncBvcKQk+rNE0WkTbOT4YshQfoMCa8XkEplMx70bT
         8zmUPJaitIRj9iE8UDOI93BQnKDOeiC8FHsIoAHipnUPkS6VT3C9GUmLGtrYRVevLFUi
         fm2+ZTzu4WuZRJeuWJJqVJlaO9OuAmDAjJOLEKhHP8ezuVGaKeLDj4mpqBHjbRoKPtS3
         8wVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783785700; x=1784390500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5tpVMPDTFvUicz2+KLP8Hde8q3QB+Jxc+FUe7rT1AhQ=;
        b=f+czhxbVdAgSiILRdvmmtKmvAAq1pH2AwN7cf1zu6C+DiieSTBeUhUfFA7DxE/KAiz
         VPNmwsPMkauOeCqdfySxx+2nEKf1xkNkS33Ob259IrlpiYPzZWgtwvoxQ2v5zFum9h8i
         ZIx3ajH5DqMWuiV0CA0LggzyVm+/eXHPAxh8eKc6pvYBo5GwCXRPQnlf9NbbT4WjZHgl
         NxplDB68UAc69KWpncK1fG5bvIGmcIX5wZvHIvEVUzxOPkjy9bCBrlYJiXP4zdt5pkFq
         cNx/r7jadq2LU0FmtyECn2r9vhuKjMiCNc8vUl4zI2jaWrx9ETWddYiAuz+qZx+TXaC9
         jgIQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq+eNWxEm60JmotPJ18c47bvKEnXoRZnVBwiBmxL8+rQyOK9B+IvAc5e5ovTFTgUVxlYUhnV+bNR//cllQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgktOCf5epm8RmmxrtUVw0uJ9GacJk1TpplU9LHHQ7pcCxFE8f
	ct4kTWKHD2QT7IhruM5H3E1zznb5k1HdIJ5yuNlF8PY2vkDjJy+LwF83
X-Gm-Gg: AfdE7cnzsY5DPmWT+zKc0Rn6dGwgGPupMem29D46KgnFn6yHzquEZDOkn+h7LIlbAoj
	HW0dOxrzEhiQDts2ae+0W4PW0XvhEOfOqt7EHpvLTm4Y169MXbkR1nhVhWWZVYc/oNyRCHM3h5E
	jrelid3XpaHw2Gd9yX4BGftsGITTt9mI2p2g8UbPV/d5b1Evc4gVwJ/+pQsAkWl84zdzdUFjCE0
	4Lgg3N6wIGxpaZYbgPKZbAO+I7yA868Ppt35s3SYqKXF6/G4BjoIOxJGqvIaCDSH5lq6YbFPaDk
	iz4tV0NcHocwqKwoLFGSzTFCB3guaM6+sMFqqz84GhrRptnhQar43w7ipkS3a4vciplOOrXnsdX
	4pexRNW+7jxrA8RZPABbjreaWgsJCvyn3EieN3TELjBy6VOJALaoTa2V21Duh2oVCgW9tZ5SYBo
	OQESYuZvFEDYOL3AGJ8qZr
X-Received: by 2002:a17:90b:5343:b0:37f:ad36:8fc5 with SMTP id 98e67ed59e1d1-38dc7759428mr3420382a91.23.1783785700259;
        Sat, 11 Jul 2026 09:01:40 -0700 (PDT)
Received: from titan.lan ([2603:8000:df01:38f7:255c:dd03:30a6:e57b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-313b9ca880fsm12560829eec.23.2026.07.11.09.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 09:01:39 -0700 (PDT)
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
Subject: [PATCH v2 08/10] tpm-buf: Remove chip parameter from tpm_buf_append_handle()
Date: Sat, 11 Jul 2026 09:01:08 -0700
Message-ID: <20260711160110.267780-9-ross.philipson@gmail.com>
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

Remove the TPM driver chip parameter from the function
tpm_buf_append_handle(). The chip parameter is only for error logging
which can be done with other facilities like WARN().

Message-ID: <20260125192526.782202-11-jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
Signed-off-by: Ross Philipson <ross.philipson@gmail.com>
---
 drivers/char/tpm/tpm-buf.c       | 9 ++++++---
 drivers/char/tpm/tpm2-cmd.c      | 2 +-
 drivers/char/tpm/tpm2-sessions.c | 2 +-
 include/linux/tpm.h              | 2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-buf.c b/drivers/char/tpm/tpm-buf.c
index 61833b4d81f0..99811809a72a 100644
--- a/drivers/char/tpm/tpm-buf.c
+++ b/drivers/char/tpm/tpm-buf.c
@@ -146,17 +146,20 @@ EXPORT_SYMBOL_GPL(tpm_buf_append_u32);
 
 /**
  * tpm_buf_append_handle() - Add a handle
- * @chip:	&tpm_chip instance
  * @buf:	&tpm_buf instance
  * @handle:	a TPM object handle
  *
  * Add a handle to the buffer, and increase the count tracking the number of
  * handles in the command buffer. Works only for command buffers.
  */
-void tpm_buf_append_handle(struct tpm_chip *chip, struct tpm_buf *buf, u32 handle)
+void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle)
 {
+	if (buf->flags & TPM_BUF_INVALID)
+		return;
+
 	if (buf->flags & TPM_BUF_TPM2B) {
-		dev_err(&chip->dev, "Invalid buffer type (TPM2B)\n");
+		WARN(1, "tpm-buf: invalid type: TPM2B\n");
+		buf->flags |= TPM_BUF_INVALID;
 		return;
 	}
 
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 280f870e6517..c7952319384e 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -198,7 +198,7 @@ int tpm2_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
 		}
 		tpm_buf_append_hmac_session(chip, &buf, 0, NULL, 0);
 	} else {
-		tpm_buf_append_handle(chip, &buf, pcr_idx);
+		tpm_buf_append_handle(&buf, pcr_idx);
 		tpm_buf_append_auth(chip, &buf, NULL, 0);
 	}
 
diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index a1ae5e1829cb..0d89643e6880 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -260,7 +260,7 @@ int tpm_buf_append_name(struct tpm_chip *chip, struct tpm_buf *buf,
 #endif
 
 	if (!tpm2_chip_auth(chip)) {
-		tpm_buf_append_handle(chip, buf, handle);
+		tpm_buf_append_handle(buf, handle);
 		return 0;
 	}
 
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 3c6a5bcc138a..b357f8971d03 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -235,7 +235,7 @@ void tpm_buf_append_u32(struct tpm_buf *buf, const u32 value);
 u8 tpm_buf_read_u8(struct tpm_buf *buf, off_t *offset);
 u16 tpm_buf_read_u16(struct tpm_buf *buf, off_t *offset);
 u32 tpm_buf_read_u32(struct tpm_buf *buf, off_t *offset);
-void tpm_buf_append_handle(struct tpm_chip *chip, struct tpm_buf *buf, u32 handle);
+void tpm_buf_append_handle(struct tpm_buf *buf, u32 handle);
 
 /*
  * Check if TPM device is in the firmware upgrade mode.
-- 
2.55.0

