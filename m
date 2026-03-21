Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9326A3033E8;
	Sat, 21 Mar 2026 08:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774082735; cv=none; b=ovk4duEuRfNGcjkqMiwsWMnErFMppW9ypUkCR6bpc/9XiNy0X0IdfuNv1hiOD9aOPnhvdc+2bCgo2x55DCz26mInfVIv8vwVY6Yrmj0C9xmrvxYgW0zPqTExb49rWdUqmjkaq5Wx6WhwHqPYRbD305ZazqWl+xfqDTOuf0ud/Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774082735; c=relaxed/simple;
	bh=OKTQfELRYID6vE4tQzS65b7TSaaOAHO71ih2uRe5sR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puJ+ENDcLzcousb1J7J45roX2cERQe3ZT7SXBlfq38+Ojs4ZlwcWw20tIJoxRx2o4tstPJ3iwfWOORsituAaGuppDqIKu+05MdPpTmI/L0yUIv36OBW/Uvhru+fxaZ7cd7/mUEEaQVehXT0YvWG5As5GvrpGxvcW1ca+nJJjxQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YXhogfG9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YXhogfG9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8T+NsjaDW002RQbG324HKtRN5L0ElniBz1VCGexWRiU=; 
	b=YXhogfG9wmpQP73LRdolSKYyfTZhtI2xGzkrYSRM1iPihIMmtnpVFxad5EE5SYbgW7FL7WWoDCV
	htixOk9tTMCe0KraHNMsbs/N9voiEvrAm/434rAua1iz22VpgEiiatVG0XUfsBgG7BNpwULrO8ZuI
	DJI0qM11KuUh3Khh7vat/cnZVuEBBGwRHjRH0bxLUBvzWTWmCwnNfsUydBxzvhK0hObL/R75fopqf
	awWun2I3XT11n8oc+xicWO78nDXX+69rHeHyW9EejZ1ClKrTI6s9W/fCo3TtMSQDpVuNwZloRoA1l
	I9oVW5juLUN63nkieDpYSskNiXj3Db/J3eZg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3rxL-00GJ7c-1F;
	Sat, 21 Mar 2026 16:45:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:45:15 +0900
Date: Sat, 21 Mar 2026 17:45:15 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>,
	"David S. Miller" <davem@davemloft.net>, linux-arm-kernel@axis.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: artpec6 - use memcpy_and_pad to simplify
 prepare_hash
Message-ID: <ab5amyOaC3GeCOtI@gondor.apana.org.au>
References: <20260309211119.81778-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309211119.81778-3-thorsten.blum@linux.dev>

On Mon, Mar 09, 2026 at 10:11:21PM +0100, Thorsten Blum wrote:
> Use memcpy_and_pad() instead of memcpy() followed by memset() to
> simplify artpec6_crypto_prepare_hash().
> 
> Also fix a duplicate word in a comment and remove a now-redundant one.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/axis/artpec6_crypto.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
