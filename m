Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEE0371CFF;
	Sat, 15 Aug 2026 18:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786817553; cv=none; b=mcCSL6EtT6n6bswcafkQXJS6ai5dsFq0OzpzYQ5QRV2bc1qCveUO4T2EC3E8Gpan16Id42whLajfpBjO752zqhXL3WxJ96aI30ih/jBAMWY685YGmh6TpdKscWq4CP0eWUrtxi5xtKt30gq5O5AykpYzJTsCPO0Rq9Zqr9tGRFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786817553; c=relaxed/simple;
	bh=pmjuG1AODIqpOq+1jh2NCV+yqn53Zvw3O2+evDIojjg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g+AdI/uDYv6zlsQopIoCs3Vg4xMUVTgowJ5HWiNDpxJcCfQkCLgb2tXKQE6m8fMEO6rJoO0Hk8f+yphxjAvL3nStrE7bpFFcDE5EoavTxztkE8SvVfDAG68DXekzNltUcY/EpbJg9PxD+gZmn4IVtGQ6hrUSi+TAeh5o9v6t3mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUJy6BdX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUJy6BdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA801F000E9;
	Sat, 15 Aug 2026 18:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786817551;
	bh=boGlZUbppWi28M8Be+twFNXFg8XXlVmUCtGBCUWWS5o=;
	h=From:To:Cc:Subject:Date;
	b=kUJy6BdXdx5DKNkIvJymTxL58RedkTTZIU5BFRV25ttL6v+w/WaZAlLrpKLxR03XG
	 73YVqI+S9ky60SA/jOTdC7EcAdHNrd6RNA4OmL5u/zxyxZqCtyYagV+ZXaUE07IMnl
	 EfSCX9Gre/JLuLrwoiELhDiWvqa+l3O5/TV7sU1Phg5NiccYYAwEdF8iEyL7OIuTG5
	 3nC11IMzHfpDTaxBygLLcKtLy6zw4YIvf44Ho+vr/kzrUX9PAlpMCGQ+1uORcxtCPg
	 WG9oJLtg80jvBrcfpXzQgIuSVF9C+lv46dyeut0ZYM2jGk7hXmRxMevuO86rNVguPS
	 ZvZPq7KSeXYNA==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 0/8] x86: Remove cpu_has_xfeatures() and add AVX-512 xor_gen()
Date: Sat, 15 Aug 2026 11:10:16 -0700
Message-ID: <20260815181024.28924-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series consolidates and cleans up how the kernel handles CPU
feature flags for AVX and AVX-512 when the underlying OS or hypervisor
(if any) doesn't enable the required xstate features in XCR0.

Specifically, it makes the checks for xstate features be done in a
single place at boot time for both UML and native x86, instead of
everywhere kernel code wants to check for AVX or AVX-512 support.

Patch 8 then adds an AVX-512 optimized implementation of xor_gen() for
RAID, which had been blocked on confusion around cpu_has_xfeatures() and
its lack of implementation on UML.

Changed in v4:
  - Added missing vzeroupper instructions in xor-avx512.c

Changed in v3:
  - Updated the implementation of fpu__init_system_xstate() as suggested
    by Borislav
  - Added Acked-by tags
  - Used "xor:" commit subject

Changed in v2:
  - Made x86 clear the AVX* bits if FPU or XSAVE features are missing.
  - Updated comment in x86 arch_xor_init().
  - Updated commit message for the UML commit to clarify that checking
    XCR0 is standard practice in userspace

Eric Biggers (8):
  x86/fpu: Check for missing AVX and AVX-512 xstate bits
  um: Check for missing AVX and AVX-512 xstate bits
  crypto: x86 - Stop using cpu_has_xfeatures()
  lib/crypto: x86: Stop using cpu_has_xfeatures()
  lib/crc: x86: Stop using cpu_has_xfeatures()
  x86/fpu: Remove cpu_has_xfeatures()
  xor: Remove redundant X86_FEATURE_OSXSAVE check
  xor: Add AVX-512 optimized xor_gen()

 arch/um/kernel/um_arch.c                   |  78 ++++++++++++-
 arch/x86/crypto/aegis128-aesni-glue.c      |   3 +-
 arch/x86/crypto/aesni-intel_glue.c         |   7 +-
 arch/x86/crypto/aria_aesni_avx2_glue.c     |  11 +-
 arch/x86/crypto/aria_aesni_avx_glue.c      |  11 +-
 arch/x86/crypto/aria_gfni_avx512_glue.c    |  11 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c |  11 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c  |  11 +-
 arch/x86/crypto/cast5_avx_glue.c           |   7 +-
 arch/x86/crypto/cast6_avx_glue.c           |   7 +-
 arch/x86/crypto/serpent_avx2_glue.c        |   9 +-
 arch/x86/crypto/serpent_avx_glue.c         |   7 +-
 arch/x86/crypto/sm4_aesni_avx2_glue.c      |  11 +-
 arch/x86/crypto/sm4_aesni_avx_glue.c       |  11 +-
 arch/x86/crypto/twofish_avx_glue.c         |   6 +-
 arch/x86/include/asm/fpu/api.h             |   9 --
 arch/x86/kernel/fpu/xstate.c               |  69 +++++-------
 lib/crc/x86/crc-pclmul-template.h          |   6 +-
 lib/crypto/x86/blake2s.h                   |   4 +-
 lib/crypto/x86/chacha.h                    |   3 +-
 lib/crypto/x86/nh.h                        |   4 +-
 lib/crypto/x86/poly1305.h                  |   7 +-
 lib/crypto/x86/sha1.h                      |   4 +-
 lib/crypto/x86/sha256.h                    |   4 +-
 lib/crypto/x86/sha512.h                    |   3 +-
 lib/crypto/x86/sm3.h                       |   3 +-
 lib/raid/xor/Makefile                      |   2 +-
 lib/raid/xor/x86/xor-avx512.c              | 125 +++++++++++++++++++++
 lib/raid/xor/x86/xor_arch.h                |  31 +++--
 29 files changed, 279 insertions(+), 196 deletions(-)
 create mode 100644 lib/raid/xor/x86/xor-avx512.c


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
2.55.0

