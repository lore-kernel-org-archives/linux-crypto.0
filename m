Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5625419F11F;
	Sat, 16 Aug 2025 19:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755373656; cv=none; b=J5zdNxiF+jBD8t4YHgbqvQZ1kSyGmlAqv2twmWJz+1fgZkzM5kIKcsKL16wSpAgNZweH5JzjbZKM6l7GZUKgETHUE6gVPm82OaqYjuFPRdTFsYqCkoIE4utPUwT4tbV/nrwBOznH9r10/t1t85v1u4FN5SY0TkyR9/8bF4TZu8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755373656; c=relaxed/simple;
	bh=gWdKsqnCQv8AjMCN4PIGSK65i4nSEgxnGoN3qZ6Ae6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JqGRfA6F4tEooAFtBEPTdr58bBiFb/uZ9RibJATPv7BJq7hYSLgiNXaOnhfHmPI5wbLab9N0A+WBbEMq9EGiZkugoP/FgEHxLZ6XbJ8auDz8r59O8CBmCSKzUt9ZDi0/FhDnuE+Or8WwTiOz088mwJ8kX81BH+aGwBdw2rDPWPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rb4d3azo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rb4d3azo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4DDC4CEEF;
	Sat, 16 Aug 2025 19:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755373655;
	bh=gWdKsqnCQv8AjMCN4PIGSK65i4nSEgxnGoN3qZ6Ae6I=;
	h=From:To:Cc:Subject:Date:From;
	b=Rb4d3azoRCv8hnrcBHQgevJf5KUy/7DBpgxvVAITh8P6pLc6LuXUMsCxqx7vMn4rh
	 OFBlfoGW6shbl2rF9aYEiPBYCTMrKa0sHkxKsxLCJyzRjL+rmbtCC7P1w1108zeKIw
	 rkYMTQ0Y+nHt1L+CHWy0SVbRs2HEnmi3pvFEC/KldaJILEfy82iMyIyGXmFbXxkaES
	 rqNdsRC9d268Z3ELgYKf7xeOqP7jUj4UahYkPx6iJRLYwdjnlq2SmLjgZ1K38EJ+kr
	 o+eDdU70kwL3gwc2Kfq5vYwg78t8IqXGSvlO7ZcmEl31TWPjHXNKvttKPso9gK3Z/s
	 Q5IcFrbJdSwNA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] Consolidate Poly1305 code and add RISC-V optimization
Date: Sat, 16 Aug 2025 12:43:50 -0700
Message-ID: <20250816194353.562491-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git poly1305-v1

This series simplifies and optimizes the organization of the Poly1305
code by consolidating it into a single module.  This follows the example
of SHA-1, SHA-256, SHA-512, CRC32, etc.

Since the RISC-V Poly1305 patch has had a moving target, I also rebased
it on top of this series and included it as patch 3.

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
 lib/crypto/Makefile                           |  69 +-
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
 31 files changed, 1172 insertions(+), 466 deletions(-)
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


base-commit: 56784a42208677e6fb24ba0bd93a2ea0bd9f41ff
-- 
2.50.1

