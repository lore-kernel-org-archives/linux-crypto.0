Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B84318C026;
	Wed, 16 Oct 2024 05:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729057088; cv=none; b=TQQsVaVdc+cCvS1C/LvTF86QJ7hCzfNnKorWwrEzP+BQB7md+IXN/jr+hf4wqXIbe1YP+CK1M7nixJTt20LDp3EqJYuizAWkqJIwh2vIcOEu3djOToAuvvb4yZbnAsaB6BZGuOaeHWK1gK5VvVR2uOkt+1JHPGiiQ2Q2z2M9LLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729057088; c=relaxed/simple;
	bh=Hxe61mAHxlkAQeFoMnrNm2digeS8SBoYNPLuYngb7fc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H6oBu7YhTo6WDDOUedXSIbLiPwUO6HJ3cw3l8k4X8TnXwIYDJOTujrqvl6NPSyJm6gCCfzahFhmWFmZ0KgiJcAqIcs+eD9MowZO4d23A8b4XWcAGXcQa0RK7L4D9QalqDFveO+1k+/aAvk6upAmvRr33d3uMFX+2OAktpeVDIYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gmAPymUo; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gmAPymUo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LEUMOUUfHvcGVlzJzuX6lug3Qy5DEcFG85wA77pcj/Q=; b=gmAPymUoB7wzAETPguk2Faq52B
	ZQ9G5rH7qNUXbhetiZR95aYBZB+5Sip9+LIJXS8W9P9crnXx7Ys6/3Zt7tovNqpOkNyWmjG3P+nNN
	GV721lpGaasuyxJON7GjFlwZ34jTV+euI4nQ0n44ecsIwcyiYrr9i3MThXWJI48f4pdmtcGIJueb6
	ALWQ1SqpubZ2qVQDXrc8D6srl0e+N4AnVix76mEddDDyasb4IYHRiHYgp9xxf8G+P3T/K3w2i5EPs
	1dnpF+4v/4Yb1//gY2GdysnQBgWUBZaFhmrf5bqmzM1PG1AEXN0KhjbkROw1vQQzYJZO8aWD+mY61
	RGcBScCA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t0wZR-009k2L-2z;
	Wed, 16 Oct 2024 13:37:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Oct 2024 13:37:55 +0800
Date: Wed, 16 Oct 2024 13:37:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.12
Message-ID: <Zw9RM_jNu9vqp9T8@gondor.apana.org.au>
References: <Y/MDmL02XYfSz8XX@gondor.apana.org.au>
 <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>

Hi Linus:

The following changes since commit 44ac4625ea002deecd0c227336c95b724206c698:

  crypto: powerpc/p10-aes-gcm - Disable CRYPTO_AES_GCM_P10 (2024-09-21 17:14:59 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p3 

for you to fetch changes up to e845d2399a00f866f287e0cefbd4fc7d8ef0d2f7:

  crypto: marvell/cesa - Disable hash algorithms (2024-10-10 17:03:35 +0800)

----------------------------------------------------------------
This push fixes the following issues:

- Remove bogus ENOENT error messages.
- Ensure algorithm is still alive before marking it as tested.
- Disable buggy hash algorithms in marvell/cesa.
----------------------------------------------------------------

Herbert Xu (3):
      crypto: api - Fix liveliness check in crypto_alg_tested
      crypto: testmgr - Hide ENOENT errors better
      crypto: marvell/cesa - Disable hash algorithms

 crypto/algapi.c                    |  2 +-
 crypto/testmgr.c                   | 23 +++++++++++------------
 drivers/crypto/marvell/cesa/hash.c | 12 ++++++------
 3 files changed, 18 insertions(+), 19 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
