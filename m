Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429FC29A1;
	Mon, 20 Oct 2025 00:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760921612; cv=none; b=sne1+QBtlWgaM0LgU5nkkt/dlx/+T0m1/DDK35dhQjC8FzJ+5QUefK9ckhHXw9Rbz1P6FZCashvghDexB/FGPfe5SQzfyp2/Nc/peMysFRHtdu49xzcrYq6aDbbdatNd/aFjGogo8EdX5ayNxf2eUajVVEPYjZ7HxufKQIGIYJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760921612; c=relaxed/simple;
	bh=JmOANjyD/5j6cWmAe84VhHCBmVIXWn3nb+w9e/Dv9Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ONm/V2d2gKbz6yFiclyHyWLokCTfbnKy9OVSDrVECtqlOYxvWE5cI7rU8cOVT5tn0qz+zSJe/F78oFU6QUcocThVNyTJgddiRvVkwBva4d4Zw9oqEF6jaKG/SlRGmbdjw+r7X8Ndp4Fric+hcR9avHDHnZvwQ2jA3PrtEPgBH88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/wAwz++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/wAwz++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED4AC4CEE7;
	Mon, 20 Oct 2025 00:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760921611;
	bh=JmOANjyD/5j6cWmAe84VhHCBmVIXWn3nb+w9e/Dv9Ds=;
	h=From:To:Cc:Subject:Date:From;
	b=a/wAwz++HOKRcfz9DcEAOY2sylzStIUZNP4xJm9y3uzHsLR9qu7KYWo630H4TD9mZ
	 Du7k2rDKKuzY2rHR3s8u+h0vtGyRO3wFaqFxVbcwrP7QWizJ/Eh/k90udvxWpb25kI
	 ZgLL3xBBHmweo2Cc+KPWLhWMkosDhXvMS3Y+hujXL10R8TshutyCNFF/YTnJyFWBBl
	 cFBo6rGTlWNnbsChsVhY7mMbHxhHPAOn5STP+0YYrII/m0b1sQm73yvdFGridtHKwf
	 uJKKC/Mk4CqvjW2P0t0Xv3OApbhC105t2kxI6yqgyjuoY9OlAIuuAksuKj3Jfq8pTf
	 x0hwFWzW091Rw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/17] SHA-3 library
Date: Sun, 19 Oct 2025 17:50:21 -0700
Message-ID: <20251020005038.661542-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git sha3-lib-v1

This series builds on the first 5 patches of David's v6 series
(https://lore.kernel.org/r/20251017144311.817771-1-dhowells@redhat.com),
which I've included unmodified as the initial patches.  The remaining
patches improve the SHA-3 library, for example by simplifying the API
and migrating the existing arm64 and s390-optimized SHA-3 code into the
library.  The last patch reimplements the sha3-* crypto_shash algorithms
on top of the library.

If the s390 folks could re-test the s390 optimized SHA-3 code, that
would be helpful.  QEMU doesn't support the instructions it uses.

David Howells (5):
  s390/sha3: Rename conflicting functions
  arm64/sha3: Rename conflicting functions
  lib/crypto: Add SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128,
    SHAKE256
  lib/crypto: Move the SHA3 Iota transform into the single round
    function
  lib/crypto: Add SHA3 kunit tests

Eric Biggers (12):
  lib/crypto: sha3: Fix libsha3 build condition
  lib/crypto: sha3: Use appropriate conversions in
    sha3_keccakf_generic()
  lib/crypto: sha3: Drop unfinished SHAKE support from
    gen-hash-testvecs.py
  lib/crypto: sha3: Consistently use EXPORT_SYMBOL_GPL
  lib/crypto: sha3: Replace redundant ad-hoc test with FIPS test
  lib/crypto: sha3: Simplify the API
  lib/crypto: sha3: Document one-shot functions in header and improve
    docs
  crypto: arm64/sha3 - Update sha3_ce_transform() to prepare for library
  lib/crypto: arm64/sha3: Migrate optimized code into library
  lib/crypto: s390/sha3: Migrate optimized code into library
  crypto: jitterentropy - use default sha3 implementation
  crypto: sha3 - Reimplement using library API

 Documentation/crypto/index.rst                |   1 +
 Documentation/crypto/sha3.rst                 | 147 +++++++
 arch/arm64/configs/defconfig                  |   2 +-
 arch/arm64/crypto/Kconfig                     |  11 -
 arch/arm64/crypto/Makefile                    |   3 -
 arch/arm64/crypto/sha3-ce-glue.c              | 151 -------
 arch/s390/configs/debug_defconfig             |   3 +-
 arch/s390/configs/defconfig                   |   3 +-
 arch/s390/crypto/Kconfig                      |  20 -
 arch/s390/crypto/Makefile                     |   2 -
 arch/s390/crypto/sha.h                        |  51 ---
 arch/s390/crypto/sha3_256_s390.c              | 157 --------
 arch/s390/crypto/sha3_512_s390.c              | 157 --------
 arch/s390/crypto/sha_common.c                 | 117 ------
 crypto/Makefile                               |   2 +-
 crypto/jitterentropy-kcapi.c                  |  12 +-
 crypto/sha3.c                                 | 172 ++++++++
 crypto/sha3_generic.c                         | 290 -------------
 crypto/testmgr.c                              |   8 +
 include/crypto/sha3.h                         | 314 ++++++++++++++-
 lib/crypto/Kconfig                            |  13 +
 lib/crypto/Makefile                           |  10 +
 .../crypto/arm64}/sha3-ce-core.S              |  66 +--
 lib/crypto/arm64/sha3.h                       |  64 +++
 lib/crypto/fips.h                             |   7 +
 lib/crypto/s390/sha3.h                        |  76 ++++
 lib/crypto/sha3.c                             | 380 ++++++++++++++++++
 lib/crypto/tests/Kconfig                      |  11 +
 lib/crypto/tests/Makefile                     |   1 +
 lib/crypto/tests/sha3_kunit.c                 | 344 ++++++++++++++++
 lib/crypto/tests/sha3_testvecs.h              | 231 +++++++++++
 scripts/crypto/gen-fips-testvecs.py           |   4 +
 scripts/crypto/gen-hash-testvecs.py           |   6 +-
 33 files changed, 1822 insertions(+), 1014 deletions(-)
 create mode 100644 Documentation/crypto/sha3.rst
 delete mode 100644 arch/arm64/crypto/sha3-ce-glue.c
 delete mode 100644 arch/s390/crypto/sha.h
 delete mode 100644 arch/s390/crypto/sha3_256_s390.c
 delete mode 100644 arch/s390/crypto/sha3_512_s390.c
 delete mode 100644 arch/s390/crypto/sha_common.c
 create mode 100644 crypto/sha3.c
 delete mode 100644 crypto/sha3_generic.c
 rename {arch/arm64/crypto => lib/crypto/arm64}/sha3-ce-core.S (84%)
 create mode 100644 lib/crypto/arm64/sha3.h
 create mode 100644 lib/crypto/s390/sha3.h
 create mode 100644 lib/crypto/sha3.c
 create mode 100644 lib/crypto/tests/sha3_kunit.c
 create mode 100644 lib/crypto/tests/sha3_testvecs.h

base-commit: 123fa1574bccee87da735d13e89c931e88288b40
-- 
2.51.1.dirty

