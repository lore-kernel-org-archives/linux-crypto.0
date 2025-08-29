Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D6D320CC0;
	Fri, 29 Aug 2025 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481186; cv=none; b=TdvzgCvwayp3KPIv4siLcsrZDDsUqBdOtr4i9B1PNKAHto3c8GswyDHWcFddblKlKLCiPAn210BA+Ts+Da6ekKz/7FpTsIAk3d77jx0/NS0CWlfzx9Urbad8w7plG+Mzvk32MYvTm3TGt9w2JrflpcsoOLmLXPujYf55FfIqyU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481186; c=relaxed/simple;
	bh=6X4sbRQB+FutSUt/G5PnchGHprmc2fud5kgFpMc+qdA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JpJhSnYWw4h6jdXyDbt8TuFyJ+h4ph0LoMf9CuWmuvSVvBAcscnRQInZqwFvDKDXGmVFf2XJyzztquIQpQYnf6npWjGElDZv2O7e2qoat/lo/qc0/68QlGLhAMh7deC6tqI84qm0YEEQg/ZR/dT/ldfXTcM4u/d7a6fxDNKUz2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTDHxJRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTDHxJRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7B1C4CEF0;
	Fri, 29 Aug 2025 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756481185;
	bh=6X4sbRQB+FutSUt/G5PnchGHprmc2fud5kgFpMc+qdA=;
	h=From:To:Cc:Subject:Date:From;
	b=OTDHxJRdBTbuCPBTBoDfHVuT+Mxg7OYwG8bjswoan+ruOixFEQOihhqIaf8XGyW/8
	 f+lpedYRW0AD5rcKmO6LUF1rjVmK9e+qfy7QreRIaext4oT6kJQRBYiFBSmHqE0nq1
	 oM0nPJF4PNbAF22SvQrUz1cSr3J0K68oOAENbpYrAG79tuiu80bJU63vCJFI9byNs2
	 80h8fyl8zEGUMTuaeiArhhRMOHibhdge+OgVZ5GpaY731YVL9mgIvHcA5TZUZ7wHJC
	 ZWvBpVEXU0I61vDgStkoRGnXc0FltNhu9nnjlh0F4T7U80XaGJtfsH/ZMdOmuGVV2Y
	 2hbtTp4PbACPQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Andy Polyakov <appro@cryptogams.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 0/3] Consolidate Poly1305 code and add RISC-V optimization
Date: Fri, 29 Aug 2025 08:25:10 -0700
Message-ID: <20250829152513.92459-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git poly1305-v3

This series simplifies and optimizes the organization of the Poly1305
code by consolidating it into a single module.  This follows the example
of SHA-1, SHA-256, SHA-512, CRC32, etc.

Since the RISC-V Poly1305 patch has had a moving target, I also rebased
it on top of this series and included it as patch 3.

Changed in v3:
- Added mips/poly1305-core.S and riscv/poly1305-core.S to 'targets'.
  This fixed a bug where the perlasm build step was always running.

Changed in v2:
- Added missing 'FORCE' to the make rules for mips/poly1305-core.S
  and riscv/poly1305-core.S.

Eric Biggers (2):
  lib/crypto: poly1305: Remove unused function
    poly1305_is_arch_optimized()
  lib/crypto: poly1305: Consolidate into single module

Zhihang Shao (1):
  lib/crypto: riscv/poly1305: Import OpenSSL/CRYPTOGAMS implementation

 crypto/Kconfig                                |   2 +
 include/crypto/internal/poly1305.h            |  16 +-
 include/crypto/poly1305.h                     |   9 -
 lib/crypto/Kconfig                            |  53 +-
 lib/crypto/Makefile                           |  73 +-
 lib/crypto/arm/Kconfig                        |   5 -
 lib/crypto/arm/Makefile                       |  18 -
 lib/crypto/arm/poly1305-armv4.pl              |   3 +-
 lib/crypto/arm/poly1305-glue.c                |  76 --
 lib/crypto/arm/poly1305.h                     |  53 ++
 lib/crypto/arm64/Kconfig                      |   6 -
 lib/crypto/arm64/Makefile                     |  13 -
 lib/crypto/arm64/poly1305-armv8.pl            |   3 +
 lib/crypto/arm64/poly1305-glue.c              |  74 --
 lib/crypto/arm64/poly1305.h                   |  50 ++
 lib/crypto/mips/Kconfig                       |   5 -
 lib/crypto/mips/Makefile                      |  14 -
 lib/crypto/mips/poly1305-glue.c               |  33 -
 lib/crypto/mips/poly1305-mips.pl              |   8 +-
 lib/crypto/mips/poly1305.h                    |  14 +
 lib/crypto/poly1305-generic.c                 |  25 -
 lib/crypto/poly1305.c                         |  81 +-
 lib/crypto/powerpc/Kconfig                    |   8 -
 lib/crypto/powerpc/Makefile                   |   3 -
 .../{poly1305-p10-glue.c => poly1305.h}       |  40 +-
 lib/crypto/riscv/poly1305-riscv.pl            | 847 ++++++++++++++++++
 lib/crypto/riscv/poly1305.h                   |  14 +
 lib/crypto/x86/Kconfig                        |   6 -
 lib/crypto/x86/Makefile                       |  10 -
 lib/crypto/x86/poly1305-x86_64-cryptogams.pl  |  33 +-
 .../x86/{poly1305_glue.c => poly1305.h}       |  47 +-
 31 files changed, 1176 insertions(+), 466 deletions(-)
 delete mode 100644 lib/crypto/arm/poly1305-glue.c
 create mode 100644 lib/crypto/arm/poly1305.h
 delete mode 100644 lib/crypto/arm64/poly1305-glue.c
 create mode 100644 lib/crypto/arm64/poly1305.h
 delete mode 100644 lib/crypto/mips/poly1305-glue.c
 create mode 100644 lib/crypto/mips/poly1305.h
 delete mode 100644 lib/crypto/poly1305-generic.c
 rename lib/crypto/powerpc/{poly1305-p10-glue.c => poly1305.h} (63%)
 create mode 100644 lib/crypto/riscv/poly1305-riscv.pl
 create mode 100644 lib/crypto/riscv/poly1305.h
 rename lib/crypto/x86/{poly1305_glue.c => poly1305.h} (83%)


base-commit: 5012bd2dc6ab0c4499923b3b6c6113def9b0c88b
-- 
2.50.1

