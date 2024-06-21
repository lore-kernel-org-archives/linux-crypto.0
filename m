Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5A52BD05;
	Fri, 21 Jun 2024 17:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989216; cv=none; b=OUxaMpOvWpZy5DzU1axKxEs91gdTRlpZw083eFsf8IoNUe+HOr2moudJW9IyVvuY8Ib+dKM7IkBwbQzOHEAATOynuw5TE8J522sSpqfAeTQ7QSShftYI+ouhEWf6WsW3WJiEAGX5p6PpcvNhjw3LQlrnTznEA+zsSuT9cuV11D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989216; c=relaxed/simple;
	bh=T5agsG03jsn5iNLlN/Q/8k0qiwUTJkBZqtzS0aWxZ64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qFfOJEVT37ozw8pKAseX7SHt7c7WH3DpEHwnHFLYY2TeJAJIPH8iJspb7amqoBW/sw72UtsuSD/hb1j49fDQ7eMSYHwnbbztWyztcSs+mddXFsoKnSrd91HxsVjnKesfuq8Al7QLujpWT4Pmwt8d0FuTSJbFrTkumuw9LLc7nzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojqrPTO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojqrPTO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653DBC2BBFC;
	Fri, 21 Jun 2024 17:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718989215;
	bh=T5agsG03jsn5iNLlN/Q/8k0qiwUTJkBZqtzS0aWxZ64=;
	h=From:To:Cc:Subject:Date:From;
	b=ojqrPTO5aTeKGpQCSMvF+zQ7FwXzf9ik9wd7WRt6ReT02MtlwSRsY7+900ySKryUf
	 dAdusLYaBuAyVE1nLHzVzn44YGXrRj5is0xXoHmUaBYoCBME/uJO+QVB74dZZjc2qk
	 tqiFh/sL3WTHXKl131e3AzIVmkR5c0AH50ObTUtyrWd6WhW3jlNmdfdSI11G9rRdzp
	 AVQ3qTefuTgEq+qJ9KwUjM0CcAzNepeyx4BRYRftNtvA/k/ZcrVyy8W1bhNkprgX4z
	 tgiostLDLm7s9EN80zODUNApObbKoLkasOAX2knaXamwq2PwtJySm1aT3fXbjnTgJo
	 FbKRwk2ZijGrg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v6 00/15] Optimize dm-verity and fsverity using multibuffer hashing
Date: Fri, 21 Jun 2024 09:59:07 -0700
Message-ID: <20240621165922.77672-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
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

Changed in v6:
  - All patches: added Reviewed-by and Acked-by tags
  - "crypto: testmgr - add tests for finup_mb": Whitespace fix
  - "crypto: testmgr - generate power-of-2 lengths more often":
    Fixed undefined behavior
  - "fsverity: improve performance by using multibuffer hashing":
    Simplified a comment
  - "dm-verity: reduce scope of real and wanted digests":
    Fixed mention of nonexistent function in commit message
  - "dm-verity: improve performance by using multibuffer hashing":
    Two small optimizations, and simplified a comment

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
  dm-verity: make verity_hash() take dm_verity_io instead of
    ahash_request
  dm-verity: hash blocks with shash import+finup when possible
  dm-verity: reduce scope of real and wanted digests
  dm-verity: improve performance by using multibuffer hashing

 arch/arm64/crypto/sha2-ce-core.S    | 281 +++++++++++++-
 arch/arm64/crypto/sha2-ce-glue.c    |  40 ++
 arch/x86/crypto/sha256_ni_asm.S     | 368 ++++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c |  39 ++
 crypto/shash.c                      |  58 +++
 crypto/testmgr.c                    |  89 ++++-
 drivers/md/dm-verity-fec.c          |  49 +--
 drivers/md/dm-verity-fec.h          |   9 +-
 drivers/md/dm-verity-target.c       | 581 ++++++++++++++++------------
 drivers/md/dm-verity.h              |  65 ++--
 fs/verity/fsverity_private.h        |   7 +
 fs/verity/hash_algs.c               |   8 +-
 fs/verity/verify.c                  | 169 ++++++--
 include/crypto/hash.h               |  52 ++-
 14 files changed, 1436 insertions(+), 379 deletions(-)


base-commit: ff33c2e6af99afcac3024a5c3ec8730d1e6b8ac7
-- 
2.45.2

