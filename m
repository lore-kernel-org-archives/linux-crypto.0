Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5AB149C50
	for <linux-crypto@vger.kernel.org>; Mon,  2 Sep 2024 16:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725293958; cv=none; b=Y4QlD/gwp5qYvXkU0rGTu9/mil5usH62q51vG5aTiO7Gw2wgmgnERwTP6V/c8h3w2rvwoZYvd5bc5dqJsGEny/inAWA4zrjg2pJZmhbH4XG5Qg+tX+BwvbAEm9KePdT1fgiS+cDFpu0V15+3H/Zd/319yj1JsIa5bDIZzzESCoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725293958; c=relaxed/simple;
	bh=hj3MXW4jHA3xVGuuoslii7RqqzICqV3FJUookSbQJhk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Pz6GWVM8835Co5p1q3INFmuu2QytCZJaEM1JhXrQ/n4ZLOckY8p7qSzkVKDCsiqNCkxRvfwiHCrqLJf52PKIWUuEw8hNpyBIVsDZDc98PrQgKobARxqRB4znVMTDKii3ZXXq4RcefYQCqeQnZXPerpbPhx1eQ3DP0RJjYq+8JLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VMLpFaeW; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VMLpFaeW"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-374bd059b12so1388101f8f.1
        for <linux-crypto@vger.kernel.org>; Mon, 02 Sep 2024 09:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725293955; x=1725898755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=vkyMDCLd9ysLyI5RLQZB8Ncj/M1dFlma3LBWXQip8L8=;
        b=VMLpFaeWOH0YhF8aRyUpWLTDcoFvgXUqODZwvDVmXLXRjjePn34lwH6zatVL8zZSko
         vLSnUpjBiQ/YSnI47jt3fw3iK3o2PyslK2ebrzDa5Inwo1XxU9bQB67N+hxvaTYMK5jh
         QhOwSaM1t3kbRikfIIAJoq6Jdc3k+aFaAljwsmrpRCswvrLMmUaxMRL6nlgGTP5MDWpO
         lhbfsuMbtLAntAERYXdRgMYSN85xWr7ow1IidofWD87oqJ+L9jex1sM+GbCF1uroOcY5
         IfelqjxHCovPOE4v6vUg/dNWXhLWzzKSCIPNUfB9zqwvI0meKl7iCTXQYFNfjyMSvHjA
         kPgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725293955; x=1725898755;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vkyMDCLd9ysLyI5RLQZB8Ncj/M1dFlma3LBWXQip8L8=;
        b=WhBvn5dzWxH3oudugmqVjttc7FqZ+kpehtkf1vjV1xoI2XFzcQ5S4T7mvVeOtcCnAy
         sJ0BGsgfv+dP49k4gd9OzngoWl1GeYQNDlF2KVauY7fcec+Tb7e+xkzDQqzPMyLKm+Z7
         7x6Lx9FckQlAwIIx/Agxq9+GZ/tovbWT4p9n2Oi/IfWK9gPwf/z3s6qbae0kmr4anWUd
         AwKm5rhV7sfFqdCxane5aFEg0CgwX7Yda+VEB4b2mjdIWhQUKwSzmkLWtStJmlTpXp7V
         eCZLK/gTd52V8X59Unc1A2uNY+RP+ZO7kZ9BQK3Z9eiSEyJjEJJWcWdxesm8OswciL0s
         0a5A==
X-Forwarded-Encrypted: i=1; AJvYcCXgcFzV64XlTyEEywT+GTSc426qPaPdBKMA1G7dy33jOtDuVo0yRSjLoS/cSZj7wVWId4TBCb6I/CNmH0o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHoAFHXpMEdD2zPgLH63fbvrP0JiWZ1EXBFOtHLCQzBbwY8so6
	K3/wDQ8GsxpjMmJ9kt54F1F/yBhZ37NOvIENij0SNIsIFs0Kz+igSbSnWjKTVSI=
X-Google-Smtp-Source: AGHT+IHesPPhCPjvUcRq0H6NjoEXRkOvc8FVbv0aFUX8CIV5jvLI1kMhKeSNICFtv/lYiO8fmaQ/Fg==
X-Received: by 2002:a05:6000:cf:b0:374:c101:32 with SMTP id ffacd0b85a97d-374c10100c3mr3726845f8f.46.1725293954927;
        Mon, 02 Sep 2024 09:19:14 -0700 (PDT)
Received: from ubuntu-vm.. (51-148-40-55.dsl.zen.co.uk. [51.148.40.55])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb6deb239sm145970065e9.5.2024.09.02.09.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 09:19:14 -0700 (PDT)
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
Subject: [PATCH v4 0/2] arm64: Implement getrandom() in vDSO
Date: Mon,  2 Sep 2024 16:15:45 +0000
Message-ID: <20240902161912.2751-1-adhemerval.zanella@linaro.org>
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

Changes from v3:
- Use alternative_has_cap_likely instead of ALTERNATIVE.

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
 arch/arm64/kernel/vdso/vgetrandom-chacha.S  | 178 ++++++++++++++++++++
 arch/arm64/kernel/vdso/vgetrandom.c         |  15 ++
 tools/arch/arm64/vdso                       |   1 +
 tools/include/linux/compiler.h              |   4 +
 tools/testing/selftests/vDSO/Makefile       |   3 +-
 15 files changed, 298 insertions(+), 16 deletions(-)
 create mode 100644 arch/arm64/include/asm/vdso/getrandom.h
 create mode 120000 arch/arm64/kernel/vdso/vdso
 create mode 100644 arch/arm64/kernel/vdso/vgetrandom-chacha.S
 create mode 100644 arch/arm64/kernel/vdso/vgetrandom.c
 create mode 120000 tools/arch/arm64/vdso

-- 
2.43.0

