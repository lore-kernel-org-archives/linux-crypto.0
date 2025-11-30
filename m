Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64612537E9;
	Sun, 30 Nov 2025 02:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764470642; cv=none; b=LXK531j713TgDFruqjSelAPpdbHEww+R7dHT5DumAOUgEyUuej1HPF93RPEZys9+riu1+Ms9ZK+DAHG5FdVrS8I+WJqKOn1FcdxKo3dxKjp5fFe50heGbLYhG1vKu2lVarEyYjnc3bRfyOOqfErOVAT7ezEjegJkkMBY202quoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764470642; c=relaxed/simple;
	bh=NtlHdyrN0jEJ/buwaAYBePm0MRGPMaoqsrGTQ9SIGNw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HhDFskJlZz1bdgLH/r0WeorMYu5tXTLEC4OSg2fV57+KdXDGjy5HPdrH7W7VgZASbz17VcGRui76gpAspauBG0ngwZBxgptDCP8gMVAUXFX8bCRNphWcY7VZNaua4e0EatcYyCbiqJRlhjSPiPBrMbl9fRQeTuaMBVLWvBhRB9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXhlg4nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXhlg4nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54CEC113D0;
	Sun, 30 Nov 2025 02:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764470641;
	bh=NtlHdyrN0jEJ/buwaAYBePm0MRGPMaoqsrGTQ9SIGNw=;
	h=Date:From:To:Cc:Subject:From;
	b=ZXhlg4nwnhHBdRGeTLQRTUCTmzq/si49RbfJ0UEY0x3Q3XNcJYsjRnaSnLRNfvl1U
	 3NM7Q/5Ul1tauOsGoIpHETEDqHt6p/mJ7svuxFnBDBEywP0DJWT9LJZgnelQ3rAY72
	 0m2M9cWXr9rNfn3f/YIKm9RURGXC8QXFmNEqPa2UDSHSVjPNc1Ut3MTuI3WbPIaq9T
	 tBTEbTEiqjgXC/lm9G87RQIyuaTKSLjptP09A9Zdl98b9OwyLnpKcijhGZXooVW/+w
	 dFh82kyMCZBWPpVD/BBwzp4sr2vm0qRU3jKG/SM0jUQMZ2tso7h09CTB3ucfG7SkR0
	 yhw970jrhY8OA==
