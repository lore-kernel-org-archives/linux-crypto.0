Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BCE7260E;
	Mon, 26 May 2025 01:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748222067; cv=none; b=R5MnIqa+eKyivdJ86mnEbf38I2VETHNMLFdoY/kybbHKIn78QRSPUB1Kx9/oEx/Rn8CjoFu/7gTOM4FvPwH5XSIxwzl+YjVMOoaVzR3XiDR4rdbH3IpDV1pRqffLQg5G9KvxC8i5Mgfdh84a+BZ55MMkGp1hrDtV1wK/G6etwBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748222067; c=relaxed/simple;
	bh=Fm+xCExh9CS+Ll5HMah9TNGbPwpa3yIf0XkE5BrdyaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eSUKTUxaAXNqr10cNH78dqHB910vxskeGDoyjcrkrR8ucZuRB9ow1mpktXeGlEPIM9tzT+q4Qf84UaQnKEgckAg+rQqTqS74bCKwFOZHQhqW7iyrmgBgVeIBtyI2Clt+wXomQ9xHsa6qJa6JbG9dFev8CxWLGXfmLMSKeS/XW7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXKxaRgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXKxaRgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC08C4CEEA;
	Mon, 26 May 2025 01:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748222066;
	bh=Fm+xCExh9CS+Ll5HMah9TNGbPwpa3yIf0XkE5BrdyaQ=;
	h=Date:From:To:Cc:Subject:From;
	b=oXKxaRgxfBoiSvPxknru5U/225MSmrjFncK/qXUhU1ik1QogHr0alCrdj5JsufZh3
	 gGI6M6PZv6W38e6yJ0PWEVsOUvzRSCRcZhJWmFjtAO3XgCORaCQkog1jjkOLDXFZC+
	 oAX+nA2RPLeovuSqsw4OL+eY4mJnm5Q5NWR9bOuvhqKh54+3bK3SGbMZTDX7kEGZjG
	 cgk4Fce00fIR/TJ6smXhc90fwiVHFqIqWxjM9vIWEKAe2z9M5QFhB9mrdM313aEUME
	 Bip/lecIu7F15lNKaFPx0R4SKnHjISzCrpeHkNuThH3JNf5ZSnzG58DE5d4y2MnYSR
	 /ltl0+QjD6dFw==
