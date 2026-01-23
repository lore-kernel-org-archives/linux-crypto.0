Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F562882CE;
	Fri, 23 Jan 2026 02:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769134896; cv=none; b=on+xl/oTRSauAxpmdc/25KMnitBv1Avw2VqraDbxQ8l/Hk43tf78ZgcTfw0caDYYK7VKo1Ox8Bk0TjAjCXFuzcjhR5MtBo4Tnk5DykJSSxSVk2mEjYPHhyIYleO4rooOfW2V4ViyIQWX9jq/iCRmB14q9mHoUeSF/jAH0tqWOXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769134896; c=relaxed/simple;
	bh=J/hRVIHdbO78lI4x/CjBK6nAgwdgepw8gjhBlVrRuEY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VDOYmOHaMIQ/j+GX5+dm1xA0CFmKR7YW12+KKMXPcejoeze9hekH9P8AlU0tOucdy4nxaAsK3kZ9ryjR+5iz/y5G9Z8PZqRsVRPj3TcQszwbOxx+2y7GtqziRqALN3e50QbYEFqVzLqPsej9tvgw497J4vxvLyABXLiXYj9DElY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NKRYvNqj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NKRYvNqj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=eENmoeO6f9ueJbEgaPAwi/m5vPQfknRTxN6aLpmkHns=; b=NKRYv
	NqjeW/6z3M4phO3rdrwqZNK2usjf+33A4pBrAH3BYwTFqPCJWbMKafZ1RYYr27kwc1Rjmmc0b7Uex
	dYVUZWOeEW08aRJoFMzkwOb9cjYy9Yv80NRDwa/iN+1Sj3+RcsGBCPZPebknHdR4PSHX33KJB7i2f
	cyBUxvYlCvlqb5uEUEYPXATgBLtj8vNzKpOQataSuCqixZHbpvvDVetBo8Pjbc/DjTZw5r7iqqmj/
	E3tR5QpL01b35BtDD+R4JEhcyKO8oqo8a4ocAsJRJ9Ob/nDMWf3NSu26L8TtZGo/BH+dWK31JcC+0
	FG4uJJF4PQqrsa8pDXhUxnD8j1g6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vj6nF-001TEK-1C;
	Fri, 23 Jan 2026 10:21:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 Jan 2026 10:21:01 +0800
Date: Fri, 23 Jan 2026 10:21:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.19
Message-ID: <aXLbDbSraxaYgfym@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus:

The following changes since commit 961ac9d97be72267255f1ed841aabf6694b17454:

  crypto: qat - fix duplicate restarting msg during AER error (2025-12-29 08:44:14 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.19-p4

for you to fetch changes up to 2397e9264676be7794f8f7f1e9763d90bd3c7335:

  crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec (2026-01-20 14:38:48 +0800)

----------------------------------------------------------------
This push contains the following changes:

- Add assoclen check in authencesn.
----------------------------------------------------------------

Taeyang Lee (1):
      crypto: authencesn - reject too-short AAD (assoclen<8) to match ESP/ESN spec

 crypto/authencesn.c | 6 ++++++
 1 file changed, 6 insertions(+)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
