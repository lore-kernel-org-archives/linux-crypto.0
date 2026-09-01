Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223C73D890B;
	Tue,  1 Sep 2026 14:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274694; cv=none; b=PVbhLo99eylpLEbooL9wVupZO57kXktPE5DKglEt1rx46zgODVtG/cGDJo2J8J5qyu3ee4J+0zRGDCOyxk84FIHAn+GM+GXJvreGdU9Ii3PAMb/tCCUQHg0qVGJX/OiNJILpNnwHwG5t87r8GPLTN7sJBGMOVzvyNJHswjo4oTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274694; c=relaxed/simple;
	bh=y83eikXk8GUd2cBtc2uTCXIv0/Xzw6ZdWBcjEeeINTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sh17K30AiT2rJmVdqvNmT+thowEIZuV+hPiyH0lku6o+MbUMN6lRCtuNzSPaGvjjEZDXNPzT6OZmiD4BJP/IdD7e333Cd+n7WH5AJwKSwiLO8bcBzn1+jG2dzbVBU0/6CZYSHhP3zDggvUG9znV3uzb1wyYt7wxpuGVOEzXA8ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSmZEpip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSmZEpip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3573A1F000E9;
	Tue,  1 Sep 2026 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274692;
	bh=iUpjiTv1KRvFABoYYph8lVPGE+bZqchdutvEQG6SYQI=;
	h=From:To:Cc:Subject:Date;
	b=hSmZEpipj6ibJ/5DHn71+dcqM3a8A0IRF+6SKnv018OiWNgwKD6W6tTBe/4ljcULg
	 dLoEAdMBZgUJPLm/f9deS/q4OirmzNLs0IlmRHjRgE7MTNhMQFbyZEz7mp1gJMqs2V
	 IyKJVxwWwMgbnXNLLQOEb3zXGB+omA6fos0RdiczaNc1di9yOPE/iZmc1NkicK3/Rf
	 aekc8fEDWh0e8iusb1w5e88WMt5jLecI1HUkP00GCsq/LMSYFcdcLYE2gdv8S8FCYv
	 sToypstdm6rsI2Jt9K09+tSTD//r1pyD7jiM2KTuZWsm3ZjuFKKD6RbmS/9TFP6YLa
	 UXU//mxVpX1hw==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v5 0/8] x86: Remove cpu_has_xfeatures() and add AVX-512 xor_gen()
Date: Tue,  1 Sep 2026 07:57:32 -0700
Message-ID: <20260901145740.42337-1-ebiggers@kernel.org>
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

Please consider this series for the x86 tree for 7.4.

Changed in v5:
  - Replaced benchmark results with the new xor_benchmark
  - Consolidated the vzeroupper in xor-avx512.c into one location

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
 lib/raid/xor/x86/xor-avx512.c              | 122 +++++++++++++++++++++
 lib/raid/xor/x86/xor_arch.h                |  31 ++++--
 29 files changed, 276 insertions(+), 196 deletions(-)
 create mode 100644 lib/raid/xor/x86/xor-avx512.c


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.55.0

