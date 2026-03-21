Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAC52D8795;
	Sat, 21 Mar 2026 08:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774082969; cv=none; b=FA8+aztQsL5/XiN4TunGY+l1pm5lXjtgy+A/wiwOEgnc69eEYXXjYw/XpBBkt9qz2BQAGHcPS9+cKcYO477z9PXAZx+hJFUxaNgaO75f64vlT7t5+WMCi8HSOq1+POAN0ycTgZQFOudAnAnPZGGCuP1+bZWyWq2YpG2YfT7a74A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774082969; c=relaxed/simple;
	bh=qU6uS/yL6P2wrp38LrhL8AUVgMfE4c+UvIUWH0dKrpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NP5gUB/O2SI0wKRJqMszJILVjHcIpyla4Ad0evFdHAG2CmEGppkta2HNPfVfRHDTzHwoLmvnCFvJ8ZE/c8GEaciKjH+52/k4dYbzP4rSpW5OlDoY/N5UOOUfXhlqfwCmK1Xsilj+YQezqFYpEUDopIx3bvClMK4wiVdyfikaUx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Q5tDrfnD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Q5tDrfnD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GwPcOnBm/QPe1UaE8iPMgQgbG/WEOLPzO3J+Y4LQgE0=; 
	b=Q5tDrfnDYwMWC0tji8dTuF61ceClY1q1oASxcA0B5Rc4IYWgtz1gY+X3ceHspy/2bZgqBqvqGtS
	jgIZQz84IGwYimy5aBx1anPrdHLnn1mSNpBWoUw31yWWKZhkqp5I5lsnGPP51dlk5h6BjaiovF4LR
	MU51u7wbjJ6IlbjJbTn8RRSPzYX/wonxhzttEkGclzMqGImkmdOox0AhhAE3WDV8UUMZn+2Td4yWP
	icx5oJbRO2+0h0oklbHxGnkYIa1+gs23i3INuE/cKEgi7R9wEcUP9xPFR9BBaWj4bOK9XhJEFgH9Y
	Yo+8IsmVBAmJ+pql7YXbiNdwVkDmx61yCmaw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3s1F-00GJAp-37;
	Sat, 21 Mar 2026 16:49:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:49:17 +0900
Date: Sat, 21 Mar 2026 17:49:17 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hwrng: hw_random.h: avoid kernel-doc warnings
Message-ID: <ab5bjcCa00fZtM0F@gondor.apana.org.au>
References: <20260312051323.679913-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312051323.679913-1-rdunlap@infradead.org>

On Wed, Mar 11, 2026 at 10:13:23PM -0700, Randy Dunlap wrote:
> Mark internal fields as "private:" so that kernel-doc comments
> are not needed for them, eliminating kernel-doc warnings:
> 
> Warning: include/linux/hw_random.h:54 struct member 'list' not described
>  in 'hwrng'
> Warning: include/linux/hw_random.h:54 struct member 'ref' not described
>  in 'hwrng'
> Warning: include/linux/hw_random.h:54 struct member 'cleanup_work' not
>  described in 'hwrng'
> Warning: include/linux/hw_random.h:54 struct member 'cleanup_done' not
>  described in 'hwrng'
> Warning: include/linux/hw_random.h:54 struct member 'dying' not described
>  in 'hwrng'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Olivia Mackall <olivia@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> 
>  include/linux/hw_random.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
