Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE833EC2D1
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 21:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879680; cv=none; b=Edugt8DHnJPXeXoa4BnEK/0bO9pA1CyLWwu29n5u+1Sdrw5c0L0AAd6SKg07Pp2+qq+tB5uBvY5IR235OYsGoMAXICxdliKX+Kt9C2Wtwr+RvSioW+L5QvJuGF+ALnQnZYvTUTglGXAUY6DjAjcLwkCX8WmEOclnM7J/5iMWUzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879680; c=relaxed/simple;
	bh=53lrliy0YE81pqMpILWMlkkyv1qPCSWN//0gQcdAdOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVoDRVIzoUfeHwbHmpx8/4a+o+EcBz03us6vnliUzlc8PJNREtu6BB1Y4COT6/v4HICKdVbkR5zvWqT60V+OkNDtNwDabUcYZ6i38PrIpe/Jx7bUFLKNXGFt9pABoCSCfZFyGZNhUiWhWBgG6+9JBNYhMh8MAbgU5MKywbEHwww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=coZxNLUV; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="coZxNLUV"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1354403c610so388927c88.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 14:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778879676; x=1779484476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zaLNJCVWymRzHzAosL0l4Cb63oV8tVc7xKx597eZEkQ=;
        b=coZxNLUVyrcW4+qDpIm9h5KsdOEZWCz2mv/nyyNz6xPun9i04yI7IEbuqeCcEA0Qvo
         CgivbygcWx0y7mhjfCmX18Xhzn5RGGCZG5QjQIefM2kR6VCGk53vZyK+JaK0zwk7Gx1d
         chHzp7T1pf3t+s/JLVCigdlmd1eGo8/R3hfUzaSHyYJZRe2droz6Mi23YqCkEtxhCJfQ
         PINrqjyV0NTayQbZmjsA83XgxsDWW8qAyI3BP3aBYfb6/nnQnY4uOxlSs9Nllt9hD8tF
         d65Lj6T5vP8vOXD9/vzC8mh30K9mShaK4LbuVvMpojiNuar0rgHSi7GT1nIGWUpwBUDM
         jK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778879676; x=1779484476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zaLNJCVWymRzHzAosL0l4Cb63oV8tVc7xKx597eZEkQ=;
        b=qnS1hxnLWu4wuEaTeWvoJ5v8LkvJirCBHS0yg1ZzZOMvlNcVDHE0VO8IgpN6gDyjU6
         gBSFgJ67ZntYInYvMNHFq3fECMjwKdKGa7kW+6LMGdgucLSPg/eSticVVRpIxAp9IRVY
         ahLgeX1f1nJDpyOZu3TjO/7TOsXF43owq1bPj7SW/M2cbMhSlTQCdH70hAx8j7mPhhSk
         N542LRsh1Z5uBsqIgEQa4FX0gbBBGg5DeMtyn3yqn8MwJO7mMNwQjXsB/UdjFqfqQUNQ
         zSGNUiPL/XL7zT3qCaAeVXTS3Wqv+M/W7kcChB6131AMFr1G7TRRHRhow0AfTYqT8C6m
         Nk6g==
X-Forwarded-Encrypted: i=1; AFNElJ/YiVMqilhH/KGffymOpohALVt1udeokf1hmZ5+nzoWRYD1YqV56vYAjuYuFbY2UVk5GUpWM8NEYdvnZ1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSL4ROp2+oUQlrESlK7sTf/Snsa9NeZOsUlTKvnckyUIbWKg/e
	DYfEjw1h4iSFo8J9esZKAMC3Htg0GaJgPnY6yaYqH9JqNuQHbDr+SmOb
X-Gm-Gg: Acq92OHkswEp7lty+ICXG4Td8N6asSvoiEp6aiPFHLgCAZqtTq0tTffdSENBJqt0xEK
	a2fISR6WlK218WqIUC/p2OgeTzBb9H5+hWWiqlhw1SdrcqaoGMD+KdSoLoVEsTxNaE+uTlg1gEO
	FP+ibPQWzF+/4Ji5VW/g3JlnMJ3BiNV5z07uoIYRZd29PEeiA0E8azKcUbWwvkgqmbA+6xGmS6J
	TQ1bV8u13QF+6r4/sqkzhEKsmu0KBQMd0ae//1T9Mdm61GRxl1EeunNEXGnCjjjZ4KlPW4jP/aa
	TcTcn3CyymjQ1P+CtBGnuxBzQFVj74nygWQttgeBI2DX2/zFphhLM6jAkk0NKjEWnUG54QxIoMU
	sYXxbjXr8pXiwkdEMhHEwRDs90GpoyS+2C7sE6fBXWF5oFYqFCxNQOCFmg8IUhmXuo1/0iDVu2A
	leMJAJ5Om7fRFoivRPWSr1cVDmwKPjMG0=
X-Received: by 2002:a05:7022:6b9a:b0:12d:de3e:86aa with SMTP id a92af1059eb24-13505642857mr2505039c88.40.1778879675567;
        Fri, 15 May 2026 14:14:35 -0700 (PDT)
Received: from mimas.lan ([2603:8000:df01:38f7:a6bb:6dff:fecf:e71a])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cc33a618sm11242540c88.12.2026.05.15.14.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 14:14:35 -0700 (PDT)
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
Subject: [PATCH v16 08/38] tpm-buf: Remove chip parameter from tpm_buf_append_handle()
Date: Fri, 15 May 2026 14:13:40 -0700
Message-ID: <20260515211410.31440-9-ross.philipson@gmail.com>
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
index 1fa3e8a43c79..c9dc35b57687 100644
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
index 3b1cf1ca0420..eb67ae14ad73 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -257,7 +257,7 @@ int tpm_buf_append_name(struct tpm_chip *chip, struct tpm_buf *buf,
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
2.47.3

