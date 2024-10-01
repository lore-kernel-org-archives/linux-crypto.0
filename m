Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252821C6F51;
	Tue,  1 Oct 2024 15:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727797160; cv=none; b=oON7yQiZtECOlbFRvgGVkhCLMtrlI3g9/RbsP+pTTEzLEB1T662TYsIOw54aBqajd3//5uvExqaL5WXZOrV2U+hAS/23ZAqJyRT3EYdXpM2zoMb/U6iwdFgV+93Vo3qkSkDAf8mE886ia4wEVRDC6v/FotyXxMwN1IgIcRkKwz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727797160; c=relaxed/simple;
	bh=SohKAUfLV7IzJXvpfUahCfDYMFsDrTqFD0/Qs1d6Vqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LzKzF2CbilTbqLxOgv/ynJFU2pynonVRKO3rzEF2NTtjgsjAcms4cWXVrSvLio/FkdDMCH+8qi9ejuTTwS35diKPf/4hpkZ3BKWqH5zLEF0AMpMD7pwHnPeb6l9MDctKyCtzqdgR//mr1/eut4j+To6e6QJ65ItO8TDhU0V3O9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aFclFuvp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aFclFuvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F181C4CEC6;
	Tue,  1 Oct 2024 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727797159;
	bh=SohKAUfLV7IzJXvpfUahCfDYMFsDrTqFD0/Qs1d6Vqs=;
	h=From:To:Cc:Subject:Date:From;
	b=aFclFuvpEBpcM7lzq45poOnrpcXgakd7NUms9f4tP2tmMXKwMX3xVLQH//aJ2ELwY
	 TwsWF3R3rmEcfhzNaG+u/78GpCwEoS6SCnSjbjfPMoH+dAla2eaG4uEnXydONtY8P+
	 9cgENhCzUXFnx0SiMgxib2iXun4B0Of0/0j/lzVvdbzeHsAGxckQ+o1Jz2MhnYlfWS
	 mjpmksmEcKMr0/ftnZdzVhGODAQ6iwWveOtFhCIRyTeDM/eTodXl/7h2bkWXHNv0PX
	 cx8bnenb/32+ymWnQ63p8nTFjf071HOVyfVXD06xy1qPT1gi3S452Wt57tHotRwl8c
	 RVO0jIOM2Gyjw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v7 0/7] Optimize dm-verity and fsverity using multibuffer hashing
Date: Tue,  1 Oct 2024 08:37:11 -0700
Message-ID: <20241001153718.111665-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.2
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

- Patch 1-2 add crypto_shash_finup_mb() and tests for it.
- Patch 3-4 implement finup_mb on x86_64 and arm64, using an
  interleaving factor of 2.
- Patch 5 adds multibuffer hashing support to fsverity.
- Patch 6-7 add multibuffer hashing support to dm-verity.

This patchset increases raw SHA-256 hashing throughput by up to 98%,
depending on the CPU (see patches for per-CPU results).  The throughput
of cold-cache reads from dm-verity and fsverity increases by around 35%.

Changed in v7:
  - Rebased onto v6.12-rc1 and dropped patches that were upstreamed.
  - Added performance results for more CPUs.

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

Eric Biggers (7):
  crypto: shash - add support for finup_mb
  crypto: testmgr - add tests for finup_mb
  crypto: x86/sha256-ni - add support for finup_mb
  crypto: arm64/sha256-ce - add support for finup_mb
  fsverity: improve performance by using multibuffer hashing
  dm-verity: reduce scope of real and wanted digests
  dm-verity: improve performance by using multibuffer hashing

 arch/arm64/crypto/sha2-ce-core.S    | 281 ++++++++++++++++++++-
 arch/arm64/crypto/sha2-ce-glue.c    |  40 +++
 arch/x86/crypto/sha256_ni_asm.S     | 368 ++++++++++++++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c |  39 +++
 crypto/shash.c                      |  58 +++++
 crypto/testmgr.c                    |  73 +++++-
 drivers/md/dm-verity-fec.c          |  19 +-
 drivers/md/dm-verity-fec.h          |   5 +-
 drivers/md/dm-verity-target.c       | 192 +++++++++++----
 drivers/md/dm-verity.h              |  34 +--
 fs/verity/fsverity_private.h        |   7 +
 fs/verity/hash_algs.c               |   8 +-
 fs/verity/verify.c                  | 169 ++++++++++---
 include/crypto/hash.h               |  52 +++-
 14 files changed, 1224 insertions(+), 121 deletions(-)


base-commit: 9852d85ec9d492ebef56dc5f229416c925758edc
-- 
2.46.2

