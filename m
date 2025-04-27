Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119231FBEA9
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 05:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745731315; cv=none; b=ucwHW5l5aEuPoMu7Bv+ThhCQHQKnaCVAZsfx33w7om/rihA8cRspS1yeJEyyzYf4tkvbfYbT9BUWtpPRWLTtXp/N8VCao9njkYTiHJ24wRI7AHzRLWKt7ycBwmjfIcvlmX2eFRJ9wkm1aBvFhEoQVFzDpjrdZc03X+RWplHJrog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745731315; c=relaxed/simple;
	bh=XCqD8rsC7z9TkRge8SgDpIO0TVBf+M0ctSCcUF835QQ=;
	h=Date:Message-Id:From:Subject:To; b=sYak+pwFKn3NJLflpeLdG3vzpXMmtkAvRJ7cMWRCdysTd1Hu53zq1nsYUTddjcBjmIT2/MojjLF7pQ5exJ3BLnSGvTPArZfUdyqdqhXUX9idgbbFRdDUjBi8zCUfV2DwJM1vB2iHODUo/Psq0wjbzErIcjVVAlN3k/X435SZ/rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oBdHiRAp; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oBdHiRAp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qHNquFb8CXfW2iFctPFU/JxnKCF/z1POS5FAYIko+tY=; b=oBdHiRApgaW/850Ku5fXxYpSIE
	NVfPQIxQiNaawMCRzDfzjdYakGT/W0TkdxFhP6RWeWYJwc46Tzq2MijLJLa8VNZ2Duik8us3i4uiR
	d9UWx4U+RJuXgg09kdSOSUDFobI0YzeLhrDLo2lUd3ijvCjOCec54rTnAdL1ZAGaNAYdq92oWmFne
	ojjT1p/pjPkYSPADiIM6KiedcTKd77+j+OGm1DSXiUUC3rHQGbv9n7uF/glJntPIoO/PsPC0WvxR/
	i3b/h7UH13d+JmkXq/Dd1AHtQwf/fwiSjcCPfACyfIsPOYdKN0mfAT/WOFyJKdbZhz7U+PmU7dQzz
	YH74+p4A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8uSb-001KyR-0J;
	Sun, 27 Apr 2025 13:21:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Apr 2025 13:21:49 +0800
Date: Sun, 27 Apr 2025 13:21:49 +0800
Message-Id: <cover.1745730946.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 00/11] crypto: lib - Add partial block helper
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v3 modifies the block helper so that arrays can be used as state.

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
 include/crypto/internal/blockhash.h           |  49 +++
 include/crypto/internal/poly1305.h            |  28 +-
 include/crypto/poly1305.h                     |  60 +---
 include/crypto/sha2.h                         |   9 +-
 include/crypto/sha256_base.h                  |  38 +--
 lib/crypto/poly1305.c                         |  83 ++---
 21 files changed, 393 insertions(+), 1282 deletions(-)
 delete mode 100644 crypto/poly1305.c
 create mode 100644 include/crypto/internal/blockhash.h

-- 
2.39.5

