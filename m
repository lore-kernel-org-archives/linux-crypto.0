Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20F9261362
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945127; cv=none; b=sRmP8wqOsrzRsm637tLpR49lVPwrfugm+z+IrqNLSmpT00ZG0Vv/Lp3RxdHGfx0BjPKxPHPgHYmt9xcL2K9exXqMqbA7cDOdN1JJsE0WTtp2BmiBLRqPonm6YIsQda27uBKpxkFDAldmMYtZd/nKDp0CDxORugORRly6Tp66pg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945127; c=relaxed/simple;
	bh=tzrYaCHyx3pVXs/pHL9KKr21SLvVRMpq2lyNhmkd3uw=;
	h=Date:Message-Id:From:Subject:To; b=mZuVAR7inzkbyu/D17hhBaYihUtk3ah1LleNwgXt7JK7B0S3LHRC8QP5JrJYFcrdvwK2nI3DrgQ1EU6rF3/C9BGrgr5QKnerT+XkCKkCO4s9Orm/CtzvucP0OPU53UQWFi0PZZobUuQV1tZeQCEsTZsY2D9hKwvUnbrSN9TJ5xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=K1dXQc1j; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="K1dXQc1j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XUF0UExasbmKzMP/v052vBKvwP/5K++vCdyJjjZJcFQ=; b=K1dXQc1jJV5E6G+kVLot33q99x
	sCUK66nf1bF13bazkA8v98JAbaGxLd7NHE424AkH0fwjphhIJunjnvexQgofyB+lEMWbpyYB0OkT3
	4IdZcPGFRwouIiUKJtOnRkNK8d5GR7EjZ//9KiJQGTd5dPvb9pacjxrtYclnqIfzXEX9QU7kCMd5T
	RIv3mQ1l9o98796MRTJliRFvlTVVQHkH4nmYJUICexPGwVJK/OZxX6a6XbYOzq68/92CSgtWRdiaO
	Hbe33hxcgkSZFMGOn8PS0S+AjPQYhkF3XDn45Cr8/KFlno++P7mcFVsAyvw2xBIu87cDxaC6q1UCZ
	U2gu5aVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bw6-00GdzP-2V;
	Fri, 18 Apr 2025 10:58:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:58:38 +0800
Date: Fri, 18 Apr 2025 10:58:38 +0800
Message-Id: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 00/67] crypto: shash - Handle partial blocks in API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v2 rebases on top of cryptodev.

Most hash algorithms are block-based and data is held back until
a whole block can be fed into the algorithm.  Currently, this
retention is entirely handled in the low-level algorithm code,
with the API and the user oblivious to it.

As a comparison, the block ciphers defer this retention entirely
to the user and the API, who is expected to provide input with
no partial data until the very end.

The result of this is that every shash algorithm has to implement
partial block handling, and it gets many times worse when you look
at ahash drivers.

This patch series adds optional handling of partial blocks to the
shash API and converts some of the shash algorithms to it.  In
particular, all the algorithms used by ahash drivers have been
converted.  This ensures that when the ahash drivers themselves
are converted the export format will be consistent.

As this touches so many shash algorithms, two extra changes have
been made at the same time: removal of SIMD fallback paths on
arm/arm64/x86 and exporting in the same format as that of the
generic algorithm.

