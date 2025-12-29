Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4BE43AA6;
	Mon, 29 Dec 2025 00:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766968384; cv=none; b=myMaOg4ztun8ME/zx7uOY2ufEbdL2KgFqbZYf8Upqfq+DTL53wYsVmOeZ8EgiyAUiWXaQ5e1iElwxwT75mcKi8pWoHx0VlBj6boWwppSMY0RqBE+7X18LU8TbI7Tj+CwAEQriTnO5qjQb1bsnPtd9S1SedUVoEieFaP5ujXJkbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766968384; c=relaxed/simple;
	bh=7TMxsq78OrqAdUrAqhUXnoJMMU2LcVBro/m7gtHli3k=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ABtFYDcJFpc+rkrPmyxRk49VExykBfPmhr+r5b2ZJo9bFWqfV22jzVGC0jp9h7jMo31BN67EcHSPW6bF2pgr6eE+cye0FwR0XW1CMB2yN1Y2L9JqxLrBRyT/pAAFX49S0gmPJyWxaV/w30kTn9CZR0zrO2+NrePKttBv6ISsqWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NinxZEH3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NinxZEH3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=9qDyA8LUs1Ztc/ROPgYY6rKDGk8erPkliU0g18dguPM=; b=NinxZ
	EH3lDKmO+Kmwgv1lPq1Du/WohNEW6CU7Cby1wBoVNGp+vUPr1eanwOxyv5Kk3hhYoMiHBMrleT9Lh
	QocjdEd4vnDxKqMjFdMLl6TiJiIXU5/03dmG0md8Jl/qDDYqmDrI/nGDVjvtomWCwm48VjBzUJV+k
	uRMDfWEKhbxDUywlcxaCZKSJABx+rLBgAKcizO8eypVOJP2UWcgNrfjcasEcoGNRdpunOHlZtt49y
	PWYHzLLfh50gAjnKfnxTPhBrQnN3sBOtSwiGMkHnYEntnFai2gimcCtDH3PTJCdhiBOnuecTXcGX3
	vCEpG0y76FAhO77FoXlPUabdOzL3w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1va1Bl-00D06i-1C;
	Mon, 29 Dec 2025 08:32:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Dec 2025 08:32:45 +0800
Date: Mon, 29 Dec 2025 08:32:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.19
Message-ID: <aVHMLaTgxU8eBdub@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 8f0b4cce4481fb22653697cced8d0d04027cb1e8:

  Linux 6.19-rc1 (2025-12-14 16:05:07 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p2

for you to fetch changes up to b74fd80d7fe578898a76344064d2678ce1efda61:

  crypto: hisilicon/qm - fix incorrect judgment in qm_get_complete_eqe_num() (2025-12-19 14:47:46 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Fix UAF in seqiv.
- Fix regression in hisilicon.
----------------------------------------------------------------

Chenghai Huang (1):
      crypto: hisilicon/qm - fix incorrect judgment in qm_get_complete_eqe_num()

Herbert Xu (1):
      crypto: seqiv - Do not use req->iv after crypto_aead_encrypt

 crypto/seqiv.c                | 8 +++++---
 drivers/crypto/hisilicon/qm.c | 9 ++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
