Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC10A436BC8;
	Fri, 18 Sep 2026 09:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725534; cv=none; b=S+aWyvwYHs3DVaRhNZ2TAFhLcNSjPIGbqri5j4ZkTmBhAV6m6kUpIRAYdczc30d28iOCCxTXzQmQIT0mBjY8uCMRM+VtXjNwlZOPvEz4ykwe5OoaxWW3eUhRSqsCdDkL6FB/ikWQtD/3x/l2PAy1IoBzEYsCHSkxFCy9ZdRud1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725534; c=relaxed/simple;
	bh=jYd+I40jEaxIomQfyEKZUk9TFt3Otioy7dxEVuOWqRk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Qxr53/Kg1QWc3ajYnQhZsrueItQ/tYlt8Tg6Oi5FpR/4bsQ9IKwJLszc97yWJsQC3U4YPPtxk7uOuI7nsriCJDdJIEE1hA+84Uzg9BXmEEmPeaJUEPztLEcd0ihchb3ujivlKyCLNLP0oXqkAp1aXUcj1RzosGb5+wWuyAoTRrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=f6ahu+/C; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="f6ahu+/C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=wpXzrCyVMAWXd9Llt5C5QD5boGXqJUlTQCeoAdJR38c=; b=f6ahu
	+/CYyUPWtKlLNezumKsmCDpJnxOUsDMC8oJerU6j++wUaDDuDNZMnBw7xvnjgv1EK0BM7T+6NydKV
	9f8A68Do3lj2/j05pMD0j2tdL9f6cGPqQmd+ZMmNYLFTYkEiz/qtQrSedT8HHYUvdk2XCf/jgH3Pw
	2p/J0wLZwfxwAW+qIZp/CQGTmv+pKMvhExP41bMJ2ZrBqLukFRSGG8XVKu98NaY1pgSZqHXa0Quxg
	+vQl+i1salm5i/YctbmXcrT++uFW0TPDSt2bHFz4enakI1JojagTGdtDc7RsmpIRMdPYcHu0yi3+K
	Jp4lyQszCQjcRJMR3w2qNhEiV+X2g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7VMm-0000000FM5v-1XXy;
	Fri, 18 Sep 2026 17:58:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:58:48 +1000
Date: Fri, 18 Sep 2026 19:58:48 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.3
Message-ID: <aq0LWN4cVftl8r5p@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 60892a384aa1e65d0e703e1c513417bdf0c80777:

  crypto: x86/aria - add missing vzeroupper in AVX-512 code (2026-09-04 18:45:51 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p4

for you to fetch changes up to 53cf0f26eece095a3752642151150404bc3351cc:

  crypto: caam - map job ring registers without claiming region (2026-09-16 19:55:13 +1000)

----------------------------------------------------------------
This push fixes a regression in caam.
----------------------------------------------------------------

Rosen Penev (1):
      crypto: caam - map job ring registers without claiming region

 drivers/crypto/caam/jr.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
