Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CEC264612;
	Sun,  9 Nov 2025 23:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762732197; cv=none; b=HQO3xpR9xB0AUTKv/NG8NxlND4QmVxo33rK5Gz/b2+rxumPGXZc94KCaZ+JQKXH9OlWNbYlsbh4xmRzu9fJDUVpvn0/dacSXU8ozXKEAqG9Gxdl485QtgvwFO+x98oiSce6aCm6HRO+YbS8N46rjLEf6tcm9R/4+Vs0Nusdun50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762732197; c=relaxed/simple;
	bh=GGXE4CX6TLqH68fC6EBiO7twAZjKaaOW8LAfS8ijyYM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=on8ZKNqs3eS74KET2PSV7YjAHdrSHG5UaHE4Aw+0Y4cE6TTvHJaWP8bHUJFJBdt7W5YMvl77T6hDtj6HwKr+LcyyQ3eTemJrSITGaIEqkq8TmbDngc+rOioZQ6mG51RCbdjsMSoOm6/P01vYm4LM+YhsKrm9LCfCVEouCB/7HHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVRhzD+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVRhzD+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00FAC4CEF8;
	Sun,  9 Nov 2025 23:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762732197;
	bh=GGXE4CX6TLqH68fC6EBiO7twAZjKaaOW8LAfS8ijyYM=;
	h=From:To:Cc:Subject:Date:From;
	b=NVRhzD+MoJJn94RWzZhNEXYLomm4+Tz1zOklh9oOfPbYIc2pDiYrNdCj6fLLUxQA2
	 nyaOE9XlGqtoXUxS13EZeQj2FI2cxPm1eeOD30NujWA9biF/27nVW2h6zpYVaRG6bd
	 MSZgBRGMjpq0Z40fEx4ZZCAWFt5TLxGc4e845aLCjNqxrqJzw1/Oa9IoIe/QndAMX6
	 u6YvJoJDW71TcTnuYc4kahTVdEkw5aFx+/qQ4v6KZaJ5lMJfe3RbQAkZdzjLeeB5fF
	 qWIb65ZilWxgqp1ds4rTP757JqserJjjMLGbsVlgwShC39VHT9W/9rmhmDP+TH0/og
	 wH7Rrfrr7lTFQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/9] POLYVAL library
Date: Sun,  9 Nov 2025 15:47:15 -0800
Message-ID: <20251109234726.638437-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git polyval-lib-v1

This series migrates the POLYVAL code to lib/crypto/.  It turns out that
just like Poly1305, the library is a much better fit for it.

This series also replaces the generic implementation of POLYVAL with a
much better one.

Notably, this series improves the performance of HCTR2, since it
eliminates unnecessary overhead that was being incurred by accessing
POLYVAL via the crypto_shash API.  I see a 45% increase in throughput
with 64-byte messages, 53% with 128-byte, or 6% with 4096-byte.

It also eliminates the need to explicitly enable the optimized POLYVAL
code, as it's now enabled automatically when HCTR2 support is enabled.

Eric Biggers (9):
  crypto: polyval - Rename conflicting functions
  lib/crypto: polyval: Add POLYVAL library
  lib/crypto: tests: Add KUnit tests for POLYVAL
  lib/crypto: arm64/polyval: Migrate optimized code into library
  lib/crypto: x86/polyval: Migrate optimized code into library
  crypto: hctr2 - Convert to use POLYVAL library
  crypto: polyval - Remove the polyval crypto_shash
  crypto: testmgr - Remove polyval tests
  fscrypt: Drop obsolete recommendation to enable optimized POLYVAL

 Documentation/filesystems/fscrypt.rst         |   2 -
 arch/arm64/crypto/Kconfig                     |  10 -
 arch/arm64/crypto/Makefile                    |   3 -
 arch/arm64/crypto/polyval-ce-glue.c           | 158 ---------
 arch/x86/crypto/Kconfig                       |  10 -
 arch/x86/crypto/Makefile                      |   3 -
 arch/x86/crypto/polyval-clmulni_glue.c        | 180 ----------
 crypto/Kconfig                                |  12 +-
 crypto/Makefile                               |   1 -
 crypto/hctr2.c                                | 226 ++++---------
 crypto/polyval-generic.c                      | 205 ------------
 crypto/tcrypt.c                               |   4 -
 crypto/testmgr.c                              |   9 +-
 crypto/testmgr.h                              | 171 ----------
 include/crypto/polyval.h                      | 182 ++++++++++-
 lib/crypto/Kconfig                            |  12 +
 lib/crypto/Makefile                           |  10 +
 .../crypto/arm64}/polyval-ce-core.S           |  38 +--
 lib/crypto/arm64/polyval.h                    |  82 +++++
 lib/crypto/polyval.c                          | 307 ++++++++++++++++++
 lib/crypto/tests/Kconfig                      |   9 +
 lib/crypto/tests/Makefile                     |   1 +
 lib/crypto/tests/polyval-testvecs.h           | 186 +++++++++++
 lib/crypto/tests/polyval_kunit.c              | 223 +++++++++++++
 .../crypto/x86/polyval-pclmul-avx.S           |  40 ++-
 lib/crypto/x86/polyval.h                      |  83 +++++
 scripts/crypto/gen-hash-testvecs.py           |  47 ++-
 27 files changed, 1240 insertions(+), 974 deletions(-)
 delete mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 delete mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
 delete mode 100644 crypto/polyval-generic.c
 rename {arch/arm64/crypto => lib/crypto/arm64}/polyval-ce-core.S (92%)
 create mode 100644 lib/crypto/arm64/polyval.h
 create mode 100644 lib/crypto/polyval.c
 create mode 100644 lib/crypto/tests/polyval-testvecs.h
 create mode 100644 lib/crypto/tests/polyval_kunit.c
 rename arch/x86/crypto/polyval-clmulni_asm.S => lib/crypto/x86/polyval-pclmul-avx.S (91%)
 create mode 100644 lib/crypto/x86/polyval.h


base-commit: ce59a87d1cbd3fa075aba73efde946e61d5ef089
-- 
2.51.2

