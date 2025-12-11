Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A8022A7E9;
	Thu, 11 Dec 2025 01:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765416051; cv=none; b=qgs8UJ5Lb0M2SdQNQwjFB3Z8e36L57ZRamm7zqnntgnNahCcrM7OyvUAu2fq6ZI0u0PmPMCBDMKl5FV7AjOju94eF9pJockwNnX26USAxQeIvSh1xuEUKF0llzfaDHnsBq7UUp4Dkanf8VqbRrGZ5tSwbY5RGZVuosBSNPQmmtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765416051; c=relaxed/simple;
	bh=9WZxU3SduU/OLs3KoFGUeeQN0S01x7wwQRNZ8loj4I0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uJEZ75eYTn7f8VzxPYTRqS+opnHa1unoFQy0sK1D8PgUb2WXwpfUJ6OBzueehdYwp38YN6+ndA6ArzTMSf6qXiprUx2oVyLYYFPL47L1rgC8DrA31TRqoTPiK4rnGlbL6UYKENtU4Diqw4Eb0mEBt725QLdzsYoew671Kj61DNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYt9t0+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYt9t0+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78D0C4CEF1;
	Thu, 11 Dec 2025 01:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765416051;
	bh=9WZxU3SduU/OLs3KoFGUeeQN0S01x7wwQRNZ8loj4I0=;
	h=From:To:Cc:Subject:Date:From;
	b=eYt9t0+ccn3lTySgqTYX5mqswut1aCmRSzK+fFWXg0ejmOqIYIGaLZFFBNklX3XGt
	 Fz+MWFQLhzgOGIqNKEkKgF3zwGajWqrxEEPDtfMudwtDo0r3UaKKFzsLtRnphKlscb
	 TMK5GelVApE2cWZogUy13U8IiPyw45IMIwStXDUWLg7WF+doHkHf4fqAaxaemop9BU
	 jbn4mCD+yWm/rSgjHzL5PyIjxVyE/dw2W+kMJ9R28KY5l366KR+cIT1+tTCMNjlwK4
	 JQ711Mr+7Kb5iLRokMmEYYWnqdQsnpcgthpKBXK7kLAX53ykogsqVQQOYSDf9lxH99
	 jxoDejdAisb+Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/12] NH library and Adiantum cleanup
Date: Wed, 10 Dec 2025 17:18:32 -0800
Message-ID: <20251211011846.8179-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git nh-lib-v1

This series removes the nhpoly1305 crypto_shash algorithm, which existed
only to fit Adiantum hashing into the traditional Linux crypto API
paradigm.  It replaces it with an nh() library function, combined with
code in the "adiantum" template that handles the Poly1305 step.

The result is simpler code.  As usual, I've also fixed the issue where
the architecture-optimized code was disabled by default.

I've also included some additional cleanups for the Adiantum code.

I'm planning to take this via libcrypto-next.

Eric Biggers (12):
  lib/crypto: nh: Add NH library
  lib/crypto: tests: Add KUnit tests for NH
  lib/crypto: arm/nh: Migrate optimized code into library
  lib/crypto: arm64/nh: Migrate optimized code into library
  lib/crypto: x86/nh: Migrate optimized code into library
  crypto: adiantum - Convert to use NH library
  crypto: adiantum - Use scatter_walk API instead of sg_miter
  crypto: adiantum - Use memcpy_{to,from}_sglist()
  crypto: adiantum - Drop support for asynchronous xchacha ciphers
  crypto: nhpoly1305 - Remove crypto_shash support
  crypto: testmgr - Remove nhpoly1305 tests
  fscrypt: Drop obsolete recommendation to enable optimized NHPoly1305

 Documentation/filesystems/fscrypt.rst         |    5 -
 arch/arm/crypto/Kconfig                       |   10 -
 arch/arm/crypto/Makefile                      |    2 -
 arch/arm/crypto/nhpoly1305-neon-glue.c        |   80 -
 arch/arm64/crypto/Kconfig                     |   10 -
 arch/arm64/crypto/Makefile                    |    3 -
 arch/arm64/crypto/nhpoly1305-neon-glue.c      |   79 -
 arch/x86/crypto/Kconfig                       |   20 -
 arch/x86/crypto/Makefile                      |    5 -
 arch/x86/crypto/nhpoly1305-avx2-glue.c        |   81 -
 arch/x86/crypto/nhpoly1305-sse2-glue.c        |   80 -
 crypto/Kconfig                                |    8 +-
 crypto/Makefile                               |    1 -
 crypto/adiantum.c                             |  442 +++---
 crypto/nhpoly1305.c                           |  255 ---
 crypto/testmgr.c                              |   10 +-
 crypto/testmgr.h                              | 1372 -----------------
 include/crypto/nh.h                           |   52 +
 include/crypto/nhpoly1305.h                   |   74 -
 lib/crypto/Kconfig                            |   13 +
 lib/crypto/Makefile                           |   11 +
 .../crypto => lib/crypto/arm}/nh-neon-core.S  |    0
 lib/crypto/arm/nh.h                           |   33 +
 .../crypto/arm64}/nh-neon-core.S              |    3 +-
 lib/crypto/arm64/nh.h                         |   34 +
 lib/crypto/nh.c                               |   82 +
 lib/crypto/tests/Kconfig                      |    8 +
 lib/crypto/tests/Makefile                     |    1 +
 lib/crypto/tests/nh-testvecs.h                |  298 ++++
 lib/crypto/tests/nh_kunit.c                   |   43 +
 .../crypto/x86/nh-avx2.S                      |    3 +-
 .../crypto/x86/nh-sse2.S                      |    3 +-
 lib/crypto/x86/nh.h                           |   45 +
 scripts/crypto/gen-hash-testvecs.py           |   40 +
 34 files changed, 909 insertions(+), 2297 deletions(-)
 delete mode 100644 arch/arm/crypto/nhpoly1305-neon-glue.c
 delete mode 100644 arch/arm64/crypto/nhpoly1305-neon-glue.c
 delete mode 100644 arch/x86/crypto/nhpoly1305-avx2-glue.c
 delete mode 100644 arch/x86/crypto/nhpoly1305-sse2-glue.c
 delete mode 100644 crypto/nhpoly1305.c
 create mode 100644 include/crypto/nh.h
 delete mode 100644 include/crypto/nhpoly1305.h
 rename {arch/arm/crypto => lib/crypto/arm}/nh-neon-core.S (100%)
 create mode 100644 lib/crypto/arm/nh.h
 rename {arch/arm64/crypto => lib/crypto/arm64}/nh-neon-core.S (97%)
 create mode 100644 lib/crypto/arm64/nh.h
 create mode 100644 lib/crypto/nh.c
 create mode 100644 lib/crypto/tests/nh-testvecs.h
 create mode 100644 lib/crypto/tests/nh_kunit.c
 rename arch/x86/crypto/nh-avx2-x86_64.S => lib/crypto/x86/nh-avx2.S (98%)
 rename arch/x86/crypto/nh-sse2-x86_64.S => lib/crypto/x86/nh-sse2.S (97%)
 create mode 100644 lib/crypto/x86/nh.h


base-commit: 0914d5848096af6496c7aa5e1ac051fcdb3f755b
-- 
2.52.0

