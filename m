Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868684CF490;
	Mon, 19 Oct 2026 02:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792377224; cv=none; b=djksrPzGKajafojh82WFFuX1vh+VGZ41iJBGkVOkgDw3Pb5rFiZ4blMxvYGjP88AAc7CkYeGU7hXgQJntoKxt6Q0HmZd5rp6d5vHyrg2JCc5AxHpi1PHARe5qCpAHJKIvCS1feI4LeY/onlsAi+bQfrtEgZusL1UMdrRjds4bT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792377224; c=relaxed/simple;
	bh=rRYTXlW3a2/O6jvsFU1ne7Pzp59ueV9oYoOM2DFy9tg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uiZ6Wpi97IxCS001YyNgztiOTEPFK3qASvB7zyGTD7BSIySbtNvZBv444lQMONJo4hvdcsbXF17pBeHmqX/CXTJ95XO37vvBY7hcyR0+LFgcT+5CoWF8bOaKXTJh3m1WloGXbkCMK+VTLUmMOf/hoA6oHgnq7jxY+62pEj0zfHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=coEZwt0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="coEZwt0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C891F1F000C4;
	Mon, 19 Oct 2026 02:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792377223;
	bh=SFyyNl3bEdn5C8Lf6zGhp41i6GNwOrEmHr79SMuCVgU=;
	h=Date:From:To:Cc:Subject;
	b=coEZwt0Ff7XZMufA1M6gvw3SAjLn6c4YFRVEaftaImIA5AxYrhTMQS4ABCIXxp6s+
	 R+ux8WCLJWIAcy5bHCiKk/0din1egLuZkLadafTOWm1ek6cWtC+Hp7sIbr9yXLaWHJ
	 TE6xZXqDOJs+5mjZAqaLmaWCABOduVHsu2NN8njaSJR1rlRNxB72Vrcj/C7QEVxMAc
	 YFsToAYq/0I/8WmwQ3XCBglYaaz1dgb2/R6lI9MIUzEZIwG+ynnhr/FGrb04egtNvs
	 yakUKh1QFv8tjOky3/OyYAZsF5WNZG4uFWTvp+MN/FBD+9CucZpRiMdmZyBE2Va5hq
	 efo7myQlUNNVQ==
Date: Sun, 18 Oct 2026 19:33:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Stian Halseth <stian@itx.no>, Thomas Huth <thuth@redhat.com>,
	Vladimir Kukharenko <vladimir@genproof.com>
