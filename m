Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9323221578;
	Wed, 21 May 2025 01:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747792799; cv=none; b=nAdfdcHhWE79TGZJQN0z+/CFwDC0IlnYHZLDaUgdjgY+yScR+zaBjkSpdN+WD3NoV9sSTNE4jxxMd9j+Tc7PCQyYKDPjrGD6aJ1P+qjjOL0YJ6Oj83BnSQWBjuraHClJraap/frQ0LgZvfr1FTP+fcmwbWkzl5FQMdBS49Ph58k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747792799; c=relaxed/simple;
	bh=Pv/KnH/JqD8jg/lF2un3qV14ygiPIJXZgUvFpPO2kZc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NXCoALGIWSETwsVOKgtMOM7DR0yKPx8P+/EPHW8850aDSXn8eJtsW0zAF9oZIRN+j7b8ZnTDKfHZDO5FRqt9n3fP6Zo3njvQeR156QyRATmoSPK14PYbnILOymGc6mOJzMipYkotF8mInFT85mphAUUp6aAeDgRamJI4vOaLotQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pPAAdnG2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pPAAdnG2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z6OPD1c/C8KSKxUCnabqzGn3b89zx01gB/mJQTQcQOI=; b=pPAAdnG2+83c5jOqjKZArcaE9M
	uCwwC7javr1c0+t45b64aQo9dWu1QpJV4KPm6Zje8M18Kqn1StjCfEvNtXhaFwxHwg1y/p63tg32o
	eljrFzqKXDwhlZwev6jg/MjYqs7b2awdYwxxO7yGVIagnITvZAr9Y4mPLuZh6P8Y0yzikCTdWto1O
	KtqXizBvHnDm20iJ4caRW6EPNhtc2NXDoUI9EzrBDuHLCq/cfvbPBgoJ6IkyBwI5JmOQgb4xaPSdd
	47GbfbXH/qxJhMrP9BntgPDgcnWoZCnMKNe2ciNe3cASMnA3quwEkxy4wyDE9EIMkc9yNZ9Y0x2Nd
	kiADwJUw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uHYkF-007gk3-0A;
	Wed, 21 May 2025 09:59:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 21 May 2025 09:59:47 +0800
Date: Wed, 21 May 2025 09:59:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.15
Message-ID: <aC0zk5QbJJ_FDCKq@gondor.apana.org.au>
References: <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au>
 <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
 <Z_89K7tSzQVKRqr6@gondor.apana.org.au>
 <aAn_NWZjdX-wYHxR@gondor.apana.org.au>
 <aBGPSpJcLRrwiutd@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBGPSpJcLRrwiutd@gondor.apana.org.au>

Hi Linus:

The following changes since commit a32f1923c6d6e9e727d00558a15ec0af6639de19:

  crypto: scompress - increment scomp_scratch_users when already allocated (2025-04-25 10:33:30 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p7

for you to fetch changes up to b2df03ed4052e97126267e8c13ad4204ea6ba9b6:

  crypto: algif_hash - fix double free in hash_accept (2025-05-19 13:44:16 +0800)

----------------------------------------------------------------
This push fixes a regression in padata as well as an ancient
double-free bug in af_alg.
----------------------------------------------------------------

Dominik Grzegorzek (1):
      padata: do not leak refcount in reorder_work

Ivan Pravdin (1):
      crypto: algif_hash - fix double free in hash_accept

 crypto/algif_hash.c | 4 ----
 kernel/padata.c     | 3 ++-
 2 files changed, 2 insertions(+), 5 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
