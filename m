Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD7D257435;
	Thu, 19 Mar 2026 06:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901155; cv=none; b=j7h86huzvpy1ZOWyM5pezr9yDKKmr39xISDgJ7sRXXQ2TmNan0GtSp1eggjOIKyEVXxoHom7ZMqnk3WZSCjM7pIICNI711epNoixL6Z0X4NZa9P0BLQFyC9ZwNfLyFEBD/uGrxrXn8cnNIGouU/1OcKfYDdzv06vNEYtK6PC/UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901155; c=relaxed/simple;
	bh=KZB8JfCq3dPwLcVvddftx2jern4tyeo/Ff5mfVfPWVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FSgNWJZ5LuFWDtBpJzB0FRA1nCVISqkskNnpXXLltFAmdaOW6bcsRmJu0wPTdcizSQWhp7r15m6TvrOPC8b718PD94lA8R79VrUo4vcD8q7cwFnDc+QXiBaIqrGYEcc7dkPeCc8iPbB1BtFnMZ8F++g8u6mgtWT/1H9E6vZSluk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fsn0C2y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fsn0C2y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F2EC19425;
	Thu, 19 Mar 2026 06:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901154;
	bh=KZB8JfCq3dPwLcVvddftx2jern4tyeo/Ff5mfVfPWVw=;
	h=From:To:Cc:Subject:Date:From;
	b=Fsn0C2y5dqD1kOcPblN1WleUMoCnQnVF5C+HGyCG/Qc5O0SwABwbWWfJORzWrv8u6
	 uRgo9Q8jzpwbCFu949FWOcEI/Ochilu+/fsfexsdN/JDs+vBSyFs7D6YEdkbOYZRXb
	 ABor2bRzWN2A6fWmrKnbm4Hg9GR4YBj5dZ2/wKg/mJ3uxVZTmm5c/6I1XLIidlxeGf
	 2B0YpxAMznGByxyFWDaf0jG8XK8v/VqVUdzJmV9L6JHmUhLmiClvML6PEg8Z0sRSmW
	 W/gxpXQHDgSGKtSRlgamAsgxCGQkj2LNfVtTqEYlGy6aFVAGNyJhF+NYO3FReTHrpZ
	 6ijS0tBbW0/7A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/19] GHASH library
Date: Wed, 18 Mar 2026 23:17:01 -0700
Message-ID: <20260319061723.1140720-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git ghash-lib-v1

This series migrates the standalone GHASH code to lib/crypto/, then
converts the "gcm" template and AES-GCM library code to use it.  (GHASH
is the universal hash function used by GCM mode.)  As was the case with
POLYVAL and Poly1305 as well, the library is a much better fit for it.

Since GHASH and POLYVAL are closely related and it often makes sense to
implement one in terms of the other, the existing "polyval" library
module is renamed to "gf128hash" and the GHASH support is added to it.

The generic implementation of GHASH is also replaced with a better one
utilizing the existing polyval_mul_generic().

