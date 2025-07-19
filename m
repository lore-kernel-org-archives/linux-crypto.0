Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498D01FDD;
	Sat, 19 Jul 2025 00:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752885385; cv=none; b=aJvkGVKMOaMxNfJaWgvl1MzT74hB+5NJTs6OXqYjHPHWlYtVbY9bi8SuZqwIwPDd8e0rr2aVRgsvs33rCmtCdOwq1trUwNzwwAun/5VVUb4yTvEP/MRJvP6PeFG9af0FVT1eDKLyomk9WDITo9OhO3XVWLiVvOJfVwaK/y5NKjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752885385; c=relaxed/simple;
	bh=I/r2vN3wqJ5qQdZvUGsuyTs//bOBUe/HAHBQjZKBpKw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=luOWB3Ad73Hu1nx9yMo6bGCoNmcRjtJs6Bzp1ir6R+u01EJ9nvGhOJtxxTKO/2rkY9AANpYb0gfEXfEnfCIXahnmW/i8CWTqj44myC9BZnim5q/itneBqcPNCsqNkkc0WHjURHZa0y4sH/nrSNE54AY9/9j58vPkd3h3w6J13v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PIMun5ui; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PIMun5ui"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IqC7ruty75JcffgNk6jVN0gBHdmHmCCllYQ2BM10vTw=; b=PIMun5ui99bZh+Ky7djZtul3Rb
	UrWzNiQ41W1bVwHBqffwJKLpUBd8QYbuTZhaiSQ5s9R10LFWdoI9aF2iBVFXn6QJRB8dOgY6qX4LD
	GLs1FN71H4PXjWuN3dgpxXcfJwvBLpM/XtfQywDYviewr4xFbS04w2men+C4fCtRoEakGBkUF1d5Y
	ESyHPLaLSgZWU+u+/Rd3ck+FOAf4fHimGMp2rdCuJ1189WNI4Ou1lX0H9SloltKJSOyKLFBN45QiE
	ODJw2FJPCC3pht3/D2QGf+q/k9IUBS4b2cZsIS0DQGZh6rPBhdVBy0MhVs/wMOFTDpqwnsEwZ5uK+
	DLyBglqg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ucvJG-0089dm-0t;
	Sat, 19 Jul 2025 08:36:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Jul 2025 10:36:10 +1000
Date: Sat, 19 Jul 2025 10:36:10 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <aHroehR8vSrZnULY@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 20d71750cc72e80859d52548cf5c2a7513983b0d:

  crypto: wp512 - Use API partial block handling (2025-06-23 16:56:56 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.16-p7

for you to fetch changes up to ccafe2821cfaa880cf4461307111b76df07c48fb:

  crypto: qat - Use crypto_shash_export_core (2025-06-26 12:55:22 +0800)

----------------------------------------------------------------
This push fixes a buffer overflows in qat and chelsio.
----------------------------------------------------------------

Herbert Xu (2):
      crypto: chelsio - Use crypto_shash_export_core
      crypto: qat - Use crypto_shash_export_core

 drivers/crypto/chelsio/chcr_algo.c             | 10 +++++-----
 drivers/crypto/intel/qat/qat_common/qat_algs.c | 14 +++++++-------
 2 files changed, 12 insertions(+), 12 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
