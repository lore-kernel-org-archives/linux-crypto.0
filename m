Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F374328E0F
	for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 04:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745816170; cv=none; b=k90otR6sn2DVj6jmFtSd9B/nzp1NFTyOSz8DVJyXtejH6cxR/ycI7v71CAOi1nr3I05cgvO52ZxxpLLe0nYDnULQtM61AqxB6VfgcjX0cN0Mp2vt6G8QIBpz8Min0u7/D8SLubj5lJeqbnoqGKpnJhblmBvjVpRO1Q0HGxVkkbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745816170; c=relaxed/simple;
	bh=qW/ikGBZsRbLog9n2q6vb9uGqJFHTxgkfKFYEZj/lrE=;
	h=Date:Message-Id:From:Subject:To; b=TB41fKDy0FtEemKVJNkNr7/bIfpFgx/AoqeTgFKIxkHqMXqF8KUUeT23T4dwr9TQ9J+NgC4GI5Tb9gjEXFrIYvH01LGOGvrn4GKy83scbhK0z2JVjtVTa3AOeVfuOcXJyc8mQmBmydtksgOOgBuCddcjVcGIwlNVh9SOxZiWVhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NFIVI9e6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NFIVI9e6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IYn2pWS1WYvtcG/uaCSiw9g8qvLTVvub5DbheE5KdOs=; b=NFIVI9e65Y/Szr/HVku1FH6GVC
	2keCxT+41foUdntBM+cSstozptHuAMDgwk/tkaGv4q7HLPhLc/3S91OB6WRYrNGyBt6Si10jQakIT
	a1rd1rtYIey0WM2sfkRdJm+vK5pw1x67BGY9SM7ndPJ0+CbZ9RWQiC3SwYYei/n/ldtjV2f121P8C
	efrRqmK7Yu1bXMDizOD+glPflRHHOlETRWOpHQY+NF2CgqVy7NMEvoEbZivZeNR2wNB3/I31NzSrb
	8wxSFifsj4hBI9Eqde4wIKikbHHVfKZ0p85AuoLMgA/YpI3KRT3RzkPo5mwZz0UoKq6RHlGtSRqWI
	ym5KefDQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9GXC-001WEc-2G;
	Mon, 28 Apr 2025 12:56:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 12:56:02 +0800
Date: Mon, 28 Apr 2025 12:56:02 +0800
Message-Id: <cover.1745815528.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 00/11] crypto: lib - Add partial block helper
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v4 modifies the block helper so that the block function and state
are back in local-scope variables, the lengths have been extended
to size_t where necessary.

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

Note that there is still some testing coverage for lib/poly1305
through the Crypto API chacha20poly1305 algorithm.

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

