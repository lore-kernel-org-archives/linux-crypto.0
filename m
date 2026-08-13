Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EEA20D4F0;
	Thu, 13 Aug 2026 02:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786587620; cv=none; b=GADUT16+/FZVWoFdRL/8xFvBkaGUojmjP0Hcf44ZwWNQXkSrA52/YmBfI5IGPmYCJveMU6b6TcFyzReD2Q1LKR/9ICDZWjte/AKyYuPi7M5Ub2RryFdtBRLWZgXAp1MdEIiHNNl3fYtF4xK1dHR1njfknWl1hzWP8/Kx+o9ckJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786587620; c=relaxed/simple;
	bh=r9CDPVWhGzXnqQIiiv36dnrD8MgIOT+o5NgDlc0hVyU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Od6/EXve+Qv6OPAaMnD+7BtZoBs2f/L5M2wltJpCDj29Mh3m0d9dsdUJZTGLxzbqH6ZErfOGqfgtM1KbCFNLbNZV9j/q9w7Ge4nMO8LS2GlO5Mj24Dp+RUYU6Ha6sHEs8F2WYYbEHJ/9SKa2gU0RcxfLbq7SNaxZ0twefJXBNRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ejmlk6Sv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ejmlk6Sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0B81F000E9;
	Thu, 13 Aug 2026 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786587618;
	bh=/zNmD9B/x2+gqm/TQnDXsoFe7SLMMlZBmFWol8zSk7o=;
	h=From:To:Cc:Subject:Date;
	b=ejmlk6Sv3jcbV5bE+4pHEkNBfN9RU954ynU40fQc0I1vrwz3rz4GfmUVYsi/d2skM
	 FjOfiSbcBvd2V7PfIuudRruKDpobVFrZMH4omgOCUguaiMgbPHlFAvGAPGhcCQblhV
	 oI9g/xOtB/Kh2ue0/nxqHvP3pHDTRP4QOledcVy526zmUEDASzeawMGRjC4rt8L2Iz
	 YEvhdItLR2UB/2DqxQY639BOly62lAUfJlgnNxjr9MP+rwZkQmOZJTBnMqjjYn3IHL
	 c8bF/Wf58YSXpqSLgRv5VWfjwJJF4CAMihf99Mk5OuQXbVwho1J87BWpzDLBXUkwPZ
	 pW77YIDeL3OAw==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 0/8] x86: Remove cpu_has_xfeatures() and add AVX-512 xor_gen()
Date: Wed, 12 Aug 2026 19:14:58 -0700
Message-ID: <20260813021506.55129-1-ebiggers@kernel.org>
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
 lib/raid/xor/x86/xor-avx512.c              | 121 +++++++++++++++++++++
 lib/raid/xor/x86/xor_arch.h                |  31 ++++--
 29 files changed, 275 insertions(+), 196 deletions(-)
 create mode 100644 lib/raid/xor/x86/xor-avx512.c


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
2.55.0

