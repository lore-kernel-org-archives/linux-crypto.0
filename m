Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0022F2F
	for <linux-crypto@vger.kernel.org>; Fri,  2 May 2025 05:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746163866; cv=none; b=VNHIDZTx+HbwjHYXRpUdC5feRaR2h3fx8eiDwtxExfffYdzbL+KIRsxodb/T9SjV8T1qrCcjUKSHmAFjFxNwCWISWWUlIQ8XoOAe4uKlV/MEcXvjDSEwBIgB+U5172HNHOgKgJgmUb/w9qEvFxs6eaUskodW3HuBKGrwhRG3Gw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746163866; c=relaxed/simple;
	bh=/a0v4X3F3PxvcUU5GbkB/DDNQEwZL3ToNg5i1LCd8gU=;
	h=Date:Message-Id:From:Subject:To; b=CF3BcqCuMZu8bMTyA43gX8LdjRJ2VOeF4GmO6PjIrwyDc3c8mikbNH8BW22+IvwbjS+OE2quHHjFybNbm5+A5Tnn820EdSliQr3FFWK5UjWxBw5gdkiT5n4lSeJxKb7pUu0Vt88MBaEiY/hdwTRlhErpEs61zlyAvpJRkwVas6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XXgz1gRx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XXgz1gRx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9LdDE0sMWSFbYXn2DaiIs4tfRKu12QaWr7s4UDo9ihc=; b=XXgz1gRx8q8hYSG6VV/wHKB/8j
	cxAiK7Mg8MaqwjoLOGLmuCjFB5NxgDnfp/nzydYn9ePCauWQ0cnMPebs7EVXwhIbrjVx9rgSPl/QP
	G2xHM8oyrSAWaUx89oO5fqhjcMijDo4FqERN3wYmmQMtyYmH0cVGNz/jHjnnPPRiwlR0nQlwGJE0s
	XgaJDpG/sBJwzbbSzrdTGI6qPWYaqXpLwblTFb12yXWT9SeU2b0mPkr/oOQLbYRe9gNrYcF+V5JvP
	m+bzZVRzUcjv84/ESX94dfCx/hZci+4SelyM5EasVTWz4f//8wIkqHj5QdmMqLg5tVjpT/OGp/LIS
	9LGxAvbw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAiz5-002lK7-1r;
	Fri, 02 May 2025 13:30:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 13:30:51 +0800
Date: Fri, 02 May 2025 13:30:51 +0800
Message-Id: <cover.1746162259.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/9] crypto: sha256 - Use partial block API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This is based on

	https://patchwork.kernel.org/project/linux-crypto/list/?series=957785

which in turn is applied on top of

	https://patchwork.kernel.org/project/linux-crypto/list/?series=957558

Rather than going through the lib/sha256 partial block handling,
use the native shash partial block API.  Add two extra shash
algorithms to provide testing coverage for lib/sha256.

Herbert Xu (9):
  crypto: lib/sha256 - Add helpers for block-based shash
  crypto: sha256 - Use the partial block API for generic
  crypto: arch/sha256 - Export block functions as GPL only
  crypto: arm/sha256 - Add simd block function
  crypto: arm64/sha256 - Add simd block function
  crypto: riscv/sha256 - Add simd block function
  crypto: x86/sha256 - Add simd block function
  crypto: lib/sha256 - Use generic block helper
  crypto: sha256 - Use the partial block API

 arch/arm/lib/crypto/Kconfig                   |   1 +
 arch/arm/lib/crypto/sha256-armv4.pl           |  20 +--
 arch/arm/lib/crypto/sha256.c                  |  16 +-
 arch/arm64/crypto/sha512-glue.c               |   6 +-
 arch/arm64/lib/crypto/Kconfig                 |   1 +
 arch/arm64/lib/crypto/sha2-armv8.pl           |   2 +-
 arch/arm64/lib/crypto/sha256.c                |  16 +-
 .../mips/cavium-octeon/crypto/octeon-sha256.c |   4 +-
 arch/powerpc/lib/crypto/sha256.c              |   4 +-
 arch/riscv/lib/crypto/Kconfig                 |   1 +
 arch/riscv/lib/crypto/sha256.c                |  17 +-
 arch/s390/lib/crypto/sha256.c                 |   4 +-
 arch/sparc/lib/crypto/sha256.c                |   4 +-
 arch/x86/lib/crypto/Kconfig                   |   1 +
 arch/x86/lib/crypto/sha256.c                  |  16 +-
 crypto/sha256.c                               | 148 +++++++++++-------
 include/crypto/internal/sha2.h                |  52 +++++-
 include/crypto/sha2.h                         |  14 +-
 lib/crypto/Kconfig                            |   8 +
 lib/crypto/sha256.c                           |  97 ++----------
 20 files changed, 239 insertions(+), 193 deletions(-)

-- 
2.39.5

