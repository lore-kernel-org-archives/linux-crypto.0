Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45381804E;
	Mon, 22 Apr 2024 20:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713818161; cv=none; b=Hjd5EbM/huoqud4AiJYVNd/2/s2oO7UhkDJA/DFBwz01ZLTqjvRSDkLXBUhpudM+05W6Ik8B8sRRu95f6DFB1WJvGr5IrPYHXT9ZQNsmE3fCfdCA3w6oD9+pnRQ+UvhsAIaqjPlWbxC6aFiN88BnWxqu0ZUkDeaRm1nlyY0st78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713818161; c=relaxed/simple;
	bh=DsQw7X3E7HxDwHTXBAUrY8ML0SrFD5lPXZ6StGjcL1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VkabNX1P1c5GNVJVxkn4MCdsO8vtuRntB9aV6BYB81ZAGwMGC4e02d3fKVaYXPMd1y+rM7Kog8p7Fp7LK8/KqdUnyQHgwTWua/Gn3fXs+U9v/k7Msi37G5p9Z+4w7YL6s2XFUOQ5SLyKZ6M/m3EvpCWzGle/mNuLcaR24oGqmFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHPZUBsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHPZUBsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198EEC2BD11;
	Mon, 22 Apr 2024 20:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713818161;
	bh=DsQw7X3E7HxDwHTXBAUrY8ML0SrFD5lPXZ6StGjcL1c=;
	h=From:To:Cc:Subject:Date:From;
	b=LHPZUBsl3Ep9Py2VBHsGjxPi5dXD2bvks1LPFi8PkShyyqLUkMqFpMPDdq0yuZ7xw
	 Hcwsyf/lbEVusdrB7NnwlDNYtdEYuQhf3CdkL5KWZdwWFg+QwnFmGKkfZULrsw+fV1
	 YmNR3KUaBb+FU4Wf2QX3BGWSMvIa/boPht6dXFTFIPdsrN8+8HaOk5RBqDwgk19xvf
	 uma0byaFObaGbGXXRVDY0Hc/ePbE1QRP3eXPc8xptlyu/hZoQbm6mFJ9IBgtWsJ4xm
	 4bEi2jrd+j33p4qAm2r4/Av8nYfYbGpSCtvoxyR2cYlt80klL/fbwxJLMSxwlcuQrE
	 VtLvZ2hJPwB7Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/8] Optimize dm-verity and fsverity using multibuffer hashing
Date: Mon, 22 Apr 2024 13:35:36 -0700
Message-ID: <20240422203544.195390-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On many modern CPUs, it is possible to compute the SHA-256 hash of two
equal-length messages in about the same time as a single message, if all
the instructions are interleaved.  This is because each SHA-256 (and
also most other cryptographic hash functions) is inherently serialized
and therefore can't always take advantage of the CPU's full throughput.

An earlier attempt to support multibuffer hashing in Linux was based
around the ahash API.  That approach had some major issues.  This
patchset instead takes a much simpler approach of just adding a
synchronous API for hashing two equal-length messages.

This works well for dm-verity and fsverity, which use Merkle trees and
therefore hash large numbers of equal-length messages.

This patchset is organized as follows:

- Patch 1-3 add crypto_shash_finup2x() and tests for it.
- Patch 4-5 implement finup2x on x86_64 and arm64.
- Patch 6-8 update fsverity and dm-verity to use crypto_shash_finup2x()
  to hash pairs of data blocks when possible.  Note: the patch
  "dm-verity: hash blocks with shash import+finup when possible" is
  revived from its original submission
  (https://lore.kernel.org/dm-devel/20231030023351.6041-1-ebiggers@kernel.org/)
  because this new work provides a new motivation for it.

On CPUs that support multiple concurrent SHA-256's (all arm64 CPUs I
tested, and AMD Zen CPUs), raw SHA-256 hashing throughput increases by
70-98%, and the throughput of cold-cache reads from dm-verity and
fsverity increases by very roughly 35%.

I consider the crypto patches (patches 1-5) to be more or less ready,
subject any feedback.  I plan to work more on cleaning up and testing
the fsverity and dm-verity patches (patches 6-8), which should go in
separately later through their respective trees.

Changed in v2:
  - Rebase onto cryptodev/master
  - Add more comments to assembly
  - Reorganize some of the assembly slightly
  - Fix the claimed throughput improvement on arm64
  - Fix incorrect kunmap order in fs/verity/verify.c
  - Adjust testmgr generation logic slightly
  - Explicitly check for INT_MAX before casting unsigned int to int
  - Mention SHA3 based parallel hashes
  - Mention AVX512-based approach

Eric Biggers (8):
  crypto: shash - add support for finup2x
  crypto: testmgr - generate power-of-2 lengths more often
  crypto: testmgr - add tests for finup2x
  crypto: x86/sha256-ni - add support for finup2x
  crypto: arm64/sha256-ce - add support for finup2x
  fsverity: improve performance by using multibuffer hashing
  dm-verity: hash blocks with shash import+finup when possible
  dm-verity: improve performance by using multibuffer hashing

 arch/arm64/crypto/sha2-ce-core.S    | 281 +++++++++++++-
 arch/arm64/crypto/sha2-ce-glue.c    |  41 ++
 arch/x86/crypto/sha256_ni_asm.S     | 368 ++++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c |  41 ++
 crypto/testmgr.c                    |  72 +++-
 drivers/md/dm-verity-fec.c          |  31 +-
 drivers/md/dm-verity-fec.h          |   7 +-
 drivers/md/dm-verity-target.c       | 560 ++++++++++++++++++++--------
 drivers/md/dm-verity.h              |  43 +--
 fs/verity/fsverity_private.h        |   5 +
 fs/verity/hash_algs.c               |  31 +-
 fs/verity/open.c                    |   6 +
 fs/verity/verify.c                  | 177 +++++++--
 include/crypto/hash.h               |  34 ++
 14 files changed, 1450 insertions(+), 247 deletions(-)


base-commit: 543ea178fbfadeaf79e15766ac989f3351349f02
-- 
2.44.0

