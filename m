Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CDD28A731;
	Wed,  8 Oct 2025 03:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759894750; cv=none; b=PZt6Bf/xPuC2z1UNY1h/Gt29CwV/CEzT/P/QY7gQd7CBm9p5O64ZPR3Dw81SpBbj8STlJ/e1quAr3Y8xozjKy4MY5rV94ViNGpSC4lCGWjAG4snPb8Dd3Uj6gJc+AVOdFkiU9eKBF3V0Xc8xDRgVHFMc2yJjas8aOvCNHJoSckk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759894750; c=relaxed/simple;
	bh=YO32Hhnuh8UDLVbUDBeYjTlDbC+BulVadgIbLPFDoH4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lUH/vDyczUfnO7iGVPBkoh2Q1WA9/1TSC8tID0C6In+qHqkgGXRnMy+T+ef/ajhbDItcrPNeCYWZF1b31E461NUeEGWa5pivDvVTknAmvbfG8t71mAgTm3sfXF9ZR+eKWnu+gbzqoHXJa+V0vp8NMBWg9sFXPB8p63uRTCkKh4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Madr73ZQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Madr73ZQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=B8/MyZPbnHEp9ATxcsnHOoukis2qWTmnSty1GRhGuaA=; b=Madr7
	3ZQ+K5DNybE/rOEcaj3bnBGAjgmqIsTRz9G1B4m7ig81TQGF+y5OgQwKHfgl9IgIiSgmS0SOnto2i
	tRwiVChXtEB7ChEYoFQRyyFkdNX3HEfn/jHvTxSslAIGbt1KwSKwr3NkhoWPLYf0YE/3812ANW28H
	lC21yHyQDbYoHaXyQDqQDJXMpghjPhJv25voiwAXW5hGtUTGVhxZPJmQP7ChCaHGOLgf08MNY/axM
	jrpu+i6ChnEyrexhzfsd9vWukc8RMDe/pcsDi4RRJ2wWJ0Mx0lovRflK9gppzkNfZZkMtfV/eIXuW
	aTA+Oo+F3iTH/L1LS4z1dtisMFOvw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v6L0u-00B93n-0p;
	Wed, 08 Oct 2025 11:38:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Oct 2025 11:38:52 +0800
Date: Wed, 8 Oct 2025 11:38:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.18
Message-ID: <aOXczKUtckTr4uCl@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 166c83f7789ed02dc1f25bc7bed4a1beb25343aa:

  dt-bindings: rng: hisi-rng: convert to DT schema (2025-09-28 11:54:48 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p2

for you to fetch changes up to c0d36727bf39bb16ef0a67ed608e279535ebf0da:

  crypto: rng - Ensure set_ent is always present (2025-10-06 10:17:07 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Fix zstd regression.
- Ensure ti driver algorithm are set as async.
- Revert patch disabling SHA1 in FIPS mode.
- Fix RNG set_ent null-pointer dereference.
----------------------------------------------------------------

Herbert Xu (3):
      crypto: zstd - Fix compression bug caused by truncation
      Revert "crypto: testmgr - desupport SHA-1 for FIPS 140"
      crypto: rng - Ensure set_ent is always present

T Pratham (1):
      crypto: ti - Add CRYPTO_ALG_ASYNC flag to DTHEv2 AES algos

 crypto/rng.c                   | 8 ++++++++
 crypto/testmgr.c               | 5 +++++
 crypto/zstd.c                  | 2 +-
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 4 files changed, 16 insertions(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
