Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E80F3090C6;
	Fri, 14 Nov 2025 10:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115327; cv=none; b=eLexSVqSte0eKP/h2sq+uyY2NHxY1Xik5xLc3E9wTmmRhY7mhQLddzSWfZ4kM/86/k5w62EuTYWZ9D52+uEOiE5Y/SDO2FS/kzQ9BPRw+3x/3uCwgNI7bQQ84EjBP6fVN1Nlt15r0XA/vOTEaudcZxuKcKKIvExPElWpkTc/E1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115327; c=relaxed/simple;
	bh=9CfEl2OfTpWThOyHVylr/RC1TyPqN/2xv5pCXp/9jHk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Q6Zy1U4mGY86yzEFmtIV2G1lMqQHRRTAvRozGWW1jKMatTPjHDRfI9w6HGnSbXRCtS4AoIHGl0V65Oj33w7w8pUulLjq10BQyagzBDT8XcBHU+8veU5GrVZOlp/9022TYw6vlfCGqdRV3YVYm36q+2BoZrMUrkjNUw7BLI+0v0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cauCCh9Y; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cauCCh9Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=QkDpA54m7yE8g+BE95bZatgV3vJf2foKGuRK6JH61No=; b=cauCC
	h9YjPLDeIJ91NP4nAeCZI1jIotgDVdQn8BbMyPlgDuuRCGqeRHIi3H+rNPdCHw9Rtxl9KJmLPHCM8
	4K+nEsZfUHWX7gEyAp9uQYuJjRZ759H73lhOikcev4r2qoYzFWTyUKOFs17edQWD1EG38E863fsU5
	lGJEe0QvSsvOoDcKrDWFwu+Przaz0nrei1dRy7NvHdescd8iOR7ogKKF1FuV+DajOFi0HfSzKiEUO
	6s2+k71hKJZIY1KCfnBl/eyy1/rjdIlC63HMTE+2uFl4GQfranpK3zKtEUXTkndbNa9MO2lXWo87Z
	6wn0p3SwHNJAd+JAC6TuByRutgC5A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqpp-002yLk-1K;
	Fri, 14 Nov 2025 18:15:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:15:17 +0800
Date: Fri, 14 Nov 2025 18:15:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.18
Message-ID: <aRcBNZJDTLFTTHxN@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 3c9bf72cc1ced1297b235f9422d62b613a3fdae9:

  crypto: aspeed - fix double free caused by devm (2025-10-23 12:53:23 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p5

for you to fetch changes up to 59b0afd01b2ce353ab422ea9c8375b03db313a21:

  crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value (2025-11-06 14:29:49 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Fix device reference leak in hisilicon.
----------------------------------------------------------------

Miaoqian Lin (1):
      crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value

 drivers/crypto/hisilicon/qm.c | 2 ++
 1 file changed, 2 insertions(+)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
