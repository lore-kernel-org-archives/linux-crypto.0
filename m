Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113522135AD;
	Sat,  6 Sep 2025 21:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757194617; cv=none; b=SAjKXS04gGAD9ViZUaHbChIUWximZ7xgFkyKi/ot0PhFzIZTpYUg8yXnEDRx29FgeOzTgxpUg5oQ3e65zOXhawJFlbSVYwHJ5LrXKIB0k0iAxFHbnczMkw+Qt3b3gCP3rZ+gua9KaYEdE2xiD0dQEoCVVVhqEH1dONJlt9hdfEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757194617; c=relaxed/simple;
	bh=IesAjkCYOGpflP2789SjEF/QyWGCcvo1W1xkNCqpIB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RIqoIiC7slItl9kVcNaoaX7SmtVAk1q63okC+ImhiC1d6PQ5XxTqboJjqHqyaNJD4yafAHMzzNrQ4SQKn1n73sxsFCLKo7zKoEEzVbQihPUS7L13eVrHsNmF9ZySosLEq9dWbJjKdaDBoHSu7RFCvSV3h0zqSmpfL80eK8ktkgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0gaTjHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0gaTjHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763D5C4CEE7;
	Sat,  6 Sep 2025 21:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757194616;
	bh=IesAjkCYOGpflP2789SjEF/QyWGCcvo1W1xkNCqpIB4=;
	h=From:To:Cc:Subject:Date:From;
	b=C0gaTjHYH0JBqqIGhTuB0tR5U5fZpfgEQeXd0gD9RnbIC89y7hF85+QF9EWH5PphP
	 nVrC2w0jeMdNVHq5OqCCHlgYFUk3fHP1vQvqjoVXhJTjabgBMVPQEpQBZnLrHLG2Nj
	 pkGB0piOP1wo7OBhrrFQfA2FotmlCNQkuYb9SwvYeJRM72w4E0anatDeebM+Uw2T7q
	 Wvqf0F7vw/JPHgNnGjaB4BoWOxsLu+U1d/YyeF7QJ5BZ+KMpohdgdjzFyyJ8abvuo2
	 opDCZACNXQ2+PGZ8K9pJmstb9/sDkgRdOUxClGdg+tLpmRNUWt5hU/We/3YecB0jYB
	 QafJKoBplsIzA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 00/12] Curve25519 cleanup
Date: Sat,  6 Sep 2025 14:35:11 -0700
Message-ID: <20250906213523.84915-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git curve25519-v2

This series removes the unused crypto_kpp support for Curve25519,
migrates curve25519-selftest to a KUnit test suite, and reorganizes the
generic and arch-optimized Curve25519 code to all be located in
lib/crypto/ and built into a single libcurve25519 module.

Changed from v1:
- Split kpp removal into multiple patches
- Don't select CRYPTO_LIB_CURVE25519_GENERIC from KUnit test
- Removed unnecessary parameter from hpre_ecc_clear_ctx()
- Removed unnecessary 'return' from arm curve25519_base_arch()
- Updated file comment in lib/crypto/curve25519.c
- Made kconfig help text for KUnit test more consistent with other tests
- Used initializer in test_curve25519()
- Removed unnecessary newlines from messages in test_curve25519()
- Use NSEC_PER_SEC instead of literal 1000000000
- Added an Acked-by

Eric Biggers (12):
  crypto: hisilicon/hpre - Remove unused curve25519 kpp support
  crypto: arm/curve25519 - Remove unused kpp support
  crypto: powerpc/curve25519 - Remove unused kpp support
  crypto: x86/curve25519 - Remove unused kpp support
  crypto: testmgr - Remove curve25519 kpp tests
  crypto: curve25519 - Remove unused kpp support
  lib/crypto: tests: Migrate Curve25519 self-test to KUnit
  lib/crypto: tests: Add Curve25519 benchmark
  lib/crypto: curve25519: Move a couple functions out-of-line
  lib/crypto: curve25519: Consolidate into single module
  lib/crypto: tests: Enable Curve25519 test when CRYPTO_SELFTESTS
  wireguard: kconfig: Simplify crypto kconfig selections

 arch/arm/crypto/Kconfig                       |   13 -
 arch/arm/crypto/Makefile                      |    2 -
 arch/arm/crypto/curve25519-glue.c             |  137 --
 arch/m68k/configs/amiga_defconfig             |    1 -
 arch/m68k/configs/apollo_defconfig            |    1 -
 arch/m68k/configs/atari_defconfig             |    1 -
 arch/m68k/configs/bvme6000_defconfig          |    1 -
 arch/m68k/configs/hp300_defconfig             |    1 -
 arch/m68k/configs/mac_defconfig               |    1 -
 arch/m68k/configs/multi_defconfig             |    1 -
 arch/m68k/configs/mvme147_defconfig           |    1 -
 arch/m68k/configs/mvme16x_defconfig           |    1 -
 arch/m68k/configs/q40_defconfig               |    1 -
 arch/m68k/configs/sun3_defconfig              |    1 -
 arch/m68k/configs/sun3x_defconfig             |    1 -
 arch/powerpc/crypto/Kconfig                   |   13 -
 arch/powerpc/crypto/Makefile                  |    2 -
 arch/s390/configs/debug_defconfig             |    1 -
 arch/s390/configs/defconfig                   |    1 -
 arch/x86/crypto/Kconfig                       |   13 -
 arch/x86/crypto/Makefile                      |    5 -
 crypto/Kconfig                                |    8 -
 crypto/Makefile                               |    1 -
 crypto/curve25519-generic.c                   |   91 --
 crypto/testmgr.c                              |    6 -
 crypto/testmgr.h                              | 1225 -----------------
 drivers/crypto/hisilicon/Kconfig              |    1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c   |  403 +-----
 drivers/net/Kconfig                           |   15 +-
 include/crypto/curve25519.h                   |   40 +-
 lib/crypto/Kconfig                            |   37 +-
 lib/crypto/Makefile                           |   27 +-
 .../crypto/arm}/curve25519-core.S             |    0
 lib/crypto/arm/curve25519.h                   |   47 +
 lib/crypto/curve25519-generic.c               |   25 -
 lib/crypto/curve25519.c                       |   69 +-
 .../crypto/powerpc}/curve25519-ppc64le_asm.S  |    0
 .../crypto/powerpc/curve25519.h               |  124 +-
 lib/crypto/tests/Kconfig                      |    9 +
 lib/crypto/tests/Makefile                     |    1 +
 .../curve25519_kunit.c}                       |   99 +-
 .../crypto/x86/curve25519.h                   |  127 +-
 42 files changed, 236 insertions(+), 2318 deletions(-)
 delete mode 100644 arch/arm/crypto/curve25519-glue.c
 delete mode 100644 crypto/curve25519-generic.c
 rename {arch/arm/crypto => lib/crypto/arm}/curve25519-core.S (100%)
 create mode 100644 lib/crypto/arm/curve25519.h
 delete mode 100644 lib/crypto/curve25519-generic.c
 rename {arch/powerpc/crypto => lib/crypto/powerpc}/curve25519-ppc64le_asm.S (100%)
 rename arch/powerpc/crypto/curve25519-ppc64le-core.c => lib/crypto/powerpc/curve25519.h (56%)
 rename lib/crypto/{curve25519-selftest.c => tests/curve25519_kunit.c} (96%)
 rename arch/x86/crypto/curve25519-x86_64.c => lib/crypto/x86/curve25519.h (94%)


base-commit: 362f92286065d9f8282da5def89e173a12191568
-- 
2.50.1

