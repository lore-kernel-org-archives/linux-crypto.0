Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CF71E5B70;
	Sat, 28 Feb 2026 08:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268196; cv=none; b=UcWb6AHit1J16WcU0Vp4hMx+FlyCIdSkbmCYvL+YlzUFwATe4QC8f3qjCTYG0t4F7y8KQjotfD1oY3oWA9IGxjcH1RqpKMh3HvGT5yflPCkNB+lmfGPP8c3lg8vz/G2uy6H1gQ1pdV3bTYWwb8YgFB8ouyhvL6GHa6ix6FAPt/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268196; c=relaxed/simple;
	bh=WhNj3d9b8p3iRFs6mmyBRM3+NhSClNesEiMzh305YQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ATVUyr0zRP8y+K9Kta1s5ElHK5eBKJ/RnZA+fAnIuefJbycfMF7aZHd7tBxaVnUDVtLpON3k0Rtl5ApLPvh7GBi2dm2ntvOHINiFFpBBQZfQ61Bh2de8B3GivSO7IjLbAZwVf0/IR0SLPn1WtXhTJnQ6fpcqJkcYtyyi5GLgTz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JtjU+eUq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JtjU+eUq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ELbmbK4zSlHi0tRWJI/XywJ3523nUmYnAJAExAQAfLc=; 
	b=JtjU+eUq7kyofdYhN+SM2AAxE9AOEatkYUfDaEgXINpneeJdYPgD4qe+hdW5M94GcN0Rpc53PfH
	NkUTPZZTn+P68iOq5DveEuYyB9U0hptdkXMJPwpIcQKkKpFIfztQAVuxxojZd4hFh5g3LctI9jH70
	93FT+Fm5qp6Gi+GIijasE8cp6fxkDePVEy/oUS0aMYRBKaGrKZDCAB4enDkHsTjNL+8+Y++0gTfuG
	2RDh92hop1AmdhD+KY4R3NBkWxQj/GelqaJxHn98Xoj1b7wIQPFl3gq+1f7NaUzVA8+3BnR6YlRwc
	GAgeJrlYwU1HQZ4FPvXzncI9FkrWyHvNLJWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwFuk-00ADmE-1s;
	Sat, 28 Feb 2026 16:43:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:43:06 +0900
Date: Sat, 28 Feb 2026 17:43:06 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
	bp@alien8.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH] crypto: ccp - allow callers to use HV-Fixed page API
 when SEV is disabled
Message-ID: <aaKqmsiXprF3nLGi@gondor.apana.org.au>
References: <20260206212645.125485-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206212645.125485-1-Ashish.Kalra@amd.com>

On Fri, Feb 06, 2026 at 09:26:45PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SEV is disabled, the HV-Fixed page allocation call fails, which in
> turn causes SFS initialization to fail.
> 
> Fix the HV-Fixed API so callers (for example, SFS) can use it even when
> SEV is disabled by performing normal page allocation and freeing.
> 
> Fixes: e09701dcdd9c ("crypto: ccp - Add new HV-Fixed page allocation/free API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
