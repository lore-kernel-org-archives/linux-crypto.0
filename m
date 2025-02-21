Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C881FFC5B;
	Fri, 21 Feb 2025 09:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129547; cv=none; b=IBtsJcU4nJRfSX5bLfnQK9970s5LkJFSnhM5louMK50AOgbJwLwdTKUChf5mqhrPOYpvYWxfsWq+dXy7UGol2KS5iDTGhC2hswFXKV5suA6jVxq7fbJdQgOjFynanl9NeOaQoaoroiVezsJJH033BXIUI/wXaqiyYj78BAWNFTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129547; c=relaxed/simple;
	bh=DoqyTiZUKjk7zE0xN37z3UIrJrOZt9BJYGECtdW7x90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IN5OO3GEg4jqUgP7XSlvsLQRrLTzXJSD6p3KRhW7jM9DMvIfD/Wb3LBjrgVrZDYK5oQazglS5PJqIsr4ltgiHdStwDaIRHZYevwK0/oiPzOA0anWWQBrmF/sqN3NU46hcSBMWqOa1WQlNCBabYn9jSCG4XUX7CQE/3IjU9Hc+fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Tys02hE/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Tys02hE/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Ix0I/hd0uOG3H6gxBx5WR9qo4P7uVR3ULK9dQNfhKLA=; b=Tys02hE/+13mL0xRt+2ZFzaF/C
	wQiBv+f5a8BUrGZ10FC4xTWGNEqEZTQsoIwaf5syyIDbh9LUTkBO8Cn4W44n8a5yl2QtPKAIqeESR
	fjLJfm0e6IIgY+aab5zGhvKXKj8cwRi4UunMxGRENqQYmNc4sr6pvAPHw3qpMMPEWsC/gtbtZqhcQ
	2CgAwu4YHToGlsWaisOcJV3H5YqfQUAgVSnCN+0Ap+hQzHU/9LNHfU4eKgPGNZbpGykx3YmUvUVpj
	24/iAvgEMcmz+R6IQdGTgUsAsZm13ag65/S79Q+w771jA7SJYC//KmjQ/ddLnswR8yKOUtXhpFS78
	uqh0byJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlPBL-000YFX-3A;
	Fri, 21 Feb 2025 17:18:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 17:18:51 +0800
Date: Fri, 21 Feb 2025 17:18:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ahash - use str_yes_no() helper in
 crypto_ahash_show()
Message-ID: <Z7hE-xwO68MrmUG_@gondor.apana.org.au>
References: <20250210100449.1197-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210100449.1197-1-thorsten.blum@linux.dev>

On Mon, Feb 10, 2025 at 11:04:48AM +0100, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_yes_no() helper function.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/ahash.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
