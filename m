Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1F826B75C;
	Mon,  1 Sep 2025 20:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756758003; cv=none; b=cPUnkgdvCQeS2vsMlLyTk+Ubm/XZIUFxXzHLRJzvH8PpOulHlcKNwP9iT1J50JZkWyUdqYvAwplT10kCHi0CnvWjCjhOYHxrClOZPBULFYjjW/EgJkC0aUhYeRsvwU8183qzNPnbNn5MT+sXf63msWhP+nbivqnF7scpqRgMDB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756758003; c=relaxed/simple;
	bh=LoGorSDHkEkIDGpixgk16+eL3mYFxlvutZWyJcKrM/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BAGgRkeDmO76+S+8LBukZpIFShwqXZ7/LbaQkhiDomeblm2mwWvPYClCHmZoTuIfcAvzN0sh2NB9BqhxsaC55EwqTK9TdVHa1r5ZXNjL32av7Nt10nkej+TmMiJQ5FAVvAYigC8LDw8Cpym9M0xZjwg9kVe9H2KqULQzaUX6RDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIzhIB/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIzhIB/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A09FC4CEF0;
	Mon,  1 Sep 2025 20:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756758002;
	bh=LoGorSDHkEkIDGpixgk16+eL3mYFxlvutZWyJcKrM/I=;
	h=From:To:Cc:Subject:Date:From;
	b=AIzhIB/CNTd0wQFTtQjTvf7CsPNPwGEkwECUVhQOAz+FgHxLrCvXjjQTQKSXXcMB7
	 HAFQwwyPtBlLZgivyflOdd+HxDbrXS1bYj7HuhR75Pf4piROorXcT+eMYY0cGTaJXz
	 jU20iRaetmGGLVL8ixBenxqd0DXxsVtgTe/XywK8pjUdRtp0wwsnSycmifhMWTHm3m
	 gMlqHexiPwAgKPX9uoJRLLtRAbl0TN0vofhHgWAlyV87Rxl7Aokfuo2luCm5+fDzeU
	 +NKtrOtCxyJd8LDrfZgg29Sxa9hqhUvlHTqooqlRV/VGc/rVqx0DbKF+ABC2/PoCyb
	 QZDoRWJ6VDFvA==
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
Subject: [PATCH 0/6] Curve25519 cleanup
Date: Mon,  1 Sep 2025 13:18:09 -0700
Message-ID: <20250901201815.594177-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git curve25519-v1

This series removes the unused crypto_kpp support for Curve25519,
migrates curve25519-selftest to a KUnit test suite, and reorganizes the
generic and arch-optimized Curve25519 code to all be located in
lib/crypto/ and built into a single libcurve25519 module.

Eric Biggers (6):
  crypto: curve25519 - Remove kpp support
  lib/crypto: tests: Migrate Curve25519 self-test to KUnit
  lib/crypto: tests: Add Curve25519 benchmark
  lib/crypto: curve25519: Move a couple functions out-of-line
  lib/crypto: curve25519: Consolidate into single module
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
 drivers/crypto/hisilicon/hpre/hpre_crypto.c   |  394 ------
 drivers/net/Kconfig                           |   15 +-
 include/crypto/curve25519.h                   |   40 +-
 lib/crypto/Kconfig                            |   37 +-
 lib/crypto/Makefile                           |   27 +-
 .../crypto/arm}/curve25519-core.S             |    0
 lib/crypto/arm/curve25519.h                   |   47 +
 lib/crypto/curve25519-generic.c               |   25 -
 lib/crypto/curve25519.c                       |   64 +-
 .../crypto/powerpc}/curve25519-ppc64le_asm.S  |    0
 .../crypto/powerpc/curve25519.h               |  124 +-
 lib/crypto/tests/Kconfig                      |   10 +
 lib/crypto/tests/Makefile                     |    1 +
 .../curve25519_kunit.c}                       |  100 +-
 .../crypto/x86/curve25519.h                   |  127 +-
 42 files changed, 232 insertions(+), 2310 deletions(-)
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

