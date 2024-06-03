Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B0B137939;
	Mon,  3 Jun 2024 18:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717439943; cv=none; b=dhKUK6EGOmdcQO9wZH9bNkUF/Mh9nsVQ6aIcv14KZ8osNmMsKIYrUfI6Qc+PuDWoXCIFW/AdNHlxHFObrAs5WwZSSyfTa27aPODlqs8zmhjxlaVwLMVvRmYbPT9Aa1NzRqOO+v5Me/acmppcmq6YM+5/q1vGoKy3+6B/g6RTOCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717439943; c=relaxed/simple;
	bh=cuaWNZB+W8ps7z5awlku/z83BkDgv1blEbXuyhu0RU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RitMZ3rvmQJCRC5tFMi5dfMFMZT85dmUgUtwxBAQFD7zWX1gnXHSNRc5W/gZwBhQSV8EAqICmRw+iPbXh075k1DBZup2qYYCbDo3NtXVYBVisD7RKDooMzmF7g8UzRPI7XLPAyboSC/9RG1mk/0cHO/tunlDq914bPlGDo5Gva0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVDmVIBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVDmVIBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00EBC2BD10;
	Mon,  3 Jun 2024 18:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717439943;
	bh=cuaWNZB+W8ps7z5awlku/z83BkDgv1blEbXuyhu0RU4=;
	h=From:To:Cc:Subject:Date:From;
	b=LVDmVIBB/u9JAy2fKk7Att6u6L85xJe6vmd8Wj9JE5RUJRwaQ8l8b9bZl2oWq6FAX
	 GyOTI4YeJtrH1BoL/FKgKYEy256xAAk6K7+20ZPD0aQGqzkpPJGEmwiWTDWIAxzfi7
	 RE7yLEpyC4hbikfnQN5mkot1TboxNqo0FF6AH40ncEuzN+Gms7SZ+O9mIHLiWVQ9Aq
	 5EljsdCUiXfifbe4vWw77Sz+NurqU4wt6uWThFLv0BGnj/LkYQYRibcBL4L9Bo3q2F
	 BcVXlEDeCKf9R0eSl7CVhWHV59O8d4UmqCAT8j9THNUI63AVANadbj+Llcgl1FlbDV
	 hflvAehx52Sgg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/8] Optimize dm-verity and fsverity using multibuffer hashing
Date: Mon,  3 Jun 2024 11:37:23 -0700
Message-ID: <20240603183731.108986-1-ebiggers@kernel.org>
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
around the ahash API.  That approach had some major issues.  This
patchset instead takes a much simpler approach of just adding a
synchronous API for hashing equal-length messages.

This works well for dm-verity and fsverity, which use Merkle trees and
therefore hash large numbers of equal-length messages.

This patchset is organized as follows:

- Patch 1-3 add crypto_shash_finup_mb() and tests for it.
- Patch 4-5 implement finup_mb on x86_64 and arm64, using an
  interleaving factor of 2.
- Patch 6-8 update fsverity and dm-verity to use crypto_shash_finup_mb()
  to hash pairs of data blocks when possible.  Note: the patch
  "dm-verity: hash blocks with shash import+finup when possible" is
  revived from its original submission
  (https://lore.kernel.org/dm-devel/20231030023351.6041-1-ebiggers@kernel.org/)
  because this new work provides a new motivation for it.

On CPUs that support multiple concurrent SHA-256's (all arm64 CPUs I
tested, and AMD Zen CPUs), raw SHA-256 hashing throughput increases by
70-98%, and the throughput of cold-cache reads from dm-verity and
fsverity increases by very roughly 35%.

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

Eric Biggers (8):
  crypto: shash - add support for finup_mb
  crypto: testmgr - generate power-of-2 lengths more often
  crypto: testmgr - add tests for finup_mb
  crypto: x86/sha256-ni - add support for finup_mb
  crypto: arm64/sha256-ce - add support for finup_mb
  fsverity: improve performance by using multibuffer hashing
  dm-verity: hash blocks with shash import+finup when possible
  dm-verity: improve performance by using multibuffer hashing

 arch/arm64/crypto/sha2-ce-core.S    | 281 +++++++++++++-
 arch/arm64/crypto/sha2-ce-glue.c    |  40 ++
 arch/x86/crypto/sha256_ni_asm.S     | 368 +++++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c |  39 ++
 crypto/shash.c                      |  60 +++
 crypto/testmgr.c                    |  90 ++++-
 drivers/md/dm-verity-fec.c          |  31 +-
 drivers/md/dm-verity-fec.h          |   7 +-
 drivers/md/dm-verity-target.c       | 545 ++++++++++++++++++++--------
 drivers/md/dm-verity.h              |  43 +--
 fs/verity/fsverity_private.h        |   7 +
 fs/verity/hash_algs.c               |   8 +-
 fs/verity/verify.c                  | 173 +++++++--
 include/crypto/hash.h               |  45 ++-
 14 files changed, 1494 insertions(+), 243 deletions(-)


base-commit: aabbf2135f9a9526991f17cb0c78cf1ec878f1c2
-- 
2.45.1

