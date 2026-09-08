Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483DE2475F7;
	Tue,  8 Sep 2026 05:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788845515; cv=none; b=FFRxXxhFzQBeTy70oV6cVeHr09mwuWMe66m0RDAzxROTq64czN1shrFvhIe5JOAvwgz+C9cHOLy2EI9iUwPNZJ6ojN8LPFSypC4Ucdi0YQEwUfGUfiH3NRhxXZQ4lcH2wchlFQNtSEHh1IcG5DNYIccN1XBARfiVablsgYmZYqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788845515; c=relaxed/simple;
	bh=ZznVUXC3Db8jyf7E+lVXxPCCkO313FilWJc3iundR8s=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Idc+7Hn7fnfzWp3+oaukhbMcNMwXtSpZNjq+l1ET9IPAY4Rfa9hXdagz3obYIFxF29RphRxptEAQrBmHQCwie5P7eINO+GkGWbBI8niS0sbfCBz8aM2CEQd0evwKaF7w5JIVjO5/RoEbm+ikCo5R7N95tgUHzUXuj8tUV+UKZ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SwrwstyX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SwrwstyX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=sU49Ut99usXq+/72Lxs2bGMm4+3EgcIUTNtn7K8dkTc=; b=Swrws
	tyXTPk+/bkv7fbfycb8JjEl/9OAqjvWaJomXP0eJD0mjJUVJIkdY6lk6Q7yxZIPa3HTaIvSEn9ri+
	CefLhwYcL4FVYHUpLY2+nnXMwp8K6OS2+B/BnQty86ixXJ2MTIWgNNue5SeAFTWJojcMa0Iktmhi6
	2O9kgnd1QdXmY0uQIHyqZ4xcj9qsqwdxbh5x31CnBtlgxcGK1/h00TZedjdlyQuwVgONMermMVim/
	LCtf3JMaOln7ydWGvLalRT82IcWVt8ALGs8kd4xHCmUiHSlKDWyoxlVAaIiYE6hiyS249s2MRUf6W
	JkJ3+l2kdUKZLg7R95ZdiCOgMnRGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x3oQs-0000000BjUN-2CvX;
	Tue, 08 Sep 2026 13:31:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Sep 2026 15:31:46 +1000
Date: Tue, 8 Sep 2026 15:31:46 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.3
Message-ID: <ap-dwlnQ8f2QSSDj@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p3

for you to fetch changes up to 60892a384aa1e65d0e703e1c513417bdf0c80777:

  crypto: x86/aria - add missing vzeroupper in AVX-512 code (2026-09-04 18:45:51 +1000)

----------------------------------------------------------------
This push adds missing vzeroupper instructions to x86/aria.
----------------------------------------------------------------

Eric Biggers (2):
      crypto: x86/aria - add missing vzeroupper in AVX2 code
      crypto: x86/aria - add missing vzeroupper in AVX-512 code

 arch/x86/crypto/aria-aesni-avx2-asm_64.S  | 6 ++++++
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 3 +++
 2 files changed, 9 insertions(+)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