Subject: [GIT PULL] Crypto library updates for 7.4
Message-ID: <20261019023341.GA3270@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 572af6872e520c7102e58362ef7cd7c2ed4342be:

  crypto: aes - Fix undesired override of some optimized AES modes (2026-09-30 08:38:06 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 20ec6916d8712e84d58e8c688a25cd368ddeb82b:

  lib/crypto: md5: remove unused header (2026-10-16 00:28:55 -0700)

----------------------------------------------------------------

- Migrate the x86 and riscv optimized implementations of various AES
  modes (ECB, CBC, CBC-CTS, CTR, XCTR, XTS) into lib/crypto/.

  This makes the library APIs be properly accelerated on these
  architectures, while still accelerating crypto_skcipher as well.

  It removes a lot of redundant glue code, since the crypto API
  boilerplate no longer needs to be duplicated for these architectures.

  It also fixes the longstanding issue where optimizations for these
  AES modes were disabled by default on these architectures.

- Optimize AES-XTS on SPARC64 using the SPARC crypto opcodes

- Move the SipHash code into lib/crypto/

- Update the ChaCha and Poly1305 functions to take size_t lengths,
  resolving issues where lengths over INT_MAX were mishandled

- Make frame pointer unwinding work properly in some of the x86
  assembly functions, by following the standard %rbp convention

- Add helper functions for zeroizing structs

- Make a few documentation improvements

----------------------------------------------------------------
Eric Biggers (31):
      Documentation: libcrypto: Add additional testing information
      MAINTAINERS: Place libcrypto docs under CRYPTO LIBRARY
      lib/crypto: aes-xctr: Pass counter by value to aes_xctr_arch()
      lib/crypto: x86/aes: Clean up aes-aesni.S in preparation for AES modes
      lib/crypto: x86/aes-ecb: Add AES-NI optimization
      lib/crypto: x86/aes-cbc: Add AES-NI optimization
      lib/crypto: x86/aes-ctr: Add AES-NI optimization
      lib/crypto: x86/aes-xts: Add AES-NI optimization
      crypto: x86/aes - Drop superseded 32-bit build support
      crypto: x86/aes-ecb - Remove superseded ECB skcipher
      crypto: x86/aes-cbc - Remove superseded CBC skciphers
      crypto: x86/aes-ctr - Remove superseded CTR skcipher
      crypto: x86/aes-xts - Remove superseded XTS skcipher
      lib/crypto: x86/aes-ctr: Migrate AVX-optimized code into library
      lib/crypto: x86/aes-xts: Migrate AVX-optimized code into library
      lib/crypto: riscv/aes: Copy aes-macros.S to library
      lib/crypto: riscv/aes: Pass key struct to assembly code
      lib/crypto: riscv/aes-ecb: Migrate optimized code into library
      lib/crypto: riscv/aes-cbc: Migrate optimized code into library
      lib/crypto: riscv/aes-ctr: Migrate optimized code into library
      lib/crypto: riscv/aes-xts: Migrate optimized code into library
      lib/crypto: x86/aes: Set RNDKEY in aes_cbc_encrypt_aesni()
      crypto: aes - Boost priority of encryption modes further
      crypto: x86/aesni-intel - Add transitional selections
      lib/crypto: x86/aes-ctr: Remove some unreachable code
      lib: Move SipHash into lib/crypto/
      lib/crypto: x86/sha1: Follow the normal %rbp convention
      lib/crypto: x86/sha256: Follow the normal %rbp convention
      lib/crypto: x86/sha512: Follow the normal %rbp convention
      lib/crypto: poly1305: Use size_t length
      lib/crypto: chacha: Use size_t length

Mohamad Raizudeen (2):
      lib/crypto: chacha20poly1305: zeroize state in __chacha20poly1305_decrypt
      lib/crypto: md5: remove unused header

Stian Halseth (1):
      lib/crypto: sparc/aes-xts: Add optimization using the AES opcodes

Thomas Huth (13):
      lib/crypto: aes: Provide functions for zeroizing aes_key and aes_enckey
      lib/crypto: aes-xts: Provide function for zeroizing aes_xts_key
      lib/crypto: aes-gcm: Provide functions for zeroizing aes_gcm* structures
      lib/crypto: aes-ccm: Provide functions for zeroizing aes_ccm* structures
      lib/crypto: md5: Provide functions for zeroizing hmac_md5 structures
      lib/crypto: sm3: Provide a function for zeroizing the sm3_ctx structure
      lib/crypto: blake2: Provide functions for zeroizing blake2*_ctx structures
      lib/crypto: sha1: Provide functions for zeroizing hmac_sha1 structures
      security: keys: trusted: always clear the hmac_sha1_ctx before returning
      x86/purgatory: Compile purgatory with -D__NO_FORTIFY and -D__DISABLE_EXPORTS
      lib/crypto: sha2: Provide functions for zeroizing SHA2 hmac_sha* structures
      smb: client: Use hmac_sha256_zeroize_ctx function to clear hmac_sha256_ctx
      lib/crypto: Add documentation about zeroization of key and context data

Vladimir Kukharenko (2):
      lib/crypto: arm/chacha: Handle lengths of 2 GiB or more in scalar code
      lib/crypto: mips/chacha: Handle lengths of 2 GiB or more

 Documentation/crypto/libcrypto-hash.rst            |    5 +
 Documentation/crypto/libcrypto-zeroization.rst     |  150 +++
 Documentation/crypto/libcrypto.rst                 |   14 +
 MAINTAINERS                                        |    9 +-
 arch/riscv/crypto/Kconfig                          |   15 -
 arch/riscv/crypto/Makefile                         |    4 -
 arch/riscv/crypto/aes-riscv64-glue.c               |  566 ---------
 arch/riscv/crypto/aes-riscv64-zvkned.S             |  312 -----
 arch/sparc/include/asm/opcodes.h                   |    6 +
 arch/x86/crypto/Kconfig                            |   18 +-
 arch/x86/crypto/Makefile                           |   10 +-
 arch/x86/crypto/aesni-intel_asm.S                  | 1338 --------------------
 arch/x86/crypto/aesni-intel_glue.c                 |  792 +-----------
 arch/x86/purgatory/Makefile                        |    3 +-
 crypto/aes.c                                       |   31 +-
 fs/smb/client/smb2transport.c                      |    3 +-
 include/crypto/aes-ccm.h                           |   22 +-
 include/crypto/aes-gcm.h                           |   22 +-
 include/crypto/aes-xts.h                           |   13 +-
 include/crypto/aes.h                               |   18 +
 include/crypto/blake2b.h                           |    9 +
 include/crypto/blake2s.h                           |    9 +
 include/crypto/chacha.h                            |    6 +-
 include/crypto/internal/poly1305.h                 |    4 +-
 include/crypto/md5.h                               |   19 +
 include/crypto/poly1305.h                          |    4 +-
 include/crypto/sha1.h                              |   19 +
 include/crypto/sha2.h                              |   73 ++
 include/crypto/sm3.h                               |   10 +
 lib/Kconfig.debug                                  |   11 -
 lib/Makefile                                       |    2 +-
 lib/crypto/.kunitconfig                            |    1 +
 lib/crypto/Makefile                                |   20 +
 lib/crypto/aes.c                                   |   34 +-
 lib/crypto/arm/chacha-scalar-core.S                |   10 +-
 lib/crypto/arm/chacha.h                            |   16 +-
 lib/crypto/arm/poly1305.h                          |    8 +-
 lib/crypto/arm64/chacha.h                          |   10 +-
 lib/crypto/arm64/poly1305.h                        |    6 +-
 lib/crypto/blake2b.c                               |    2 +-
 lib/crypto/blake2s.c                               |    2 +-
 lib/crypto/chacha.c                                |    8 +-
 lib/crypto/chacha20poly1305.c                      |   11 +-
 lib/crypto/md5.c                                   |    3 +-
 lib/crypto/mips/chacha-core.S                      |    8 +-
 lib/crypto/mips/chacha.h                           |   23 +-
 lib/crypto/mips/poly1305.h                         |    2 +-
 lib/crypto/poly1305-donna32.c                      |    2 +-
 lib/crypto/poly1305-donna64.c                      |    2 +-
 lib/crypto/poly1305.c                              |   10 +-
 lib/crypto/powerpc/chacha-p10le-8x.S               |    2 +-
 lib/crypto/powerpc/chacha.h                        |   10 +-
 lib/crypto/powerpc/poly1305-p10le_64.S             |   23 +-
 lib/crypto/powerpc/poly1305.h                      |    8 +-
 .../riscv/crypto => lib/crypto/riscv}/aes-macros.S |   25 +-
 .../crypto/riscv}/aes-riscv64-zvkned-zvbb-zvkg.S   |   99 +-
 .../crypto/riscv}/aes-riscv64-zvkned-zvkb.S        |   23 +-
 lib/crypto/riscv/aes-riscv64-zvkned.S              |  305 ++++-
 lib/crypto/riscv/aes.h                             |  244 +++-
 lib/crypto/riscv/chacha.h                          |    6 +-
 lib/crypto/riscv/poly1305.h                        |    2 +-
 lib/crypto/s390/chacha.h                           |    2 +-
 lib/crypto/sha1.c                                  |    2 +-
 lib/{ => crypto}/siphash.c                         |    0
 lib/crypto/sm3.c                                   |    2 +-
 lib/crypto/sparc/aes.h                             |   75 ++
 lib/crypto/sparc/aes_asm.S                         |  165 +++
 lib/crypto/tests/Kconfig                           |    9 +
 lib/crypto/tests/Makefile                          |    1 +
 lib/{ => crypto}/tests/siphash_kunit.c             |    0
 lib/crypto/x86/aes-aesni.S                         |  817 ++++++++++--
 .../crypto => lib/crypto/x86}/aes-ctr-avx-x86_64.S |  117 +-
 .../crypto => lib/crypto/x86}/aes-xts-avx-x86_64.S |  179 +--
 lib/crypto/x86/aes.h                               |  381 +++++-
 lib/crypto/x86/chacha.h                            |   40 +-
 lib/crypto/x86/poly1305.h                          |    4 +-
 lib/crypto/x86/sha1-avx2-asm.S                     |   10 +-
 lib/crypto/x86/sha1-ssse3-and-avx.S                |    9 +-
 lib/crypto/x86/sha256-avx-asm.S                    |   10 +-
 lib/crypto/x86/sha256-avx2-asm.S                   |   10 +-
 lib/crypto/x86/sha256-ni-asm.S                     |    9 +-
 lib/crypto/x86/sha256-ssse3-asm.S                  |    8 +-
 lib/crypto/x86/sha512-avx-asm.S                    |   11 +-
 lib/crypto/x86/sha512-avx2-asm.S                   |   11 +-
 lib/crypto/x86/sha512-ssse3-asm.S                  |   11 +-
 lib/tests/Makefile                                 |    1 -
 security/keys/trusted-keys/trusted_tpm1.c          |    2 +-
 tools/testing/selftests/bpf/progs/test_siphash.h   |    2 +-
 88 files changed, 2670 insertions(+), 3660 deletions(-)
 create mode 100644 Documentation/crypto/libcrypto-zeroization.rst
 delete mode 100644 arch/riscv/crypto/aes-riscv64-glue.c
 delete mode 100644 arch/riscv/crypto/aes-riscv64-zvkned.S
 delete mode 100644 arch/x86/crypto/aesni-intel_asm.S
 rename {arch/riscv/crypto => lib/crypto/riscv}/aes-macros.S (90%)
 rename {arch/riscv/crypto => lib/crypto/riscv}/aes-riscv64-zvkned-zvbb-zvkg.S (74%)
 rename {arch/riscv/crypto => lib/crypto/riscv}/aes-riscv64-zvkned-zvkb.S (93%)
 rename lib/{ => crypto}/siphash.c (100%)
 rename lib/{ => crypto}/tests/siphash_kunit.c (100%)
 rename {arch/x86/crypto => lib/crypto/x86}/aes-ctr-avx-x86_64.S (88%)
 rename {arch/x86/crypto => lib/crypto/x86}/aes-xts-avx-x86_64.S (81%)
