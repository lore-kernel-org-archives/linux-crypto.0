Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E7C7E1
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675238; cv=none; b=ba+aWwuiOkwXiYB3cGvh7CcLSyf9zUKzUZCX+1TnfqWplvBjZRId0nHvKiE9n6hraClHylVGJc2Y34esSActtovbzRXXAaqf9SIQdjb1J9KURGkSxSAgNE5QSN4CyAWBHR4W3zCkYMREwt+eX8ZTUK/aVhx9xzQx3/Q674+W6cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675238; c=relaxed/simple;
	bh=xGGlIxWKG9bea84KU3fBgZzK84euFd4///0neLetIcY=;
	h=Date:Message-Id:From:Subject:To:Cc; b=ijF7INj6WgoNDqPps8CpItDM1KbmV8EVenke9eHOBsz6dUlZ96dj56QKn3gmedtEsu+FJ1wgETYFrBIvQUrX9ksGPgwAVQcIYxi4WgPFteh9vgZcNTD1Uhb+aIprjoxA0AJKzin8Jd2ypxVcUKHZCCLiwHjjENs1S0LcHm6voGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pMjNsOyp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pMjNsOyp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jbv0crTi/1bNZ6Z4c1j/Ti4Xt9+uhEJBwupTv7FXLEI=; b=pMjNsOypHURqJEuKhCoge7fgro
	6F8OteNQPtJERYLweAbTZ3jfOEtVWzPV6lCi+fKkF+FOpdXV/iFxNFCpUBQHHWfjEXkhbP5oR4qWq
	72MYMsr3JRcV4Q29pwet3IQnTw+zdRk924G3FzQ40YQ9YvgnOYlhyak9Xw28rlExp2c3xAX9VinH4
	39tpcQmZjkrse5cf6DIIAXYo1Kh1cqCdvNTQZn6uopCQFJaZTgGmRnaKgMrh8qQbOgiv+Kgm9/+TC
	+SgFtyYR2o0z0Z3LEYIJDESJvdsG7eO3wh3KuQBL0cAAUJmGocr07BgRMokzf3loxXqA46nj5PNOY
	qmIgnXFA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUmz-000gXN-2S;
	Sun, 16 Feb 2025 11:07:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:10 +0800
Date: Sun, 16 Feb 2025 11:07:10 +0800
Message-Id: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 00/11] Multibuffer hashing take two
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch-set introduces two additions to the ahash interface.
First of all request chaining is added so that an arbitrary number
of requests can be submitted in one go.  Incidentally this also
reduces the cost of indirect calls by amortisation.

It then adds virtual address support to ahash.  This allows the
user to supply a virtual address as the input instead of an SG
list.

This is assumed to be not DMA-capable so it is always copied
before it's passed to an existing ahash driver.  New drivers can
elect to take virtual addresses directly.  Of course existing shash
algorithms are able to take virtual addresses without any copying.

The next patch resurrects the old SHA2 AVX2 muiltibuffer code as
a proof of concept that this API works.  The result shows that with
a full complement of 8 requests, this API is able to achieve parity
with the more modern but single-threaded SHA-NI code.  This passes
the multibuffer fuzz tests.

Finally introduce a sync hash interface that is similar to the sync
skcipher interface.  This will replace the shash interface for users.
Use it in fsverity and enable multibuffer hashing.

Eric Biggers (1):
  fsverity: improve performance by using multibuffer hashing

Herbert Xu (10):
  crypto: ahash - Only save callback and data in ahash_save_req
  crypto: x86/ghash - Use proper helpers to clone request
  crypto: hash - Add request chaining API
  crypto: tcrypt - Restore multibuffer ahash tests
  crypto: ahash - Add virtual address support
  crypto: ahash - Set default reqsize from ahash_alg
  crypto: testmgr - Add multibuffer hash testing
  crypto: x86/sha2 - Restore multibuffer AVX2 support
  crypto: hash - Add sync hash interface
  fsverity: Use sync hash instead of shash

 arch/x86/crypto/Makefile                   |   2 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c |  23 +-
 arch/x86/crypto/sha256_mb_mgr_datastruct.S | 304 +++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c        | 540 ++++++++++++++++--
 arch/x86/crypto/sha256_x8_avx2.S           | 598 ++++++++++++++++++++
 crypto/ahash.c                             | 605 ++++++++++++++++++---
 crypto/algapi.c                            |   2 +-
 crypto/tcrypt.c                            | 231 ++++++++
 crypto/testmgr.c                           | 132 ++++-
 fs/verity/fsverity_private.h               |   4 +-
 fs/verity/hash_algs.c                      |  41 +-
 fs/verity/verify.c                         | 179 +++++-
 include/crypto/algapi.h                    |  11 +
 include/crypto/hash.h                      | 172 +++++-
 include/crypto/internal/hash.h             |  17 +-
 include/linux/crypto.h                     |  24 +
 16 files changed, 2659 insertions(+), 226 deletions(-)
 create mode 100644 arch/x86/crypto/sha256_mb_mgr_datastruct.S
 create mode 100644 arch/x86/crypto/sha256_x8_avx2.S

-- 
2.39.5