Herbert Xu (67):
  crypto: shash - Handle partial blocks in API
  crypto: blake2b-generic - Use API partial block handling
  crypto: arm/blake2b - Use API partial block handling
  crypto: ghash-generic - Use API partial block handling
  crypto: powerpc/ghash - Use API partial block handling
  crypto: arm/ghash - Use API partial block handling
  crypto: arm64/ghash - Use API partial block handling
  crypto: riscv/ghash - Use API partial block handling
  crypto: s390/ghash - Use API partial block handling
  crypto: x86/ghash - Use API partial block handling
  crypto: md5-generic - Use API partial block handling
  crypto: mips/octeon-md5 - Use API partial block handling
  crypto: powerpc/md5 - Use API partial block handling
  crypto: sparc/md5 - Use API partial block handling
  crypto: x86/sha1 - Use API partial block handling
  crypto: arm64/sha1 - Use API partial block handling
  crypto: mips/octeon-sha1 - Use API partial block handling
  crypto: sha1-generic - Use API partial block handling
  crypto: arm/sha1-ce - Use API partial block handling
  crypto: arm/sha1-neon - Use API partial block handling
  crypto: arm/sha1-asm - Use API partial block handling
  crypto: powerpc/sha1 - Use API partial block handling
  crypto: powerpc/sha1-spe - Use API partial block handling
  crypto: s390/sha1 - Use API partial block handling
  crypto: sparc/sha1 - Use API partial block handling
  crypto: sha1_base - Remove partial block helpers
  crypto: x86/sha256 - Use API partial block handling
  crypto: mips/octeon-sha256 - Use API partial block handling
  crypto: riscv/sha256 - Use API partial block handling
  crypto: sha256-generic - Use API partial block handling
  crypto: arm/sha256-ce - Use API partial block handling
  crypto: arm/sha256-neon - Use API partial block handling
  crypto: arm/sha256-asm - Use API partial block handling
  crypto: arm64/sha256-ce - Use API partial block handling
  crypto: arm64/sha256 - Use API partial block handling
  crypto: powerpc/sha256-spe - Use API partial block handling
  crypto: s390/sha256 - Use API partial block handling
  crypto: sparc/sha256 - Use API partial block handling
  crypto: sha256_base - Remove partial block helpers
  crypto: arm64/sha3-ce - Use API partial block handling
  crypto: s390/sha3 - Use API partial block handling
  crypto: sha3-generic - Use API partial block handling
  crypto: zynqmp-sha - Use API partial block handling
  crypto: x86/sha512 - Use API partial block handling
  crypto: mips/octeon-sha512 - Use API partial block handling
  crypto: riscv/sha512 - Use API partial block handling
  crypto: sha512-generic - Use API partial block handling
  crypto: arm/sha512-neon - Use API partial block handling
  crypto: arm/sha512-asm - Use API partial block handling
  crypto: arm64/sha512-ce - Use API partial block handling
  crypto: arm/sha512 - Use API partial block handling
  crypto: s390/sha512 - Use API partial block handling
  crypto: sparc/sha512 - Use API partial block handling
  crypto: sha512_base - Remove partial block helpers
  crypto: sm3-generic - Use API partial block handling
  crypto: arm64/sm3-ce - Use API partial block handling
  crypto: arm64/sm3-neon - Use API partial block handling
  crypto: riscv/sm3 - Use API partial block handling
  crypto: x86/sm3 - Use API partial block handling
  crypto: lib/sm3 - Remove partial block helpers
  crypto: cbcmac - Use API partial block handling
  crypto: cmac - Use API partial block handling
  crypto: xcbc - Use API partial block handling
  crypto: arm64/aes - Use API partial block handling
  crypto: arm64/sm4 - Use API partial block handling
  crypto: nx - Use API partial block handling
  crypto: padlock-sha - Use API partial block handling

 arch/arm/crypto/blake2b-neon-glue.c           |  20 +-
 arch/arm/crypto/ghash-ce-glue.c               | 110 ++---
 arch/arm/crypto/sha1-ce-glue.c                |  36 +-
 arch/arm/crypto/sha1.h                        |  14 -
 arch/arm/crypto/sha1_glue.c                   |  33 +-
 arch/arm/crypto/sha1_neon_glue.c              |  39 +-
 arch/arm/crypto/sha2-ce-glue.c                |  52 +-
 arch/arm/crypto/sha256_glue.c                 |  46 +-
 arch/arm/crypto/sha256_glue.h                 |   8 +-
 arch/arm/crypto/sha256_neon_glue.c            |  49 +-
 arch/arm/crypto/sha512-glue.c                 |  36 +-
 arch/arm/crypto/sha512-neon-glue.c            |  43 +-
 arch/arm/crypto/sha512.h                      |   6 -
 arch/arm64/crypto/aes-glue.c                  | 122 ++---
 arch/arm64/crypto/ghash-ce-glue.c             | 151 +++---
 arch/arm64/crypto/sha1-ce-glue.c              |  66 +--
 arch/arm64/crypto/sha2-ce-glue.c              |  90 +---
 arch/arm64/crypto/sha256-glue.c               |  97 ++--
 arch/arm64/crypto/sha3-ce-glue.c              | 107 ++--
 arch/arm64/crypto/sha512-ce-glue.c            |  49 +-
 arch/arm64/crypto/sha512-glue.c               |  28 +-
 arch/arm64/crypto/sm3-ce-glue.c               |  48 +-
 arch/arm64/crypto/sm3-neon-glue.c             |  48 +-
 arch/arm64/crypto/sm4-ce-glue.c               |  98 ++--
 arch/mips/cavium-octeon/crypto/octeon-md5.c   | 119 ++---
 arch/mips/cavium-octeon/crypto/octeon-sha1.c  | 136 ++---
 .../mips/cavium-octeon/crypto/octeon-sha256.c | 161 ++----
 .../mips/cavium-octeon/crypto/octeon-sha512.c | 155 ++----
 arch/powerpc/crypto/ghash.c                   |  81 ++-
 arch/powerpc/crypto/md5-glue.c                |  99 +---
 arch/powerpc/crypto/sha1-spe-glue.c           | 132 +----
 arch/powerpc/crypto/sha1.c                    | 101 +---
 arch/powerpc/crypto/sha256-spe-glue.c         | 167 ++-----
 arch/riscv/crypto/ghash-riscv64-glue.c        |  58 +--
 arch/riscv/crypto/sha256-riscv64-glue.c       |  68 ++-
 arch/riscv/crypto/sha512-riscv64-glue.c       |  47 +-
 arch/riscv/crypto/sm3-riscv64-glue.c          |  49 +-
 arch/s390/crypto/ghash_s390.c                 | 110 ++---
 arch/s390/crypto/sha.h                        |  22 +-
 arch/s390/crypto/sha1_s390.c                  |  22 +-
 arch/s390/crypto/sha256_s390.c                |  35 +-
 arch/s390/crypto/sha3_256_s390.c              |  60 +--
 arch/s390/crypto/sha3_512_s390.c              |  67 +--
 arch/s390/crypto/sha512_s390.c                |  45 +-
 arch/s390/crypto/sha_common.c                 |  84 ++--
 arch/sparc/crypto/md5_glue.c                  | 141 +++---
 arch/sparc/crypto/sha1_glue.c                 | 109 +---
 arch/sparc/crypto/sha256_glue.c               | 121 +----
 arch/sparc/crypto/sha512_glue.c               | 102 +---
 arch/x86/crypto/ghash-clmulni-intel_asm.S     |   5 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c    | 301 ++----------
 arch/x86/crypto/sha1_ssse3_glue.c             |  81 +--
 arch/x86/crypto/sha256_ssse3_glue.c           | 104 ++--
 arch/x86/crypto/sha512_ssse3_glue.c           |  79 +--
 arch/x86/crypto/sm3_avx_glue.c                |  54 +-
 crypto/blake2b_generic.c                      |  31 +-
 crypto/ccm.c                                  |  59 +--
 crypto/cmac.c                                 |  92 +---
 crypto/ghash-generic.c                        |  56 +--
 crypto/md5.c                                  | 102 ++--
 crypto/sha1_generic.c                         |  33 +-
 crypto/sha256_generic.c                       |  50 +-
 crypto/sha3_generic.c                         | 101 ++--
 crypto/sha512_generic.c                       |  56 +--
 crypto/shash.c                                | 229 +++++++--
 crypto/sm3_generic.c                          |  31 +-
 crypto/xcbc.c                                 |  92 +---
 drivers/crypto/nx/nx-aes-xcbc.c               | 128 ++---
 drivers/crypto/nx/nx-sha256.c                 | 130 ++---
 drivers/crypto/nx/nx-sha512.c                 | 143 +++---
 drivers/crypto/nx/nx.c                        |  15 +-
 drivers/crypto/nx/nx.h                        |   6 +-
 drivers/crypto/padlock-sha.c                  | 464 ++++++------------
 drivers/crypto/xilinx/zynqmp-sha.c            |  71 +--
 include/crypto/blake2b.h                      |  31 +-
 include/crypto/ghash.h                        |   4 +-
 include/crypto/hash.h                         | 104 ++--
 include/crypto/internal/blake2b.h             |  94 ++--
 include/crypto/internal/hash.h                |  15 +
 include/crypto/md5.h                          |   3 +-
 include/crypto/sha1.h                         |   9 +-
 include/crypto/sha1_base.h                    |  79 +--
 include/crypto/sha2.h                         |  20 +-
 include/crypto/sha256_base.h                  | 111 +++--
 include/crypto/sha3.h                         |  16 +-
 include/crypto/sha512_base.h                  |  88 ++--
 include/crypto/sm3.h                          |   3 +-
 include/crypto/sm3_base.h                     |  79 ++-
 include/linux/crypto.h                        |   2 +
 lib/crypto/sha256.c                           |   7 +-
 lib/crypto/sm3.c                              |  68 +--
 91 files changed, 2372 insertions(+), 4561 deletions(-)
 delete mode 100644 arch/arm/crypto/sha1.h


base-commit: da4cb617bc7d827946cbb368034940b379a1de90
-- 
2.39.5

