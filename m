Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A972331E11D;
	Fri, 31 Oct 2025 09:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761902470; cv=none; b=A6QdFsvEye2Fsu2txYM7Wev/kGYzAaQ/LKshcXNIUQs7RLNirU85fFMtmu97FrSQfYm6K2GMyCtqNiY3B54M5nXvfS+88vSxUGAMlCd6IIQtyxaPz0LatFmLpZMKTLJxCSUOZB1OW/idwEaf6CDrT1UkuWWYvccLsQlHsa2bcYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761902470; c=relaxed/simple;
	bh=PUz28ThoKzjRXcHTmMIXe+63T7xFQIqA6NI+Jeth6Cw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JJBIMv4+JnAdRX9RR9BAlTXn0rqRDRHqQIQi8rVbRQjuVBydOhRMGsMHfkExIgDgPfuwN6grHY4x90MLua2fop0GHczdHwHBBN5R4p/k1NsOHOWOkm0DkZkew0PaGJDkJrCemSyhpSjg1bRDbXK58RcnkOc7cThz34rOBhJRF0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rtl3ISA4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rtl3ISA4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=JAAMRj4Ls91quenHk+XdqZWgA1ZNSmPkHTvgWowdmkw=; b=rtl3I
	SA4sscWiyfKW8b8uVjpGCTa5xlibaBaNAcvYxjXIHFhFw7g53JBaAOiCiAGr3nN1hmhIbpx3weWjF
	LkJQ19pUZq53ACNG7nSOWjXtcUpCVk7OzuxU7xIEkkBD1hUQDA0cqhtuX2yZLtTgk+dYadlniZhGh
	uTQzqKVQLvcxxnsUcZiipbhHaTWbBpnDxkm1qwjVPLQhbN2ujtRj/tJpnPdTsv676FvawhXeAtdKF
	nE9ngO3StMsA+RmkeC0zX/R7Ok327C/GkslYEnW237jd7NcaP6nVRTaI8tS6FpIELUS1rM1Sj3Ku1
	C/TCUCOvgw3pfgcfknfRwp3GzFJyQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vElJW-00H1Mu-0c;
	Fri, 31 Oct 2025 17:20:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Oct 2025 17:20:54 +0800
Date: Fri, 31 Oct 2025 17:20:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.18
Message-ID: <aQR_duMIT385hw9N@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.18-p4

for you to fetch changes up to 3c9bf72cc1ced1297b235f9422d62b613a3fdae9:

  crypto: aspeed - fix double free caused by devm (2025-10-23 12:53:23 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Fix double free in aspeed.
- Fix req->nbytes clobbering in s390/phmac.

----------------------------------------------------------------
Haotian Zhang (1):
      crypto: aspeed - fix double free caused by devm

Harald Freudenberger (1):
      crypto: s390/phmac - Do not modify the req->nbytes value

 arch/s390/crypto/phmac_s390.c       | 52 ++++++++++++++++++++++++-------------
 drivers/crypto/aspeed/aspeed-acry.c |  2 --
 2 files changed, 34 insertions(+), 20 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
