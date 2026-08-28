Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BC93D330C;
	Fri, 28 Aug 2026 06:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787899900; cv=none; b=Gx4CqGt3wv0cXVCdBqoTAj3f9BYYMlwD8Rv/88jqap+gQMjUtYCQGtx26TJPO/F9672s97tVrm1P3/UscFmLi5Q5ocHKvuG+ASKx8QicCxhEURm8JLzvyxyVETsr5K3rw8x6hYcCMzH0ZPj9OAJgOVcsXOuXENW5v4pvl3Y0Zh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787899900; c=relaxed/simple;
	bh=1wNN/F8KDFYBS0r8QlYA8kiEcA5eaH4aSSUJO1bnV+4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Knkc4ILDl770cIVygDh/qytgbkH1BoV/UjRnZDnD8m6KGrQk8k1iRSZBWSwbwtMAQc1ldM8mCpcPLeTKrRcC2viiGNm9PznIKfMZfreyrseTizoPOt7DQfQJeRG9oBhS+xDWcIkXe+lvvyfDfATIUQA3RVEROcLloPNW46UARIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sFdmPgom; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sFdmPgom"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=PGwA9i86wTba7lXxrz0PlW6jD591vnYGvNq4YXk0BXw=; b=sFdmP
	gomSrpWzF6U9NWMmZ5czbzYcB7jQd35lMBkPiPv2NLOeTLhb3QRFr0DxS+N8MCHYNz18k1pT6T+us
	Mprv67Q5++zbgnBR0s+PNNc8SSHv+6eqlAbMIOogfrehvhDL51RdM2wSbiVcxUqtRaChj1x8m2fUt
	3RL1oJoAGbDg7l0G2EJtmvU80PMiie+jZamqnh7iNOWIOjnbFnazUq4nNn16xVt/icXk5cbV2ReTp
	82roTJAZHf8xCPHpl6s/iVI3Nk5wuIsq9hhZJBLvSxHkLsFpnaz4LtoVLz8aRJk8UYiwD3rgMrXUy
	Xac+rOPTG1xAtOUIK39+zrQjZCSjQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wzqQv-00000008Xhs-14bV;
	Fri, 28 Aug 2026 14:51:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Aug 2026 16:51:25 +1000
Date: Fri, 28 Aug 2026 16:51:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.3
Message-ID: <apEv7dEdx36Oano_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Linus:

The following changes since commit 7537036a2e6fe96f8ed82034f755c54714a0e417:

  crypto: lskcipher - propagate errors from unaligned crypt (2026-08-15 11:28:36 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 tags/v7.3-p2

for you to fetch changes up to ee440d4fc0d2f15894ab1f64c474a3adbc858880:

  crypto: acomp - allocate async request context when cloning (2026-08-26 10:30:25 +1000)

----------------------------------------------------------------
This push fixes a memory allocation overrun in crypto acomp.
----------------------------------------------------------------

Jérémy Jean (1):
      crypto: acomp - allocate async request context when cloning

 crypto/acompress.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
