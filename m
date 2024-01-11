Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBB515AC2
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 12:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a7991l1T"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3369724e899so2962699f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 04:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704976403; x=1705581203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Wf/mkSRXChTHcUlL2Vb7KqDkWA64XmDkawzZXTOrlfg=;
        b=a7991l1TLpMUF65HpglGRFR+kvzlXGZ8I3CtfOZKKjh0198lm+kMJKgPe1ccwTW70E
         6UNEOrhLQqAMGo78NFkbZEQgTew/eGVS42kz85HJH8n5q4wvaoS8fs51vTvCxZe9D0a9
         1SvK29W27e6qnlDdKgYIrBnfkHJ9tjkYajhxQ47mCqlnuHDXZA6mC2T7zjIqdNKvY1fC
         IgYh8zvUutOFWi8651wd993+uT130UYEcIiVISdKG1A2z2eVEHX2TkVTRZooOIDjLC3N
         ITK8sD3AsHVliwHjBuBa+hOe2wEf7/6FT2p/ZIF0U3mqfzL3mlYzao5p++Gx5S92UW2j
         7Trg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976403; x=1705581203;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wf/mkSRXChTHcUlL2Vb7KqDkWA64XmDkawzZXTOrlfg=;
        b=WIm+4ZqSS7wcuVZpImlwnDZwKrKOP5PSTREtbCTN/SyKVfjNbAcuN/0Krm6MO7Eqrp
         m1GMjxB1R2+5P8oOoKBYAiiCE+k5ypx5YFxCcAFAcwaG5Gfv3YOu5L94PjGtsTYECIct
         yfWUPN0a8by/dSv6hLsYsXK4sj5fs1ja/UCaTUpoPUrhbcbN2c1yY02G0KcsW58Bx8+m
         s2jzgfiRzRigcjYFKXJxMNnOFo7SJXV3uaBzA2zUGC7er3GGClKMwUSAh0n8M9ZIcfmJ
         CojBdWobrC60iH7I8KiYELPLfZJhCYkcP4sEma2kq2x9PHhk2NtITUKTu0dBz9cKkrFG
         s3dg==
X-Gm-Message-State: AOJu0YzqvLWGVMNCUxzoudBNiqbrsv+NLP5DhUdsn2JX9yiil761T5n/
	Xk4PXlXV7TiNcNNPYwcRmds3DdFAJaYqbOJU4Ab8Y6k7f2meBz/UqYad9PifKrw0QMPXatiyIOV
	mvQTMTreGveRWLuXDSYmYd/6oFOS740k74v5diitRTuAxAaR3hwyuypIqEUDtL52Gk4X+1Cw=
X-Google-Smtp-Source: AGHT+IEhkLU43a/j/HQoj2qSXY8KibSro2i8kcZB979O2zcZAjES2M0r0HAIkGy444aMNLYDisxSb4uz
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:6000:983:b0:337:68b0:d6b3 with SMTP id
 by3-20020a056000098300b0033768b0d6b3mr6518wrb.7.1704976402473; Thu, 11 Jan
 2024 04:33:22 -0800 (PST)
Date: Thu, 11 Jan 2024 13:33:03 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1944; i=ardb@kernel.org;
 h=from:subject; bh=/TPz+K6fEhNdUeW4brejkFunArsnPVFr3iZELrKJR+I=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXX+/X+vbWwFj9bfmsJd/+VmFCP/9OZJ26fdWzbdrvt6O
 POXCYevd5SyMIhxMMiKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJHP7EyPCrOdP2j59F8o+N
 xw0+RtzrMwrKa17t/beC/+/6nQz1wmcY/ufmvFmTJnhRbOuKE0olq28mr85brPpRfk3s9Klbat0 2uHEBAA==
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111123302.589910-10-ardb+git@google.com>
Subject: [PATCH 0/8] crypto: Clean up arm64 AES-CCM code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The AES-CCM driver was written 10+ years ago, based on the very first
kernel mode NEON API for arm64, which eagerly preserved/restored the
NEON registers on each call to kernel_neon_begin() resp.
kernel_neon_end().

For this reason, the asm helpers were constructed in a way that used
only 6 NEON registers, as the kernel mode NEON API at the time
implemented an optimization where kernel_neon_begin() took an int
denoting the number of NEON registers to preserve/restore. Given that no
actual hardware existed at the time (except perhaps for APM Xgene1 which
did not implement the crypto instructions), all of this was based on
premature assumptions.

These days, the NEON API is a bit more sophisticated, and does not
bother to preserve/restore anything unless it is needed (e.g., when
context switching or returning to user space). It also no longer
disables preemption. Finally, we've developed some code patterns in the
mean time to deal with tail blocks more cleanly and efficiently.

So let's bring the CCM driver up to date with all of this.

Ard Biesheuvel (8):
  crypto: arm64/aes-ccm - Revert "Rewrite skcipher walker loop"
  crypto: arm64/aes-ccm - Keep NEON enabled during skcipher walk
  crypto: arm64/aes-ccm - Pass short inputs via stack buffer
  crypto: arm64/aes-ccm - Replace bytewise tail handling with NEON
    permute
  crypto: arm64/aes-ccm - Reuse existing MAC update for AAD input
  crypto: arm64/aes-ccm - Cache round keys and unroll AES loops
  crypto: arm64/aes-ccm - Merge encrypt and decrypt asm routines
  crypto: arm64/aes-ccm - Merge finalization into en/decrypt asm helper

 arch/arm64/crypto/Kconfig           |   1 +
 arch/arm64/crypto/aes-ce-ccm-core.S | 270 +++++++-------------
 arch/arm64/crypto/aes-ce-ccm-glue.c | 154 +++++++----
 arch/arm64/crypto/aes-glue.c        |   1 +
 4 files changed, 199 insertions(+), 227 deletions(-)

-- 
2.43.0.275.g3460e3d667-goog

