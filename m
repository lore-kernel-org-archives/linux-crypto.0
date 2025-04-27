Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32F91E7C3B
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745715603; cv=none; b=HsqZ2XXdX9+YytXyP+9eaE4GJks55s1h6kmTGlMpJ7CTmEjzxVyKDRFys+zlmjSIn5FCWU2uGSdFeyEO1oHSrqRCTlLmky6409VJDZg62uVCmPpYt6wTTJ/ybrXSZXwIBATLkHZNuNpOCh12hE7/vWcvxXgO9PHa65cxHtNUltg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745715603; c=relaxed/simple;
	bh=J1a4sXLuHG7BQCj5Q4pZ8FrQwl3tRaTXqxWDqkldHB0=;
	h=Date:Message-Id:From:Subject:To; b=XSDlq2IhjJEJA+ncPuSurq7Wd/HIpGmYKAUbXeaV27F6y1F47Z8fqPX8L4S08Q97BzSHO8qC7mUeFhuHMfyL3UCQnndHQ6mVILtzi7DQAHaGH0mA4Q1YmivQZ7MhEBUxoJjKL+DPSPQ75vE1LBF3HDzWlUKaa2XstZtuf+WM714=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qmpma3zH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qmpma3zH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h9GfyJIwJYguO++Dkk4+Lp5pmY7uinK/6DEu1Ihczvg=; b=qmpma3zHdBOqn9N1Oc0gTnQHNz
	jneGPLFPA1AjxzTGAbRyLFMgc0B3wYMf1S1Av1JWrRTlNVvv3Q77BWMonUD83QaX6SrNDFY0/5LLY
	0AJCuiW8zgCGK2MqGSDfBvPZ1pcinz31f8b9IbvWC8v0vBoUpmviyzBNYDCDgGKXjS8QHQ1QhTFjX
	mvMj4NFHUBsPMwR7Pc9RF2uX0iT0wDGxRvcUhG+kySe7o3gViuBu0k/qnn6h165DgR9qSrmDiGE+k
	Odt4MT/vF6037Nxj9hcncoeIjUeVBzoGBZ8bMmIEKnOJVvUPJxZJY8jjwP/QScq7KQ605mAmRDuKa
	hfUQHa3w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8qNA-001JGg-2I;
	Sun, 27 Apr 2025 08:59:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Apr 2025 08:59:56 +0800
Date: Sun, 27 Apr 2025 08:59:56 +0800
Message-Id: <cover.1745714715.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 00/11] crypto: lib - Add partial block helper
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v2:
- Remove the polyval patches.
- Rename one-block key to raw_key.
- Rename poly1305_block to poly1305_blocks.
- Fix the arch/generic if clause in poly1305_blocks.
- Rewrite crypto/chacha20poly1305 to use lib/crypto poly1305.
- Remove shash poly1305.

This is based on

	https://patchwork.kernel.org/project/linux-crypto/list/?series=955753
	https://patchwork.kernel.org/project/linux-crypto/list/?series=957401

This series introduces a partial block helper for lib/crypto hash
algorithms based on the one from sha256_base.

It then uses it on poly1305 to eliminate duplication between
architectures.  In particular, instead of having complete update
functions for each architecture, reduce it to a block function
per architecture instead.  The partial block handling is handled
by the generic library layer.

The poly1305 implementation was anomalous due to the inability
to call setkey in softirq.  It also has just a single user, which
is chacha20poly1305 that is hard-coded to use poly1305.  Replace
the gratuitous use of ahash in chacha20poly1305 with the lib/crypto
poly1305 instead.

This then allows the shash poly1305 to be removed.

Herbert Xu (11):
  crypto: lib/sha256 - Move partial block handling out
  crypto: lib/poly1305 - Add block-only interface
  crypto: arm/poly1305 - Add block-only interface
  crypto: arm64/poly1305 - Add block-only interface
  crypto: mips/poly1305 - Add block-only interface
  crypto: powerpc/poly1305 - Add block-only interface
  crypto: x86/poly1305 - Add block-only interface
  crypto: chacha20poly1305 - Use lib/crypto poly1305
  crypto: testmgr - Remove poly1305
  crypto: poly1305 - Remove algorithm
  crypto: lib/poly1305 - Use block-only interface

 arch/arm/lib/crypto/poly1305-armv4.pl         |   4 +-
 arch/arm/lib/crypto/poly1305-glue.c           | 113 ++----
 arch/arm64/lib/crypto/Makefile                |   3 +-
 arch/arm64/lib/crypto/poly1305-glue.c         | 105 ++----
 arch/mips/lib/crypto/poly1305-glue.c          |  75 +---
 arch/mips/lib/crypto/poly1305-mips.pl         |  12 +-
 arch/powerpc/lib/crypto/poly1305-p10-glue.c   | 109 ++----
 .../lib/crypto/poly1305-x86_64-cryptogams.pl  |  33 +-
 arch/x86/lib/crypto/poly1305_glue.c           | 169 +++------
 crypto/Kconfig                                |  14 +-
 crypto/Makefile                               |   2 -
 crypto/chacha20poly1305.c                     | 323 ++++--------------
 crypto/poly1305.c                             | 152 ---------
 crypto/testmgr.c                              |   6 -
 crypto/testmgr.h                              | 288 ----------------
 include/crypto/internal/blockhash.h           |  52 +++
 include/crypto/internal/poly1305.h            |  28 +-
 include/crypto/poly1305.h                     |  60 +---
 include/crypto/sha2.h                         |   9 +-
 include/crypto/sha256_base.h                  |  38 +--
 lib/crypto/poly1305.c                         |  83 ++---
 21 files changed, 396 insertions(+), 1282 deletions(-)
 delete mode 100644 crypto/poly1305.c
 create mode 100644 include/crypto/internal/blockhash.h

-- 
2.39.5

