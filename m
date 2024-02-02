Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E719679930
	for <linux-crypto@vger.kernel.org>; Fri,  2 Feb 2024 10:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706868733; cv=none; b=OSvPVIErPUzE//TWA69OXXH+NsRF1s9F6HMPnDIcuZXYIxx1zLS6f1LeSsNhf/P7lB2Cuj0Zxx9rx7aLQ2HtP1MZws+JWa269pZfpOBziOTOQhUHJ/CLu8SRF83AUXeXKx5Y33UyUcv59Im42eCwS+RPgr9cwgZMUo4MXmFYIyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706868733; c=relaxed/simple;
	bh=n1395KoXyjuOkrRPuFdHLsyxIiAaOAQkXxlqJTKLZgs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=HVNrxWD3G6wcdM25vO24cqNtT1tlpNmLBRpJdO4ESamysAzNZJI94/cH1G4fUSyC28rHjhGp0TG8aWvM34+U9RkqxBWOK6RYBDF1haniCUWlZZg547LFtc/0wyWnhh+wLgY2TdI5DCbzLDz07DgwsRfYoaAQOOx1lvdL+ojbDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rVqWj-0092ut-UD; Fri, 02 Feb 2024 18:12:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Feb 2024 18:12:19 +0800
Date: Fri, 2 Feb 2024 18:12:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ahash - unexport crypto_hash_alg_has_setkey()
Message-ID: <ZbzAA3Zf9dl2xxLN@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240127074927.74282-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since crypto_hash_alg_has_setkey() is only called from ahash.c itself,
> make it a static function.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/ahash.c                 | 21 ++++++++++-----------
> include/crypto/internal/hash.h |  2 --
> 2 files changed, 10 insertions(+), 13 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
