Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3314C13A3F2
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 10:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651301; cv=none; b=ugsQHzOHKUHgVCkbf+E5pgUkSKDusG9PcYhUP6JEw5JxO/RfFPOk5UyE8eZTNzSAK+2ebElqPRPhSG8tGYEJZJK8V4e7RfijCJbMe5LIAUmVYJaExLvEA2ylpCppd2AqxLpfzDK2acbax2vhgyKceWVd0OQSypbcU8Qz3Y6JBGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651301; c=relaxed/simple;
	bh=f0PsmDzrPlbHPzEm4kYRnL2PeiUy82YgFqzdylQmmOc=;
	h=Date:Message-Id:From:Subject:To:Cc; b=omLB6R0m9CfLkCMn72KKiTk8F9mG9Yi3eg1kQ7VeAWKlMZiPrtNhwlkadXkNN8+RuF62Jiue3PPw1o4VPs56qPfSEA5HyiFyfMR3m/3u8V7t02O0U1jaM2hN2dOoC8XYqCm64RTxZm4TUwvM2SakM2oNFgIUgWw7gJS2E3ClOiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FzCF0F3V; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FzCF0F3V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OUqLYkxIvjh8nd/Otc2gCbSQQSabj9ja5wdytCsUyy0=; b=FzCF0F3VkiTI7GKWP8/By1xmYm
	q7DsAsg62J5VmZhDPgb0zva7wCk946gvO8G7ehHK+dkIcZmutxxL1A2f+iJv6kgzVdkCEIXNpDSPq
	InKsoh1uUnc4KmecQj00o88JLxQSoIHvcSHoGaZ53YYVJ+W7j8n7llORnOs5KtzoSLbHs0PQCuNhH
	gCL0Ng9Uita9OJ0Wl1mgVzAwu6912uQ5FuRYd93968ME+wp0kvbE8QN3uXu4eM1FkxHHrbfaUp6Af
	9UF4grimvhlm5LEzxnmQ6HHjjNu4F426KBbo74sH/IXm5VLeCYIzKiq0lSjTa1Yh2FW4v9cC0/u2K
	zU4eCwUA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnaur-002DqT-1G;
	Thu, 27 Feb 2025 18:14:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 18:14:53 +0800
Date: Thu, 27 Feb 2025 18:14:53 +0800
Message-Id: <cover.1740651138.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/7] crypto: acomp - Add request chaining and virtual address support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series adds reqeust chaining and virtual address support
to the crypto_acomp interface.  The last patch is a demo of what
it looks like to the user.  It will not be applied.

Herbert Xu (7):
  crypto: iaa - Test the correct request flag
  crypto: acomp - Remove acomp request flags
  crypto: acomp - Add request chaining and virtual addresses
  crypto: testmgr - Remove NULL dst acomp tests
  crypto: scomp - Remove support for non-trivial SG lists
  crypto: scomp - Add chaining and virtual address support
  mm: zswap: Use acomp virtual address interface

 crypto/acompress.c                         | 207 ++++++++++++++++++++-
 crypto/scompress.c                         | 175 ++++++-----------
 crypto/testmgr.c                           |  29 ---
 drivers/crypto/intel/iaa/iaa_crypto_main.c |   4 +-
 include/crypto/acompress.h                 |  95 +++++++---
 include/crypto/internal/acompress.h        |  22 +++
 include/crypto/internal/scompress.h        |   2 -
 mm/zswap.c                                 |  23 +--
 8 files changed, 365 insertions(+), 192 deletions(-)

-- 
2.39.5

