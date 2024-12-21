Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0021A8406
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772291; cv=none; b=psK5lOTSVc5CXIL6BOLdrtYNu0Dl6GWtvw6mwOFQuJqbUhleJKqusXLCsPvoV8ms67RwO3d0GjSYdv6scbeTOp/uJxhpzKYSE4gQeezPixqhAirooQ+KK+rujpdTsAFRSP/3NGRmZZXhRdowenP1/3f1eaiqYhitBGuzU7IoPUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772291; c=relaxed/simple;
	bh=NEn4SdydraMFJD03iaaNBxunSUQ9publkVj056MY7/M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HD6a1X/sdvWMDxjvF0H0lZRaOHSKnKWUZQ4AmHBmHAY0JoaYOaJpASHmSEyf9JRzn/KoPuFrap0iJwQTZxoRl8mTG7YhJQbB9z6Hla+gctw8EQGNzkJ2xc1hhfL4K4sb2key/hjgSzrLYrrkmvfBj32INfC46wpVJc+eLXIYIaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5TI+G1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5TI+G1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3323C4CECE
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772290;
	bh=NEn4SdydraMFJD03iaaNBxunSUQ9publkVj056MY7/M=;
	h=From:To:Subject:Date:From;
	b=Z5TI+G1RVzZutwhHJzEDkPsvBcmHOdF+tqBzc20ry3I9C+ci8Q3BtUjPNZussuHLp
	 IXUYGa54R/ebGjtePXS2AqEh7ty9fPJphzG19GjwMZBd+Gx/iWbkcEcCZBN8ZtLzSF
	 K3vxyzLh8OEFcZxpN/NeAQvHs4L7jCIxKhGzOYEUnYKmK3O0zPy7r7z70aVSHBqtrt
	 IpfYd74P/L4YIhowkS9ny4w+3ZnpJiU/YRw2dZfbPH3SYWny4mRjlPkXU2fMzAdOPj
	 Z5NOG+FYO1Eu00EBKsZ83GB716XAgbeS4gT/u6DRiren2/tMt8EtTqtJdmtuFBljtT
	 t1z0+m0nDNGnQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 00/29] crypto: scatterlist handling improvements
Date: Sat, 21 Dec 2024 01:10:27 -0800
Message-ID: <20241221091056.282098-1-ebiggers@kernel.org>
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
- Patch 11-14 improve scatter_walk, introducing easier-to-use functions
  and optimizing performance in some cases.
- Patch 15-27 convert users to use the new functions.
- Patch 28 removes functions that are no longer needed.
- Patch 29 optimizes the walker on !HIGHMEM platforms to start returning
  data segments that can cross a page boundary.  This can significantly
  improve performance in cases where messages can cross pages, such as
  IPsec.  Previously there was a large overhead caused by packets being
  unnecessarily divided into multiple parts by the walker, including
  hitting skcipher_next_slow() which uses a single-block bounce buffer.

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
  crypto: skcipher - use scatterwalk_start_at_pos()
  crypto: aegis - use the new scatterwalk functions
  crypto: arm/ghash - use the new scatterwalk functions
  crypto: arm64 - use the new scatterwalk functions
  crypto: keywrap - use the new scatterwalk functions
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
 crypto/keywrap.c                       |  48 +----
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
 include/crypto/scatterwalk.h           | 181 ++++++++++++++----
 net/tls/tls_device_fallback.c          |  16 +-
 25 files changed, 454 insertions(+), 551 deletions(-)


base-commit: f916e44487f56df4827069ff3a2070c0746dc511
-- 
2.47.1