Date: Sat, 29 Nov 2025 18:42:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>
Subject: [GIT PULL] Crypto library updates for 6.19
Message-ID: <20251130024212.GB12664@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa:

  Linux 6.18-rc3 (2025-10-26 15:59:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-updates-for-linus

for you to fetch changes up to 2dbb6f4a25d38fcf7d6c1c682e45a13e6bbe9562:

  fscrypt: Drop obsolete recommendation to enable optimized POLYVAL (2025-11-11 11:03:39 -0800)

----------------------------------------------------------------

This is the main crypto library pull request for 6.19. It includes:

- Add SHA-3 support to lib/crypto/, including support for both the
  hash functions and the extendable-output functions. Reimplement the
  existing SHA-3 crypto_shash support on top of the library.

  This is motivated mainly by the upcoming support for the ML-DSA
  signature algorithm, which needs the SHAKE128 and SHAKE256
  functions. But even on its own it's a useful cleanup.

  This also fixes the longstanding issue where the
  architecture-optimized SHA-3 code was disabled by default.

- Add BLAKE2b support to lib/crypto/, and reimplement the existing
  BLAKE2b crypto_shash support on top of the library.

  This is motivated mainly by btrfs, which supports BLAKE2b checksums.
  With this change, all btrfs checksum algorithms now have library
  APIs. btrfs is planned to start just using the library directly.

  This refactor also improves consistency between the BLAKE2b code and
  BLAKE2s code. And as usual, it also fixes the issue where the
  architecture-optimized BLAKE2b code was disabled by default.

- Add POLYVAL support to lib/crypto/, replacing the existing POLYVAL
  support in crypto_shash. Reimplement HCTR2 on top of the library.

  This simplifies the code and improves HCTR2 performance. As usual,
  it also makes the architecture-optimized code be enabled by default.
  The generic implementation of POLYVAL is greatly improved as well.

- Clean up the BLAKE2s code.

- Add FIPS self-tests for SHA-1, SHA-2, and SHA-3.

----------------------------------------------------------------
David Howells (4):
      crypto: s390/sha3 - Rename conflicting functions
      crypto: arm64/sha3 - Rename conflicting function
      lib/crypto: sha3: Add SHA-3 support
      lib/crypto: sha3: Move SHA3 Iota step mapping into round function

Eric Biggers (33):
      lib/crypto: Add FIPS self-tests for SHA-1 and SHA-2
      lib/crypto: blake2s: Adjust parameter order of blake2s()
      lib/crypto: blake2s: Rename blake2s_state to blake2s_ctx
      lib/crypto: blake2s: Drop excessive const & rename block => data
      lib/crypto: blake2s: Document the BLAKE2s library API
      byteorder: Add le64_to_cpu_array() and cpu_to_le64_array()
      lib/crypto: blake2b: Add BLAKE2b library functions
      lib/crypto: arm/blake2b: Migrate optimized code into library
      crypto: blake2b - Reimplement using library API
      lib/crypto: sha3: Add FIPS cryptographic algorithm self-test
      crypto: arm64/sha3 - Update sha3_ce_transform() to prepare for library
      lib/crypto: arm64/sha3: Migrate optimized code into library
      lib/crypto: s390/sha3: Add optimized Keccak functions
      lib/crypto: sha3: Support arch overrides of one-shot digest functions
      lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest functions
      crypto: jitterentropy - Use default sha3 implementation
      crypto: sha3 - Reimplement using library API
      crypto: s390/sha3 - Remove superseded SHA-3 code
      lib/crypto: arm/blake2s: Fix some comments
      lib/crypto: arm, arm64: Drop filenames from file comments
      lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit
      lib/crypto: x86/blake2s: Drop check for nblocks == 0
      lib/crypto: x86/blake2s: Use local labels for data
      lib/crypto: x86/blake2s: Improve readability
      lib/crypto: x86/blake2s: Avoid writing back unchanged 'f' value
      lib/crypto: x86/blake2s: Use vpternlogd for 3-input XORs
      crypto: polyval - Rename conflicting functions
      lib/crypto: polyval: Add POLYVAL library
      lib/crypto: arm64/polyval: Migrate optimized code into library
      lib/crypto: x86/polyval: Migrate optimized code into library
      crypto: hctr2 - Convert to use POLYVAL library
      crypto: polyval - Remove the polyval crypto_shash
      fscrypt: Drop obsolete recommendation to enable optimized POLYVAL

 Documentation/crypto/index.rst                     |   1 +
 Documentation/crypto/sha3.rst                      | 119 ++++++
 Documentation/filesystems/fscrypt.rst              |   2 -
 arch/arm/crypto/Kconfig                            |  16 -
 arch/arm/crypto/Makefile                           |   2 -
 arch/arm/crypto/blake2b-neon-glue.c                | 104 ------
 arch/arm64/configs/defconfig                       |   2 +-
 arch/arm64/crypto/Kconfig                          |  21 --
 arch/arm64/crypto/Makefile                         |   6 -
 arch/arm64/crypto/polyval-ce-glue.c                | 158 --------
 arch/arm64/crypto/sha3-ce-glue.c                   | 151 --------
 arch/s390/configs/debug_defconfig                  |   3 +-
 arch/s390/configs/defconfig                        |   3 +-
 arch/s390/crypto/Kconfig                           |  20 -
 arch/s390/crypto/Makefile                          |   2 -
 arch/s390/crypto/sha.h                             |  51 ---
 arch/s390/crypto/sha3_256_s390.c                   | 157 --------
 arch/s390/crypto/sha3_512_s390.c                   | 157 --------
 arch/s390/crypto/sha_common.c                      | 117 ------
 arch/x86/crypto/Kconfig                            |  10 -
 arch/x86/crypto/Makefile                           |   3 -
 arch/x86/crypto/polyval-clmulni_glue.c             | 180 ---------
 crypto/Kconfig                                     |  14 +-
 crypto/Makefile                                    |   6 +-
 crypto/blake2b.c                                   | 111 ++++++
 crypto/blake2b_generic.c                           | 192 ----------
 crypto/hctr2.c                                     | 226 ++++-------
 crypto/jitterentropy-kcapi.c                       |  12 +-
 crypto/polyval-generic.c                           | 205 ----------
 crypto/sha3.c                                      | 166 +++++++++
 crypto/sha3_generic.c                              | 290 ---------------
 crypto/testmgr.c                                   |  15 +-
 drivers/char/random.c                              |   6 +-
 drivers/net/wireguard/cookie.c                     |  18 +-
 drivers/net/wireguard/noise.c                      |  32 +-
 include/crypto/blake2b.h                           | 143 +++++--
 include/crypto/blake2s.h                           | 126 +++++--
 include/crypto/internal/blake2b.h                  | 101 -----
 include/crypto/polyval.h                           | 182 ++++++++-
 include/crypto/sha3.h                              | 320 +++++++++++++++-
 include/linux/byteorder/generic.h                  |  16 +
 lib/crypto/Kconfig                                 |  36 ++
 lib/crypto/Makefile                                |  30 ++
 .../crypto => lib/crypto/arm}/blake2b-neon-core.S  |  29 +-
 lib/crypto/arm/blake2b.h                           |  41 ++
 lib/crypto/arm/blake2s-core.S                      |  22 +-
 lib/crypto/arm/blake2s.h                           |   4 +-
 lib/crypto/arm/sha1-armv7-neon.S                   |   2 +-
 lib/crypto/arm/sha1-ce-core.S                      |   2 +-
 lib/crypto/arm/sha256-ce.S                         |   2 +-
 .../crypto => lib/crypto/arm64}/polyval-ce-core.S  |  38 +-
 lib/crypto/arm64/polyval.h                         |  82 ++++
 lib/crypto/arm64/sha1-ce-core.S                    |   2 +-
 lib/crypto/arm64/sha256-ce.S                       |   2 +-
 .../crypto => lib/crypto/arm64}/sha3-ce-core.S     |  69 ++--
 lib/crypto/arm64/sha3.h                            |  62 ++++
 lib/crypto/arm64/sha512-ce-core.S                  |   2 +-
 lib/crypto/blake2b.c                               | 174 +++++++++
 lib/crypto/blake2s.c                               |  66 ++--
 lib/crypto/fips.h                                  |  45 +++
 lib/crypto/polyval.c                               | 307 +++++++++++++++
 lib/crypto/s390/sha3.h                             | 151 ++++++++
 lib/crypto/sha1.c                                  |  19 +-
 lib/crypto/sha256.c                                |  26 +-
 lib/crypto/sha3.c                                  | 411 +++++++++++++++++++++
 lib/crypto/sha512.c                                |  19 +-
 lib/crypto/tests/blake2s_kunit.c                   |  39 +-
 lib/crypto/x86/blake2s-core.S                      | 275 ++++++++------
 lib/crypto/x86/blake2s.h                           |  22 +-
 .../crypto/x86/polyval-pclmul-avx.S                |  40 +-
 lib/crypto/x86/polyval.h                           |  83 +++++
 scripts/crypto/gen-fips-testvecs.py                |  36 ++
 72 files changed, 3076 insertions(+), 2528 deletions(-)
 create mode 100644 Documentation/crypto/sha3.rst
 delete mode 100644 arch/arm/crypto/blake2b-neon-glue.c
 delete mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 delete mode 100644 arch/arm64/crypto/sha3-ce-glue.c
 delete mode 100644 arch/s390/crypto/sha.h
 delete mode 100644 arch/s390/crypto/sha3_256_s390.c
 delete mode 100644 arch/s390/crypto/sha3_512_s390.c
 delete mode 100644 arch/s390/crypto/sha_common.c
 delete mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
 create mode 100644 crypto/blake2b.c
 delete mode 100644 crypto/blake2b_generic.c
 delete mode 100644 crypto/polyval-generic.c
 create mode 100644 crypto/sha3.c
 delete mode 100644 crypto/sha3_generic.c
 delete mode 100644 include/crypto/internal/blake2b.h
 rename {arch/arm/crypto => lib/crypto/arm}/blake2b-neon-core.S (94%)
 create mode 100644 lib/crypto/arm/blake2b.h
 rename {arch/arm64/crypto => lib/crypto/arm64}/polyval-ce-core.S (92%)
 create mode 100644 lib/crypto/arm64/polyval.h
 rename {arch/arm64/crypto => lib/crypto/arm64}/sha3-ce-core.S (83%)
 create mode 100644 lib/crypto/arm64/sha3.h
 create mode 100644 lib/crypto/blake2b.c
 create mode 100644 lib/crypto/fips.h
 create mode 100644 lib/crypto/polyval.c
 create mode 100644 lib/crypto/s390/sha3.h
 create mode 100644 lib/crypto/sha3.c
 rename arch/x86/crypto/polyval-clmulni_asm.S => lib/crypto/x86/polyval-pclmul-avx.S (91%)
 create mode 100644 lib/crypto/x86/polyval.h
 create mode 100755 scripts/crypto/gen-fips-testvecs.py
