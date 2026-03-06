Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9C11D47B4;
	Fri,  6 Mar 2026 03:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772766130; cv=none; b=jpBIKaWj184F/y8Sw+/TJQ+/nhit5Ow79EQZIwZh5FIWLN6H/r9Gfmqko+sm/oW4pzfrRTeLSBemqmNKnPf0UHiT8gslUjgaqyDqBhWMiyMn7Xu/H4KoUJ4J9vZeRBF3aQDBsn/SiqymkRa+Zx4eyjDMS2E/MylQMSdTw+/CA1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772766130; c=relaxed/simple;
	bh=cYsFBDxeH7XQgwnisJ0NeCTIUFF5JQeRIXRxNhQORrI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=vDWzv/bscnL/wF20eGF3hkZAQwZFjI95dOd41uwaL0zRQW80avmRTG7Tm8WdSQv4CsGPXlvKkhPiy252oQ5t3vPJ9KzRXyurbUuRdY56nI6o4XbroSyF7uoEx6aAeCkhLnWcUlJTNP81mxoSVJUyKwEAasRyg7JUcuwfU6uXEW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oAE1Db4M; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oAE1Db4M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=pARoOQjLnFAa6vgxr9eXH/gxQeXLKv6NBwNdsqsoofs=; b=oAE1D
	b4MAIk74s8yMMOEYADDUml9sOIiJb3R6ZObTuJSnr/6FML9ZVnrmoaSQtoN9BY7Jn1wfv69czFcDr
	93mrqZHfTgLwXVICe8/FAjeQYSNZ7vdHzDlGZmogtUZI8zwAhcO9172/s+RP4WW6K5WO08KKnuwLI
	VQfVNHT0dbkT37+Gb+Ab4Wx7IM3ikaS4lt3zn98sgs0GBp1gz7xwxNVrU9VqwwDcR0q4N12R8ZvuJ
	Pem12CPKbF1XXEY6X3QtLe6cUionaumW6qApFNlcT+Yt1tB+sbvlEarnpiJA1yJBQABB6qRbYyGYO
	0TjJX4iwqtXGRVlOxqXP7ntO5qeiA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vyLRn-00BzF4-0h;
	Fri, 06 Mar 2026 11:01:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Mar 2026 12:01:51 +0900
Date: Fri, 6 Mar 2026 12:01:51 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 7.0
Message-ID: <aapDn5mYeL861_6n@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v7.0-p2

for you to fetch changes up to d240b079a37e90af03fd7dfec94930eb6c83936e:

  crypto: atmel-sha204a - Fix OOM ->tfm_count leak (2026-02-28 12:53:25 +0900)

----------------------------------------------------------------
This push contains the following changes:

- Fix use-after-free in ccp.
- Fix bug when SEV is disabled in ccp.
- Fix tfm_count leak in atmel-sha204a.
----------------------------------------------------------------

Alper Ak (1):
      crypto: ccp - Fix use-after-free on error path

Ashish Kalra (1):
      crypto: ccp - allow callers to use HV-Fixed page API when SEV is disabled

Thorsten Blum (1):
      crypto: atmel-sha204a - Fix OOM ->tfm_count leak

 drivers/crypto/atmel-sha204a.c   |  5 +++--
 drivers/crypto/ccp/sev-dev-tsm.c |  2 +-
 drivers/crypto/ccp/sev-dev.c     | 10 ++++------
 3 files changed, 8 insertions(+), 9 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
