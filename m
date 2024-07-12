Received: from norbury.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EAA38DD9;
	Fri, 12 Jul 2024 23:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828567; cv=none; b=EAHBbIu3tUilFi4y3RoBO7YZSCWZcHK2OPji/yvuFNdqB0I4QxkTnjxW5Kh5IPlYIb4lZPryPmIhakPc506gGKlSdy1QTpQAsej9PC+Lqptrp3X7ruwmuTJ1dBzEFiXglT1fdo+3NTvYPD1oam9wTVdLB5UKVeohyV14CJdJ8I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828567; c=relaxed/simple;
	bh=WPbn2OJSKWjSFX3PGLZrjduabEBFvXvhJNRll6QcZxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y0JveeHFq6sy1pXm6WewcS/146pn1XzVEPud0j5QwygCN8G/VHQOEBqU929ALTMEdRxZo811YlzsB7EopdNXoIuTaX4QZjGpIRy6hsrFSE/1dQQ0Ki9S7SzrcAVd+115qYzhynnCU9p5UhdUcEU3wqVKWDi0rUsuZ6/7wZxeL/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sSQ6t-001q3k-1R;
	Sat, 13 Jul 2024 09:55:32 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Jul 2024 11:55:31 +1200
Date: Sat, 13 Jul 2024 11:55:31 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Olivia Mackall <olivia@selenic.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH v1] hwrng: Kconfig - Do not enable by default CN10K driver
Message-ID: <ZpHCcw7nXvgGon5J@gondor.apana.org.au>
References: <20240625195746.48905-1-francesco@dolcini.it>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625195746.48905-1-francesco@dolcini.it>

On Tue, Jun 25, 2024 at 09:57:46PM +0200, Francesco Dolcini wrote:
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> Do not enable by default the CN10K HW random generator driver.
> 
> CN10K Random Number Generator is available only on some specific
> Marvell SoCs, however the driver is in practice enabled by default on
> all arm64 configs.
> 
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
> as an alternative I could propose
> 
> default HW_RANDOM if ARCH_THUNDER=y
> 
> ---
>  drivers/char/hw_random/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