Date: Sun, 25 May 2025 18:14:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [GIT PULL] CRC updates for 6.16
Message-ID: <20250526011412.GB23241@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 8ffd015db85fea3e15a77027fda6c02ced4d2444:

  Linux 6.15-rc2 (2025-04-13 11:54:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to 289c99bec7eed918ab37c62cbb29a2e3f58fb1fb:

  lib/crc32: add SPDX license identifier (2025-05-14 09:15:38 -0700)

----------------------------------------------------------------

Cleanups for the kernel's CRC (cyclic redundancy check) code:

- Use __ro_after_init where appropriate
- Remove unnecessary static_key on s390
- Rename some source code files
- Rename the crc32 and crc32c crypto API modules
- Use subsys_initcall instead of arch_initcall
- Restore maintainers for crc_kunit.c
- Fold crc16_byte() into crc16.c
- Add some SPDX license identifiers

----------------------------------------------------------------
Eric Biggers (15):
      lib/crc: make the CPU feature static keys __ro_after_init
      s390/crc32: Remove no-op module init and exit functions
      arm/crc: drop "glue" from filenames
      arm64/crc: drop "glue" from filenames
      powerpc/crc: drop "glue" from filenames
      powerpc/crc: rename crc32-vpmsum_core.S to crc-vpmsum-template.S
      s390/crc: drop "glue" from filenames
      sparc/crc: drop "glue" from filenames
      x86/crc: drop "glue" from filenames
      crypto: crc32 - remove "generic" from file and module names
      lib/crc: make arch-optimized code use subsys_initcall
      MAINTAINERS: add crc_kunit.c back to CRC LIBRARY
      w1: ds2406: use crc16() instead of crc16_byte() loop
      lib/crc16: unexport crc16_table and crc16_byte()
      lib/crc32: add SPDX license identifier

Heiko Carstens (1):
      s390/crc32: Remove have_vxrs static key

 MAINTAINERS                                         |  1 +
 arch/arm/lib/Makefile                               |  4 ++--
 arch/arm/lib/{crc-t10dif-glue.c => crc-t10dif.c}    |  6 +++---
 arch/arm/lib/{crc32-glue.c => crc32.c}              |  6 +++---
 arch/arm64/lib/Makefile                             |  4 ++--
 arch/arm64/lib/{crc-t10dif-glue.c => crc-t10dif.c}  |  6 +++---
 arch/arm64/lib/{crc32.S => crc32-core.S}            |  0
 arch/arm64/lib/{crc32-glue.c => crc32.c}            |  0
 arch/loongarch/lib/crc32-loongarch.c                |  4 ++--
 arch/mips/lib/crc32-mips.c                          |  4 ++--
 arch/powerpc/lib/Makefile                           |  4 ++--
 .../powerpc/lib/{crc-t10dif-glue.c => crc-t10dif.c} |  4 ++--
 .../{crc32-vpmsum_core.S => crc-vpmsum-template.S}  |  0
 arch/powerpc/lib/{crc32-glue.c => crc32.c}          |  4 ++--
 arch/powerpc/lib/crc32c-vpmsum_asm.S                |  2 +-
 arch/powerpc/lib/crct10dif-vpmsum_asm.S             |  2 +-
 arch/s390/lib/Makefile                              |  2 +-
 arch/s390/lib/{crc32-glue.c => crc32.c}             | 21 +++------------------
 arch/sparc/lib/Makefile                             |  2 +-
 arch/sparc/lib/{crc32_glue.c => crc32.c}            |  6 +++---
 arch/x86/lib/Makefile                               |  6 +++---
 arch/x86/lib/{crc-t10dif-glue.c => crc-t10dif.c}    |  4 ++--
 arch/x86/lib/{crc32-glue.c => crc32.c}              |  6 +++---
 arch/x86/lib/{crc64-glue.c => crc64.c}              |  4 ++--
 crypto/Makefile                                     | 10 ++++++----
 crypto/{crc32_generic.c => crc32.c}                 |  0
 crypto/{crc32c_generic.c => crc32c.c}               |  0
 drivers/w1/slaves/w1_ds2406.c                       | 12 ++----------
 include/linux/crc16.h                               |  9 +--------
 include/linux/crc32.h                               |  5 +----
 lib/crc16.c                                         |  9 ++++-----
 lib/crc32.c                                         |  4 +---
 32 files changed, 59 insertions(+), 92 deletions(-)
 rename arch/arm/lib/{crc-t10dif-glue.c => crc-t10dif.c} (91%)
 rename arch/arm/lib/{crc32-glue.c => crc32.c} (95%)
 rename arch/arm64/lib/{crc-t10dif-glue.c => crc-t10dif.c} (91%)
 rename arch/arm64/lib/{crc32.S => crc32-core.S} (100%)
 rename arch/arm64/lib/{crc32-glue.c => crc32.c} (100%)
 rename arch/powerpc/lib/{crc-t10dif-glue.c => crc-t10dif.c} (94%)
 rename arch/powerpc/lib/{crc32-vpmsum_core.S => crc-vpmsum-template.S} (100%)
 rename arch/powerpc/lib/{crc32-glue.c => crc32.c} (95%)
 rename arch/s390/lib/{crc32-glue.c => crc32.c} (85%)
 rename arch/sparc/lib/{crc32_glue.c => crc32.c} (92%)
 rename arch/x86/lib/{crc-t10dif-glue.c => crc-t10dif.c} (89%)
 rename arch/x86/lib/{crc32-glue.c => crc32.c} (94%)
 rename arch/x86/lib/{crc64-glue.c => crc64.c} (91%)
 rename crypto/{crc32_generic.c => crc32.c} (100%)
 rename crypto/{crc32c_generic.c => crc32c.c} (100%)
