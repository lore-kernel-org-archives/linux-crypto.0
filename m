Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D443719DF9A
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 09:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744018415; cv=none; b=JF5qzGQtYeXxF3VrMy9Be92hHMJIfchxsDNYRwnUcCjWNa3ppYeemFOahWQgyl3f/hFq3MF3tIfm4jjxTt51Ak6zJfPjjloXVc5jrou8Q+fhfZCzB1PpA0vruZ7pz1T19bL9shG4gmAph3G2QGixlHx2wvQ/TV3KlIdxHeee24w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744018415; c=relaxed/simple;
	bh=DRJpAJGrKn4jb8OadfnXLOpmIPIbJQ1vfS1E/5CpNKY=;
	h=Date:Message-Id:From:Subject:To; b=XPHZnK36MmPsE1/7UWkM+NxO6Btbg5BIaps9qzDR8X1ZvflZMzF2rkGfT3iFzBmsrH6fThCHd+cOr51ZfGOTtLhShUTmHEZxTxEgZQZqZ6yPxmpYiJWoM6iH5y2Fvznp1l3+uPzs4d3P2mQ1Gac6nzkIo47lqZiq9TweNySOmDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qrDge4K1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qrDge4K1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uAZ+VpS1TNzaAKk1oEr1CnFMzXoQOV1o0gcgSvU7/5c=; b=qrDge4K1YtLbmrcfWEn/JkCYWg
	gTTqdV6gvOPCePQvLTDxtg1EiM787Fv0LgBLverdXTgvAsRWUGln38D5FZX8EYYgI0YPVaZM9KgQ0
	cSkzxJkDZ7SInRYaLn/e9rxQUmgpKRhK05mE/7dMaQwwc7X4mtKuhYtELCxIerQDdYp8afTzKt/IO
	1TxCmXgswLWqi/3Oc4nPk2O8T3qraZ4ub7yWupfTeHL6x0Wd4O9VWEBpRdyNgF93s2k/a4BdYhQ7+
	i+fQDc1IAqw0cdm3LuwkeYrB5KIfRk9nDoHmAo0CZw5w+2Seco8GGxHYC8zdAdbySSZX/+WzTXfYV
	VCRwedKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1ir9-00DR07-1L;
	Mon, 07 Apr 2025 17:33:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 17:33:27 +0800
Date: Mon, 07 Apr 2025 17:33:27 +0800
Message-Id: <cover.1744018301.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/5] crypto: Remove request chaining
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This series removes request chaining from acomp and ahash.

Herbert Xu (5):
  Revert "crypto: testmgr - Add multibuffer acomp testing"
  crypto: deflate - Remove request chaining
  crypto: acomp - Remove request chaining
  Revert "crypto: tcrypt - Restore multibuffer ahash tests"
  crypto: ahash - Remove request chaining

 crypto/acompress.c                  | 117 ++++----------
 crypto/ahash.c                      | 234 ++++------------------------
 crypto/deflate.c                    |  14 --
 crypto/scompress.c                  |  18 +--
 crypto/tcrypt.c                     | 231 ---------------------------
 crypto/testmgr.c                    | 145 ++++++++---------
 include/crypto/acompress.h          |  14 --
 include/crypto/algapi.h             |   5 -
 include/crypto/hash.h               |  12 --
 include/crypto/internal/acompress.h |   5 -
 include/crypto/internal/hash.h      |   5 -
 include/linux/crypto.h              |  15 --
 12 files changed, 130 insertions(+), 685 deletions(-)

-- 
2.39.5

