Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA4839B975;
	Mon, 10 Aug 2026 08:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350672; cv=none; b=IShqIRQnQnZpULtYQc3hrFlApn6swgPoZDDR6V/5oyHV0cplEDgRfhkgx3i0gK1sbSUMckWyk4oW57CvyACopY3kjNZ3Hmke4N08gTweH1/KzyrU+tZzf+DmnHgz4EJ4dAmF2lcrFRE+/7erhKdJgPYrAWL+v77fJzqx3Km9Czg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350672; c=relaxed/simple;
	bh=C12B4ajBn82+50mQeKsgeQVGvbjp1rs+uPprAvLg1DY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZzlbW2dLtUhvUIESFiiIPPNiJBaUVQJAHSo5smenwtJum0wHwP3M2Aq4zJA0rfgcnLcim62AfYNqHZSr/DvzHcOl1WzJf3znCCHArNgZyfzTK1m3wmzHJcpaN+O71C0Z8G3Oq1xCGqWWolZ+7rLe0RHXF28K1UeDLUi4K2hbyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=k176fqIF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="k176fqIF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7IwcdFeRYg1MvXu7BQWdTvi9T9dtILAVO5YYoRXZcdk=; 
	b=k176fqIFls5VT7/J8GeWSsWrhQ3xqkte0a9xcCnIxFeZvvMks0eqzQnsiFnuQAxQOKs0+zNGml3
	6OvZPy6BgELH1u1tcgwj42Dv6wj7C4tuAhVhImn9KUSaM9nmrTFdpUVv7TGhAOttXGqo6cueEzM/B
	VY+/EsmnDH4R0csm2M/IH4mnJAot0EEX9gU8lomcvx9GzZCS4fQ5Bn+UABq7UOFIAoRknmt2ltRsq
	l9KDaYGtgYvcpAYh72AomVherEr4pxRwzm9PGrnoi6NZJWm5PCXymKW3NE7ny5b0MzI+bxWCk7Y7O
	/RZnfajnXFzFQFjWuSJ5ysDnYNadPuaYFPHQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLPW-00000003WkY-3yI9;
	Mon, 10 Aug 2026 16:31:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:31:06 +1000
Date: Mon, 10 Aug 2026 18:31:06 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH] crypto: ecdsa - Fix typo in function documentation
Message-ID: <anmMSvSMGsIjl3PC@gondor.apana.org.au>
References: <20260730-fix-ecc-header-typo-v1-1-9d58356560d2@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-fix-ecc-header-typo-v1-1-9d58356560d2@bootlin.com>

On Thu, Jul 30, 2026 at 05:48:41PM +0200, Paul Louvel wrote:
> Fix the misspelling of 'validate' in crypto_ecdh_shared_secret() and
> ecc_is_pubkey_valid_partial() documentation.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>  include/crypto/internal/ecc.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
