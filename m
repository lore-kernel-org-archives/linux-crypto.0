Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C6D1C7017
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993183; cv=none; b=YjJ80vtPDNB0M17m02p6R9wRHGwzmTAIb3ujVBYPK3cASKnseo0YQJrN+mMQ6MiQR6tapu1Mtau5TWZ3iMOLf5uBQ5GtkIZL8lSCaLpZyfO3pPeIDBr9B42R8dHZVT9Tnlnzb6Qhqr67DDpX7m1V15g34b3j4GwPrJn4zapvVoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993183; c=relaxed/simple;
	bh=23+F1gbQBUOg4Rqzq8sYemW6dTlQF5S4PL5/FsnhILs=;
	h=Date:Message-Id:From:Subject:To; b=N25GUZ82vXMks3p6j7a4F+5lBf+6g2yKDYNIpzDi0stxkL4fVwm9vfr9qaFdJj7P+4I1pUTz+wsRkGA18agcsvkF1Q7lOwWmllwyZ08nYio+0kfmDbVan7hCXEjyFkjuJGltChHxS3igKubmkK1+sr4L8kZOTEQ13E1gygt2Lh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fdEkQiWY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fdEkQiWY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2Alc+6GG3wzPvDWpBthghiio7nVhJv1J0q2MadYT9aM=; b=fdEkQiWYcxCUArNgPhQ9wghQGP
	6wSENymyeoP2bHlwqiCtO0UFIsHW89iKtGt6hjv6G/LWwO16FL5rvTmUwevr4Jw1XBIwh1UduRjYp
	NxBW7J+1YY1Vod9h/56bujjIWBkgjA0t9skzZ59O+MyzsOZxY4vIDm5zlOECwRrLQdJv17yV22Vv1
	HOvGn3t93drvaEh6AfEmFKI+mbfZ/rwaSTVqpl1quKzOkMmEO30XnPb3bcFNl6hTEk3EZzSqSpMjU
	dFLw3zmhs6caPL0woJ9vXWkUafB6CpbzjzH0mhC2EvTr2lPo2lBe7N5fBHrzxY6ls1pbVkm8GuC8h
	B2rse/gw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aF-002AZY-0e;
	Wed, 30 Apr 2025 14:06:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:15 +0800
Date: Wed, 30 Apr 2025 14:06:15 +0800
Message-Id: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 00/12] crypto: sha256 - Use partial block API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This is based on

	https://patchwork.kernel.org/project/linux-crypto/list/?series=957785

Rather than going through the lib/sha256 partial block handling,
use the native shash partial block API.  Add two extra shash
algorithms to provide testing coverage for lib/sha256.

Herbert Xu (12):
  crypto: lib/sha256 - Restore lib_sha256 finup code
  crypto: sha256 - Use the partial block API for generic
  crypto: arm/sha256 - Add simd block function
  crypto: arm64/sha256 - Add simd block function
  crypto: mips/sha256 - Export block functions as GPL only
  crypto: powerpc/sha256 - Export block functions as GPL only
  crypto: riscv/sha256 - Add simd block function
  crypto: s390/sha256 - Export block functions as GPL only
  crypto: sparc/sha256 - Export block functions as GPL only
  crypto: x86/sha256 - Add simd block function
  crypto: lib/sha256 - Use generic block helper
  crypto: sha256 - Use the partial block API

 arch/arm/lib/crypto/Kconfig                   |   1 +
 arch/arm/lib/crypto/sha256-armv4.pl           |  20 +--
 arch/arm/lib/crypto/sha256.c                  |  16 +--
 arch/arm64/crypto/sha512-glue.c               |   6 +-
 arch/arm64/lib/crypto/Kconfig                 |   1 +
 arch/arm64/lib/crypto/sha2-armv8.pl           |   2 +-
 arch/arm64/lib/crypto/sha256.c                |  16 +--
 .../mips/cavium-octeon/crypto/octeon-sha256.c |   4 +-
 arch/powerpc/lib/crypto/sha256.c              |   4 +-
 arch/riscv/lib/crypto/Kconfig                 |   1 +
 arch/riscv/lib/crypto/sha256.c                |  17 ++-
 arch/s390/lib/crypto/sha256.c                 |   4 +-
 arch/sparc/lib/crypto/sha256.c                |   4 +-
 arch/x86/lib/crypto/Kconfig                   |   1 +
 arch/x86/lib/crypto/sha256.c                  |  16 ++-
 crypto/sha256.c                               | 134 +++++++++++-------
 include/crypto/internal/sha2.h                |  46 ++++++
 include/crypto/sha2.h                         |  14 +-
 lib/crypto/Kconfig                            |   8 ++
 lib/crypto/sha256.c                           | 100 +++----------
 20 files changed, 232 insertions(+), 183 deletions(-)

-- 
2.39.5

