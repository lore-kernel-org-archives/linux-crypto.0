Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664B33AE71E;
	Fri, 27 Mar 2026 10:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606125; cv=none; b=XA7LS/Ryt0y4x281obT8SHJKfQXxg+HYUTvzKDrfx0N0SPO3/GOxNH4Tr5K3lHP+xYsZVS7pvdgWT36Vk6FJNZH29k1+h4QeVIJ7XhI1HxO0wWxkDiuW+3AKJV9valjrWokB2Wz2s1n3EHKISQ5tQ98z/aag4WMwUkcm0haqosM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606125; c=relaxed/simple;
	bh=Tr/vB1vDjmiIRwFD7hHgmDJla8QuIxdDlohdWZzYU5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hrw7x/uN9hEUcmJ5aZSrgVEaJvcfm+QIoMOdK/vPhDnnYM7K2qvIAzc2/HNyNmGAVhhMyV09brs/Cl9Nd2RbRia88MBbBZah5KaMtbFpBil8Xru5MmXulDBE1InCQ8f44/A9wbXouz5jN8GRJRaM6FdbkdPK0B5n75UINtlP3FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jBYSXik0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jBYSXik0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=c12kSdprXC39vKCXXFKji6j7eF/JjYqJMcZ0t574Ubo=; 
	b=jBYSXik0SFiBONhs8ZtSl9Eh2coka3evQ7RheiY02Gfy3rufsMAH/8YDsyQJk/Pot2tM+rB123n
	h34NTdyT1ALO6kevY5C3moaTyJedrrW2G1zeG7Das3yl69W4SLQKE9RmeL0WQTbBhQcHbdFKaCgCU
	p5+wgD2eCp5pWCcduMb1Wc9vZ5g+aazxYFCuKQMnXmil2ZlcEz+h1fVBnjwBXxdG4Cx/2ati27VnU
	Wtc53CjM6juKmqN9jvvqQCnT9h2G5jg3pcE0+0VLxDX6Z2ziGwTC8HjF4am+6ok5ddLqlNyDnumRj
	4iN8MXpHuPMikMfXJmAqoxD6UMWka5w0LtgA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63hh-001bo3-3D;
	Fri, 27 Mar 2026 18:08:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:08:28 +0900
Date: Fri, 27 Mar 2026 19:08:28 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: stm32 - use list_first_entry_or_null to
 simplify hash_find_dev
Message-ID: <acZXHNMdYNgQfxCb@gondor.apana.org.au>
References: <20260320084914.7180-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320084914.7180-3-thorsten.blum@linux.dev>

On Fri, Mar 20, 2026 at 09:49:13AM +0100, Thorsten Blum wrote:
> Use list_first_entry_or_null() to simplify stm32_hash_find_dev() and
> remove the now-unused local variable 'struct stm32_hash_dev *tmp'.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/stm32/stm32-hash.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
