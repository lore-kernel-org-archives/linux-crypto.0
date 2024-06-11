Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2357016F91C;
	Tue, 11 Jun 2024 03:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077751; cv=none; b=KXHz8jSriSdRXSqEfJXiYCO04P4nSi13h15AXunGCRAGa9neJf+YtdRtzsff1uAc5eH4TmOi8DSlb/HrRgFJCytXrzVlXEmOXv3vgQo0qMXSBr0RMjVMPqLB7lgVdqBJFiRGl1pC+zHV26sAA5+hyItF8f7YLRgc6RI+Dal2wpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077751; c=relaxed/simple;
	bh=HmppuSdMEcls8lIaD2eKT+Qd5mKUgYyRhGLeScD8ung=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bWGTP6tSCcwW54Nt4C4VKFsLopdySbB5f3UpVfqULdhNHpoF0Q1vbRK0OHwGraKjNFXu9PaYVwHqJhmYmIscNqfnDtY5bgQV73vYuLuZjSJb2MIwRAwKFrGtnNtwY1EnfoOixrvrNFyp0cRPohdLqCc20iI8NT4EF0GA24bfLgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNOVaIcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNOVaIcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A1BC4AF4D;
	Tue, 11 Jun 2024 03:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718077750;
	bh=HmppuSdMEcls8lIaD2eKT+Qd5mKUgYyRhGLeScD8ung=;
	h=From:To:Cc:Subject:Date:From;
	b=DNOVaIcscxBEg2ws26lKyNXx/TG5TD5D1zQeJ1CzGsyGK/84/UAPPhscnWloQeT6L
	 YLgs4LaKztbzuppPtcmO353nkd3GAdtGreB1WxHaQdaXXGLhWz3QLoRfcPmzD+W2Nc
	 MCjzYjn5Yw2S5+lK1Y9HA/ZmnoX9SbWxODNvDcMZKCedfe0bDRhoVVlUXkqgERQNVs
	 V5E3KPby81ZvKQLUwJjVh3bmv2ri8gYzvRgk9bdRBBJkKceBWTh9kZipLV7lxtFnUU
	 mTGKpivDkmSJCr5sWHKGkkWx2jTjf/kLNCPU50iQ3xLshpQde6J4k0RUzG1+6tr0q4
	 Wn0yiFiu/g1qA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v5 00/15] Optimize dm-verity and fsverity using multibuffer hashing
Date: Mon, 10 Jun 2024 20:48:07 -0700
Message-ID: <20240611034822.36603-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.1
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
around the ahash API.  That approach had some major issues, as does the
alternative ahash-based approach proposed by Herbert (see my response at
https://lore.kernel.org/linux-crypto/20240610164258.GA3269@sol.localdomain/).
This patchset instead takes a much simpler approach of just adding a
synchronous API for hashing equal-length messages.

This works well for dm-verity and fsverity, which use Merkle trees and
therefore hash large numbers of equal-length messages.

This patchset is organized as follows:

- Patch 1-3 add crypto_shash_finup_mb() and tests for it.
- Patch 4-5 implement finup_mb on x86_64 and arm64, using an
  interleaving factor of 2.
- Patch 6 adds multibuffer hashing support to fsverity.
- Patches 7-14 are cleanups and optimizations to dm-verity that prepare
  the way for adding multibuffer hashing support.  These don't depend on
  any of the previous patches.
- Patch 15 adds multibuffer hashing support to dm-verity.

On CPUs that support multiple concurrent SHA-256's (all arm64 CPUs I
tested, and AMD Zen CPUs), raw SHA-256 hashing throughput increases by
70-98%, and the throughput of cold-cache reads from dm-verity and
fsverity increases by very roughly 35%.

Changed in v5:
  - Reworked the dm-verity patches again.  Split the preparation work
    into separate patches, fixed two bugs, and added some new cleanups.
  - Other small cleanups

Changed in v4:
  - Reorganized the fsverity and dm-verity code to have a unified code
    path for single-block vs. multi-block processing.  For data blocks
    they now use only crypto_shash_finup_mb().

Changed in v3:
  - Change API from finup2x to finup_mb.  It now takes arrays of data
    buffer and output buffers, avoiding hardcoding 2x in the API.

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

Eric Biggers (15):
  crypto: shash - add support for finup_mb
  crypto: testmgr - generate power-of-2 lengths more often
  crypto: testmgr - add tests for finup_mb
  crypto: x86/sha256-ni - add support for finup_mb
  crypto: arm64/sha256-ce - add support for finup_mb
  fsverity: improve performance by using multibuffer hashing
  dm-verity: move hash algorithm setup into its own function
  dm-verity: move data hash mismatch handling into its own function
  dm-verity: make real_digest and want_digest fixed-length
  dm-verity: provide dma_alignment limit in io_hints
  dm-verity: always "map" the data blocks
  dm-verity: make verity_hash() take dm_verity_io instead of ahash_request
  dm-verity: hash blocks with shash import+finup when possible
  dm-verity: reduce scope of real and wanted digests
  dm-verity: improve performance by using multibuffer hashing

 arch/arm64/crypto/sha2-ce-core.S    | 281 +++++++++++++-
 arch/arm64/crypto/sha2-ce-glue.c    |  40 ++
 arch/x86/crypto/sha256_ni_asm.S     | 368 ++++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c |  39 ++
 crypto/shash.c                      |  58 +++
 crypto/testmgr.c                    |  90 ++++-
 drivers/md/dm-verity-fec.c          |  49 +--
 drivers/md/dm-verity-fec.h          |   9 +-
 drivers/md/dm-verity-target.c       | 582 ++++++++++++++++------------
 drivers/md/dm-verity.h              |  66 ++--
 fs/verity/fsverity_private.h        |   7 +
 fs/verity/hash_algs.c               |   8 +-
 fs/verity/verify.c                  | 170 ++++++--
 include/crypto/hash.h               |  52 ++-
 14 files changed, 1440 insertions(+), 379 deletions(-)


base-commit: 6d4e1993a30539f556da2ebd36f1936c583eb812
-- 
2.45.1

