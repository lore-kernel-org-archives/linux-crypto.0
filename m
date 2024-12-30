Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA42645;
	Mon, 30 Dec 2024 00:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517760; cv=none; b=endtq+RaanqR4jFfPY2tlH1Pf3qNtUDJ2BoHaxsFhLcpjzhAaU8UNHi65LWHMALIK8UsP6cKXHdtXn1u24gA4lyeWzu1kGqQonjzpoCWYs8wwZe2Pqzd2jlzEcpqvAzvIWrWWV4lPGJ9i9QwMHE7BmNNXwnmrq3opSXkbNa9sec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517760; c=relaxed/simple;
	bh=B+ea5VZa9ni0fkXA4ElZFEdkMpMI5FHChY7YG1cUOFY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DGNeyLX6+CEyoW3vPPF3vLnp5wvQsm7PgvCfeN8qFWtpqsDDfKgbitRXG8bEZoSZNTsi8CbzbKL2lSw9r8no/qy8O9uDQx1lgfxJvBbYK5myXY8Z109jFHmTaIOu2ZFsOqzYWAJqlTQNEcsMy7Xa4KrGXQSarpSTvA0ifRoFdQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDavyfp4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDavyfp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A6BC4CED1;
	Mon, 30 Dec 2024 00:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517759;
	bh=B+ea5VZa9ni0fkXA4ElZFEdkMpMI5FHChY7YG1cUOFY=;
	h=From:To:Cc:Subject:Date:From;
	b=PDavyfp4nGwP5wE2qadoiyDh6nMzHjUBym+MKyaAFBX3MmUvReHVsqR/av8hs3uBl
	 6PPDlT28nolMQVWNqnQfh/5nFZZCvI7StvKFAm4hl9LzhzEVszXfZMf1ECqhLGz1RG
	 euYki8RI/K/F980PVP0DLVIAf4ztuUBeDxc55Zo/1caR5GNEnZax/Pw+pcaG+vttWz
	 DwY8hrLiMRgOAbm+tU09KcCPHLsX8nxW0d/Tx1bBDrktVkueuA3pJbovEoGseV+adp
	 v4uLr5JQ2aNiIjWdQf18WZKJXziNI2G+FICcH0ghcYRZw/Gu8M9dNC8v9CbLUN6yL0
	 Hkl+j/8v7juzQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/29] crypto: scatterlist handling improvements
Date: Sun, 29 Dec 2024 16:13:49 -0800
Message-ID: <20241230001418.74739-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series cleans up and optimizes the code that translates between
scatterlists (the input to the API) and virtual addresses (what software
implementations operate on) for skcipher and aead algorithms.

This takes the form of cleanups and optimizations to the skcipher_walk
functions and a rework of the underlying scatter_walk functions.

This series is organized as follows:

- Patch 1-8 are cleanups and optimizations for skcipher_walk.
- Patch 9-10 are cleanups for drivers that were unnecessarily using
  scatter_walk when simpler approaches existed.
- Patch 11-15 improve scatter_walk, introducing easier-to-use functions
  and optimizing performance in some cases.
- Patch 16-27 convert users to use the new functions.
- Patch 28 removes functions that are no longer needed.
- Patch 29 optimizes the walker on !HIGHMEM platforms to start returning
  data segments that can cross a page boundary.  This can significantly
  improve performance in cases where messages can cross pages, such as
  IPsec.  Previously there was a large overhead caused by packets being
  unnecessarily divided into multiple parts by the walker, including
  hitting skcipher_next_slow() which uses a single-block bounce buffer.

Changed in v2:
  - Added comment to scatterwalk_done_dst().
  - Added scatterwalk_get_sglist() and use it in net/tls/.
  - Dropped the keywrap patch, as keywrap is being removed by
    https://lore.kernel.org/r/20241227220802.92550-1-ebiggers@kernel.org

Eric Biggers (29):
  crypto: skcipher - document skcipher_walk_done() and rename some vars
  crypto: skcipher - remove unnecessary page alignment of bounce buffer
  crypto: skcipher - remove redundant clamping to page size
  crypto: skcipher - remove redundant check for SKCIPHER_WALK_SLOW
  crypto: skcipher - fold skcipher_walk_skcipher() into
    skcipher_walk_virt()
  crypto: skcipher - clean up initialization of skcipher_walk::flags
  crypto: skcipher - optimize initializing skcipher_walk fields
  crypto: skcipher - call cond_resched() directly
  crypto: omap - switch from scatter_walk to plain offset
  crypto: powerpc/p10-aes-gcm - simplify handling of linear associated
    data
  crypto: scatterwalk - move to next sg entry just in time
  crypto: scatterwalk - add new functions for skipping data
  crypto: scatterwalk - add new functions for iterating through data
  crypto: scatterwalk - add new functions for copying data
  crypto: scatterwalk - add scatterwalk_get_sglist()
  crypto: skcipher - use scatterwalk_start_at_pos()
  crypto: aegis - use the new scatterwalk functions
  crypto: arm/ghash - use the new scatterwalk functions
  crypto: arm64 - use the new scatterwalk functions
  crypto: nx - use the new scatterwalk functions
  crypto: s390/aes-gcm - use the new scatterwalk functions
  crypto: s5p-sss - use the new scatterwalk functions
  crypto: stm32 - use the new scatterwalk functions
  crypto: x86/aes-gcm - use the new scatterwalk functions
  crypto: x86/aegis - use the new scatterwalk functions
  net/tls: use the new scatterwalk functions
  crypto: skcipher - use the new scatterwalk functions
  crypto: scatterwalk - remove obsolete functions
  crypto: scatterwalk - don't split at page boundaries when !HIGHMEM

 arch/arm/crypto/ghash-ce-glue.c        |  15 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c    |  17 +-
 arch/arm64/crypto/ghash-ce-glue.c      |  16 +-
 arch/arm64/crypto/sm4-ce-ccm-glue.c    |  27 ++-
 arch/arm64/crypto/sm4-ce-gcm-glue.c    |  31 ++-
 arch/powerpc/crypto/aes-gcm-p10-glue.c |   8 +-
 arch/s390/crypto/aes_s390.c            |  33 ++--
 arch/x86/crypto/aegis128-aesni-glue.c  |  10 +-
 arch/x86/crypto/aesni-intel_glue.c     |  28 +--
 crypto/aegis128-core.c                 |  10 +-
 crypto/scatterwalk.c                   |  91 +++++----
 crypto/skcipher.c                      | 253 ++++++++++---------------
 drivers/crypto/nx/nx-aes-ccm.c         |  16 +-
 drivers/crypto/nx/nx-aes-gcm.c         |  17 +-
 drivers/crypto/nx/nx.c                 |  31 +--
 drivers/crypto/nx/nx.h                 |   3 -
 drivers/crypto/omap-aes.c              |  34 ++--
 drivers/crypto/omap-aes.h              |   6 +-
 drivers/crypto/omap-des.c              |  40 ++--
 drivers/crypto/s5p-sss.c               |  38 ++--
 drivers/crypto/stm32/stm32-cryp.c      |  34 ++--
 include/crypto/internal/skcipher.h     |   2 +-
 include/crypto/scatterwalk.h           | 203 ++++++++++++++++----
 net/tls/tls_device_fallback.c          |  31 +--
 24 files changed, 473 insertions(+), 521 deletions(-)


base-commit: 7b6092ee7a4ce2d03dc65b87537889e8e1e0ab95
prerequisite-patch-id: a0414cca60a72ee1056cce0a74175103b19e0e77
-- 
2.47.1

