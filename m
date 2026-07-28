Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFC319005E;
	Tue, 28 Jul 2026 02:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785205158; cv=none; b=nBpcoqYwDCOiHNxnr3QCCel5nFUAcvBxhLGXb3Y5vThh0mX6Zeh9TGQN6FRnd42I74TsjAep3qyJ54Rq/DC3OVE0yiAD4j1mXcxMpz0/iOLwe9ZHgT9GXCvJmKIKyTD4BpwdBcPeFLcvSTn/TXLwFaTGzRknZJyDwKZqNGf26ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785205158; c=relaxed/simple;
	bh=JD0aXN7L9TkB2VhdzAH5K1HhfowWeweFOplM0gM5XBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ENO38yVTTDnzamcRl/5YOOYf+tmYRKCGhAUWBP4CWTlDmsAoklVWMuGVKQzCz6EZuRPxUwViUBpbnePWGNgrdCjNUFJjZYDuovN/0qpl8eNBCALX1v7ro9C35K60i+jbZNa5eojmUO5L83kko5D0/mWY/5yvVheuocrRojLQXDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c8TOFlLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c8TOFlLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1331F000E9;
	Tue, 28 Jul 2026 02:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785205156;
	bh=3GT4DkuXPLrNuHBtj16uB1HtM7QTZwonA+LlCLJaorI=;
	h=From:To:Cc:Subject:Date;
	b=c8TOFlLlA45pS17ZPF7tHUHXPBvFoBoL0bXs1CuDyAPgKS+zZTIS0CwgmJgkr6s1s
	 X3y3D1dzNqLjYEvGkRH7P4ejs4Qfrl+WYtt3N+W9ZBi7GqimpBT6JqfhWkWPA/5K6W
	 GvBwbYOh87HPlIQaTAylCZcA5HsXA8KgCRYioCGbG7wqIY/Jr+aqPXE8vlL6j416fB
	 PgRRW0prjr0DcVwfZ0yEEx8WolrNAnxdNiVMBpogwjasaJZJWTDE1Mkyn7ZHcTgUCP
	 v7zpzPQVPwLBD6Wu0npbGDXLrou6DbPDWNbauOQQEya49tQvbst17QDtF4AciWCCdw
	 4Jd8v0pduC7dw==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/8] x86: Remove cpu_has_xfeatures() and add AVX-512 xor_gen()
Date: Mon, 27 Jul 2026 19:15:55 -0700
Message-ID: <20260728021603.79870-1-ebiggers@kernel.org>
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
  lib/raid/xor: x86: Remove redundant X86_FEATURE_OSXSAVE check
  lib/raid/xor: x86: Add AVX-512 optimized xor_gen()

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
 arch/x86/kernel/fpu/xstate.c               |  65 ++++-------
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
 lib/raid/xor/x86/xor-avx512.c              | 121 +++++++++++++++++++++
 lib/raid/xor/x86/xor_arch.h                |  31 ++++--
 29 files changed, 273 insertions(+), 194 deletions(-)
 create mode 100644 lib/raid/xor/x86/xor-avx512.c


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.55.0

