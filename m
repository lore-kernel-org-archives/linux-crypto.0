Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACB2C2EF;
	Sun, 16 Feb 2025 23:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739746832; cv=none; b=MgtioPSW2T0v6yCreQcp5enYrIwvzAI6ahtyKWdmv9GZNElHAd0ksHh5XwefvfXg6mCr3OFWehZK+6zGzNDV0jb97vvTClE75iW9MNxdt2X/Ah/GyRT1ifBAWfM59q6CNwijmc7eN2Y1Y8tLiFklSJ470ecVQymUeTQdPSERxzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739746832; c=relaxed/simple;
	bh=2d6ZtWkWQ357DtEP1dRgzHJghjeMoRX2Npj7Yv4hSGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tjtbhQk1zHn1FzCDjQrLsbUUBbvTbOIeVXnXpHikoF1qngBqL9YS7nut0h6gBqhxKjlo5mgWfXbuLdUCFNjaZXI9sa/mEQ28VWNH26FGCJHLdPAv4S8jDudCBTC5YjASpkx7e/mUC3Btyo8XiBncTxdDjsHZu4lSk5roIvGLa+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QohltwnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QohltwnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65928C4CEDD;
	Sun, 16 Feb 2025 23:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739746831;
	bh=2d6ZtWkWQ357DtEP1dRgzHJghjeMoRX2Npj7Yv4hSGE=;
	h=From:To:Cc:Subject:Date:From;
	b=QohltwnVNTwOz7KDrIKCLR37vW5W4nrOzm7uF7UIuCKk1SlnGDxR0Z/2pl3ag4fm9
	 SY5blg5pleNqD+N3p2pu3d2nWtMCvQEihDPmiyWmHwgRO9vEgBKe4d4reZuZDyZyGM
	 EkAiu18j4zY5bfptlaaAhja8S/IeQ07X6uZkD7vLBiMDXyDkd6NOZt/OGAAwacjEc0
	 4aBn2i/12jAC6TPGTJSeL3H2ZM6tUyGWGmHLbNgTpyCHhPXIJS2kXgdmG398QvYsP0
	 qlPhWtPFLB4P5gZuswb7PN1rWTQJva2HMrcvWrvNKMzN0R40VYUBZz2ydGC8sPGoYe
	 mc9HLIccc8gyA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Xiao Wang <xiao.w.wang@intel.com>,
	Charlie Jenkins <charlie@rivosinc.com>
Subject: [PATCH 0/4] RISC-V CRC optimizations
Date: Sun, 16 Feb 2025 14:55:26 -0800
Message-ID: <20250216225530.306980-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is a replacement for
"[PATCH v4] riscv: Optimize crct10dif with Zbc extension"
(https://lore.kernel.org/r/20250211071101.181652-1-zhihang.shao.iscas@gmail.com/).
It adopts the approach that I'm taking for x86 where code is shared
among CRC variants.  It replaces the existing Zbc optimized CRC32
functions, then adds Zbc optimized CRC-T10DIF and CRC64 functions.

This new code should be significantly faster than the current Zbc
optimized CRC32 code and the previously proposed CRC-T10DIF code.  It
uses "folding" instead of just Barrett reduction, and it also implements
Barrett reduction more efficiently.

This applies to crc-next at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next.
It depends on other patches that are queued there for 6.15, so I plan to
take it through there if there are no objections.

Tested with crc_kunit in QEMU (set CONFIG_CRC_KUNIT_TEST=y and
CONFIG_CRC_BENCHMARK=y), both 32-bit and 64-bit.  I don't have real Zbc
capable hardware to benchmark this on, but the new code should work very
well; similar optimizations work very well on other architectures.

Eric Biggers (4):
  riscv/crc: add "template" for Zbc optimized CRC functions
  riscv/crc32: reimplement the CRC32 functions using new template
  riscv/crc-t10dif: add Zbc optimized CRC-T10DIF function
  riscv/crc64: add Zbc optimized CRC64 functions

 arch/riscv/Kconfig                  |   2 +
 arch/riscv/lib/Makefile             |   5 +
 arch/riscv/lib/crc-clmul-consts.h   | 122 +++++++++++
 arch/riscv/lib/crc-clmul-template.h | 265 ++++++++++++++++++++++++
 arch/riscv/lib/crc-clmul.h          |  23 +++
 arch/riscv/lib/crc-t10dif.c         |  24 +++
 arch/riscv/lib/crc16_msb.c          |  18 ++
 arch/riscv/lib/crc32-riscv.c        | 310 ----------------------------
 arch/riscv/lib/crc32.c              |  53 +++++
 arch/riscv/lib/crc32_lsb.c          |  18 ++
 arch/riscv/lib/crc32_msb.c          |  18 ++
 arch/riscv/lib/crc64.c              |  34 +++
 arch/riscv/lib/crc64_lsb.c          |  18 ++
 arch/riscv/lib/crc64_msb.c          |  18 ++
 scripts/gen-crc-consts.py           |  55 ++++-
 15 files changed, 672 insertions(+), 311 deletions(-)
 create mode 100644 arch/riscv/lib/crc-clmul-consts.h
 create mode 100644 arch/riscv/lib/crc-clmul-template.h
 create mode 100644 arch/riscv/lib/crc-clmul.h
 create mode 100644 arch/riscv/lib/crc-t10dif.c
 create mode 100644 arch/riscv/lib/crc16_msb.c
 delete mode 100644 arch/riscv/lib/crc32-riscv.c
 create mode 100644 arch/riscv/lib/crc32.c
 create mode 100644 arch/riscv/lib/crc32_lsb.c
 create mode 100644 arch/riscv/lib/crc32_msb.c
 create mode 100644 arch/riscv/lib/crc64.c
 create mode 100644 arch/riscv/lib/crc64_lsb.c
 create mode 100644 arch/riscv/lib/crc64_msb.c


base-commit: cf1ea3a7c1f63cba7d1dd313ee3accde0c0c8988
-- 
2.48.1

