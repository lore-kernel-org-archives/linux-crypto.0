Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D6B51CF73;
	Thu, 15 Oct 2026 09:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792058135; cv=none; b=e23rmNEhA4+cm0CgEYU7mjWeSRyWIi3CpXokV1W4QqTaymXk871acKAOXxq1rm10SyR1Nx/BCW1B1didrIXT2W6EiN1vSi3OVSNTQZhNW5SvEu49JGcugcLKf8juzFZvpJBGm19cLOwAGr9kBp8fEZ7iE30m6Ub2rA3ZCEp4ayY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792058135; c=relaxed/simple;
	bh=6SX4yecHyXVbLshPsQWLilXsP7byy14yjQf58IyCF+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdN5AKS0xOVe0ZUSiqkZPR1gN8GaK9DUgtnKAudHHrrFifR5ibtSyh3sZycRygE9eXcimOYUAMplHmj1rQ6K1lg7jLCk/JIu7xSDA/dinr3cYChqpXbBQcB8v3YiPMh0rm832EQbmo56vY1rFiBK0hQtJKXAhDNchH1MyqRYA9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oH0fZ7Iq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oH0fZ7Iq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=23bNt0OfM+po4Z/srMUpSEf31cb6QWN8dJc5Q7JS6H0=; 
	b=oH0fZ7Iq/R2ZrwSMbLU+BACQiQiFP4PkbXDETCo4gfnhoHGjpepjrXRGbmRBLZacfHFwlAP8ehd
	EtIVfkPmvGWBThc/eZJ2EBQnhoLiAXXIPaoLBnS8Bu6bchWWhhLzTGYkTjFNaEpgvPWwhVLh/NNhC
	HGNzBKmeJX5a28aCbLGBd+tqCseIynvQkfDBQu9iH0kfufX0Ozmt4gLcHL/F9hMpZOk8XTQrQcxMk
	ScAKT1hHDu1UX4OgGxzt1AzUQijLGKCaYbx0T4Y3R1rBd239PWdijdd+S6g6P6XW/U4WAgIAVcY6/
	qG+d7tKnr9jBxtZTvvJyx8T3QCpCoAWgIE9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHIBG-000000047td-1SWx;
	Thu, 15 Oct 2026 17:55:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 20:55:22 +1100
Date: Thu, 15 Oct 2026 20:55:22 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: intel - simplify intel_rng_mod_init()
Message-ID: <atCjCnj5LkSNaxYK@gondor.apana.org.au>
References: <20261006172628.103594-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006172628.103594-2-blum@kernel.org>

On Tue, Oct 06, 2026 at 07:26:27PM +0200, Thorsten Blum wrote:
> Return errors directly to simplify intel_rng_mod_init().
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/intel-rng.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
