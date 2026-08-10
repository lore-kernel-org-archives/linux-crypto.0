Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D43B37204E;
	Mon, 10 Aug 2026 07:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786347521; cv=none; b=VbN182rIkHKbnpjz8Rv/CPiSQOLAhYTx9JiKBqpYqrMmrawFXnWwjOMrmslM9DNLucQYJ6Ie1nhJYVZTmDqruanFzLvNIDHDD/ShcykMzh9Nc4MLHwOrJxxSwPCf9i7O/Gqf0+Git1H8DBEPhIeB8b3fjO5WAo3bGrXa40JOvWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786347521; c=relaxed/simple;
	bh=98sELRT+ug83gGNKnZyvx4Zp2DbVlRPoAiw6/0Es2ik=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=P1oxWy5ZHt2YMNakuucld6lq3OW1qPIytko7vpPoUMQRma4CAD8jHoiFKQBIokpILMau3ZAlea7YFvcTspm76xuUUN1JAZrV5Gn8GCSSqStrs2Ko6mpvFt+i/N38LgsN3j4JbJEGGXX7I040nz+QO9kB6rqf4vjbaIw49xKVDxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=CTpU0ASj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="CTpU0ASj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=1F9z21xx108cwXYV/cgyVFJ9rW5fh6J7oe1SLAmKbFs=; b=CTpU0
	ASjZEpKDIeftd6hkRjqDmQtbKVaYDxgG9QD0qfTmTMEKmVwUX63BJxCnSZoLWide2luZOhR9O7MUG
	ZUumLKrRVySOpqOxJzk9LxcBnNkvvoWdcDs5BXdrsdTzYwgNnYgTuGLe1NwMsiKWuEWkgzz1cAnGq
	9XGsqOuQ6u2mSuzALXSPu20GOlb4uEUL4DTEUUxVtZ5NJWkanORnTjTBNDDXnCzm42vk5H5oMe09m
	B3fPB9xPi9Ul202wOx+uc3t6cAefSJLQhNqiyWcR5Dolv2i7GjHZus8IZRNQQeu0iP61haP5yCtU8
	+A6srB9tTayuMm1u5bWRrpFLnZxxA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtK0p-00000003VLz-2zz3;
	Mon, 10 Aug 2026 15:01:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 17:01:31 +1000
Date: Mon, 10 Aug 2026 17:01:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.2
Message-ID: <anl3S6pbchyEAvzF@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 8173f7e2ce67e6ca1d4763f3da14e5b01ce77456:

  rhashtable: clear stale iter->p on table restart (2026-07-17 09:04:45 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.2-p3

for you to fetch changes up to 285d8204638cf8be0dc304dc40f0290ada701340:

  crypto: af_alg - Allow cbc(paes) (2026-07-30 17:44:21 +1000)

----------------------------------------------------------------
This push contains the following changes:

- Fix lockdep warning regression in rhashtable.
- Fix default authsize in rfc4309.
- Fix gcm cryptlen calculation in tegra.
- Fix qce registration error-path bug.
- Fix incorrect use of sg_dma_len before mapping in starfive.
- Allow cbc(paes) to be used with af_alg.
----------------------------------------------------------------

Florian Westphal (1):
      rhashtable: fix false-positive lockdep splat on rhltable destruction

Herbert Xu (1):
      crypto: ccm - Set rfc4309 maxauthsize from child

Richard Weinberger (1):
      crypto: af_alg - Allow cbc(paes)

Thorsten Blum (2):
      crypto: qce - fix error path in devm_qce_register_algs
      crypto: starfive - use scatterlist length before DMA mapping

Vladislav Dronov (1):
      crypto: tegra - fix rctx->cryptlen calculation in tegra_gcm_do_one_req()

 crypto/algif_skcipher.c              |  8 +++++++-
 crypto/ccm.c                         |  2 +-
 drivers/crypto/qce/core.c            |  2 +-
 drivers/crypto/starfive/jh7110-aes.c |  2 +-
 drivers/crypto/tegra/tegra-se-aes.c  | 22 +++-------------------
 lib/rhashtable.c                     |  2 +-
 6 files changed, 14 insertions(+), 24 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