Note that some GHASH implementations, often faster ones using more
recent CPU features, still exist in arch/*/crypto/ as internal
components of AES-GCM implementations.  Those are left as-is for now.
The goal with this GHASH library is just to provide parity with the
existing standalone GHASH support, which is used when a full
implementation of AES-GCM (or ${someothercipher}-GCM, if another block
cipher is being used) is unavailable.  Migrating the
architecture-optimized AES-GCM code to lib/crypto/ will be a next step.

Eric Biggers (19):
  lib/crypto: gf128hash: Rename polyval module to gf128hash
  lib/crypto: gf128hash: Support GF128HASH_ARCH without all POLYVAL
    functions
  lib/crypto: gf128hash: Add GHASH support
  lib/crypto: tests: Add KUnit tests for GHASH
  crypto: arm/ghash - Make the "ghash" crypto_shash NEON-only
  crypto: arm/ghash - Move NEON GHASH assembly into its own file
  lib/crypto: arm/ghash: Migrate optimized code into library
  crypto: arm64/ghash - Move NEON GHASH assembly into its own file
  lib/crypto: arm64/ghash: Migrate optimized code into library
  crypto: arm64/aes-gcm - Rename struct ghash_key and make fixed-sized
  lib/crypto: powerpc/ghash: Migrate optimized code into library
  lib/crypto: riscv/ghash: Migrate optimized code into library
  lib/crypto: s390/ghash: Migrate optimized code into library
  lib/crypto: x86/ghash: Migrate optimized code into library
  crypto: gcm - Use GHASH library instead of crypto_ahash
  crypto: ghash - Remove ghash from crypto_shash API
  lib/crypto: gf128mul: Remove unused 4k_lle functions
  lib/crypto: gf128hash: Remove unused content from ghash.h
  lib/crypto: aesgcm: Use GHASH library API

 MAINTAINERS                                   |   4 +-
 arch/arm/crypto/Kconfig                       |  13 +-
 arch/arm/crypto/ghash-ce-core.S               | 171 +-------
 arch/arm/crypto/ghash-ce-glue.c               | 166 +------
 arch/arm64/crypto/Kconfig                     |   5 +-
 arch/arm64/crypto/ghash-ce-core.S             | 221 +---------
 arch/arm64/crypto/ghash-ce-glue.c             | 164 +------
 arch/powerpc/crypto/Kconfig                   |   5 +-
 arch/powerpc/crypto/Makefile                  |   8 +-
 arch/powerpc/crypto/aesp8-ppc.h               |   1 -
 arch/powerpc/crypto/ghash.c                   | 160 -------
 arch/powerpc/crypto/vmx.c                     |  10 +-
 arch/riscv/crypto/Kconfig                     |  11 -
 arch/riscv/crypto/Makefile                    |   3 -
 arch/riscv/crypto/ghash-riscv64-glue.c        | 146 -------
 arch/s390/configs/debug_defconfig             |   1 -
 arch/s390/configs/defconfig                   |   1 -
 arch/s390/crypto/Kconfig                      |  10 -
 arch/s390/crypto/Makefile                     |   1 -
 arch/s390/crypto/ghash_s390.c                 | 144 ------
 arch/x86/crypto/Kconfig                       |  10 -
 arch/x86/crypto/Makefile                      |   3 -
 arch/x86/crypto/aesni-intel_glue.c            |   1 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c    | 163 -------
 crypto/Kconfig                                |  11 +-
 crypto/Makefile                               |   1 -
 crypto/gcm.c                                  | 413 ++++--------------
 crypto/ghash-generic.c                        | 162 -------
 crypto/hctr2.c                                |   2 +-
 crypto/tcrypt.c                               |   9 -
 crypto/testmgr.c                              |  16 +-
 crypto/testmgr.h                              | 109 -----
 drivers/crypto/starfive/jh7110-aes.c          |   2 +-
 include/crypto/gcm.h                          |   4 +-
 include/crypto/{polyval.h => gf128hash.h}     | 126 +++++-
 include/crypto/gf128mul.h                     |  17 +-
 include/crypto/ghash.h                        |  12 -
 lib/crypto/.kunitconfig                       |   1 +
 lib/crypto/Kconfig                            |  31 +-
 lib/crypto/Makefile                           |  47 +-
 lib/crypto/aesgcm.c                           |  55 +--
 lib/crypto/arm/gf128hash.h                    |  43 ++
 lib/crypto/arm/ghash-neon-core.S              | 209 +++++++++
 lib/crypto/arm64/gf128hash.h                  | 137 ++++++
 lib/crypto/arm64/ghash-neon-core.S            | 220 ++++++++++
 lib/crypto/arm64/polyval.h                    |  80 ----
 lib/crypto/{polyval.c => gf128hash.c}         | 183 ++++++--
 lib/crypto/gf128mul.c                         |  73 +---
 lib/crypto/powerpc/.gitignore                 |   1 +
 lib/crypto/powerpc/gf128hash.h                | 109 +++++
 .../crypto/powerpc}/ghashp8-ppc.pl            |   1 +
 lib/crypto/riscv/gf128hash.h                  |  57 +++
 .../crypto/riscv}/ghash-riscv64-zvkg.S        |  13 +-
 lib/crypto/s390/gf128hash.h                   |  54 +++
 lib/crypto/tests/Kconfig                      |  12 +-
 lib/crypto/tests/Makefile                     |   1 +
 lib/crypto/tests/ghash-testvecs.h             | 186 ++++++++
 lib/crypto/tests/ghash_kunit.c                | 194 ++++++++
 lib/crypto/tests/polyval_kunit.c              |   2 +-
 lib/crypto/x86/{polyval.h => gf128hash.h}     |  72 ++-
 .../crypto/x86/ghash-pclmul.S                 |  98 ++---
 scripts/crypto/gen-hash-testvecs.py           |  63 ++-
 62 files changed, 1903 insertions(+), 2345 deletions(-)
 delete mode 100644 arch/powerpc/crypto/ghash.c
 delete mode 100644 arch/riscv/crypto/ghash-riscv64-glue.c
 delete mode 100644 arch/s390/crypto/ghash_s390.c
 delete mode 100644 arch/x86/crypto/ghash-clmulni-intel_glue.c
 delete mode 100644 crypto/ghash-generic.c
 rename include/crypto/{polyval.h => gf128hash.h} (60%)
 create mode 100644 lib/crypto/arm/gf128hash.h
 create mode 100644 lib/crypto/arm/ghash-neon-core.S
 create mode 100644 lib/crypto/arm64/gf128hash.h
 create mode 100644 lib/crypto/arm64/ghash-neon-core.S
 delete mode 100644 lib/crypto/arm64/polyval.h
 rename lib/crypto/{polyval.c => gf128hash.c} (61%)
 create mode 100644 lib/crypto/powerpc/gf128hash.h
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/ghashp8-ppc.pl (98%)
 create mode 100644 lib/crypto/riscv/gf128hash.h
 rename {arch/riscv/crypto => lib/crypto/riscv}/ghash-riscv64-zvkg.S (91%)
 create mode 100644 lib/crypto/s390/gf128hash.h
 create mode 100644 lib/crypto/tests/ghash-testvecs.h
 create mode 100644 lib/crypto/tests/ghash_kunit.c
 rename lib/crypto/x86/{polyval.h => gf128hash.h} (51%)
 rename arch/x86/crypto/ghash-clmulni-intel_asm.S => lib/crypto/x86/ghash-pclmul.S (54%)


base-commit: 520a39fb6916ac3a269ad4ea87a6cb9af9d5a910
-- 
2.53.0

