Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75703A1C9;
	Sat, 22 Nov 2025 03:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763781586; cv=none; b=IqJqXBsOKr1rRJtYIbM0cJermG1CnDAasb5WttWFwkFVUKB1NcVKhfIQhwz3wNsvS+ZA07+bpAGc/wJ0kXRuBimDL3LWRALX6q8EnuyqfE+9VOv7N4Tzt+JlJKnXxof/SejzEzL5UEbGXcMoS3+MC9cfpufpV1van5YjfMaE0r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763781586; c=relaxed/simple;
	bh=yIn/tthgNd9bxDW9yhRB76CAxvhBESfZFf8sVdOS5Cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rq3ONXWnbHhpuVKfSpLiFQe7k6Db2XyTCnj7JCdNCUD/2iukMkf2aJIoJrPQG8DR4U+dTkYWNMt+uM2Vx0wtGUXjK/TAAgYkV7x8FD4kbel/ZFGMrsMeySspkAdBu1emntWbDLR4Y2KorcRAPZe7+MwmlnTs675nrYn2CO7m8Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GrIdhhYr; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GrIdhhYr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/VtJmjWyhD9p/vW0wwQo1A1riD3TRH5yAihW69nTRPU=; 
	b=GrIdhhYrjpJsNhxcHNBOTmVQdimka5b09H4Pcvh1fUaE5XzfH/OxqU8MIMOYfI3mUNGYCiZVnTa
	wGYP6DQqTHa4PbXEU1je7zceY2Totdk1YbkdbSDr0z1q+wKnwI+KKqGnDtoiU4sLddHhHF+ZBno77
	/Tx//CcNeol38w5mT+I8YRPBLfK98M1qYBHRYNSeeU3QdRnJuFsWLRX1txwpdW/5aWBHGXV04Mm1u
	79ZpA5O/0Rjz6FzZgFpJH1FPiC4K4cGzky1OZcE3xMnsV/QyZ2BI248Qv0j1dnIJmj4o8VvHbE3n7
	Ff97GTAU+tfOZuPPvMUh+uc2oWNctEQAyS+g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMe9u-0056Y6-12;
	Sat, 22 Nov 2025 11:19:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 11:19:34 +0800
Date: Sat, 22 Nov 2025 11:19:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Colin Ian King <coking@nvidia.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] crypto: Fix memcpy_sglist()
Message-ID: <aSErxmqQiY5kVAOz@gondor.apana.org.au>
References: <20251115230817.26070-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115230817.26070-1-ebiggers@kernel.org>

On Sat, Nov 15, 2025 at 03:08:15PM -0800, Eric Biggers wrote:
> This series rewrites memcpy_sglist() to fix the bug where it called
> functions that could fail and ignored errors.
> 
> This series is targeting crypto/master.
> 
> Changed in v2:
>     - Don't try to support arbitrary overlaps
>     - Use memcpy_page()
> 
> Eric Biggers (2):
>   crypto: scatterwalk - Fix memcpy_sglist() to always succeed
>   Revert "crypto: scatterwalk - Move skcipher walk and use it for
>     memcpy_sglist"
> 
>  crypto/scatterwalk.c               | 345 +++++++----------------------
>  crypto/skcipher.c                  | 261 +++++++++++++++++++++-
>  include/crypto/algapi.h            |  12 +
>  include/crypto/internal/skcipher.h |  48 +++-
>  include/crypto/scatterwalk.h       | 117 +++-------
>  5 files changed, 431 insertions(+), 352 deletions(-)
> 
> 
> base-commit: 59b0afd01b2ce353ab422ea9c8375b03db313a21
> -- 
> 2.51.2

Patch applied to cryptodev.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
