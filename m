Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B5E1B9859
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 12:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725365396; cv=none; b=sYjcZLtMIx9H+69tXZApOuv1rCBgCv/k8Bm2gl3ty4rUBIyMQqgjQJeJhAR2JzKtuk+SmYU27qMFMlm2sejq1csyjdklYtmTWc8UDerXuP0Oaw3C6uPPI8fRZBY3Khd/AIWbFtPWZaUgFohlMRHfKVuOfBPzUqWaVlAF1coH3gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725365396; c=relaxed/simple;
	bh=N1qqn7vYKBlbeXYmAR1aaSBjOkAuuoIsPmVXjG1IKa0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YPNt7XOGAr4vJxTnX+cAu7MMWm+1qgKwAveEqvkyzDSe1we1SiK9JxSzpMp2joAHu+tRGxvKO5VpoCV4zTAxGQP93p6rsMaHdE+eLHPKAbu0O3r5jrIltMhMx5iuX43YLFML0RHNT1XjjVe7YmjS3HNDfombMpo4nb7L4yef37I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S9fJCH2U; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S9fJCH2U"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4280ca0791bso45340265e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 05:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725365393; x=1725970193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=JLYlLLGKbB0TvMjhCmijODtjVYZ8RqD6X4SH5pHru3k=;
        b=S9fJCH2UgJkF2l+UauktRfkH4nq6TM7EIxAYnstUodWneXJ/guUWV3jxiexAaIpX4P
         cOq8nLDzfXxC24xhhrjvz8eoi7ZCHnuoeIc9i5DH2nwzRDOdkBbkMElRrv5Dx5N8rVH0
         daBP0biULvTTipG6uBkctB9INyCkes3hes1btVssSexWAWLn9xBLIUnBQYOpgVKLNU3I
         RmQVAeQuXl+Z1Ew8SF0UsboblwrwBQioUMVgi3C8lf1Xu3gc0XDkEQeX3+dzbKYdjQjt
         tB2SGlEpDmfrbfc0mEyAoZ40Cj+dHGrp4/SxzdaspfziCz5RqhBjWQmsWgv+wodJCxeR
         faOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725365393; x=1725970193;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JLYlLLGKbB0TvMjhCmijODtjVYZ8RqD6X4SH5pHru3k=;
        b=miKELIxwRyBW/BJGD+NAMmsnZDhrZF9B+T4RJApuHf8h/ySHJ66pbWh7LtjIdg/zwi
         eJXQkd99b4cXwfg/Gy5/zvDW/LRN/UIXRsUOTX0f9eH6zvocmcqQr/D+k2QXBI/lEmE/
         z9ywgeHgicEoQr0p1BXV1liWNnivXRve4vFA3cfqp890xyZb1RoF+GFRrmJ3YfLcOhjL
         ZDkqBgfPoNkrTeUJkK9Wzx/M1sQRTQegikihZRxcSjSru00fwABkb2do9dSQWbL7baLe
         M0LdPBS0t6SIEGHLfKDdfvFhANLIJzjrtUeabYzxpAYSAIAfQymlCGAFCcLdyieH090Z
         WNeg==
X-Forwarded-Encrypted: i=1; AJvYcCUR4W09WDuM+OUeznuzyldxCvsWQDyb0kc4BNj7CFrnwCB1ySFo/FeRxVElEeDP/LVfOyhUxkI4NLmvYK8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7j3oUDzmgjSSLzqujYq81GYYgFqhchmeUkfnBdRe2iw4wnxHm
	EJ5vP2LPdQhEK/nBcfkS5GFQwiET2F3PjvyrJ/xeCC33bJQjR1cFZyPPgpwFAyo=
X-Google-Smtp-Source: AGHT+IEyoZ4C1GIHdc4etZJ5y8/7i4ZOxLROM5omYazPOI3P6CpupmD7KGheFpP2J3CHj/uHt2FC5g==
X-Received: by 2002:a5d:440b:0:b0:374:c847:852 with SMTP id ffacd0b85a97d-376dd71aa2bmr403119f8f.29.1725365393138;
        Tue, 03 Sep 2024 05:09:53 -0700 (PDT)
Received: from ubuntu-vm.. (51-148-40-55.dsl.zen.co.uk. [51.148.40.55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3749ee4a55fsm14069238f8f.10.2024.09.03.05.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 05:09:51 -0700 (PDT)
From: Adhemerval Zanella <adhemerval.zanella@linaro.org>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v5 0/2] arm64: Implement getrandom() in vDSO
Date: Tue,  3 Sep 2024 12:09:15 +0000
Message-ID: <20240903120948.13743-1-adhemerval.zanella@linaro.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement stack-less ChaCha20 and wire it with the generic vDSO
getrandom code.  The first patch is Mark's fix to the alternatives
system in the vDSO, while the the second is the actual vDSO work.

Changes from v4:
- Improve BE handling.

Changes from v3:
- Use alternative_has_cap_likely instead of ALTERNATIVE.
- Header/include and comment fixups.

Changes from v2:
- Refactor Makefile to use same flags for vgettimeofday and
  vgetrandom.
- Removed rodata usage and fixed BE on vgetrandom-chacha.S.

Changes from v1:
- Fixed style issues and typos.
- Added fallback for systems without NEON support.
- Avoid use of non-volatile vector registers in neon chacha20.
- Use c-getrandom-y for vgetrandom.c.
- Fixed TIMENS vdso_rnd_data access.

Adhemerval Zanella (1):
  arm64: vdso: wire up getrandom() vDSO implementation

Mark Rutland (1):
  arm64: alternative: make alternative_has_cap_likely() VDSO compatible

 arch/arm64/Kconfig                          |   1 +
 arch/arm64/include/asm/alternative-macros.h |   4 +
 arch/arm64/include/asm/mman.h               |   6 +-
 arch/arm64/include/asm/vdso.h               |   6 +
 arch/arm64/include/asm/vdso/getrandom.h     |  50 ++++++
 arch/arm64/include/asm/vdso/vsyscall.h      |  10 ++
 arch/arm64/kernel/vdso.c                    |   6 -
 arch/arm64/kernel/vdso/Makefile             |  25 ++-
 arch/arm64/kernel/vdso/vdso                 |   1 +
 arch/arm64/kernel/vdso/vdso.lds.S           |   4 +
 arch/arm64/kernel/vdso/vgetrandom-chacha.S  | 172 ++++++++++++++++++++
 arch/arm64/kernel/vdso/vgetrandom.c         |  15 ++
 tools/arch/arm64/vdso                       |   1 +
 tools/include/linux/compiler.h              |   4 +
 tools/testing/selftests/vDSO/Makefile       |   3 +-
 15 files changed, 292 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm64/include/asm/vdso/getrandom.h
 create mode 120000 arch/arm64/kernel/vdso/vdso
 create mode 100644 arch/arm64/kernel/vdso/vgetrandom-chacha.S
 create mode 100644 arch/arm64/kernel/vdso/vgetrandom.c
 create mode 120000 tools/arch/arm64/vdso

-- 
2.43.0

