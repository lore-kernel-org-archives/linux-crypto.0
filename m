Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4346B211472
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 10:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745491623; cv=none; b=gdgeLkrOWaPd9OwyD5zTFoHNIt4ljJp3YhXPn/kzxotP4/+/HFDNSanWP7Fv9yxLltb44Yz+KEPmcQTKrUDAxDyakypNCx7NK14RmN9PYasbT4mrr969JrbI93aMWRbBpMn5ex+RTEw4WmdqxJ5kRB9qrWrN7eX6n4o2HifEc5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745491623; c=relaxed/simple;
	bh=HxSIPu2kaDUhQVvMkxL353Y8I4VjSETefh1R7CdqNUQ=;
	h=Date:Message-Id:From:Subject:To; b=aQa3Fq/ugXAiNLF6XHRyGbqQAxBE6hoTCfpnNETAM9EnIGAM2LxVP7mNdYfCVCvLj5/LwNx0DFa9R0TjOaHadGfjX9aJR2/eUXbS0pRPPvQV4bPm85qyRVZl49Ur2ocgycd+DSA6rMstraalMCF0pk3mVJOts/D9VmMG3Z5mfAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KpfVVjSq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KpfVVjSq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=r3/ghgGtPjdQo4lhSfw4TH58BB/uShIfGyIv12/WrQM=; b=KpfVVjSqy1peMIkOj+bmiO29nI
	yZR4T0mHPe9LtZVIW9Khwdwy2nyNu5W18cliEpOR95tshHJmTzo1PghgR+SMyDQKCuKI3h2FpjQIB
	ZSZJHCxERY9FPLmNY69yVAiS3RRRgt4zxJkyfAIdmiVbLygdinyU/p9Ge4afTQEK9hzCXPjIc5zK3
	GVGv8qv+QKn9FxWeI3mwNfMiqerwAoW8gZ+92XRq8sA8WD1s95b6lqInTqG9j2aKIetykHMHCt5Mv
	Uib2xNdHImEoyUBH7Krt/cjuh1Zcu2LIVXz+4mKHIzXcccY0LGmRCLKxhaSPOihJWlX3hd66ExBRA
	Taja/Thw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7u6a-000fLI-0d;
	Thu, 24 Apr 2025 18:46:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Apr 2025 18:46:56 +0800
Date: Thu, 24 Apr 2025 18:46:56 +0800
Message-Id: <cover.1745490652.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 00/15] crypto: lib - Add partial block helper
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This is based on

	https://patchwork.kernel.org/project/linux-crypto/patch/20250422152151.3691-2-ebiggers@kernel.org/
	https://patchwork.kernel.org/project/linux-crypto/patch/20250422152716.5923-2-ebiggers@kernel.org/
	https://patchwork.kernel.org/project/linux-crypto/patch/2ea17454f213a54134340b25f70a33cd3f26be37.1745399917.git.herbert@gondor.apana.org.au/

This series introduces a partial block helper for lib/crypto hash
algorithms based on the one from sha256_base.

It then uses it on poly1305 to eliminate duplication between
architectures.  In particular, instead of having complete update
functions for each architecture, reduce it to a block function
per architecture instead.  The partial block handling is handled
by the generic library layer.

The poly1305 implementation was anomalous due to the inability
to call setkey in softirq.  This has since been resolved with
the addition of cloning.  Add setkey to poly1305 and switch the
IPsec code (rfc7539) to use that.

Finally add a partial blocks conversion for polyval.

Herbert Xu (15):
  crypto: lib/sha256 - Move partial block handling out
  crypto: lib/poly1305 - Add block-only interface
  crypto: arm/poly1305 - Add block-only interface
  crypto: arm64/poly1305 - Add block-only interface
  crypto: mips/poly1305 - Add block-only interface
  crypto: powerpc/poly1305 - Add block-only interface
  crypto: x86/poly1305 - Add block-only interface
  crypto: poly1305 - Use API partial block handling
  crypto: lib/poly1305 - Use block-only interface
  crypto: chacha20poly1305 - Use setkey on poly1305
  crypto: testmgr/poly1305 - Use setkey on poly1305
  crypto: poly1305 - Make setkey mandatory
  crypto: arm64/polyval - Use API partial block handling
  crypto: x86/polyval - Use API partial block handling
  crypto: polyval-generic - Use API partial block handling

 arch/arm/lib/crypto/poly1305-armv4.pl       |   4 +-
 arch/arm/lib/crypto/poly1305-glue.c         | 112 ++++---------
 arch/arm64/crypto/polyval-ce-glue.c         |  73 +++------
 arch/arm64/lib/crypto/Makefile              |   3 +-
 arch/arm64/lib/crypto/poly1305-glue.c       | 104 ++++--------
 arch/mips/lib/crypto/poly1305-glue.c        |  74 ++-------
 arch/mips/lib/crypto/poly1305-mips.pl       |  12 +-
 arch/powerpc/lib/crypto/poly1305-p10-glue.c | 105 ++++--------
 arch/x86/crypto/polyval-clmulni_glue.c      |  72 +++------
 arch/x86/lib/crypto/poly1305_glue.c         | 168 +++++---------------
 crypto/chacha20poly1305.c                   | 115 ++++++++------
 crypto/poly1305.c                           | 124 ++++++++++-----
 crypto/polyval-generic.c                    | 120 +++++---------
 crypto/testmgr.h                            | 112 +++++++------
 include/crypto/internal/blockhash.h         |  52 ++++++
 include/crypto/internal/poly1305.h          |  28 +++-
 include/crypto/poly1305.h                   |  60 ++-----
 include/crypto/polyval.h                    |   8 -
 include/crypto/sha2.h                       |   9 +-
 include/crypto/sha256_base.h                |  38 +----
 include/linux/crypto.h                      |   3 +
 lib/crypto/poly1305.c                       |  80 +++++-----
 22 files changed, 595 insertions(+), 881 deletions(-)
 create mode 100644 include/crypto/internal/blockhash.h

-- 
2.39.5

