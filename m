Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE5B224C6
	for <linux-crypto@vger.kernel.org>; Tue, 13 Feb 2024 09:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707815797; cv=none; b=oBTvYW1a1o3phOeUTAGkhYBXEGox1T3AHjW+IwxLEbdg6l0n8j1QNW/Y/u0x/DcnIbphrRHn3KlgZ6uogr6TbXxxl2o4jfxbl7KKwSG5V8caBG71kyHHOluNFqS/nsbjadet2k5UHKXSD3D6KXy9H9fWXOPv0ehPmisRqN+2xWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707815797; c=relaxed/simple;
	bh=5/3ZsM1U2kAYU1HknkMLI1s2Z/PH4xTESNk/ckSXjRY=;
	h=Message-Id:From:Date:Subject:To; b=CFS1o/sd/2gETnJj0+iyob8us7+H2WVPDmBqldwOHuGWFSdIB9gUQLsFmxqAZiU0o2ZFMw++d+FtL/PTxKbq2SCqRJYBFBkEi6OjEYo50Z1XnsvC2j64DkA9Bp5aJdHjKr6lU5uXJ+jl8qLym5KPkCshbimpaRyl9YhSHmbf6Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rZots-00D1on-0d; Tue, 13 Feb 2024 17:16:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Feb 2024 17:16:38 +0800
Message-Id: <cover.1707815065.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 13 Feb 2024 17:04:25 +0800
Subject: [PATCH 00/15] crypto: Add twopass lskcipher for adiantum
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

In order to process the data incrementally, adiantum needs see the
source data twice.  This patch series adds support for such algorithms
in lskcipher including adaptations to algif_skcipher.

For now this capability isn't actually exported completely through
algif_skcipher.  That is, if the source data is too large to be fed
at once through an SG list the operation will fail with ENOSYS.

As a future extension, the incremental processing can be extended
through algif_skcipher (and perhaps even algif_aead).  However,
I'd like to see some real uses for it before adding this complexity.
For example, one valid use-case would be some hardware that directly
supported such incremental processing.

In addition to converting adiantum, the underlying chacha algorithm
is also converted over to lskcipher.

The algorithms cts + xts have been converted too to ensure that the
tailsize mechanism works properly for them.  While doing this the
parameters for cts + xts have been modified so that blocksize is now
1.  This entails changing the paramters of all drivers that support
cts and/or xts.

Herbert Xu (15):
  crypto: skcipher - Add tailsize attribute
  crypto: algif_skcipher - Add support for tailsize
  crypto: skcipher - Remove ivsize check for lskcipher simple templates
  crypto: xts - Convert from skcipher to lskcipher
  crypto: skcipher - Add twopass attribute
  crypto: algif_skcipher - Disallow nonincremental algorithms
  crypto: adiantum - Use lskcipher instead of cipher
  crypto: skcipher - Add incremental support to lskcipher wrapper
  crypto: chacha-generic - Convert from skcipher to lskcipher
  crypto: skcipher - Move nesting check into ecb
  crypto: skcipher - Propagate zero-length requests to lskcipher
  crypto: cts - Convert from skcipher to lskcipher
  crypto: cts,xts - Update parameters blocksize/chunksize/tailsize
  crypto: lskcipher - Export incremental interface internally
  crypto: adiantum - Convert from skcipher to lskcipher

 arch/arm/crypto/aes-ce-glue.c                 |   8 +-
 arch/arm/crypto/aes-neonbs-glue.c             |   4 +-
 arch/arm64/crypto/aes-glue.c                  |   8 +-
 arch/arm64/crypto/aes-neonbs-glue.c           |   4 +-
 arch/arm64/crypto/sm4-ce-glue.c               |   8 +-
 arch/powerpc/crypto/aes-spe-glue.c            |   4 +-
 arch/powerpc/crypto/aes_xts.c                 |   4 +-
 arch/s390/crypto/aes_s390.c                   |   4 +-
 arch/s390/crypto/paes_s390.c                  |   4 +-
 arch/x86/crypto/aesni-intel_glue.c            |   8 +-
 crypto/adiantum.c                             | 573 ++++++++++--------
 crypto/algif_skcipher.c                       |  11 +-
 crypto/cbc.c                                  |   5 +
 crypto/chacha_generic.c                       | 161 ++---
 crypto/cts.c                                  | 355 +++--------
 crypto/ecb.c                                  |   4 +
 crypto/lskcipher.c                            |  94 ++-
 crypto/skcipher.c                             |  18 +-
 crypto/xts.c                                  | 572 +++++++----------
 drivers/crypto/atmel-aes.c                    |   4 +-
 drivers/crypto/axis/artpec6_crypto.c          |   2 +
 drivers/crypto/bcm/cipher.c                   |   4 +-
 drivers/crypto/caam/caamalg.c                 |   4 +-
 drivers/crypto/caam/caamalg_qi.c              |   4 +-
 drivers/crypto/caam/caamalg_qi2.c             |   4 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c        |   4 +-
 .../crypto/cavium/nitrox/nitrox_skcipher.c    |   8 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c       |   4 +-
 drivers/crypto/ccree/cc_cipher.c              |  12 +-
 drivers/crypto/chelsio/chcr_algo.c            |   4 +-
 drivers/crypto/hisilicon/sec/sec_algs.c       |   4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c    |  23 +-
 .../crypto/inside-secure/safexcel_cipher.c    |   4 +-
 .../intel/keembay/keembay-ocs-aes-core.c      |  11 +-
 .../crypto/intel/qat/qat_common/qat_algs.c    |   4 +-
 .../crypto/marvell/octeontx/otx_cptvf_algs.c  |   4 +-
 .../marvell/octeontx2/otx2_cptvf_algs.c       |   4 +-
 drivers/crypto/qce/skcipher.c                 |   6 +-
 include/crypto/internal/chacha.h              |  22 +-
 include/crypto/internal/skcipher.h            |  43 ++
 include/crypto/skcipher.h                     |  65 ++
 include/crypto/xts.h                          |  24 +-
 42 files changed, 1067 insertions(+), 1050 deletions(-)

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

